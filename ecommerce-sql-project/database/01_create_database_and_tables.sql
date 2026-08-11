/* ==========================================================
   E-COMMERCE ORDER MANAGEMENT & SALES ANALYTICS
   MS SQL Server Project
   File: 01_create_database_and_tables.sql
   Purpose: Create the database and all base tables
   ========================================================== */

CREATE DATABASE ECommerceDB;
GO

USE ECommerceDB;
GO

-- ==========================================================
-- Table: Customers
-- ==========================================================
CREATE TABLE Customers (
    CustomerID      INT IDENTITY(1,1) PRIMARY KEY,
    CustomerName    VARCHAR(100) NOT NULL,
    Email           VARCHAR(100) UNIQUE NOT NULL,
    Phone           VARCHAR(15),
    City            VARCHAR(50),
    State           VARCHAR(50),
    RegistrationDate DATE DEFAULT GETDATE()
);
GO

-- ==========================================================
-- Table: Categories
-- ==========================================================
CREATE TABLE Categories (
    CategoryID      INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName    VARCHAR(50) NOT NULL
);
GO

-- ==========================================================
-- Table: Products
-- ==========================================================
CREATE TABLE Products (
    ProductID       INT IDENTITY(1,1) PRIMARY KEY,
    ProductName     VARCHAR(100) NOT NULL,
    CategoryID      INT NOT NULL FOREIGN KEY REFERENCES Categories(CategoryID),
    Price           DECIMAL(10,2) NOT NULL CHECK (Price > 0),
    StockQuantity   INT NOT NULL CHECK (StockQuantity >= 0)
);
GO

-- ==========================================================
-- Table: Orders  (order header)
-- ==========================================================
CREATE TABLE Orders (
    OrderID         INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID      INT NOT NULL FOREIGN KEY REFERENCES Customers(CustomerID),
    OrderDate       DATETIME DEFAULT GETDATE(),
    OrderStatus     VARCHAR(20) DEFAULT 'Pending',   -- Pending, Completed, Cancelled
    TotalAmount     DECIMAL(10,2) DEFAULT 0
);
GO

-- ==========================================================
-- Table: OrderItems  (line items per order)
-- ==========================================================
CREATE TABLE OrderItems (
    OrderItemID     INT IDENTITY(1,1) PRIMARY KEY,
    OrderID         INT NOT NULL FOREIGN KEY REFERENCES Orders(OrderID),
    ProductID       INT NOT NULL FOREIGN KEY REFERENCES Products(ProductID),
    Quantity        INT NOT NULL CHECK (Quantity > 0),
    UnitPrice       DECIMAL(10,2) NOT NULL
);
GO

-- ==========================================================
-- Table: Payments
-- ==========================================================
CREATE TABLE Payments (
    PaymentID       INT IDENTITY(1,1) PRIMARY KEY,
    OrderID         INT NOT NULL FOREIGN KEY REFERENCES Orders(OrderID),
    PaymentDate     DATETIME DEFAULT GETDATE(),
    PaymentMethod   VARCHAR(20),          -- UPI, Credit Card, Debit Card, Cash
    PaymentStatus   VARCHAR(20) DEFAULT 'Success',  -- Success, Pending, Refunded
    Amount          DECIMAL(10,2) NOT NULL
);
GO

-- ==========================================================
-- Table: Reviews
-- ==========================================================
CREATE TABLE Reviews (
    ReviewID        INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID      INT NOT NULL FOREIGN KEY REFERENCES Customers(CustomerID),
    ProductID       INT NOT NULL FOREIGN KEY REFERENCES Products(ProductID),
    Rating          INT NOT NULL CHECK (Rating BETWEEN 1 AND 5),
    ReviewDate      DATE DEFAULT GETDATE()
);
GO

-- ==========================================================
-- Table: InventoryLog  (audit trail - used by triggers)
-- ==========================================================
CREATE TABLE InventoryLog (
    LogID           INT IDENTITY(1,1) PRIMARY KEY,
    ProductID       INT NOT NULL,
    ChangeType      VARCHAR(20),          -- SALE or RESTOCK
    QuantityChanged INT,
    ChangeDate      DATETIME DEFAULT GETDATE()
);
GO

PRINT 'All tables created successfully.';
