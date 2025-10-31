# 04_Advanced_DML.md - Advanced Data Manipulation Techniques

## 🎯 Learning Objectives

After completing this lesson, you will be able to:
- Combine INSERT, UPDATE, and DELETE operations in complex workflows
- Use MERGE statements for sophisticated data synchronization
- Implement transaction management for data integrity
- Handle concurrent access and locking scenarios
- Apply advanced error handling and recovery techniques
- Optimize DML operations for performance at scale
- Design audit trails and change tracking systems

## 📖 What is Advanced DML?

Advanced Data Manipulation Language (DML) goes beyond basic INSERT, UPDATE, and DELETE operations. It encompasses complex scenarios where multiple operations work together, sophisticated data synchronization, transaction management, performance optimization, and enterprise-level data integrity patterns.

## 🔄 The MERGE Statement

### What is MERGE?
MERGE is a powerful statement that can INSERT, UPDATE, or DELETE records in a single operation based on conditions. It's perfect for data synchronization scenarios.

### Basic MERGE Syntax
```sql
MERGE target_table AS target
USING source_table AS source ON (join_condition)
WHEN MATCHED THEN
    UPDATE SET column1 = source.column1, column2 = source.column2
WHEN NOT MATCHED BY TARGET THEN
    INSERT (column1, column2) VALUES (source.column1, source.column2)
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;
```

### Real-World MERGE Example: Customer Data Synchronization
```sql
-- Synchronize customer data from import table
MERGE Customers AS target
USING CustomerImport AS source ON (target.CustomerID = source.CustomerID)

-- Update existing customers
WHEN MATCHED THEN
    UPDATE SET 
        FirstName = source.FirstName,
        LastName = source.LastName,
        Email = source.Email,
        Phone = source.Phone,
        LastModified = GETDATE()

-- Insert new customers
WHEN NOT MATCHED BY TARGET THEN
    INSERT (CustomerID, FirstName, LastName, Email, Phone, CreatedDate)
    VALUES (source.CustomerID, source.FirstName, source.LastName, 
            source.Email, source.Phone, GETDATE())

-- Optional: Delete customers no longer in source
WHEN NOT MATCHED BY SOURCE THEN
    DELETE

-- Get summary of what happened
OUTPUT $action AS Operation,
       inserted.CustomerID AS CustomerID,
       deleted.CustomerID AS OldCustomerID;
```

### Conditional MERGE Operations
```sql
-- More sophisticated MERGE with multiple conditions
MERGE Products AS target
USING ProductUpdates AS source ON (target.ProductID = source.ProductID)

-- Update only if price has changed significantly
WHEN MATCHED AND ABS(target.Price - source.Price) > 0.01 THEN
    UPDATE SET 
        Price = source.Price,
        LastPriceUpdate = GETDATE(),
        ModifiedBy = @UserID

-- Insert only active products
WHEN NOT MATCHED BY TARGET AND source.IsActive = 1 THEN
    INSERT (ProductID, ProductName, Price, IsActive, CreatedDate)
    VALUES (source.ProductID, source.ProductName, source.Price, 
            source.IsActive, GETDATE())

-- Deactivate products that are no longer in source
WHEN NOT MATCHED BY SOURCE THEN
    UPDATE SET IsActive = 0, DeactivatedDate = GETDATE();
```

## 🔒 Advanced Transaction Management

### ACID Properties in Practice
```sql
-- Atomicity, Consistency, Isolation, Durability example
BEGIN TRANSACTION;

BEGIN TRY
    -- Atomicity: All operations succeed or all fail
    
    -- Transfer money between accounts
    UPDATE Accounts 
    SET Balance = Balance - 1000,
        LastTransaction = GETDATE()
    WHERE AccountID = @FromAccount;
    
    IF @@ROWCOUNT != 1
        THROW 50001, 'Source account not found or already modified', 1;
    
    UPDATE Accounts 
    SET Balance = Balance + 1000,
        LastTransaction = GETDATE()
    WHERE AccountID = @ToAccount;
    
    IF @@ROWCOUNT != 1
        THROW 50002, 'Destination account not found or already modified', 1;
    
    -- Log the transaction
    INSERT INTO TransactionLog (FromAccount, ToAccount, Amount, TransactionDate)
    VALUES (@FromAccount, @ToAccount, 1000, GETDATE());
    
    -- Consistency: Check business rules
    IF (SELECT Balance FROM Accounts WHERE AccountID = @FromAccount) < 0
        THROW 50003, 'Insufficient funds', 1;
    
    -- If we get here, everything is consistent
    COMMIT TRANSACTION;
    
END TRY
BEGIN CATCH
    -- Atomicity: Roll back all changes on any error
    ROLLBACK TRANSACTION;
    
    -- Log the error
    INSERT INTO ErrorLog (ErrorMessage, ErrorDate, UserID)
    VALUES (ERROR_MESSAGE(), GETDATE(), @UserID);
    
    -- Re-throw the error
    THROW;
END CATCH
```

