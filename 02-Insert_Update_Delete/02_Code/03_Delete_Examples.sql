-- Module 02: Insert, Update & Delete
-- 03_Delete_Examples.sql - Comprehensive DELETE Operation Examples

-- Instructions: Study these examples to understand DELETE operations in practice
-- Run these examples in your practice database to see how they work
-- Prerequisites: Complete previous examples and read 01_Teaching/03_Delete_Operations.md

-- Make sure you're in a practice database
USE TshigidimasaDB;  -- Change to your practice database name

-- ⚠️ CRITICAL WARNING ⚠️
-- DELETE operations are PERMANENT and IRREVERSIBLE!
-- Always backup your data before major deletions
-- Always test your WHERE clauses with SELECT first
-- Use transactions for complex deletions

PRINT '🚨 SAFETY REMINDER: DELETE operations cannot be undone!';
PRINT 'Always backup data and test WHERE clauses first!';

-- =====================================================
-- SETUP: CREATE BACKUP AND SAMPLE DATA
-- =====================================================

-- First, let's create backups of our important tables
SELECT * INTO CustomersBackup_DeleteExamples FROM SampleCustomers;
SELECT * INTO ProductsBackup_DeleteExamples FROM SampleProducts;
SELECT * INTO OrdersBackup_DeleteExamples FROM SampleOrders;

-- Create some test data specifically for deletion examples
INSERT INTO SampleCustomers (FirstName, LastName, Email, CustomerType, IsActive)
VALUES 
    ('Delete', 'Test1', 'delete1@test.com', 'Test', 0),
    ('Delete', 'Test2', 'delete2@test.com', 'Test', 0),
    ('Delete', 'Test3', 'delete3@test.com', 'Test', 1),
    ('Temp', 'User1', 'temp1@test.com', 'Temporary', 1),
    ('Temp', 'User2', 'temp2@test.com', 'Temporary', 1);

-- Create a temporary table for deletion practice
CREATE TABLE TempLogs (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    LogMessage VARCHAR(255),
    LogDate DATETIME DEFAULT GETDATE(),
    LogLevel VARCHAR(20),
    IsProcessed BIT DEFAULT 0
);

INSERT INTO TempLogs (LogMessage, LogLevel, LogDate, IsProcessed)
VALUES 
    ('System started', 'INFO', DATEADD(DAY, -10, GETDATE()), 1),
    ('Error occurred', 'ERROR', DATEADD(DAY, -9, GETDATE()), 1),
    ('User login', 'INFO', DATEADD(DAY, -8, GETDATE()), 1),
    ('System error', 'ERROR', DATEADD(DAY, -7, GETDATE()), 0),
    ('Debug message', 'DEBUG', DATEADD(DAY, -6, GETDATE()), 0),
    ('Warning issued', 'WARN', DATEADD(DAY, -5, GETDATE()), 0),
    ('Recent log entry', 'INFO', DATEADD(HOUR, -2, GETDATE()), 0);

PRINT 'Setup complete. Sample data and backups created.';

-- =====================================================
-- SAFE DELETE METHODOLOGY
-- =====================================================

-- Example 1: The proper way to delete - test first!

-- STEP 1: Always test your WHERE clause with SELECT first
SELECT LogID, LogMessage, LogLevel, LogDate, IsProcessed
FROM TempLogs 
WHERE LogLevel = 'DEBUG' AND IsProcessed = 1;

-- STEP 2: Count how many records will be deleted
SELECT COUNT(*) AS RecordsToDelete
FROM TempLogs 
WHERE LogLevel = 'DEBUG' AND IsProcessed = 1;

-- STEP 3: If the count looks right, proceed with DELETE
DELETE FROM TempLogs 
WHERE LogLevel = 'DEBUG' AND IsProcessed = 1;

-- STEP 4: Check how many were actually deleted
SELECT @@ROWCOUNT AS RecordsDeleted;

-- STEP 5: Verify the deletion worked as expected
SELECT COUNT(*) AS RemainingDebugRecords
FROM TempLogs 
WHERE LogLevel = 'DEBUG';

-- =====================================================
-- BASIC DELETE EXAMPLES
-- =====================================================

-- Example 2: Simple single record deletion
-- Delete a specific test customer
DELETE FROM SampleCustomers 
WHERE Email = 'delete1@test.com';

PRINT 'Deleted customer with email delete1@test.com';

-- Example 3: Delete multiple records with same condition
-- Delete all inactive test customers
DELETE FROM SampleCustomers 
WHERE CustomerType = 'Test' AND IsActive = 0;

PRINT 'Deleted ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' inactive test customers';

