-- Module 02: Insert, Update & Delete
-- 01_Insert_Examples.sql - Comprehensive INSERT Operation Examples

-- Instructions: Study these examples to understand INSERT operations in practice
-- Run these examples in your practice database to see how they work
-- Prerequisites: Complete Module 01 (Create) and read 01_Teaching/01_Insert_Operations.md

-- Make sure you're in a practice database
USE TshigidimasaDB;  -- Change to your practice database name

-- =====================================================
-- SETUP: CREATE TABLES FOR INSERT EXAMPLES
-- =====================================================

-- Create sample tables for our examples
CREATE TABLE SampleCustomers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(20),
    DateJoined DATE DEFAULT GETDATE(),
    IsActive BIT DEFAULT 1,
    CustomerType VARCHAR(20) DEFAULT 'Standard'
);

CREATE TABLE SampleProducts (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName VARCHAR(200) NOT NULL,
    Description TEXT,
    Price DECIMAL(10,2) NOT NULL,
    CategoryID INT,
    InStock INT DEFAULT 0,
    CreatedDate DATETIME DEFAULT GETDATE(),
    IsActive BIT DEFAULT 1
);

CREATE TABLE SampleOrders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT,
    OrderDate DATETIME DEFAULT GETDATE(),
    TotalAmount DECIMAL(10,2),
    OrderStatus VARCHAR(20) DEFAULT 'Pending',
    ShippingAddress TEXT,
    FOREIGN KEY (CustomerID) REFERENCES SampleCustomers(CustomerID)
);

CREATE TABLE SampleOrderDetails (
    OrderDetailID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES SampleOrders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES SampleProducts(ProductID)
);

-- =====================================================
-- BASIC INSERT EXAMPLES
-- =====================================================

-- Example 1: Simple single record insert
-- Notice we don't specify CustomerID (it's auto-increment)
INSERT INTO SampleCustomers (FirstName, LastName, Email, Phone)
VALUES ('John', 'Smith', 'john.smith@email.com', '555-123-4567');

-- Example 2: Insert using all columns (except auto-increment)
INSERT INTO SampleCustomers (FirstName, LastName, Email, Phone, DateJoined, IsActive, CustomerType)
VALUES ('Jane', 'Doe', 'jane.doe@email.com', '555-987-6543', '2024-10-15', 1, 'Premium');

-- Example 3: Insert with some default values (omit columns that have defaults)
INSERT INTO SampleCustomers (FirstName, LastName, Email)
VALUES ('Bob', 'Johnson', 'bob.johnson@email.com');
-- DateJoined, IsActive, and CustomerType will use their default values

-- Example 4: Insert with NULL values (for columns that allow them)
INSERT INTO SampleCustomers (FirstName, LastName, Email, Phone)
VALUES ('Alice', 'Brown', 'alice.brown@email.com', NULL);

-- =====================================================
-- MULTIPLE RECORD INSERTS
-- =====================================================

-- Example 5: Insert multiple customers in one statement
INSERT INTO SampleCustomers (FirstName, LastName, Email, Phone, CustomerType)
VALUES 
    ('Mike', 'Wilson', 'mike.wilson@email.com', '555-111-2222', 'Premium'),
    ('Sarah', 'Davis', 'sarah.davis@email.com', '555-333-4444', 'Standard'),
    ('Tom', 'Miller', 'tom.miller@email.com', '555-555-6666', 'VIP'),
    ('Lisa', 'Garcia', 'lisa.garcia@email.com', '555-777-8888', 'Standard');

-- Example 6: Insert multiple products with different data types
INSERT INTO SampleProducts (ProductName, Description, Price, CategoryID, InStock)
VALUES 
    ('Gaming Laptop', 'High-performance laptop for gaming and development', 1299.99, 1, 15),
    ('Wireless Mouse', 'Ergonomic wireless mouse with precision tracking', 49.99, 1, 50),
    ('Office Chair', 'Comfortable ergonomic office chair', 299.99, 2, 8),
    ('Coffee Mug', 'Ceramic coffee mug with company logo', 12.99, 3, 100),
    ('Desk Lamp', 'LED desk lamp with adjustable brightness', 79.99, 2, 25);

-- =====================================================
-- WORKING WITH DIFFERENT DATA TYPES
-- =====================================================

