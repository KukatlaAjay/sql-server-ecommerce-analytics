/* ==========================================================
   File: 03_indexes.sql
   Purpose: Indexes on frequently joined / filtered columns
   ========================================================== */

USE ECommerceDB;
GO

CREATE INDEX IX_Orders_CustomerID       ON Orders(CustomerID);
CREATE INDEX IX_Orders_OrderDate        ON Orders(OrderDate);
CREATE INDEX IX_OrderItems_OrderID      ON OrderItems(OrderID);
CREATE INDEX IX_OrderItems_ProductID    ON OrderItems(ProductID);
CREATE INDEX IX_Products_CategoryID     ON Products(CategoryID);
CREATE INDEX IX_Reviews_ProductID       ON Reviews(ProductID);
GO

PRINT 'Indexes created successfully.';

/*
   WHY THESE INDEXES?
   -------------------
   - CustomerID / ProductID / OrderID columns are used in almost every JOIN
     in the queries folder, so indexing them speeds up lookups.
   - OrderDate is used for date-range and monthly sales reports.
   - Indexing does NOT make every query faster -- it speeds up reads but
     adds a small overhead to INSERT/UPDATE/DELETE, because the index
     itself has to be updated too. That trade-off is worth mentioning
     if asked about it in an interview.
*/
