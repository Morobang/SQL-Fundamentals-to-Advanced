# 03_Delete_Operations.md - Mastering Safe Data Removal

## 🎯 Learning Objectives

After completing this lesson, you will be able to:
- Write DELETE statements to remove records safely
- Use WHERE clauses to precisely target records for deletion
- Understand the difference between DELETE, DROP, and TRUNCATE
- Implement soft delete strategies for data recovery
- Handle cascading deletes and referential integrity
- Apply best practices for safe data removal and backup strategies

## 📖 What is DELETE?

The DELETE statement is used to remove existing records from a table. Unlike DROP which removes entire tables or databases, DELETE removes specific rows while keeping the table structure intact. Think of it as erasing specific entries from a spreadsheet while leaving the spreadsheet itself and its column headers.

## ⚠️ CRITICAL SAFETY WARNING

**DELETE operations are PERMANENT and IRREVERSIBLE!** Always use extreme caution:

1. **ALWAYS use a WHERE clause** (unless you really want to delete ALL records)
2. **ALWAYS backup data** before major delete operations
3. **Test with SELECT first** to verify which records will be deleted
4. **Use transactions** for complex deletion scenarios
5. **Consider soft deletes** instead of hard deletes for important data

```sql
-- CATASTROPHIC: Deletes ALL records from table
DELETE FROM Customers;

-- SAFE: Deletes specific records
DELETE FROM Customers WHERE CustomerID = 123;
```

## 🔧 Basic DELETE Syntax

### Simple DELETE
```sql
DELETE FROM table_name
WHERE condition;
```

### DELETE with Multiple Conditions
```sql
DELETE FROM table_name
WHERE condition1 AND condition2;
```

**Key Components:**
- `DELETE FROM`: SQL keywords indicating we want to remove data
- `table_name`: The target table containing records to delete
- `WHERE condition`: Specifies which records to delete (ESSENTIAL!)

## 📝 Real-World Examples

### Example 1: Remove Inactive Customers
```sql
-- Delete customers who haven't ordered in 2 years
DELETE FROM Customers 
WHERE LastOrderDate < '2022-01-01' 
  AND IsActive = 0;
```

### Example 2: Clean Up Expired Sessions
```sql
-- Remove expired user sessions
DELETE FROM UserSessions 
WHERE ExpiryDate < GETDATE();
```

### Example 3: Remove Cancelled Orders
```sql
-- Delete orders that were cancelled more than 30 days ago
DELETE FROM Orders 
WHERE OrderStatus = 'Cancelled' 
  AND CancelledDate < DATEADD(DAY, -30, GETDATE());
```

## 🗂️ Understanding Different Deletion Methods

### DELETE vs TRUNCATE vs DROP

```sql
-- DELETE: Removes specific rows, can use WHERE clause
DELETE FROM Products WHERE IsDiscontinued = 1;
-- ✅ Selective removal
-- ✅ Can be rolled back in transaction
-- ❌ Slower for large datasets
-- ❌ Doesn't reset auto-increment values

-- TRUNCATE: Removes ALL rows, no WHERE clause allowed
TRUNCATE TABLE TempData;
-- ✅ Very fast for removing all data
-- ✅ Resets auto-increment values
-- ❌ Cannot use WHERE clause
-- ❌ Cannot be rolled back in some databases

-- DROP: Removes entire table structure
DROP TABLE OldTable;
-- ✅ Completely removes table and structure
-- ❌ All data and structure is lost
-- ❌ Cannot be undone easily
```

## 🛡️ Safe Deletion Practices

### 1. Always Test with SELECT First
```sql
-- STEP 1: Test your WHERE clause with SELECT
SELECT * FROM Orders 
WHERE OrderStatus = 'Cancelled' 
  AND CancelledDate < DATEADD(DAY, -30, GETDATE());

-- STEP 2: Count how many records will be deleted
SELECT COUNT(*) AS RecordsToDelete
FROM Orders 
WHERE OrderStatus = 'Cancelled' 
  AND CancelledDate < DATEADD(DAY, -30, GETDATE());

-- STEP 3: If the count looks right, proceed with DELETE
DELETE FROM Orders 
WHERE OrderStatus = 'Cancelled' 
  AND CancelledDate < DATEADD(DAY, -30, GETDATE());
```