-- Example 7: Date and time insertions
INSERT INTO SampleOrders (CustomerID, OrderDate, TotalAmount, OrderStatus, ShippingAddress)
VALUES 
    (1, '2024-10-15 09:30:00', 1349.98, 'Pending', '123 Main St, Anytown, ST 12345'),
    (2, '2024-10-16 14:45:00', 62.98, 'Shipped', '456 Oak Ave, Another City, ST 67890');

-- Example 8: Using current date/time functions
INSERT INTO SampleOrders (CustomerID, OrderDate, TotalAmount, OrderStatus)
VALUES 
    (3, GETDATE(), 299.99, 'Processing'),  -- Current date and time
    (4, CAST(GETDATE() AS DATE), 92.98, 'Pending');  -- Current date only

-- Example 9: Boolean/bit data
-- Note: In SQL Server, use 1 for TRUE and 0 for FALSE
INSERT INTO SampleProducts (ProductName, Price, CategoryID, InStock, IsActive)
VALUES 
    ('Discontinued Item', 99.99, 1, 0, 0),  -- IsActive = 0 (FALSE)
    ('New Product', 199.99, 2, 10, 1);      -- IsActive = 1 (TRUE)

-- =====================================================
-- HANDLING AUTO-INCREMENT AND IDENTITY COLUMNS
-- =====================================================

-- Example 10: Getting the auto-generated ID after insert
INSERT INTO SampleCustomers (FirstName, LastName, Email)
VALUES ('New', 'Customer', 'newcustomer@email.com');

-- Get the ID that was just generated
SELECT SCOPE_IDENTITY() AS NewCustomerID;

-- Example 11: Using the generated ID in subsequent inserts
DECLARE @NewCustomerID INT;

INSERT INTO SampleCustomers (FirstName, LastName, Email)
VALUES ('Another', 'Customer', 'another@email.com');

SET @NewCustomerID = SCOPE_IDENTITY();

-- Now use that ID to create an order for the new customer
INSERT INTO SampleOrders (CustomerID, TotalAmount)
VALUES (@NewCustomerID, 150.00);

-- =====================================================
-- INSERT WITH SUBQUERIES
-- =====================================================

-- Example 12: Insert data based on existing data
-- Create order details for the orders we just created
INSERT INTO SampleOrderDetails (OrderID, ProductID, Quantity, UnitPrice)
SELECT 
    o.OrderID,
    p.ProductID,
    2 AS Quantity,  -- Order 2 of each product
    p.Price AS UnitPrice
FROM SampleOrders o
CROSS JOIN (SELECT TOP 2 ProductID, Price FROM SampleProducts WHERE IsActive = 1) p
WHERE o.OrderStatus = 'Pending';

-- Example 13: Copy data from one table to another
-- First, let's create a temp table with customer data
CREATE TABLE #TempCustomers (
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    ImportDate DATE
);

INSERT INTO #TempCustomers VALUES 
    ('Import', 'Customer1', 'import1@email.com', '2024-10-19'),
    ('Import', 'Customer2', 'import2@email.com', '2024-10-19'),
    ('Import', 'Customer3', 'import3@email.com', '2024-10-19');

-- Now insert from temp table into main table
INSERT INTO SampleCustomers (FirstName, LastName, Email, CustomerType)
SELECT FirstName, LastName, Email, 'Imported'
FROM #TempCustomers
WHERE ImportDate = '2024-10-19';

-- Clean up temp table
DROP TABLE #TempCustomers;

-- =====================================================
-- CONDITIONAL INSERTS
-- =====================================================

-- Example 14: Insert only if record doesn't exist
-- Check if customer exists before inserting
IF NOT EXISTS (SELECT 1 FROM SampleCustomers WHERE Email = 'conditional@email.com')
BEGIN
    INSERT INTO SampleCustomers (FirstName, LastName, Email)
    VALUES ('Conditional', 'Insert', 'conditional@email.com');
    PRINT 'Customer inserted successfully';
END
ELSE
BEGIN
    PRINT 'Customer with this email already exists';
END

-- Example 15: INSERT with WHERE clause (using subquery)
-- Insert products that don't already exist
INSERT INTO SampleProducts (ProductName, Price, CategoryID)
SELECT 'Unique Product', 99.99, 1
WHERE NOT EXISTS (
    SELECT 1 FROM SampleProducts 
    WHERE ProductName = 'Unique Product'
);

