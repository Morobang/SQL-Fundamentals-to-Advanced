# 01_Insert_Operations.md - Mastering Data Insertion

## 🎯 Learning Objectives

After completing this lesson, you will be able to:
- Write basic INSERT statements to add single records
- Insert multiple records efficiently in one operation
- Handle different data types correctly during insertion
- Work with auto-increment and default values
- Insert data from other tables using subqueries
- Apply best practices for safe and efficient data insertion

## 📖 What is INSERT?

The INSERT statement is used to add new records (rows) to a table. It's one of the fundamental Data Manipulation Language (DML) operations in SQL. Think of it as adding new entries to a spreadsheet - you're creating new rows with data in the appropriate columns.

## 🔧 Basic INSERT Syntax

### Single Record Insertion

```sql
INSERT INTO table_name (column1, column2, column3)
VALUES (value1, value2, value3);
```

**Key Components:**
- `INSERT INTO`: SQL keyword indicating we want to add data
- `table_name`: The target table where data will be added
- `(column1, column2, column3)`: Column list (optional if inserting into all columns)
- `VALUES`: Keyword indicating the data values follow
- `(value1, value2, value3)`: The actual data values

### Multiple Records Insertion

```sql
INSERT INTO table_name (column1, column2, column3)
VALUES 
    (value1a, value2a, value3a),
    (value1b, value2b, value3b),
    (value1c, value2c, value3c);
```

## 📝 Real-World Examples

### Example 1: Adding a Customer

```sql
-- Insert a new customer
INSERT INTO Customers (CustomerID, FirstName, LastName, Email, Phone)
VALUES (1, 'John', 'Smith', 'john.smith@email.com', '555-123-4567');
```

### Example 2: Adding Multiple Products

```sql
-- Insert multiple products at once
INSERT INTO Products (ProductName, Price, Category, InStock)
VALUES 
    ('Laptop Computer', 999.99, 'Electronics', 50),
    ('Office Chair', 199.99, 'Furniture', 25),
    ('Coffee Mug', 12.99, 'Kitchen', 100);
```

## 🎭 Working with Different Data Types

### Text Data
```sql
INSERT INTO Users (Username, FirstName, LastName, Bio)
VALUES ('jsmith', 'John', 'Smith', 'Software developer from New York');
```

### Numeric Data
```sql
INSERT INTO Products (ProductID, Price, Weight, Quantity)
VALUES (101, 29.99, 1.5, 100);
```

### Date and Time Data
```sql
INSERT INTO Orders (OrderID, CustomerID, OrderDate, ShipDate)
VALUES (1001, 123, '2024-10-19', '2024-10-21');

-- Using current date/time
INSERT INTO UserSessions (UserID, LoginTime)
VALUES (456, GETDATE()); -- SQL Server
-- VALUES (456, NOW());     -- MySQL
-- VALUES (456, CURRENT_TIMESTAMP); -- PostgreSQL
```

### Boolean Data
```sql
INSERT INTO UserPreferences (UserID, EmailNotifications, DarkMode)
VALUES (789, 1, 0); -- 1 = true, 0 = false

-- Or with proper boolean values (depends on database)
INSERT INTO UserPreferences (UserID, EmailNotifications, DarkMode)
VALUES (790, TRUE, FALSE);
```

## 🔑 Handling Primary Keys and Auto-Increment

### Auto-Increment Columns
```sql
-- When ID is auto-increment, omit it from the INSERT
INSERT INTO Customers (FirstName, LastName, Email)
VALUES ('Jane', 'Doe', 'jane.doe@email.com');

-- The database automatically assigns the next ID
```

### Manual Primary Key Assignment
```sql
-- When you control the primary key value
INSERT INTO Categories (CategoryID, CategoryName, Description)
VALUES (1, 'Electronics', 'Electronic devices and accessories');
```

## 🎲 Working with Default Values

### Using Column Defaults
```sql
-- If CreatedDate has a default of GETDATE()
INSERT INTO Posts (UserID, Title, Content)
VALUES (123, 'My First Post', 'This is the content of my first post');
-- CreatedDate will automatically use the default value
```