### 2. Create Backups Before Major Deletions
```sql
-- Create backup table before deletion
SELECT * INTO DeletedCustomers_Backup_20241019
FROM Customers 
WHERE LastOrderDate < '2022-01-01';

-- Verify backup was created
SELECT COUNT(*) FROM DeletedCustomers_Backup_20241019;

-- Now perform the deletion
DELETE FROM Customers 
WHERE LastOrderDate < '2022-01-01';
```

### 3. Use Transactions for Safety
```sql
BEGIN TRANSACTION;

-- Perform the deletion
DELETE FROM TempOrders 
WHERE CreatedDate < DATEADD(DAY, -1, GETDATE());

-- Check the result
SELECT @@ROWCOUNT AS DeletedRows;

-- If the number looks right, commit
-- If something seems wrong, rollback
COMMIT TRANSACTION;
-- ROLLBACK TRANSACTION; -- Use this if something went wrong
```

## 🔄 Soft Delete vs Hard Delete

### Hard Delete (Permanent Removal)
```sql
-- Hard delete: Record is permanently removed
DELETE FROM Users WHERE UserID = 123;
```

### Soft Delete (Mark as Deleted)
```sql
-- Soft delete: Mark record as deleted but keep it
UPDATE Users 
SET IsDeleted = 1,
    DeletedDate = GETDATE(),
    DeletedBy = @CurrentUserID
WHERE UserID = 123;

-- Query active users (excluding soft-deleted)
SELECT * FROM Users WHERE IsDeleted = 0 OR IsDeleted IS NULL;
```

### Soft Delete Best Practices
```sql
-- Create table with soft delete support
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    IsDeleted BIT DEFAULT 0,
    DeletedDate DATETIME NULL,
    DeletedBy INT NULL,
    CreatedDate DATETIME DEFAULT GETDATE()
);

-- Implement soft delete procedure
CREATE PROCEDURE SoftDeleteCustomer
    @CustomerID INT,
    @DeletedBy INT
AS
BEGIN
    UPDATE Customers 
    SET IsDeleted = 1,
        DeletedDate = GETDATE(),
        DeletedBy = @DeletedBy
    WHERE CustomerID = @CustomerID AND IsDeleted = 0;
    
    SELECT @@ROWCOUNT AS RowsAffected;
END
```

## 🔗 Handling Referential Integrity

### Understanding Foreign Key Constraints
```sql
-- This might fail if there are related records
DELETE FROM Customers WHERE CustomerID = 123;
-- Error: Cannot delete because Orders table references this customer

-- Check for related records first
SELECT COUNT(*) AS RelatedOrders
FROM Orders 
WHERE CustomerID = 123;
```

### Cascading Deletes
```sql
-- Set up cascade delete (done when creating foreign key)
ALTER TABLE Orders
ADD CONSTRAINT FK_Orders_CustomerID
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
ON DELETE CASCADE;

-- Now deleting customer automatically deletes their orders
DELETE FROM Customers WHERE CustomerID = 123;
-- This will also delete all orders for this customer
```

### Manual Cascading (More Control)
```sql
BEGIN TRANSACTION;

-- Delete in order of dependency (children first, parent last)
DELETE FROM OrderDetails WHERE OrderID IN (
    SELECT OrderID FROM Orders WHERE CustomerID = 123
);

DELETE FROM Orders WHERE CustomerID = 123;

DELETE FROM CustomerAddresses WHERE CustomerID = 123;

DELETE FROM Customers WHERE CustomerID = 123;

COMMIT TRANSACTION;
```

## 🎯 Advanced WHERE Clause Techniques

### Subquery Deletions
```sql
-- Delete customers who have never placed an order
DELETE FROM Customers 
WHERE CustomerID NOT IN (
    SELECT DISTINCT CustomerID 
    FROM Orders 
    WHERE CustomerID IS NOT NULL
);

-- Delete products that are no longer in any category
DELETE FROM Products 
WHERE CategoryID NOT IN (
    SELECT CategoryID FROM Categories
);
```

### JOIN-based Deletions
```sql
-- Delete orders for inactive customers (SQL Server syntax)
DELETE o
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE c.IsActive = 0;

-- Alternative syntax for other databases
DELETE FROM Orders 
WHERE CustomerID IN (
    SELECT CustomerID FROM Customers WHERE IsActive = 0
);
```