-- =====================================================
-- BULK INSERT EXAMPLES
-- =====================================================

-- Example 16: Large batch insert for performance
-- Insert many customers at once
INSERT INTO SampleCustomers (FirstName, LastName, Email, CustomerType)
VALUES 
    ('Bulk01', 'Customer', 'bulk01@email.com', 'Standard'),
    ('Bulk02', 'Customer', 'bulk02@email.com', 'Standard'),
    ('Bulk03', 'Customer', 'bulk03@email.com', 'Standard'),
    ('Bulk04', 'Customer', 'bulk04@email.com', 'Premium'),
    ('Bulk05', 'Customer', 'bulk05@email.com', 'Premium'),
    ('Bulk06', 'Customer', 'bulk06@email.com', 'Standard'),
    ('Bulk07', 'Customer', 'bulk07@email.com', 'VIP'),
    ('Bulk08', 'Customer', 'bulk08@email.com', 'Standard'),
    ('Bulk09', 'Customer', 'bulk09@email.com', 'Premium'),
    ('Bulk10', 'Customer', 'bulk10@email.com', 'Standard');

-- =====================================================
-- HANDLING CONSTRAINTS AND ERRORS
-- =====================================================

-- Example 17: Dealing with foreign key constraints
-- This will work (customer ID 1 exists)
INSERT INTO SampleOrders (CustomerID, TotalAmount)
VALUES (1, 199.99);

-- This would fail (customer ID 999 doesn't exist)
-- Uncomment to see the error:
-- INSERT INTO SampleOrders (CustomerID, TotalAmount)
-- VALUES (999, 199.99);

-- Example 18: Handling unique constraint violations
-- This will work the first time
INSERT INTO SampleCustomers (FirstName, LastName, Email)
VALUES ('Unique', 'Email', 'unique.test@email.com');

-- This would fail (duplicate email)
-- Uncomment to see the error:
-- INSERT INTO SampleCustomers (FirstName, LastName, Email)
-- VALUES ('Another', 'Person', 'unique.test@email.com');

-- =====================================================
-- TRANSACTION EXAMPLES
-- =====================================================

-- Example 19: Using transactions for data integrity
BEGIN TRANSACTION;

BEGIN TRY
    -- Insert customer
    INSERT INTO SampleCustomers (FirstName, LastName, Email)
    VALUES ('Transaction', 'Test', 'transaction.test@email.com');
    
    DECLARE @CustomerID INT = SCOPE_IDENTITY();
    
    -- Insert order for that customer
    INSERT INTO SampleOrders (CustomerID, TotalAmount)
    VALUES (@CustomerID, 299.99);
    
    DECLARE @OrderID INT = SCOPE_IDENTITY();
    
    -- Insert order details
    INSERT INTO SampleOrderDetails (OrderID, ProductID, Quantity, UnitPrice)
    VALUES (@OrderID, 1, 2, 149.995);  -- Note: deliberate decimal issue
    
    -- If we get here, commit the transaction
    COMMIT TRANSACTION;
    PRINT 'Transaction completed successfully';
    
END TRY
BEGIN CATCH
    -- If anything fails, rollback
    ROLLBACK TRANSACTION;
    PRINT 'Transaction failed: ' + ERROR_MESSAGE();
END CATCH

-- =====================================================
-- ADVANCED INSERT PATTERNS
-- =====================================================

-- Example 20: INSERT with calculated values
INSERT INTO SampleOrderDetails (OrderID, ProductID, Quantity, UnitPrice)
SELECT 
    o.OrderID,
    p.ProductID,
    CASE 
        WHEN p.Price > 1000 THEN 1
        WHEN p.Price > 100 THEN 2
        ELSE 3
    END AS Quantity,
    p.Price * 0.9 AS UnitPrice  -- 10% discount
FROM SampleOrders o
CROSS JOIN SampleProducts p
WHERE o.OrderStatus = 'Processing'
  AND p.IsActive = 1
  AND NOT EXISTS (
      SELECT 1 FROM SampleOrderDetails od 
      WHERE od.OrderID = o.OrderID AND od.ProductID = p.ProductID
  );

-- Example 21: INSERT with data transformation
-- Create a staging table
CREATE TABLE #CustomerImport (
    FullName VARCHAR(100),
    EmailAddress VARCHAR(100),
    PhoneNumber VARCHAR(20),
    JoinDate VARCHAR(20)
);