### Isolation Levels and Locking
```sql
-- Read Uncommitted (Dirty Reads possible)
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SELECT * FROM Products; -- May read uncommitted changes

-- Read Committed (Default - no dirty reads)
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT * FROM Products; -- Only reads committed data

-- Repeatable Read (No phantom reads of existing rows)
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
BEGIN TRANSACTION;
SELECT COUNT(*) FROM Products WHERE Price > 100; -- Lock these rows
-- Another transaction cannot modify these rows until we commit
COMMIT TRANSACTION;

-- Serializable (Complete isolation)
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN TRANSACTION;
SELECT COUNT(*) FROM Products WHERE Price > 100;
-- No other transaction can even insert new products in this range
COMMIT TRANSACTION;

-- Snapshot Isolation (Row versioning)
SET TRANSACTION ISOLATION LEVEL SNAPSHOT;
BEGIN TRANSACTION;
-- Reads data as it existed at transaction start time
SELECT * FROM Products;
COMMIT TRANSACTION;
```

### Savepoints for Partial Rollback
```sql
BEGIN TRANSACTION;

-- Create a savepoint
SAVE TRANSACTION SavePoint1;

-- Do some work
INSERT INTO Customers (FirstName, LastName) VALUES ('John', 'Doe');

-- Create another savepoint
SAVE TRANSACTION SavePoint2;

-- Do more work
UPDATE Customers SET Email = 'john@example.com' WHERE FirstName = 'John';

-- Something goes wrong, rollback to SavePoint2
ROLLBACK TRANSACTION SavePoint2;

-- The UPDATE is rolled back, but the INSERT remains
-- Continue with transaction or commit
COMMIT TRANSACTION;
```

## 🔄 Complex DML Workflows

### ETL (Extract, Transform, Load) Pattern
```sql
-- Complete ETL workflow
CREATE PROCEDURE ProcessDailyImport
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @StartTime DATETIME = GETDATE();
    DECLARE @RecordsProcessed INT = 0;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- 1. EXTRACT: Load raw data from external source
        INSERT INTO StagingCustomers (ExternalID, RawData, ImportDate)
        SELECT ExternalID, RawDataXML, @StartTime
        FROM ExternalCustomerFeed
        WHERE ProcessedDate IS NULL;
        
        -- 2. TRANSFORM: Clean and validate data
        UPDATE StagingCustomers 
        SET FirstName = TRIM(UPPER(LEFT(ParsedFirstName, 1)) + LOWER(SUBSTRING(ParsedFirstName, 2, 100))),
            LastName = TRIM(UPPER(LEFT(ParsedLastName, 1)) + LOWER(SUBSTRING(ParsedLastName, 2, 100))),
            Email = LOWER(TRIM(ParsedEmail)),
            IsValid = CASE 
                WHEN ParsedEmail LIKE '%@%.%' AND LEN(ParsedFirstName) > 0 
                THEN 1 ELSE 0 END
        WHERE ImportDate = @StartTime;
        
        -- 3. LOAD: Merge valid data into production tables
        MERGE Customers AS target
        USING (
            SELECT ExternalID, FirstName, LastName, Email
            FROM StagingCustomers 
            WHERE ImportDate = @StartTime AND IsValid = 1
        ) AS source ON (target.ExternalID = source.ExternalID)
        
        WHEN MATCHED THEN
            UPDATE SET 
                FirstName = source.FirstName,
                LastName = source.LastName,
                Email = source.Email,
                LastModified = @StartTime
                
        WHEN NOT MATCHED THEN
            INSERT (ExternalID, FirstName, LastName, Email, CreatedDate)
            VALUES (source.ExternalID, source.FirstName, source.LastName, 
                    source.Email, @StartTime);
        
        SET @RecordsProcessed = @@ROWCOUNT;
        
        -- Mark external records as processed
        UPDATE ExternalCustomerFeed 
        SET ProcessedDate = @StartTime
        WHERE ProcessedDate IS NULL;
        
        -- Log success
        INSERT INTO ProcessLog (ProcessName, StartTime, EndTime, RecordsProcessed, Status)
        VALUES ('DailyCustomerImport', @StartTime, GETDATE(), @RecordsProcessed, 'Success');
        
        COMMIT TRANSACTION;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        
        -- Log error
        INSERT INTO ProcessLog (ProcessName, StartTime, EndTime, RecordsProcessed, Status, ErrorMessage)
        VALUES ('DailyCustomerImport', @StartTime, GETDATE(), 0, 'Failed', ERROR_MESSAGE());
        
        THROW;
    END CATCH
END
```