-- Example 4: Delete with date condition
-- Delete old processed log entries
DELETE FROM TempLogs 
WHERE LogDate < DATEADD(DAY, -7, GETDATE()) 
  AND IsProcessed = 1;

PRINT 'Deleted ' + CAST(@@ROWCOUNT AS VARCHAR(10)) + ' old processed log entries';

-- =====================================================
-- DELETE WITH DIFFERENT WHERE CONDITIONS
-- =====================================================

-- Example 5: Delete with IN clause
-- Delete multiple specific records
DELETE FROM TempLogs 
WHERE LogLevel IN ('ERROR', 'WARN');

-- Example 6: Delete with LIKE pattern
-- Delete temporary users
DELETE FROM SampleCustomers 
WHERE Email LIKE 'temp%@test.com';

-- Example 7: Delete with NOT EXISTS
-- Delete customers who have never placed orders
DELETE FROM SampleCustomers 
WHERE CustomerType = 'Temporary'
  AND NOT EXISTS (
      SELECT 1 FROM SampleOrders 
      WHERE SampleOrders.CustomerID = SampleCustomers.CustomerID
  );

-- Example 8: Delete with range condition
-- Delete logs from a specific time period
DELETE FROM TempLogs 
WHERE LogDate BETWEEN '2024-10-10' AND '2024-10-15';

-- =====================================================
-- SAFE DELETE WITH TRANSACTIONS
-- =====================================================

-- Example 9: Delete with transaction safety
BEGIN TRANSACTION;

-- Count before deletion
SELECT COUNT(*) AS BeforeCount FROM TempLogs;

-- Perform deletion
DELETE FROM TempLogs 
WHERE LogLevel = 'INFO' AND IsProcessed = 1;

-- Check results
SELECT COUNT(*) AS AfterCount FROM TempLogs;
SELECT @@ROWCOUNT AS DeletedCount;

-- Decision point: commit or rollback
PRINT 'Review the counts above. Uncomment COMMIT or ROLLBACK:';
-- COMMIT TRANSACTION;    -- Uncomment to keep changes
ROLLBACK TRANSACTION;   -- Uncomment to undo changes

-- =====================================================
-- DELETE WITH SUBQUERIES
-- =====================================================

-- Example 10: Delete based on subquery results
-- Create some sample orders first for this example
INSERT INTO SampleOrders (CustomerID, TotalAmount, OrderStatus)
SELECT TOP 3 CustomerID, 50.00, 'Test Order'
FROM SampleCustomers 
WHERE CustomerType != 'Test';

-- Now delete orders for specific customers
DELETE FROM SampleOrders 
WHERE CustomerID IN (
    SELECT CustomerID 
    FROM SampleCustomers 
    WHERE CustomerType = 'Test'
);

-- Example 11: Delete with correlated subquery
-- Delete customers who have only test orders
DELETE FROM SampleCustomers 
WHERE EXISTS (
    SELECT 1 FROM SampleOrders 
    WHERE SampleOrders.CustomerID = SampleCustomers.CustomerID
      AND OrderStatus = 'Test Order'
)
AND NOT EXISTS (
    SELECT 1 FROM SampleOrders 
    WHERE SampleOrders.CustomerID = SampleCustomers.CustomerID
      AND OrderStatus != 'Test Order'
);

-- =====================================================
-- CASCADING DELETES AND FOREIGN KEYS
-- =====================================================

-- Example 12: Understanding foreign key constraints
-- This will show what happens when you try to delete referenced data

-- First, let's see what orders exist
SELECT o.OrderID, o.CustomerID, c.FirstName, c.LastName
FROM SampleOrders o
JOIN SampleCustomers c ON o.CustomerID = c.CustomerID;

-- Try to delete a customer who has orders (this should fail)
BEGIN TRY
    DELETE FROM SampleCustomers WHERE CustomerID = 1;
    PRINT 'Customer deleted successfully';
END TRY
BEGIN CATCH
    PRINT 'Delete failed: ' + ERROR_MESSAGE();
    PRINT 'This is expected due to foreign key constraints';
END CATCH

-- Example 13: Proper way to handle related data
-- Delete in correct order (children first, then parent)

DECLARE @CustomerToDelete INT = 1;

BEGIN TRANSACTION;

-- First, delete order details
DELETE FROM SampleOrderDetails 
WHERE OrderID IN (
    SELECT OrderID FROM SampleOrders 
    WHERE CustomerID = @CustomerToDelete
);

-- Then delete orders
DELETE FROM SampleOrders 
WHERE CustomerID = @CustomerToDelete;