### Explicitly Setting NULL
```sql
-- Explicitly inserting NULL (if column allows it)
INSERT INTO Customers (FirstName, LastName, MiddleName, Email)
VALUES ('John', 'Smith', NULL, 'john.smith@email.com');
```

## 📊 INSERT with Subqueries

### Copying Data from Another Table
```sql
-- Insert customer data from a temporary import table
INSERT INTO Customers (FirstName, LastName, Email)
SELECT FirstName, LastName, Email
FROM TempCustomerImport
WHERE IsValid = 1;
```

### Using Calculated Values
```sql
-- Insert order totals calculated from order details
INSERT INTO OrderSummary (OrderID, TotalAmount, ItemCount)
SELECT 
    OrderID, 
    SUM(Price * Quantity) AS TotalAmount,
    COUNT(*) AS ItemCount
FROM OrderDetails
GROUP BY OrderID;
```

## ⚠️ Common Mistakes and How to Avoid Them

### Mistake 1: Column/Value Mismatch
```sql
-- WRONG: Number of columns doesn't match number of values
INSERT INTO Customers (FirstName, LastName, Email)
VALUES ('John', 'Smith'); -- Missing email value

-- CORRECT: Match columns and values
INSERT INTO Customers (FirstName, LastName, Email)
VALUES ('John', 'Smith', 'john.smith@email.com');
```

### Mistake 2: Data Type Mismatches
```sql
-- WRONG: Trying to insert text into numeric column
INSERT INTO Products (ProductID, ProductName, Price)
VALUES ('ABC', 'Laptop', 999.99); -- ProductID expects number

-- CORRECT: Use appropriate data types
INSERT INTO Products (ProductID, ProductName, Price)
VALUES (123, 'Laptop', 999.99);
```

### Mistake 3: Violating Constraints
```sql
-- WRONG: Duplicate primary key
INSERT INTO Customers (CustomerID, FirstName, LastName)
VALUES (1, 'John', 'Smith');
INSERT INTO Customers (CustomerID, FirstName, LastName)
VALUES (1, 'Jane', 'Doe'); -- Error: Duplicate primary key

-- CORRECT: Use unique primary keys
INSERT INTO Customers (CustomerID, FirstName, LastName)
VALUES (1, 'John', 'Smith');
INSERT INTO Customers (CustomerID, FirstName, LastName)
VALUES (2, 'Jane', 'Doe');
```

## 🚀 Performance Considerations

### Bulk Inserts vs. Single Inserts
```sql
-- SLOW: Multiple single inserts
INSERT INTO Products (ProductName, Price) VALUES ('Product A', 10.00);
INSERT INTO Products (ProductName, Price) VALUES ('Product B', 15.00);
INSERT INTO Products (ProductName, Price) VALUES ('Product C', 20.00);

-- FAST: Single bulk insert
INSERT INTO Products (ProductName, Price)
VALUES 
    ('Product A', 10.00),
    ('Product B', 15.00),
    ('Product C', 20.00);
```

### Transaction Management for Large Inserts
```sql
-- Wrap large inserts in transactions
BEGIN TRANSACTION;

INSERT INTO LargeTable (Column1, Column2)
SELECT Column1, Column2
FROM SourceTable
WHERE SomeCondition = 1;

-- Check if insert was successful
IF @@ROWCOUNT > 0
    COMMIT TRANSACTION;
ELSE
    ROLLBACK TRANSACTION;
```

## 🛡️ Best Practices for INSERT Operations

### 1. Always Specify Column Names
```sql
-- GOOD: Explicit column specification
INSERT INTO Customers (FirstName, LastName, Email)
VALUES ('John', 'Smith', 'john@email.com');

-- AVOID: Relying on column order
INSERT INTO Customers 
VALUES ('John', 'Smith', 'john@email.com', '555-1234', ...);
```

### 2. Validate Data Before Insertion
```sql
-- Check for duplicates before inserting
IF NOT EXISTS (SELECT 1 FROM Customers WHERE Email = 'john@email.com')
BEGIN
    INSERT INTO Customers (FirstName, LastName, Email)
    VALUES ('John', 'Smith', 'john@email.com');
END
```

