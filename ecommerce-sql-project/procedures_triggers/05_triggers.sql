/* ==========================================================
   File: 05_triggers.sql
   Purpose: Triggers for stock control and inventory logging
   ========================================================== */

USE ECommerceDB;
GO

-- ==========================================================
-- Trigger: trg_AfterOrderItemInsert
-- Fires whenever a new order item is inserted.
-- 1. Checks that enough stock exists.
-- 2. If not enough stock -> rolls back the whole transaction.
-- 3. If enough stock -> reduces StockQuantity and logs the sale.
-- ==========================================================
CREATE TRIGGER trg_AfterOrderItemInsert
ON OrderItems
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Check stock for every inserted row
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Products p ON i.ProductID = p.ProductID
        WHERE p.StockQuantity < i.Quantity
    )
    BEGIN
        RAISERROR('Insufficient stock for one or more products. Order rolled back.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Reduce stock
    UPDATE p
    SET p.StockQuantity = p.StockQuantity - i.Quantity
    FROM Products p
    JOIN inserted i ON p.ProductID = i.ProductID;

    -- Log the sale
    INSERT INTO InventoryLog (ProductID, ChangeType, QuantityChanged)
    SELECT ProductID, 'SALE', Quantity
    FROM inserted;
END;
GO

-- ==========================================================
-- Trigger: trg_PreventNegativeStock
-- Safety net: blocks any update (from anywhere) that would
-- push StockQuantity below zero.
-- ==========================================================
CREATE TRIGGER trg_PreventNegativeStock
ON Products
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS (SELECT 1 FROM inserted WHERE StockQuantity < 0)
    BEGIN
        RAISERROR('Stock cannot go below zero. Update blocked.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

PRINT 'Triggers created successfully.';

/*
   WHY TWO TRIGGERS?
   -------------------
   trg_AfterOrderItemInsert  -> business logic (stock deduction + audit log)
                                fired by a specific event (new order item).

   trg_PreventNegativeStock  -> a safety constraint that protects data
                                integrity no matter HOW the Products table
                                is updated (even a manual UPDATE statement
                                by an admin would be blocked).

   This is a common interview question: "Why not just check stock in the
   stored procedure?" Answer: the stored procedure covers the normal path,
   but the trigger guarantees the rule is enforced at the database level,
   even if someone updates the table directly.
*/