-- Finally, delete the customer
DELETE FROM SampleCustomers 
WHERE CustomerID = @CustomerToDelete;

-- Check if all deletions succeeded
IF @@ERROR = 0
BEGIN
    COMMIT TRANSACTION;
    PRINT 'Customer and all related data deleted successfully';
END
ELSE
BEGIN
    ROLLBACK TRANSACTION;
    PRINT 'Delete failed, all changes rolled back';
END

-- =====================================================
-- BULK DELETE OPERATIONS
-- =====================================================

-- Example 14: Batch deletion for large datasets
-- Delete large amounts of data in batches to avoid long locks

-- Repopulate logs for this example
INSERT INTO TempLogs (LogMessage, LogLevel, LogDate, IsProcessed)
SELECT 
    'Batch log ' + CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS VARCHAR(10)),
    CASE (ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) % 4)
        WHEN 0 THEN 'DEBUG'
        WHEN 1 THEN 'INFO'
        WHEN 2 THEN 'WARN'
        ELSE 'ERROR'
    END,
    DATEADD(MINUTE, -ROW_NUMBER() OVER (ORDER BY (SELECT NULL)), GETDATE()),
    1
FROM SampleCustomers c1
CROSS JOIN SampleCustomers c2;  -- Creates many combinations

-- Now delete in batches
DECLARE @BatchSize INT = 10;
DECLARE @RowsDeleted INT = @BatchSize;
DECLARE @TotalDeleted INT = 0;

PRINT 'Starting batch deletion...';

WHILE @RowsDeleted = @BatchSize
BEGIN
    DELETE TOP (@BatchSize) FROM TempLogs 
    WHERE LogLevel = 'DEBUG' AND IsProcessed = 1;
    
    SET @RowsDeleted = @@ROWCOUNT;
    SET @TotalDeleted = @TotalDeleted + @RowsDeleted;
    
    PRINT 'Deleted ' + CAST(@RowsDeleted AS VARCHAR(10)) + ' records in this batch';
    
    -- Small delay to reduce system impact
    WAITFOR DELAY '00:00:00.100';  -- 100ms pause
END

PRINT 'Batch deletion complete. Total deleted: ' + CAST(@TotalDeleted AS VARCHAR(10));

-- =====================================================
-- SOFT DELETE vs HARD DELETE
-- =====================================================

-- Example 15: Implementing soft delete
-- Add columns for soft delete if they don't exist
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
               WHERE TABLE_NAME = 'SampleCustomers' AND COLUMN_NAME = 'IsDeleted')
BEGIN
    ALTER TABLE SampleCustomers ADD IsDeleted BIT DEFAULT 0;
    ALTER TABLE SampleCustomers ADD DeletedDate DATETIME NULL;
    ALTER TABLE SampleCustomers ADD DeletedBy VARCHAR(100) NULL;
END

-- Soft delete example - mark as deleted instead of removing
UPDATE SampleCustomers 
SET IsDeleted = 1,
    DeletedDate = GETDATE(),
    DeletedBy = USER_NAME()
WHERE CustomerType = 'Test';

PRINT 'Soft deleted test customers';

-- Query active customers (excluding soft-deleted)
SELECT CustomerID, FirstName, LastName, Email
FROM SampleCustomers 
WHERE IsDeleted = 0 OR IsDeleted IS NULL;

-- Example 16: Hard delete of soft-deleted records
-- After a grace period, permanently remove soft-deleted records
DELETE FROM SampleCustomers 
WHERE IsDeleted = 1 
  AND DeletedDate < DATEADD(DAY, -30, GETDATE());

-- =====================================================
-- DELETE WITH OUTPUT CLAUSE
-- =====================================================

-- Example 17: Capture deleted data for audit purposes
DECLARE @DeletedCustomers TABLE (
    CustomerID INT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    DeletedDate DATETIME DEFAULT GETDATE()
);

-- Delete and capture what was deleted
DELETE FROM SampleCustomers 
OUTPUT deleted.CustomerID, deleted.FirstName, deleted.LastName, deleted.Email
INTO @DeletedCustomers (CustomerID, FirstName, LastName, Email)
WHERE IsDeleted = 1;

-- Show what was deleted
SELECT * FROM @DeletedCustomers;

-- =====================================================
-- DATA RETENTION POLICIES
-- =====================================================

-- Example 18: Implement automated data retention
-- Delete old data according to retention policies

-- Delete old logs (older than 30 days)
DELETE FROM TempLogs 
WHERE LogDate < DATEADD(DAY, -30, GETDATE());