### Bulk Operations with Staging Tables
```sql
-- Efficient bulk update pattern
CREATE PROCEDURE BulkUpdatePrices
    @UpdateData XML -- Contains ProductID and new Price
AS
BEGIN
    -- Create temporary table for updates
    CREATE TABLE #PriceUpdates (
        ProductID INT,
        NewPrice DECIMAL(10,2),
        INDEX IX_ProductID (ProductID)
    );
    
    -- Parse XML into temp table
    INSERT INTO #PriceUpdates (ProductID, NewPrice)
    SELECT 
        T.c.value('@ProductID', 'INT'),
        T.c.value('@Price', 'DECIMAL(10,2)')
    FROM @UpdateData.nodes('/Updates/Product') T(c);
    
    -- Validate all updates before applying
    IF EXISTS (
        SELECT 1 FROM #PriceUpdates u
        LEFT JOIN Products p ON u.ProductID = p.ProductID
        WHERE p.ProductID IS NULL OR u.NewPrice <= 0
    )
    BEGIN
        THROW 50001, 'Invalid product IDs or prices in update data', 1;
    END
    
    -- Apply bulk update
    UPDATE p
    SET Price = u.NewPrice,
        LastPriceUpdate = GETDATE(),
        PriceChangeCount = PriceChangeCount + 1
    FROM Products p
    JOIN #PriceUpdates u ON p.ProductID = u.ProductID;
    
    -- Return summary
    SELECT @@ROWCOUNT AS ProductsUpdated;
    
    DROP TABLE #PriceUpdates;
END
```

## 🎯 Data Integrity Patterns

### Implementing Optimistic Locking
```sql
-- Table with version column for optimistic locking
CREATE TABLE Documents (
    DocumentID INT PRIMARY KEY,
    Title VARCHAR(200),
    Content TEXT,
    Version INT DEFAULT 1,
    LastModified DATETIME DEFAULT GETDATE(),
    ModifiedBy INT
);

-- Update with version check
CREATE PROCEDURE UpdateDocument
    @DocumentID INT,
    @NewTitle VARCHAR(200),
    @NewContent TEXT,
    @ExpectedVersion INT,
    @UserID INT
AS
BEGIN
    -- Attempt update with version check
    UPDATE Documents 
    SET Title = @NewTitle,
        Content = @NewContent,
        Version = Version + 1,
        LastModified = GETDATE(),
        ModifiedBy = @UserID
    WHERE DocumentID = @DocumentID 
      AND Version = @ExpectedVersion;
    
    -- Check if update succeeded
    IF @@ROWCOUNT = 0
    BEGIN
        -- Check if document exists
        IF EXISTS (SELECT 1 FROM Documents WHERE DocumentID = @DocumentID)
            THROW 50001, 'Document was modified by another user', 1;
        ELSE
            THROW 50002, 'Document not found', 1;
    END
    
    -- Return new version
    SELECT Version FROM Documents WHERE DocumentID = @DocumentID;
END
```