### Date-based Deletions
```sql
-- Delete old log entries
DELETE FROM SystemLogs 
WHERE LogDate < DATEADD(MONTH, -6, GETDATE());

-- Delete future-dated test records
DELETE FROM TestOrders 
WHERE OrderDate > GETDATE();
```

### Pattern-based Deletions
```sql
-- Delete test accounts
DELETE FROM Users 
WHERE Email LIKE '%@test.com' 
   OR Username LIKE 'test_%';

-- Delete spam comments
DELETE FROM Comments 
WHERE Content LIKE '%viagra%' 
   OR Content LIKE '%casino%'
   OR Content LIKE '%free money%';
```

## ⚡ Performance Considerations

### Batch Deletions for Large Datasets
```sql
-- Delete large datasets in batches to avoid long locks
DECLARE @BatchSize INT = 1000;
DECLARE @RowsDeleted INT = @BatchSize;

WHILE @RowsDeleted = @BatchSize
BEGIN
    DELETE TOP (@BatchSize) FROM LogEntries 
    WHERE LogDate < '2022-01-01';
    
    SET @RowsDeleted = @@ROWCOUNT;
    
    -- Optional pause to reduce system impact
    WAITFOR DELAY '00:00:01';
END
```

### Index Considerations
```sql
-- GOOD: Uses indexed column in WHERE clause
DELETE FROM Orders WHERE OrderID = 12345;

-- SLOWER: Non-indexed column
DELETE FROM Orders WHERE Notes LIKE '%cancel%';

-- Consider adding index if you frequently delete by certain criteria
CREATE INDEX IX_Orders_Status ON Orders(OrderStatus);
```

## 🔍 Monitoring and Verification

### Check Deletion Results
```sql
-- Count records before deletion
SELECT COUNT(*) AS BeforeCount FROM TempData;

-- Perform deletion
DELETE FROM TempData WHERE ProcessedDate < '2024-01-01';

-- Check how many were deleted
SELECT @@ROWCOUNT AS DeletedCount;

-- Count remaining records
SELECT COUNT(*) AS AfterCount FROM TempData;
```

### Audit Trail for Deletions
```sql
-- Create deletion log table
CREATE TABLE DeletionLog (
    LogID INT IDENTITY(1,1) PRIMARY KEY,
    TableName VARCHAR(100),
    RecordID INT,
    DeletedBy VARCHAR(100),
    DeletedDate DATETIME DEFAULT GETDATE(),
    Reason VARCHAR(500)
);

-- Log deletions
INSERT INTO DeletionLog (TableName, RecordID, DeletedBy, Reason)
VALUES ('Customers', 123, USER_NAME(), 'Customer requested account deletion');

DELETE FROM Customers WHERE CustomerID = 123;
```

## 🚨 Error Handling and Recovery

### Safe Deletion with Error Handling
```sql
BEGIN TRY
    BEGIN TRANSACTION;
    
    -- Attempt deletion
    DELETE FROM TempOrders 
    WHERE OrderDate < '2024-01-01';
    
    -- Check if expected number of rows were deleted
    IF @@ROWCOUNT BETWEEN 100 AND 500  -- Expected range
    BEGIN
        COMMIT TRANSACTION;
        PRINT 'Deletion completed successfully';
    END
    ELSE
    BEGIN
        ROLLBACK TRANSACTION;
        PRINT 'Unexpected number of rows deleted - rolled back';
    END
    
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error during deletion: ' + ERROR_MESSAGE();
END CATCH
```

### Recovery Strategies
```sql
-- Method 1: Restore from backup (if available)
-- This depends on your backup strategy

-- Method 2: Recreate from related data
INSERT INTO Customers (CustomerID, FirstName, LastName, Email)
SELECT DISTINCT CustomerID, 'Unknown', 'Customer', 'noemail@company.com'
FROM Orders 
WHERE CustomerID NOT IN (SELECT CustomerID FROM Customers);

-- Method 3: Import from external source
-- Bulk insert from CSV, API, or other database
```

## 🛠️ Best Practices Summary

### 1. Pre-Deletion Checklist
```sql
-- ✅ Have I backed up the data?
-- ✅ Have I tested my WHERE clause with SELECT?
-- ✅ Have I checked for foreign key dependencies?
-- ✅ Am I using a transaction for complex deletions?
-- ✅ Have I considered soft delete instead?
-- ✅ Is this deletion really necessary?
```