PRINT 'Deleted logs older than 30 days: ' + CAST(@@ROWCOUNT AS VARCHAR(10));

-- Delete old test orders (older than 7 days)
DELETE FROM SampleOrders 
WHERE OrderStatus = 'Test Order' 
  AND OrderDate < DATEADD(DAY, -7, GETDATE());

-- Example 19: Archive before delete pattern
-- Create archive table
CREATE TABLE ArchivedOrders (
    OrderID INT,
    CustomerID INT,
    OrderDate DATETIME,
    TotalAmount DECIMAL(10,2),
    OrderStatus VARCHAR(20),
    ArchivedDate DATETIME DEFAULT GETDATE()
);

-- Archive old completed orders before deleting
INSERT INTO ArchivedOrders (OrderID, CustomerID, OrderDate, TotalAmount, OrderStatus)
SELECT OrderID, CustomerID, OrderDate, TotalAmount, OrderStatus
FROM SampleOrders 
WHERE OrderStatus = 'Completed' 
  AND OrderDate < DATEADD(YEAR, -1, GETDATE());

-- Now delete the archived orders from main table
DELETE FROM SampleOrders 
WHERE OrderStatus = 'Completed' 
  AND OrderDate < DATEADD(YEAR, -1, GETDATE());

-- =====================================================
-- ERROR HANDLING AND RECOVERY
-- =====================================================

-- Example 20: Comprehensive error handling for deletes
CREATE PROCEDURE SafeDeleteCustomer
    @CustomerID INT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @RelatedOrders INT;
    
    BEGIN TRY
        -- Validation
        IF NOT EXISTS (SELECT 1 FROM SampleCustomers WHERE CustomerID = @CustomerID)
        BEGIN
            THROW 50001, 'Customer not found', 1;
        END
        
        -- Check for related data
        SELECT @RelatedOrders = COUNT(*)
        FROM SampleOrders 
        WHERE CustomerID = @CustomerID;
        
        IF @RelatedOrders > 0
        BEGIN
            THROW 50002, 'Cannot delete customer with existing orders', 1;
        END
        
        BEGIN TRANSACTION;
        
        -- Perform the deletion
        DELETE FROM SampleCustomers 
        WHERE CustomerID = @CustomerID;
        
        -- Log the deletion
        INSERT INTO TempLogs (LogMessage, LogLevel)
        VALUES ('Customer ' + CAST(@CustomerID AS VARCHAR(10)) + ' deleted', 'INFO');
        
        COMMIT TRANSACTION;
        
        PRINT 'Customer deleted successfully';
        
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
            
        SET @ErrorMessage = ERROR_MESSAGE();
        PRINT 'Delete failed: ' + @ErrorMessage;
        
        -- Log the error
        INSERT INTO TempLogs (LogMessage, LogLevel)
        VALUES ('Customer deletion failed: ' + @ErrorMessage, 'ERROR');
    END CATCH
END

-- Test the safe delete procedure
EXEC SafeDeleteCustomer @CustomerID = 999;  -- Non-existent customer

-- =====================================================
-- PERFORMANCE CONSIDERATIONS
-- =====================================================

-- Example 21: Efficient deletion strategies

-- Create index for faster deletions (if it doesn't exist)
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_TempLogs_LogDate')
BEGIN
    CREATE INDEX IX_TempLogs_LogDate ON TempLogs(LogDate);
END

-- Efficient deletion using indexed column
DELETE FROM TempLogs 
WHERE LogDate < '2024-10-01';  -- Uses index on LogDate

-- Example 22: Avoid inefficient deletions
-- BAD: Function on column prevents index use
-- DELETE FROM TempLogs WHERE YEAR(LogDate) = 2023;

-- GOOD: Range condition that can use index
DELETE FROM TempLogs 
WHERE LogDate >= '2023-01-01' AND LogDate < '2024-01-01';

-- =====================================================
-- TRUNCATE vs DELETE
-- =====================================================

-- Example 23: When to use TRUNCATE instead of DELETE

-- TRUNCATE: Fast way to delete ALL rows (no WHERE clause allowed)
-- Creates a temporary table to demonstrate
CREATE TABLE #TruncateDemo (
    ID INT IDENTITY(1,1),
    Data VARCHAR(50)
);

INSERT INTO #TruncateDemo (Data) VALUES ('Test1'), ('Test2'), ('Test3');

-- TRUNCATE removes all rows very quickly
TRUNCATE TABLE #TruncateDemo;

-- Check that it's empty and identity is reset
SELECT COUNT(*) AS RecordCount FROM #TruncateDemo;