### Audit Trail Implementation
```sql
-- Comprehensive audit trail system
CREATE TABLE AuditLog (
    AuditID BIGINT IDENTITY(1,1) PRIMARY KEY,
    TableName VARCHAR(100),
    Operation VARCHAR(10), -- INSERT, UPDATE, DELETE
    RecordID VARCHAR(50),
    OldValues XML,
    NewValues XML,
    ChangedBy VARCHAR(100),
    ChangedDate DATETIME DEFAULT GETDATE(),
    ApplicationName VARCHAR(100),
    IPAddress VARCHAR(50)
);

-- Trigger for automatic audit logging
CREATE TRIGGER tr_Products_Audit
ON Products
FOR INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Handle INSERT
    IF EXISTS (SELECT 1 FROM inserted) AND NOT EXISTS (SELECT 1 FROM deleted)
    BEGIN
        INSERT INTO AuditLog (TableName, Operation, RecordID, NewValues, ChangedBy)
        SELECT 
            'Products',
            'INSERT',
            CAST(ProductID AS VARCHAR(50)),
            (SELECT * FROM inserted i WHERE i.ProductID = inserted.ProductID FOR XML AUTO),
            SYSTEM_USER
        FROM inserted;
    END
    
    -- Handle UPDATE
    IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
    BEGIN
        INSERT INTO AuditLog (TableName, Operation, RecordID, OldValues, NewValues, ChangedBy)
        SELECT 
            'Products',
            'UPDATE',
            CAST(i.ProductID AS VARCHAR(50)),
            (SELECT * FROM deleted d WHERE d.ProductID = i.ProductID FOR XML AUTO),
            (SELECT * FROM inserted ins WHERE ins.ProductID = i.ProductID FOR XML AUTO),
            SYSTEM_USER
        FROM inserted i;
    END
    
    -- Handle DELETE
    IF EXISTS (SELECT 1 FROM deleted) AND NOT EXISTS (SELECT 1 FROM inserted)
    BEGIN
        INSERT INTO AuditLog (TableName, Operation, RecordID, OldValues, ChangedBy)
        SELECT 
            'Products',
            'DELETE',
            CAST(ProductID AS VARCHAR(50)),
            (SELECT * FROM deleted d WHERE d.ProductID = deleted.ProductID FOR XML AUTO),
            SYSTEM_USER
        FROM deleted;
    END
END
```

## ⚡ Performance Optimization Techniques

### Batch Processing with Progress Tracking
```sql
CREATE PROCEDURE ArchiveOldOrders
    @CutoffDate DATE,
    @BatchSize INT = 1000,
    @MaxBatches INT = 100
AS
BEGIN
    DECLARE @BatchCount INT = 0;
    DECLARE @TotalArchived INT = 0;
    DECLARE @RowsInBatch INT = @BatchSize;
    
    PRINT 'Starting order archival process...';
    PRINT 'Cutoff Date: ' + CAST(@CutoffDate AS VARCHAR(20));
    PRINT 'Batch Size: ' + CAST(@BatchSize AS VARCHAR(10));
    
    WHILE @RowsInBatch = @BatchSize AND @BatchCount < @MaxBatches
    BEGIN
        BEGIN TRANSACTION;
        
        -- Insert batch into archive
        INSERT INTO ArchivedOrders (OrderID, CustomerID, OrderDate, TotalAmount, ArchivedDate)
        SELECT TOP (@BatchSize) 
            OrderID, CustomerID, OrderDate, TotalAmount, GETDATE()
        FROM Orders 
        WHERE OrderDate < @CutoffDate
          AND OrderStatus = 'Completed'
          AND OrderID NOT IN (SELECT OrderID FROM ArchivedOrders);
        
        SET @RowsInBatch = @@ROWCOUNT;
        
        -- Delete the archived orders
        DELETE FROM Orders 
        WHERE OrderID IN (
            SELECT TOP (@BatchSize) OrderID 
            FROM ArchivedOrders 
            WHERE ArchivedDate = CAST(GETDATE() AS DATE)
        );
        
        COMMIT TRANSACTION;
        
        SET @BatchCount = @BatchCount + 1;
        SET @TotalArchived = @TotalArchived + @RowsInBatch;
        
        -- Progress report
        IF @BatchCount % 10 = 0
            PRINT 'Processed ' + CAST(@BatchCount AS VARCHAR(10)) + ' batches, ' + 
                  CAST(@TotalArchived AS VARCHAR(10)) + ' orders archived';
        
        -- Small delay to reduce system impact
        WAITFOR DELAY '00:00:00.100'; -- 100ms
    END
    
    PRINT 'Archival complete. Total orders archived: ' + CAST(@TotalArchived AS VARCHAR(10));
END
```