### 3. Handle Errors Gracefully
```sql
-- Use TRY-CATCH for error handling (SQL Server example)
BEGIN TRY
    INSERT INTO Customers (FirstName, LastName, Email)
    VALUES ('John', 'Smith', 'john@email.com');
    PRINT 'Customer inserted successfully';
END TRY
BEGIN CATCH
    PRINT 'Error inserting customer: ' + ERROR_MESSAGE();
END CATCH
```

### 4. Use Parameterized Queries (Application Code)
```sql
-- Good practice in application code (prevents SQL injection)
-- Example structure (actual syntax varies by programming language):
-- INSERT INTO Users (Username, Password) VALUES (?, ?)
-- Parameters: [@username, @hashed_password]
```

## 🔍 Verification and Testing

### Check Your Inserts
```sql
-- Verify data was inserted correctly
SELECT * FROM Customers WHERE CustomerID = 1;

-- Count records before and after
SELECT COUNT(*) AS RecordCount FROM Products;
-- ... perform insert ...
SELECT COUNT(*) AS RecordCount FROM Products;
```

### Test with Different Data Types
```sql
-- Test inserting various data types
INSERT INTO TestTable (
    TextColumn, 
    IntColumn, 
    DecimalColumn, 
    DateColumn, 
    BoolColumn
)
VALUES (
    'Test text with special chars: àáâã', 
    42, 
    99.99, 
    '2024-10-19', 
    1
);
```

## 🎯 Real-World Scenarios

### E-commerce Product Catalog
```sql
-- Adding new products to an online store
INSERT INTO Products (SKU, ProductName, Description, Price, CategoryID, InStock, IsActive)
VALUES 
    ('ELEC-LAP-001', 'Gaming Laptop', 'High-performance laptop for gaming', 1299.99, 1, 15, 1),
    ('FURN-CHR-001', 'Ergonomic Office Chair', 'Comfortable chair for long work sessions', 299.99, 2, 8, 1),
    ('BOOK-FIC-001', 'Mystery Novel', 'Bestselling thriller by acclaimed author', 14.99, 3, 50, 1);
```

### User Registration System
```sql
-- Adding new user accounts
INSERT INTO Users (Username, Email, PasswordHash, CreatedDate, IsActive, EmailVerified)
VALUES 
    ('johndoe123', 'john.doe@email.com', 'hashed_password_here', GETDATE(), 1, 0),
    ('janesmit456', 'jane.smith@email.com', 'hashed_password_here', GETDATE(), 1, 0);
```

### Order Processing
```sql
-- Creating a new order with multiple items
-- First, insert the order header
INSERT INTO Orders (CustomerID, OrderDate, ShippingAddress, OrderStatus)
VALUES (123, GETDATE(), '123 Main St, City, State 12345', 'Pending');

-- Get the new order ID (method varies by database)
DECLARE @NewOrderID INT = SCOPE_IDENTITY(); -- SQL Server

-- Then insert order details
INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice)
VALUES 
    (@NewOrderID, 101, 2, 29.99),
    (@NewOrderID, 102, 1, 49.99),
    (@NewOrderID, 103, 3, 19.99);
```

## 🔗 Connection to Other Operations

Understanding INSERT operations sets the foundation for:
- **UPDATE operations**: Modifying data you've inserted
- **DELETE operations**: Removing data when needed
- **SELECT operations**: Querying the data you've added
- **JOIN operations**: Relating inserted data across tables

## 📚 What's Next?

Now that you understand how to add data to tables, you're ready to learn how to modify existing data with UPDATE operations. The concepts you've learned here about data types, constraints, and best practices will apply directly to updating records.

## 💡 Key Takeaways

1. **INSERT adds new records** to existing tables
2. **Always specify column names** for clarity and maintainability
3. **Match data types** between your values and table columns
4. **Use bulk inserts** for better performance with multiple records
5. **Handle auto-increment columns** by omitting them from your INSERT
6. **Validate and test** your inserts to ensure data integrity
7. **Use transactions** for complex or large insert operations

Ready to practice? Head over to `02_Code/01_Insert_Examples.sql` to see these concepts in action, then challenge yourself with `03_Practice/01_Insert_Practice.sql`!

---

*Next: [02_Update_Operations.md](02_Update_Operations.md) - Learn to modify existing data safely and efficiently.*