-- Insert new data to see identity reset
INSERT INTO #TruncateDemo (Data) VALUES ('After Truncate');
SELECT * FROM #TruncateDemo;  -- ID starts at 1 again

DROP TABLE #TruncateDemo;

-- Example 24: DELETE vs TRUNCATE comparison
PRINT 'DELETE vs TRUNCATE:';
PRINT 'DELETE: Can use WHERE clause, slower, can be rolled back, keeps identity sequence';
PRINT 'TRUNCATE: No WHERE clause, very fast, resets identity, minimal logging';

-- =====================================================
-- VERIFICATION AND CLEANUP
-- =====================================================

-- Example 25: Verify deletions and check data integrity

-- Check remaining data counts
SELECT 'Table Counts After Deletions' AS Category;
SELECT 'SampleCustomers' AS TableName, COUNT(*) AS RecordCount FROM SampleCustomers
UNION ALL
SELECT 'SampleOrders', COUNT(*) FROM SampleOrders
UNION ALL
SELECT 'TempLogs', COUNT(*) FROM TempLogs;

-- Check for orphaned records
SELECT 'Orphaned Records Check' AS Category;
SELECT 'Orders without customers' AS Issue, COUNT(*) AS Count
FROM SampleOrders o
LEFT JOIN SampleCustomers c ON o.CustomerID = c.CustomerID
WHERE c.CustomerID IS NULL
UNION ALL
SELECT 'Order details without orders', COUNT(*)
FROM SampleOrderDetails od
LEFT JOIN SampleOrders o ON od.OrderID = o.OrderID
WHERE o.OrderID IS NULL;

-- =====================================================
-- RESTORE FROM BACKUP (If needed)
-- =====================================================

-- Example 26: How to restore from backup if you made a mistake

-- Check current state
SELECT COUNT(*) AS CurrentCustomerCount FROM SampleCustomers;

-- If you need to restore (uncomment these lines):
/*
-- Restore customers from backup
DELETE FROM SampleCustomers;  -- Clear current data
INSERT INTO SampleCustomers (CustomerID, FirstName, LastName, Email, Phone, DateJoined, IsActive, CustomerType)
SELECT CustomerID, FirstName, LastName, Email, Phone, DateJoined, IsActive, CustomerType
FROM CustomersBackup_DeleteExamples;

PRINT 'Customers restored from backup';
*/

-- =====================================================
-- CLEANUP - REMOVE EXAMPLE DATA AND BACKUPS
-- =====================================================

-- Clean up our example objects
DROP TABLE TempLogs;
DROP TABLE ArchivedOrders;
DROP PROCEDURE SafeDeleteCustomer;

-- Clean up backup tables (uncomment if you want to remove backups)
/*
DROP TABLE CustomersBackup_DeleteExamples;
DROP TABLE ProductsBackup_DeleteExamples;
DROP TABLE OrdersBackup_DeleteExamples;
*/

-- =====================================================
-- KEY LEARNING POINTS SUMMARY
-- =====================================================

/*
Key DELETE Concepts Demonstrated:

1. CRITICAL SAFETY: Always backup and test before deleting
2. Proper methodology: SELECT first, count, then DELETE
3. Basic DELETE syntax with WHERE clauses
4. Different WHERE conditions (IN, LIKE, EXISTS, ranges)
5. Transaction safety for complex deletions
6. Subquery and correlated subquery deletions
7. Foreign key constraints and cascading deletes
8. Batch deletion for large datasets
9. Soft delete vs hard delete strategies
10. OUTPUT clause for capturing deleted data
11. Data retention and archival patterns
12. Error handling and recovery procedures
13. Performance optimization techniques
14. TRUNCATE vs DELETE comparison
15. Data integrity verification after deletion

CRITICAL SAFETY REMINDERS:
🚨 DELETE operations are PERMANENT and IRREVERSIBLE
🚨 ALWAYS backup important data before major deletions
🚨 ALWAYS test WHERE clauses with SELECT first
🚨 Use transactions for complex multi-table deletions
🚨 Consider soft deletes for recoverable scenarios
🚨 Verify foreign key relationships before deleting
🚨 Monitor performance impact of large deletions

Best Practices:
- Create backups before major delete operations
- Test WHERE clauses thoroughly
- Use appropriate batch sizes for large deletions
- Implement proper error handling
- Consider soft delete for important business data
- Document deletion policies and procedures
- Regular cleanup based on data retention policies
*/

PRINT '🚨 DELETE examples completed!';
PRINT 'Remember: DELETE operations cannot be undone - always be careful!';
PRINT 'Next: Study 04_Advanced_DML_Examples.sql';