### 2. Production Deletion Template
```sql
-- 1. Create backup
SELECT * INTO BackupTable_YYYYMMDD FROM TargetTable 
WHERE [conditions];

-- 2. Test selection
SELECT COUNT(*) FROM TargetTable WHERE [conditions];

-- 3. Begin transaction
BEGIN TRANSACTION;

-- 4. Perform deletion
DELETE FROM TargetTable WHERE [conditions];

-- 5. Verify result
DECLARE @DeletedCount INT = @@ROWCOUNT;
PRINT 'Deleted ' + CAST(@DeletedCount AS VARCHAR(10)) + ' records';

-- 6. Commit or rollback
IF @DeletedCount BETWEEN @MinExpected AND @MaxExpected
    COMMIT TRANSACTION;
ELSE
    ROLLBACK TRANSACTION;
```

## 🎯 Real-World Scenarios

### Data Retention Policy Implementation
```sql
-- Delete old application logs (older than 90 days)
DELETE FROM ApplicationLogs 
WHERE LogDate < DATEADD(DAY, -90, GETDATE());

-- Delete old user sessions (older than 30 days)
DELETE FROM UserSessions 
WHERE LastActivity < DATEADD(DAY, -30, GETDATE());

-- Archive and delete old completed orders (older than 7 years)
INSERT INTO ArchivedOrders SELECT * FROM Orders 
WHERE OrderDate < DATEADD(YEAR, -7, GETDATE()) 
  AND OrderStatus = 'Completed';

DELETE FROM Orders 
WHERE OrderDate < DATEADD(YEAR, -7, GETDATE()) 
  AND OrderStatus = 'Completed';
```

### GDPR Compliance (Right to be Forgotten)
```sql
-- Complete user data deletion for GDPR compliance
BEGIN TRANSACTION;

-- Log the deletion request
INSERT INTO GDPRDeletionLog (UserID, RequestDate, ProcessedBy)
VALUES (@UserID, GETDATE(), @ProcessedBy);

-- Delete user data across all tables
DELETE FROM UserPreferences WHERE UserID = @UserID;
DELETE FROM UserSessions WHERE UserID = @UserID;
DELETE FROM UserComments WHERE UserID = @UserID;
DELETE FROM UserProfiles WHERE UserID = @UserID;

-- Anonymize instead of delete for orders (business requirement)
UPDATE Orders 
SET CustomerName = 'Deleted User',
    CustomerEmail = 'deleted@privacy.com'
WHERE UserID = @UserID;

DELETE FROM Users WHERE UserID = @UserID;

COMMIT TRANSACTION;
```

### Cleanup Procedures
```sql
-- Regular maintenance procedure
CREATE PROCEDURE CleanupOldData
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @DeletedCount INT = 0;
    
    -- Clean expired sessions
    DELETE FROM UserSessions WHERE ExpiryDate < GETDATE();
    SET @DeletedCount = @DeletedCount + @@ROWCOUNT;
    
    -- Clean old logs
    DELETE FROM ErrorLogs WHERE LogDate < DATEADD(DAY, -30, GETDATE());
    SET @DeletedCount = @DeletedCount + @@ROWCOUNT;
    
    -- Clean orphaned records
    DELETE FROM OrderDetails 
    WHERE OrderID NOT IN (SELECT OrderID FROM Orders);
    SET @DeletedCount = @DeletedCount + @@ROWCOUNT;
    
    PRINT 'Cleanup completed. Total records deleted: ' + CAST(@DeletedCount AS VARCHAR(10));
END
```

## 📚 What's Next?

Now that you understand how to safely remove data, you're ready to explore advanced data manipulation techniques that combine INSERT, UPDATE, and DELETE operations in sophisticated ways.

## 💡 Key Takeaways

1. **DELETE is permanent** - always backup and test first
2. **Always use WHERE clauses** unless you really want to delete everything
3. **Test with SELECT first** to verify which records will be deleted
4. **Use transactions** for complex or critical deletions
5. **Consider soft deletes** for important business data
6. **Handle foreign keys** and referential integrity properly
7. **Monitor performance** and use batch operations for large deletions
8. **Implement audit trails** to track what was deleted when and why

Ready to practice safe deletion? Head over to `02_Code/03_Delete_Examples.sql` to see these concepts in action, then challenge yourself with `03_Practice/03_Delete_Practice.sql`!

---

*Next: [04_Advanced_DML.md](04_Advanced_DML.md) - Learn advanced data manipulation techniques and best practices.*