-- Insert some test data
INSERT INTO #CustomerImport VALUES 
    ('John Q. Public', 'john.public@email.com', '(555) 123-4567', '2024-10-15'),
    ('Jane M. Smith', 'jane.smith@email.com', '555.987.6543', '10/16/2024');

-- Transform and insert into main table
INSERT INTO SampleCustomers (FirstName, LastName, Email, Phone, DateJoined)
SELECT 
    TRIM(LEFT(FullName, CHARINDEX(' ', FullName) - 1)) AS FirstName,
    TRIM(SUBSTRING(FullName, CHARINDEX(' ', FullName) + 1, 100)) AS LastName,
    LOWER(TRIM(EmailAddress)) AS Email,
    REPLACE(REPLACE(REPLACE(PhoneNumber, '(', ''), ')', ''), '.', '-') AS Phone,
    CAST(JoinDate AS DATE) AS DateJoined
FROM #CustomerImport;

-- Clean up
DROP TABLE #CustomerImport;

-- =====================================================
-- VERIFICATION AND TESTING
-- =====================================================

-- Example 22: Verify your inserts
-- Count records in each table
SELECT 'Customers' AS TableName, COUNT(*) AS RecordCount FROM SampleCustomers
UNION ALL
SELECT 'Products', COUNT(*) FROM SampleProducts
UNION ALL
SELECT 'Orders', COUNT(*) FROM SampleOrders
UNION ALL
SELECT 'OrderDetails', COUNT(*) FROM SampleOrderDetails;

-- Example 23: Check data quality
-- Look for potential data issues
SELECT 'Customers with NULL phone' AS Issue, COUNT(*) AS Count
FROM SampleCustomers WHERE Phone IS NULL
UNION ALL
SELECT 'Products with zero stock', COUNT(*)
FROM SampleProducts WHERE InStock = 0
UNION ALL
SELECT 'Orders without details', COUNT(*)
FROM SampleOrders o
LEFT JOIN SampleOrderDetails od ON o.OrderID = od.OrderID
WHERE od.OrderID IS NULL;

-- Example 24: Show relationships
-- Display orders with customer and product information
SELECT 
    c.FirstName + ' ' + c.LastName AS CustomerName,
    o.OrderID,
    o.OrderDate,
    o.OrderStatus,
    od.Quantity,
    p.ProductName,
    od.UnitPrice,
    (od.Quantity * od.UnitPrice) AS LineTotal
FROM SampleCustomers c
JOIN SampleOrders o ON c.CustomerID = o.CustomerID
JOIN SampleOrderDetails od ON o.OrderID = od.OrderID
JOIN SampleProducts p ON od.ProductID = p.ProductID
ORDER BY c.LastName, o.OrderDate;

-- =====================================================
-- CLEANUP (Optional)
-- =====================================================

-- Uncomment these lines if you want to remove all sample data
/*
DROP TABLE SampleOrderDetails;
DROP TABLE SampleOrders;
DROP TABLE SampleProducts;
DROP TABLE SampleCustomers;
*/

-- =====================================================
-- KEY LEARNING POINTS SUMMARY
-- =====================================================

/*
Key INSERT Concepts Demonstrated:

1. Basic INSERT syntax with VALUES clause
2. Auto-increment/IDENTITY column handling
3. Working with default values and NULL
4. Multiple record insertion
5. Different data types (text, numbers, dates, booleans)
6. INSERT with subqueries (SELECT)
7. Conditional inserts (IF NOT EXISTS)
8. Transaction usage for data integrity
9. Foreign key constraint handling
10. Bulk insert operations for performance
11. Data transformation during insert
12. Error handling with TRY-CATCH
13. Verification and data quality checks

Best Practices Shown:
- Always specify column names
- Use transactions for related inserts
- Handle errors gracefully
- Validate data before and after insertion
- Use appropriate data types
- Consider performance for bulk operations
*/

PRINT 'INSERT examples completed successfully!';
PRINT 'Next: Study 02_Update_Examples.sql';