### Set-based Operations vs Cursors
```sql
-- AVOID: Cursor-based approach (slow)
DECLARE product_cursor CURSOR FOR
    SELECT ProductID, Price FROM Products WHERE CategoryID = 1;

DECLARE @ProductID INT, @Price DECIMAL(10,2);

OPEN product_cursor;
FETCH NEXT FROM product_cursor INTO @ProductID, @Price;

WHILE @@FETCH_STATUS = 0
BEGIN
    UPDATE Products 
    SET Price = @Price * 1.1 
    WHERE ProductID = @ProductID;
    
    FETCH NEXT FROM product_cursor INTO @ProductID, @Price;
END

CLOSE product_cursor;
DEALLOCATE product_cursor;

-- PREFER: Set-based approach (fast)
UPDATE Products 
SET Price = Price * 1.1 
WHERE CategoryID = 1;
```

### Minimizing Lock Duration
```sql
-- BAD: Long-running transaction
BEGIN TRANSACTION;

-- Do lots of work, holding locks for a long time
UPDATE LargeTable SET Status = 'Processed' WHERE BatchID = @BatchID;
-- ... more operations ...
-- ... complex calculations ...
-- ... external API calls ...

COMMIT TRANSACTION;

-- GOOD: Minimize lock time
-- Do preparatory work outside transaction
DECLARE @UpdatedIDs TABLE (ID INT);

-- Quick transaction for data changes only
BEGIN TRANSACTION;

UPDATE LargeTable 
SET Status = 'Processed' 
OUTPUT inserted.ID INTO @UpdatedIDs
WHERE BatchID = @BatchID;

COMMIT TRANSACTION;

-- Do post-processing work outside transaction
-- ... complex calculations ...
-- ... external API calls ...
```

## 🔧 Error Handling and Recovery

### Comprehensive Error Handling Pattern
```sql
CREATE PROCEDURE ProcessCustomerOrders
    @CustomerID INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON; -- Automatically rollback on errors
    
    DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;
    DECLARE @OrderID INT;
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Validate input
        IF NOT EXISTS (SELECT 1 FROM Customers WHERE CustomerID = @CustomerID)
            THROW 50001, 'Customer not found', 1;
        
        IF EXISTS (SELECT 1 FROM Customers WHERE CustomerID = @CustomerID AND IsActive = 0)
            THROW 50002, 'Customer account is inactive', 1;
        
        -- Process orders
        DECLARE order_cursor CURSOR FOR
            SELECT OrderID FROM Orders 
            WHERE CustomerID = @CustomerID AND OrderStatus = 'Pending';
        
        OPEN order_cursor;
        FETCH NEXT FROM order_cursor INTO @OrderID;
        
        WHILE @@FETCH_STATUS = 0
        BEGIN
            -- Process individual order
            EXEC ProcessSingleOrder @OrderID;
            
            FETCH NEXT FROM order_cursor INTO @OrderID;
        END
        
        CLOSE order_cursor;
        DEALLOCATE order_cursor;
        
        COMMIT TRANSACTION;
        
        RETURN 0; -- Success
        
    END TRY
    BEGIN CATCH
        -- Clean up cursor if still open
        IF CURSOR_STATUS('local', 'order_cursor') >= 0
        BEGIN
            CLOSE order_cursor;
            DEALLOCATE order_cursor;
        END
        
        -- Rollback transaction if active
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        -- Capture error information
        SELECT 
            @ErrorMessage = ERROR_MESSAGE(),
            @ErrorSeverity = ERROR_SEVERITY(),
            @ErrorState = ERROR_STATE();
        
        -- Log the error
        INSERT INTO ErrorLog (ProcedureName, ErrorMessage, ErrorSeverity, ErrorState, ErrorDate, UserID)
        VALUES ('ProcessCustomerOrders', @ErrorMessage, @ErrorSeverity, @ErrorState, GETDATE(), @CustomerID);
        
        -- Re-throw the error
        RAISERROR(@ErrorMessage, @ErrorSeverity, @ErrorState);
        
        RETURN -1; -- Error
    END CATCH
END
```

