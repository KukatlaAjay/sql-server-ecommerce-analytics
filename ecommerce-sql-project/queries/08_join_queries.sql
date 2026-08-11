/* ==========================================================
   File: 08_join_queries.sql
   Purpose: INNER JOIN / LEFT JOIN practice
   ========================================================== */

USE ECommerceDB;
GO

-- 21. Orders with customer names
SELECT o.OrderID, c.CustomerName, o.OrderDate, o.OrderStatus
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID;

-- 22. Products with their category name
SELECT p.ProductName, p.Price, c.CategoryName
FROM Products p
JOIN Categories c ON p.CategoryID = c.CategoryID;

-- 23. Order items with product names
SELECT oi.OrderID, p.ProductName, oi.Quantity, oi.UnitPrice
FROM OrderItems oi
JOIN Products p ON oi.ProductID = p.ProductID;

-- 24. Complete order details (customer + product)
SELECT o.OrderID, c.CustomerName, p.ProductName, oi.Quantity, oi.UnitPrice
FROM Orders o
JOIN Customers c   ON o.CustomerID = c.CustomerID
JOIN OrderItems oi ON o.OrderID = oi.OrderID
JOIN Products p    ON oi.ProductID = p.ProductID;

-- 25. Total spending per customer (excluding cancelled orders)
SELECT c.CustomerID, c.CustomerName,
       SUM(oi.Quantity * oi.UnitPrice) AS TotalSpending
FROM Customers c
JOIN Orders o      ON c.CustomerID = o.CustomerID
JOIN OrderItems oi ON o.OrderID = oi.OrderID
WHERE o.OrderStatus <> 'Cancelled'
GROUP BY c.CustomerID, c.CustomerName
ORDER BY TotalSpending DESC;

-- 26. Best-selling product overall
SELECT TOP 1 p.ProductName, SUM(oi.Quantity) AS TotalQuantitySold
FROM Products p
JOIN OrderItems oi ON p.ProductID = oi.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY TotalQuantitySold DESC;

-- 27. Sales total by category
SELECT c.CategoryName, SUM(oi.Quantity * oi.UnitPrice) AS TotalSales
FROM Categories c
JOIN Products p    ON c.CategoryID = p.CategoryID
JOIN OrderItems oi ON p.ProductID = oi.ProductID
GROUP BY c.CategoryID, c.CategoryName
ORDER BY TotalSales DESC;

-- 28. Customers who have placed at least one order
SELECT DISTINCT c.CustomerID, c.CustomerName
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID;

-- 29. Customers who have never placed an order  (LEFT JOIN + IS NULL)
SELECT c.CustomerID, c.CustomerName
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;

-- 30. Products that have never been reviewed
SELECT p.ProductID, p.ProductName
FROM Products p
LEFT JOIN Reviews r ON p.ProductID = r.ProductID
WHERE r.ReviewID IS NULL;
