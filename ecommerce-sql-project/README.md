# E-Commerce Order Management & Sales Analytics (MS SQL Server)

A relational database project built with **Microsoft SQL Server (T-SQL)** that
models a small e-commerce system — customers, products, orders, payments and
reviews — and includes both transactional logic (stored procedures, triggers)
and analytical reporting (views, joins, CTEs, window functions).

Built as a resume project for SQL Developer / Data fresher roles.

---

## Project Objective

- Design a normalized relational schema for an e-commerce business
- Handle order placement and cancellation safely using **transactions**
- Automatically manage stock and audit logs using **triggers**
- Answer business questions using **JOINs, subqueries, CTEs, CASE, and window functions**
- Build reusable **views** and **indexes** for reporting

---

## SQL Skills Demonstrated

DDL • DML • Constraints (PK/FK/CHECK) • Stored Procedures • Triggers •
Transactions (TRY/CATCH) • JOINs • GROUP BY / HAVING • Subqueries • CTEs •
Window Functions (RANK, ROW_NUMBER, running totals) • CASE expressions •
Views • Indexes

---

## Database Structure

```
Categories --< Products --< OrderItems >-- Orders --< Payments
                  |                            |
               Reviews                      Customers
```

**8 tables:**

| Table         | Purpose                                      |
|---------------|-----------------------------------------------|
| Customers     | Customer details                              |
| Categories    | Product categories                            |
| Products      | Product catalog with price & stock            |
| Orders        | Order header (status, total, date)            |
| OrderItems    | Line items per order                          |
| Payments      | Payment records per order                     |
| Reviews       | Customer product ratings                      |
| InventoryLog  | Audit log of stock changes (used by triggers) |

---

## Folder Structure

```
ecommerce-sql-project/
│
├── README.md
│
├── database/
│   ├── 01_create_database_and_tables.sql
│   ├── 02_insert_sample_data.sql
│   └── 03_indexes.sql
│
├── procedures_triggers/
│   ├── 04_stored_procedures.sql
│   └── 05_triggers.sql
│
├── views/
│   └── 06_views.sql
│
├── queries/
│   ├── 07_basic_and_aggregate_queries.sql
│   ├── 08_join_queries.sql
│   ├── 09_subqueries_and_ctes.sql
│   └── 10_case_and_window_functions.sql
│
└── screenshots/
    (add your own SSMS screenshots here: schema diagram, query results, etc.)
```

---

## How to Run This Project

1. Open **SQL Server Management Studio (SSMS)** and connect to your local server.
2. Run the files **in this exact order**:
   1. `database/01_create_database_and_tables.sql`
   2. `database/02_insert_sample_data.sql`
   3. `database/03_indexes.sql`
   4. `procedures_triggers/04_stored_procedures.sql`
   5. `procedures_triggers/05_triggers.sql`
   6. `views/06_views.sql`
3. Then run any file in `queries/` to explore the data.
4. Try the stored procedures yourself:
   ```sql
   EXEC usp_PlaceOrder @CustomerID = 1, @ProductID = 3, @Quantity = 2;
   EXEC usp_CancelOrder @OrderID = 13;
   EXEC usp_GetCustomerOrderHistory @CustomerID = 1;
   ```

---

## Key Design Decisions

- **Transactions with TRY/CATCH** in `usp_PlaceOrder` and `usp_CancelOrder`
  guarantee that partial failures don't leave the data inconsistent — if
  anything fails mid-way, everything rolls back.
- **Stock deduction lives in a trigger** (`trg_AfterOrderItemInsert`), not
  just the stored procedure. This means stock is protected even if a row is
  inserted into `OrderItems` some other way, not only through the procedure.
- **`trg_PreventNegativeStock`** is a second, independent safety net at the
  table level — it blocks stock from ever going negative no matter what
  caused the update.
- **`UnitPrice` is stored on `OrderItems`, not just looked up from `Products`**,
  because a product's price today shouldn't change what a customer was
  charged in a past order. This is a common data-modeling interview question.
- **Indexes** were added on foreign key columns (`CustomerID`, `ProductID`,
  `OrderID`) and `OrderDate`, since those are the columns most queries filter
  or join on.

**Technologies:** MS SQL Server | T-SQL | SSMS | Stored Procedures | Triggers | Views | Indexes

---

## Notes

This is a learning/portfolio project built with a small hand-crafted sample
dataset — it's meant to demonstrate SQL Server concepts clearly, not to be a
production-scale system.
