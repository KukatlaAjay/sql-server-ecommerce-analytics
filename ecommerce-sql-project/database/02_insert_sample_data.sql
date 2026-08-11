/* ==========================================================
   File: 02_insert_sample_data.sql
   Purpose: Insert sample data into all tables
   Run this AFTER 01_create_database_and_tables.sql
   ========================================================== */

USE ECommerceDB;
GO

-- ==========================================================
-- Customers
-- ==========================================================
INSERT INTO Customers (CustomerName, Email, Phone, City, State) VALUES
('Rahul Sharma', 'rahul@email.com', '9876543210', 'Hyderabad', 'Telangana'),
('Priya Reddy',  'priya@email.com', '9876543211', 'Warangal',  'Telangana'),
('Arjun Kumar',  'arjun@email.com', '9876543212', 'Bangalore', 'Karnataka'),
('Sneha Rao',    'sneha@email.com', '9876543213', 'Chennai',   'Tamil Nadu'),
('Vikram Singh', 'vikram@email.com','9876543214', 'Delhi',     'Delhi'),
('Anjali Patel', 'anjali@email.com','9876543215', 'Mumbai',    'Maharashtra'),
('Kiran Reddy',  'kiran@email.com', '9876543216', 'Hyderabad', 'Telangana'),
('Neha Gupta',   'neha@email.com',  '9876543217', 'Pune',      'Maharashtra'),
('Ravi Kumar',   'ravikumar@email.com','9876543218','Warangal','Telangana'),
('Meena Das',    'meena@email.com', '9876543219', 'Kolkata',   'West Bengal');
GO

-- ==========================================================
-- Categories
-- ==========================================================
INSERT INTO Categories (CategoryName) VALUES
('Electronics'),
('Clothing'),
('Home Appliances'),
('Books'),
('Sports');
GO

-- ==========================================================
-- Products
-- ==========================================================
INSERT INTO Products (ProductName, CategoryID, Price, StockQuantity) VALUES
('Laptop',              1, 55000.00, 20),
('Smartphone',          1, 25000.00, 50),
('Headphones',          1, 2000.00, 100),
('Smart Watch',         1, 4500.00, 45),
('T-Shirt',             2, 800.00, 150),
('Jeans',               2, 1800.00, 80),
('Mixer Grinder',       3, 3500.00, 40),
('Air Fryer',           3, 6000.00, 30),
('Python Programming',  4, 700.00, 100),
('Data Science Book',   4, 900.00, 75),
('Cricket Bat',         5, 2500.00, 50),
('Football',            5, 1200.00, 60);
GO

-- ==========================================================
-- Orders  (historical orders - inserted directly for demo/report data)
-- ==========================================================
INSERT INTO Orders (CustomerID, OrderDate, OrderStatus, TotalAmount) VALUES
(1, '2024-07-01', 'Completed', 59000.00),
(2, '2024-07-02', 'Completed', 26600.00),
(3, '2024-07-05', 'Completed', 4300.00),
(1, '2024-07-10', 'Completed', 6500.00),
(4, '2024-07-12', 'Cancelled', 3500.00),
(5, '2024-07-15', 'Completed', 8500.00),
(6, '2024-07-18', 'Completed', 3600.00),
(7, '2024-07-20', 'Completed', 25000.00),
(8, '2024-07-22', 'Completed', 1800.00),
(9, '2024-07-25', 'Completed', 5000.00),
(10,'2024-08-01', 'Completed', 55000.00),
(3, '2024-08-05', 'Completed', 50000.00);
GO

-- ==========================================================
-- OrderItems
-- ==========================================================
INSERT INTO OrderItems (OrderID, ProductID, Quantity, UnitPrice) VALUES
(1, 1, 1, 55000.00),
(1, 3, 2, 2000.00),
(2, 2, 1, 25000.00),
(2, 5, 2, 800.00),
(3, 6, 2, 1800.00),
(3, 9, 1, 700.00),
(4, 4, 1, 4500.00),
(4, 3, 1, 2000.00),
(5, 7, 1, 3500.00),
(6, 8, 1, 6000.00),
(6, 11,1, 2500.00),
(7, 5, 3, 800.00),
(7, 12,1, 1200.00),
(8, 2, 1, 25000.00),
(9, 10,2, 900.00),
(10,11,2, 2500.00),
(11,1, 1, 55000.00),
(12,2, 2, 25000.00);
GO

-- ==========================================================
-- Payments
-- ==========================================================
INSERT INTO Payments (OrderID, PaymentDate, PaymentMethod, PaymentStatus, Amount) VALUES
(1, '2024-07-01', 'UPI',         'Success',  59000.00),
(2, '2024-07-02', 'Credit Card', 'Success',  26600.00),
(3, '2024-07-05', 'UPI',         'Success',  4300.00),
(4, '2024-07-10', 'Debit Card',  'Success',  6500.00),
(5, '2024-07-12', 'UPI',         'Refunded', 3500.00),
(6, '2024-07-15', 'Credit Card', 'Success',  8500.00),
(7, '2024-07-18', 'UPI',         'Success',  3600.00),
(8, '2024-07-20', 'Credit Card', 'Success',  25000.00),
(9, '2024-07-22', 'UPI',         'Success',  1800.00),
(10,'2024-07-25', 'Cash',        'Success',  5000.00),
(11,'2024-08-01', 'Credit Card', 'Success',  55000.00),
(12,'2024-08-05', 'UPI',         'Success',  50000.00);
GO

-- ==========================================================
-- Reviews
-- ==========================================================
INSERT INTO Reviews (CustomerID, ProductID, Rating, ReviewDate) VALUES
(1, 1, 5, '2024-07-05'),
(2, 2, 4, '2024-07-06'),
(3, 6, 3, '2024-07-08'),
(4, 5, 2, '2024-07-15'),
(5, 8, 5, '2024-07-18'),
(6, 12,4, '2024-07-20'),
(7, 2, 5, '2024-07-25'),
(8, 10,4, '2024-07-27'),
(9, 11,5, '2024-07-28'),
(10,1, 4, '2024-08-03');
GO

PRINT 'Sample data inserted successfully.';
