/* ==========================================================
   File: 10_case_and_window_functions.sql
   Purpose: CASE statements + Window function practice
   ========================================================== */

USE ECommerceDB;
GO

-- 39. Categorize products by price band
SELECT ProductName, Price,
    CASE
        WHEN Price >= 30000 THEN 'Expensive'
        WHEN Price >= 5000  THEN 'Medium'
        ELSE 'Affordable'
    END AS PriceCategory
FROM Products;

-- 40. Categorize customers by total spending
WITH CustomerSales AS (
    SELECT c.CustomerID, c.CustomerName,
           SUM(oi.Quantity * oi.UnitPrice) AS TotalSpending
    FROM Customers c
    JOIN Orders o      ON c.CustomerID = o.CustomerID
    JOIN OrderItems oi ON o.OrderID = oi.OrderID
    GROUP BY c.CustomerID, c.CustomerName
)
SELECT CustomerName, TotalSpending,
    CASE
        WHEN TotalSpending >= 50000 THEN 'Premium'
        WHEN TotalSpending >= 20000 THEN 'Regular'
        ELSE 'Basic'
    END AS CustomerSegment
FROM CustomerSales;

-- 41. Rank products by price (RANK gives ties the same rank)
SELECT ProductName, Price,
       RANK() OVER (ORDER BY Price DESC) AS PriceRank
FROM Products;

-- 42. Rank customers by total spending
WITH CustomerSales AS (
    SELECT c.CustomerID, c.CustomerName,
           SUM(oi.Quantity * oi.UnitPrice) AS TotalSpending
    FROM Customers c
    JOIN Orders o      ON c.CustomerID = o.CustomerID
    JOIN OrderItems oi ON o.OrderID = oi.OrderID
    GROUP BY c.CustomerID, c.CustomerName
)
SELECT CustomerName, TotalSpending,
       RANK() OVER (ORDER BY TotalSpending DESC) AS CustomerRank
FROM CustomerSales;

-- 43. Running total of sales by order date
WITH DailySales AS (
    SELECT o.OrderDate, SUM(oi.Quantity * oi.UnitPrice) AS DailyTotal
    FROM Orders o
    JOIN OrderItems oi ON o.OrderID = oi.OrderID
    GROUP BY o.OrderDate
)
SELECT OrderDate, DailyTotal,
       SUM(DailyTotal) OVER (ORDER BY OrderDate
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningTotal
FROM DailySales;

-- 44. Monthly sales summary
SELECT YEAR(o.OrderDate) AS SalesYear,
       MONTH(o.OrderDate) AS SalesMonth,
       SUM(oi.Quantity * oi.UnitPrice) AS MonthlySales
FROM Orders o
JOIN OrderItems oi ON o.OrderID = oi.OrderID
WHERE o.OrderStatus <> 'Cancelled'
GROUP BY YEAR(o.OrderDate), MONTH(o.OrderDate)
ORDER BY SalesYear, SalesMonth;

-- 45. Average rating per product, highest first
SELECT p.ProductName, AVG(CAST(r.Rating AS DECIMAL(3,2))) AS AverageRating
FROM Products p
JOIN Reviews r ON p.ProductID = r.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY AverageRating DESC;

-- 46. Products with an average rating greater than 4
SELECT p.ProductName, AVG(CAST(r.Rating AS DECIMAL(3,2))) AS AverageRating
FROM Products p
JOIN Reviews r ON p.ProductID = r.ProductID
GROUP BY p.ProductID, p.ProductName
HAVING AVG(CAST(r.Rating AS DECIMAL(3,2))) > 4;

-- 47. Payment method usage summary
SELECT PaymentMethod, COUNT(*) AS TransactionCount, SUM(Amount) AS TotalAmount
FROM Payments
WHERE PaymentStatus = 'Success'
GROUP BY PaymentMethod
ORDER BY TotalAmount DESC;

-- 48. Cancelled orders
SELECT o.OrderID, c.CustomerName, o.OrderDate
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE o.OrderStatus = 'Cancelled';

-- 49. Customers who placed more than one order
SELECT c.CustomerName, COUNT(o.OrderID) AS OrderCount
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CustomerName
HAVING COUNT(o.OrderID) > 1;

-- 50. Each customer's most recent order (classic interview question)
WITH RankedOrders AS (
    SELECT OrderID, CustomerID, OrderDate,
           ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY OrderDate DESC) AS rn
    FROM Orders
)
SELECT c.CustomerName, r.OrderID, r.OrderDate
FROM RankedOrders r
JOIN Customers c ON r.CustomerID = c.CustomerID
WHERE r.rn = 1;