## 🎯 Real-World Integration Scenarios

### E-commerce Order Processing
```sql
CREATE PROCEDURE ProcessEcommerceOrder
    @OrderData XML
AS
BEGIN
    DECLARE @OrderID INT;
    DECLARE @CustomerID INT;
    DECLARE @TotalAmount DECIMAL(10,2);
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Parse order data
        SELECT 
            @CustomerID = OrderXML.value('(/Order/CustomerID)[1]', 'INT'),
            @TotalAmount = OrderXML.value('(/Order/TotalAmount)[1]', 'DECIMAL(10,2)')
        FROM (SELECT @OrderData AS OrderXML) AS X;
        
        -- Create order header
        INSERT INTO Orders (CustomerID, OrderDate, OrderStatus, TotalAmount)
        VALUES (@CustomerID, GETDATE(), 'Processing', @TotalAmount);
        
        SET @OrderID = SCOPE_IDENTITY();
        
        -- Insert order items
        INSERT INTO OrderItems (OrderID, ProductID, Quantity, UnitPrice)
        SELECT 
            @OrderID,
            Item.value('@ProductID', 'INT'),
            Item.value('@Quantity', 'INT'),
            Item.value('@UnitPrice', 'DECIMAL(10,2)')
        FROM @OrderData.nodes('/Order/Items/Item') AS ItemTable(Item);
        
        -- Update inventory
        UPDATE Products 
        SET InStock = InStock - oi.Quantity,
            LastSold = GETDATE()
        FROM Products p
        JOIN OrderItems oi ON p.ProductID = oi.ProductID
        WHERE oi.OrderID = @OrderID;
        
        -- Check for negative inventory
        IF EXISTS (
            SELECT 1 FROM Products p
            JOIN OrderItems oi ON p.ProductID = oi.ProductID
            WHERE oi.OrderID = @OrderID AND p.InStock < 0
        )
            THROW 50001, 'Insufficient inventory for order', 1;
        
        -- Update customer statistics
        UPDATE Customers 
        SET TotalOrders = TotalOrders + 1,
            TotalSpent = TotalSpent + @TotalAmount,
            LastOrderDate = GETDATE()
        WHERE CustomerID = @CustomerID;
        
        -- Mark order as completed
        UPDATE Orders 
        SET OrderStatus = 'Completed',
            CompletedDate = GETDATE()
        WHERE OrderID = @OrderID;
        
        COMMIT TRANSACTION;
        
        -- Return order ID for confirmation
        SELECT @OrderID AS OrderID;
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
```

## 💡 Best Practices Summary

### 1. Transaction Design Principles
- Keep transactions as short as possible
- Never include user interaction in transactions
- Use appropriate isolation levels
- Handle errors gracefully with proper cleanup

### 2. Performance Guidelines
- Prefer set-based operations over cursor loops
- Use staging tables for complex ETL processes
- Implement batch processing for large operations
- Monitor and optimize query plans

### 3. Data Integrity Rules
- Always validate data before processing
- Implement audit trails for critical operations
- Use constraints and foreign keys appropriately
- Design for concurrent access scenarios

### 4. Error Handling Standards
- Use structured error handling (TRY-CATCH)
- Log errors with sufficient detail for debugging
- Provide meaningful error messages to users
- Implement retry logic where appropriate

## 📚 What's Next?

You've now mastered the complete spectrum of data manipulation operations! Your next step is to move on to **Module 03: Select** where you'll learn to retrieve and query the data you've been manipulating. The foundation you've built here will be crucial for understanding how to effectively query complex data structures.

## 🎯 Module Completion Checklist

- [ ] Understand MERGE operations for data synchronization
- [ ] Can implement proper transaction management
- [ ] Know how to handle concurrent access scenarios
- [ ] Can design and implement audit trails
- [ ] Understand performance optimization techniques
- [ ] Can implement comprehensive error handling
- [ ] Ready to move on to advanced querying techniques

Congratulations! You've mastered advanced data manipulation and are ready to become a SQL query expert! 🚀

---

*Next Module: [Module 03: Select](../../03-Select/01_Teaching/README.md) - Master the art of querying and retrieving data.*