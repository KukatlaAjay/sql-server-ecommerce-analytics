/* ==========================================================
   File: 07_basic_and_aggregate_queries.sql
   Purpose: Basic SELECTs + aggregate function practice
   ========================================================== */

USE ECommerceDB;
GO

-- 1. All customers
SELECT * FROM Customers;

-- 2. Customers from Hyderabad
SELECT * FROM Customers WHERE City = 'Hyderabad';

-- 3. Products costing more than 5000
SELECT * FROM Products WHERE Price > 5000;

-- 4. Products between 1000 and 5000
SELECT * FROM Products WHERE Price BETWEEN 1000 AND 5000;

-- 5. Unique cities
SELECT DISTINCT City FROM Customers;

-- 6. Products sorted by price, highest first
SELECT ProductName, Price FROM Products ORDER BY Price DESC;

-- 7. Cheapest product   (T-SQL uses TOP, not LIMIT)
SELECT TOP 1 * FROM Products ORDER BY Price ASC;

-- 8. Most expensive product
SELECT TOP 1 * FROM Products ORDER BY Price DESC;

-- 9. Total number of customers
SELECT COUNT(*) AS TotalCustomers FROM Customers;

-- 10. Total number of products
SELECT COUNT(*) AS TotalProducts FROM Products;

-- 11. Average product price
SELECT AVG(Price) AS AveragePrice FROM Products;

-- 12. Total stock across all products
SELECT SUM(StockQuantity) AS TotalStock FROM Products;

-- 13. Highest product price
SELECT MAX(Price) AS MaxPrice FROM Products;

-- 14. Lowest product price
SELECT MIN(Price) AS MinPrice FROM Products;

-- 15. Number of customers per city
SELECT City, COUNT(*) AS CustomerCount
FROM Customers
GROUP BY City;

-- 16. Number of products per category
SELECT CategoryID, COUNT(*) AS ProductCount
FROM Products
GROUP BY CategoryID;

-- 17. Average price per category
SELECT CategoryID, AVG(Price) AS AveragePrice
FROM Products
GROUP BY CategoryID;

-- 18. Categories with more than 2 products
SELECT CategoryID, COUNT(*) AS ProductCount
FROM Products
GROUP BY CategoryID
HAVING COUNT(*) > 2;

-- 19. Total quantity sold per product
SELECT ProductID, SUM(Quantity) AS TotalQuantitySold
FROM OrderItems
GROUP BY ProductID;

-- 20. Revenue per order line
SELECT OrderItemID, OrderID, ProductID, Quantity, UnitPrice,
       (Quantity * UnitPrice) AS Revenue
FROM OrderItems;
