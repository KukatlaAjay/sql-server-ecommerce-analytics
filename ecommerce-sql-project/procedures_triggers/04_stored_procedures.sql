/* ==========================================================
   File: 04_stored_procedures.sql
   Purpose: Stored procedures for placing and cancelling orders
   ========================================================== */

USE ECommerceDB;
GO

-- ==========================================================
-- Procedure: usp_PlaceOrder
-- Places a new order for one product.
-- Stock deduction and inventory logging is handled by the
-- trg_AfterOrderItemInsert trigger (see 05_triggers.sql),
-- so this procedure only needs to insert the order + item
-- and let the trigger take care of stock.
-- ==========================================================
CREATE PROCEDURE usp_PlaceOrder
    @CustomerID INT,
    @ProductID  INT,
    @Quantity   INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @Price DECIMAL(10,2), @OrderID INT;

        SELECT @Price = Price
        FROM Products
        WHERE ProductID = @ProductID;

        IF @Price IS NULL
        BEGIN
            RAISERROR('Product does not exist.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Create the order header first (status Pending, total updated after item insert)
        INSERT INTO Orders (CustomerID, OrderStatus, TotalAmount)
        VALUES (@CustomerID, 'Pending', 0);

        SET @OrderID = SCOPE_IDENTITY();

        -- Insert the order item.
        -- trg_AfterOrderItemInsert will check stock and either
        -- update Products/InventoryLog or roll back this transaction.
        INSERT INTO OrderItems (OrderID, ProductID, Quantity, UnitPrice)
        VALUES (@OrderID, @ProductID, @Quantity, @Price);

        -- Finalize order total and status
        UPDATE Orders
        SET TotalAmount = @Quantity * @Price,
            OrderStatus = 'Completed'
        WHERE OrderID = @OrderID;

        COMMIT TRANSACTION;

        SELECT @OrderID AS NewOrderID, 'Order placed successfully' AS Message;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SELECT ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;
GO

-- ==========================================================
-- Procedure: usp_CancelOrder
-- Cancels an order, restores stock, and marks payment refunded.
-- ==========================================================
CREATE PROCEDURE usp_CancelOrder
    @OrderID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @CurrentStatus VARCHAR(20);

        SELECT @CurrentStatus = OrderStatus FROM Orders WHERE OrderID = @OrderID;

        IF @CurrentStatus IS NULL
        BEGIN
            RAISERROR('Order not found.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        IF @CurrentStatus = 'Cancelled'
        BEGIN
            RAISERROR('Order is already cancelled.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END

        -- Restore stock for every item in the order
        UPDATE p
        SET p.StockQuantity = p.StockQuantity + oi.Quantity
        FROM Products p
        JOIN OrderItems oi ON p.ProductID = oi.ProductID
        WHERE oi.OrderID = @OrderID;

        -- Log the restock
        INSERT INTO InventoryLog (ProductID, ChangeType, QuantityChanged)
        SELECT ProductID, 'RESTOCK', Quantity
        FROM OrderItems
        WHERE OrderID = @OrderID;

        -- Mark the order cancelled
        UPDATE Orders
        SET OrderStatus = 'Cancelled'
        WHERE OrderID = @OrderID;

        -- Mark related payment as refunded (if one exists)
        UPDATE Payments
        SET PaymentStatus = 'Refunded'
        WHERE OrderID = @OrderID;

        COMMIT TRANSACTION;

        SELECT 'Order cancelled and stock restored' AS Message;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        SELECT ERROR_MESSAGE() AS ErrorMessage;
    END CATCH
END;
GO

-- ==========================================================
-- Procedure: usp_GetCustomerOrderHistory
-- Returns every order + items for a given customer.
-- ==========================================================
CREATE PROCEDURE usp_GetCustomerOrderHistory
    @CustomerID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        o.OrderID,
        o.OrderDate,
        o.OrderStatus,
        p.ProductName,
        oi.Quantity,
        oi.UnitPrice,
        (oi.Quantity * oi.UnitPrice) AS LineTotal
    FROM Orders o
    JOIN OrderItems oi ON o.OrderID = oi.OrderID
    JOIN Products p    ON oi.ProductID = p.ProductID
    WHERE o.CustomerID = @CustomerID
    ORDER BY o.OrderDate DESC;
END;
GO

PRINT 'Stored procedures created successfully.';

/*
   EXAMPLE EXECUTION
   -------------------
   EXEC usp_PlaceOrder @CustomerID = 1, @ProductID = 3, @Quantity = 2;
   EXEC usp_CancelOrder @OrderID = 13;
   EXEC usp_GetCustomerOrderHistory @CustomerID = 1;
*/
