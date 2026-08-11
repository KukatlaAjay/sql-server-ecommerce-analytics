/* ==========================================================
   File: 06_views.sql
   Purpose: Reusable reporting views
   ========================================================== */

USE ECommerceDB;
GO

-- ==========================================================
-- View: vw_OrderSummary
-- One row per order with customer name and item count
-- ==========================================================
CREATE VIEW vw_OrderSummary AS
SELECT
    o.OrderID,
    c.CustomerName,
    o.OrderDate,
    o.OrderStatus,
    o.TotalAmount,
    SUM(oi.Quantity) AS TotalItems
FROM Orders o
JOIN Customers c   ON o.CustomerID = c.CustomerID
JOIN OrderItems oi ON o.OrderID = oi.OrderID
GROUP BY o.OrderID, c.CustomerName, o.OrderDate, o.OrderStatus, o.TotalAmount;
GO

-- ==========================================================
-- View: vw_TopSellingProducts
-- Top 5 products by quantity sold
-- ==========================================================
CREATE VIEW vw_TopSellingProducts AS
SELECT TOP 5
    p.ProductID,
    p.ProductName,
    SUM(oi.Quantity) AS TotalQuantitySold,
    SUM(oi.Quantity * oi.UnitPrice) AS TotalRevenue
FROM OrderItems oi
JOIN Products p ON oi.ProductID = p.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY TotalQuantitySold DESC;
GO

-- ==========================================================
-- View: vw_CustomerSpending
-- Total spending per customer + a simple segment label
-- ==========================================================
CREATE VIEW vw_CustomerSpending AS
SELECT
    c.CustomerID,
    c.CustomerName,
    COUNT(DISTINCT o.OrderID) AS TotalOrders,
    SUM(oi.Quantity * oi.UnitPrice) AS TotalSpending,
    CASE
        WHEN SUM(oi.Quantity * oi.UnitPrice) >= 50000 THEN 'Premium'
        WHEN SUM(oi.Quantity * oi.UnitPrice) >= 20000 THEN 'Regular'
        ELSE 'Basic'
    END AS CustomerSegment
FROM Customers c
JOIN Orders o      ON c.CustomerID = o.CustomerID
JOIN OrderItems oi ON o.OrderID = oi.OrderID
WHERE o.OrderStatus <> 'Cancelled'
GROUP BY c.CustomerID, c.CustomerName;
GO

-- ==========================================================
-- View: vw_ProductRatings
-- Average rating per product
-- ==========================================================
CREATE VIEW vw_ProductRatings AS
SELECT
    p.ProductID,
    p.ProductName,
    AVG(CAST(r.Rating AS DECIMAL(3,2))) AS AverageRating,
    COUNT(r.ReviewID) AS TotalReviews
FROM Products p
JOIN Reviews r ON p.ProductID = r.ProductID
GROUP BY p.ProductID, p.ProductName;
GO

PRINT 'Views created successfully.';

/*
   USAGE EXAMPLES
   -------------------
   SELECT * FROM vw_OrderSummary ORDER BY OrderDate DESC;
   SELECT * FROM vw_TopSellingProducts;
   SELECT * FROM vw_CustomerSpending ORDER BY TotalSpending DESC;
   SELECT * FROM vw_ProductRatings ORDER BY AverageRating DESC;
*/
