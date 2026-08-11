/* ==========================================================
   File: 09_subqueries_and_ctes.sql
   Purpose: Subquery and CTE (Common Table Expression) practice
   ========================================================== */

USE ECommerceDB;
GO

-- 31. Products priced above the average product price
SELECT ProductName, Price
FROM Products
WHERE Price > (SELECT AVG(Price) FROM Products);

-- 32. Customers spending above the average customer spending
WITH CustomerSales AS (
    SELECT c.CustomerID, c.CustomerName,
           SUM(oi.Quantity * oi.UnitPrice) AS TotalSpending
    FROM Customers c
    JOIN Orders o      ON c.CustomerID = o.CustomerID
    JOIN OrderItems oi ON o.OrderID = oi.OrderID
    GROUP BY c.CustomerID, c.CustomerName
)
SELECT CustomerName, TotalSpending
FROM CustomerSales
WHERE TotalSpending > (SELECT AVG(TotalSpending) FROM CustomerSales);

-- 33. Second-highest product price
SELECT MAX(Price) AS SecondHighestPrice
FROM Products
WHERE Price < (SELECT MAX(Price) FROM Products);

-- 34. Second-highest priced product (name + price)
SELECT ProductName, Price
FROM Products
WHERE Price = (
    SELECT MAX(Price) FROM Products
    WHERE Price < (SELECT MAX(Price) FROM Products)
);

-- 35. Customers who purchased a Laptop
SELECT DISTINCT c.CustomerName
FROM Customers c
JOIN Orders o      ON c.CustomerID = o.CustomerID
JOIN OrderItems oi ON o.OrderID = oi.OrderID
JOIN Products p    ON oi.ProductID = p.ProductID
WHERE p.ProductName = 'Laptop';

-- 36. Orders that contain a product costing more than 10000
SELECT DISTINCT oi.OrderID
FROM OrderItems oi
JOIN Products p ON oi.ProductID = p.ProductID
WHERE p.Price > 10000;

-- 37. Total value of every order, using a CTE
WITH OrderValue AS (
    SELECT OrderID, SUM(Quantity * UnitPrice) AS OrderTotal
    FROM OrderItems
    GROUP BY OrderID
)
SELECT * FROM OrderValue ORDER BY OrderTotal DESC;

-- 38. Top 3 customers by spending, using a CTE
WITH CustomerSales AS (
    SELECT c.CustomerID, c.CustomerName,
           SUM(oi.Quantity * oi.UnitPrice) AS TotalSales
    FROM Customers c
    JOIN Orders o      ON c.CustomerID = o.CustomerID
    JOIN OrderItems oi ON o.OrderID = oi.OrderID
    GROUP BY c.CustomerID, c.CustomerName
)
SELECT TOP 3 * FROM CustomerSales ORDER BY TotalSales DESC;
