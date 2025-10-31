-- Module 02: Insert, Update & Delete
-- 04_Advanced_DML_Examples.sql - Advanced Data Manipulation Examples

-- Instructions: Study these advanced examples that combine INSERT, UPDATE, DELETE
-- Run these examples in your practice database to see complex DML in action
-- Prerequisites: Complete all previous examples and read 01_Teaching/04_Advanced_DML.md

-- Make sure you're in a practice database
USE TshigidimasaDB;  -- Change to your practice database name

PRINT '🚀 Advanced DML Examples - Combining INSERT, UPDATE, DELETE operations';
PRINT 'These examples show enterprise-level data manipulation patterns';

-- =====================================================
-- SETUP: CREATE ADVANCED EXAMPLE TABLES
-- =====================================================

-- Create tables for advanced scenarios
CREATE TABLE AdvancedCustomers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(20),
    CustomerType VARCHAR(20) DEFAULT 'Standard',
    TotalSpent DECIMAL(10,2) DEFAULT 0,
    OrderCount INT DEFAULT 0,
    LastOrderDate DATETIME NULL,
    CreatedDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME DEFAULT GETDATE(),
    Version INT DEFAULT 1,
    IsActive BIT DEFAULT 1
);

CREATE TABLE AdvancedProducts (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName VARCHAR(200) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    InStock INT DEFAULT 0,
    ReorderLevel INT DEFAULT 10,
    CategoryID INT,
    IsActive BIT DEFAULT 1,
    CreatedDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME DEFAULT GETDATE(),
    Version INT DEFAULT 1
);

CREATE TABLE AdvancedOrders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT FOREIGN KEY REFERENCES AdvancedCustomers(CustomerID),
    OrderDate DATETIME DEFAULT GETDATE(),
    TotalAmount DECIMAL(10,2) DEFAULT 0,
    OrderStatus VARCHAR(20) DEFAULT 'Pending',
    CreatedDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME DEFAULT GETDATE()
);

CREATE TABLE AdvancedOrderItems (
    OrderItemID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT FOREIGN KEY REFERENCES AdvancedOrders(OrderID) ON DELETE CASCADE,
    ProductID INT FOREIGN KEY REFERENCES AdvancedProducts(ProductID),
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    LineTotal AS (Quantity * UnitPrice) PERSISTED
);

-- Staging table for imports
CREATE TABLE CustomerImportStaging (
    ImportID INT IDENTITY(1,1) PRIMARY KEY,
    ExternalID VARCHAR(50),
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    Phone VARCHAR(20),
    ImportDate DATETIME DEFAULT GETDATE(),
    IsProcessed BIT DEFAULT 0,
    IsValid BIT DEFAULT 0,
    ValidationErrors VARCHAR(MAX) NULL
);

-- Audit table
CREATE TABLE DataChangeAudit (
    AuditID BIGINT IDENTITY(1,1) PRIMARY KEY,
    TableName VARCHAR(100),
    Operation VARCHAR(10),
    RecordID INT,
    OldValues XML,
    NewValues XML,
    ChangeDate DATETIME DEFAULT GETDATE(),
    ChangedBy VARCHAR(100) DEFAULT USER_NAME()
);

PRINT 'Advanced tables created successfully';

-- =====================================================
-- MERGE STATEMENT EXAMPLES
-- =====================================================

-- Example 1: Basic MERGE for customer synchronization
-- First, populate some test data
INSERT INTO AdvancedCustomers (FirstName, LastName, Email, CustomerType)
VALUES 
    ('John', 'Smith', 'john.smith@email.com', 'Premium'),
    ('Jane', 'Doe', 'jane.doe@email.com', 'Standard'),
    ('Bob', 'Johnson', 'bob.johnson@email.com', 'VIP');

-- Populate staging with updates and new records
INSERT INTO CustomerImportStaging (ExternalID, FirstName, LastName, Email, Phone, IsValid)
VALUES 
    ('CUST001', 'John', 'Smith-Updated', 'john.smith@email.com', '555-1234', 1),  -- Update existing
    ('CUST002', 'Jane', 'Doe', 'jane.doe.new@email.com', '555-5678', 1),         -- Update existing  
    ('CUST003', 'Alice', 'Brown', 'alice.brown@email.com', '555-9999', 1),       -- New customer
    ('CUST004', 'Invalid', '', '', '', 0);                                       -- Invalid record

-- MERGE operation
MERGE AdvancedCustomers AS target
USING (
    SELECT ExternalID, FirstName, LastName, Email, Phone
    FROM CustomerImportStaging
    WHERE IsValid = 1 AND IsProcessed = 0
) AS source ON (target.Email = source.Email)

-- Update existing customers
WHEN MATCHED THEN
    UPDATE SET 
        FirstName = source.FirstName,
        LastName = source.LastName,
        Phone = source.Phone,
        ModifiedDate = GETDATE(),
        Version = Version + 1

-- Insert new customers
WHEN NOT MATCHED BY TARGET THEN
    INSERT (FirstName, LastName, Email, Phone)
    VALUES (source.FirstName, source.LastName, source.Email, source.Phone)

-- Optional: Handle records in target not in source
-- WHEN NOT MATCHED BY SOURCE THEN DELETE

-- Capture the results
OUTPUT $action AS MergeAction,
       inserted.CustomerID AS CustomerID,
       inserted.FirstName + ' ' + inserted.LastName AS CustomerName;

-- Mark staging records as processed
UPDATE CustomerImportStaging 
SET IsProcessed = 1
WHERE IsValid = 1 AND IsProcessed = 0;

PRINT 'MERGE operation completed - customers synchronized';

-- Example 2: Complex MERGE with conditional logic
-- Populate products for this example
INSERT INTO AdvancedProducts (ProductName, Price, InStock, CategoryID)
VALUES 
    ('Laptop', 999.99, 50, 1),
    ('Mouse', 29.99, 100, 1),
    ('Keyboard', 79.99, 75, 1);

-- Create product update staging
CREATE TABLE #ProductUpdates (
    ProductID INT,
    NewPrice DECIMAL(10,2),
    NewStock INT,
    UpdateType VARCHAR(20)
);

INSERT INTO #ProductUpdates VALUES 
    (1, 899.99, 45, 'PRICE_DROP'),     -- Price decrease
    (2, 34.99, 120, 'PRICE_INCREASE'), -- Price increase  
    (3, 79.99, 0, 'OUT_OF_STOCK'),     -- Stock depletion
    (999, 199.99, 25, 'NEW_PRODUCT');  -- Non-existent product

-- Advanced MERGE with business logic
MERGE AdvancedProducts AS target
USING #ProductUpdates AS source ON (target.ProductID = source.ProductID)

-- Update existing products with business rules
WHEN MATCHED AND source.UpdateType = 'PRICE_DROP' THEN
    UPDATE SET 
        Price = source.NewPrice,
        InStock = source.NewStock,
        ModifiedDate = GETDATE(),
        Version = Version + 1

WHEN MATCHED AND source.UpdateType = 'PRICE_INCREASE' AND source.NewPrice <= target.Price * 1.2 THEN
    UPDATE SET 
        Price = source.NewPrice,
        InStock = source.NewStock,
        ModifiedDate = GETDATE(),
        Version = Version + 1

WHEN MATCHED AND source.UpdateType = 'OUT_OF_STOCK' THEN
    UPDATE SET 
        InStock = 0,
        IsActive = 0,  -- Deactivate out of stock items
        ModifiedDate = GETDATE(),
        Version = Version + 1

-- Don't insert new products in this scenario
-- WHEN NOT MATCHED BY TARGET THEN ...

OUTPUT $action AS Action,
       COALESCE(inserted.ProductID, deleted.ProductID) AS ProductID,
       COALESCE(inserted.ProductName, deleted.ProductName) AS ProductName,
       deleted.Price AS OldPrice,
       inserted.Price AS NewPrice;

DROP TABLE #ProductUpdates;

-- =====================================================
-- TRANSACTION MANAGEMENT EXAMPLES
-- =====================================================

-- Example 3: Complex transaction with savepoints
BEGIN TRANSACTION OrderProcessing;

BEGIN TRY
    DECLARE @CustomerID INT = 1;
    DECLARE @OrderID INT;
    
    -- Create order header
    INSERT INTO AdvancedOrders (CustomerID, OrderDate)
    VALUES (@CustomerID, GETDATE());
    
    SET @OrderID = SCOPE_IDENTITY();
    
    -- Savepoint after order creation
    SAVE TRANSACTION OrderCreated;
    
    -- Add order items
    INSERT INTO AdvancedOrderItems (OrderID, ProductID, Quantity, UnitPrice)
    VALUES 
        (@OrderID, 1, 2, 999.99),  -- 2 Laptops
        (@OrderID, 2, 1, 29.99);   -- 1 Mouse
    
    -- Savepoint after items added
    SAVE TRANSACTION ItemsAdded;
    
    -- Update inventory
    UPDATE AdvancedProducts 
    SET InStock = InStock - 2,
        ModifiedDate = GETDATE()
    WHERE ProductID = 1;
    
    UPDATE AdvancedProducts 
    SET InStock = InStock - 1,
        ModifiedDate = GETDATE()
    WHERE ProductID = 2;
    
    -- Check for negative inventory
    IF EXISTS (SELECT 1 FROM AdvancedProducts WHERE InStock < 0)
    BEGIN
        -- Rollback to after items were added, before inventory update
        ROLLBACK TRANSACTION ItemsAdded;
        
        -- Adjust quantities and try again
        UPDATE AdvancedOrderItems 
        SET Quantity = 1
        WHERE OrderID = @OrderID AND ProductID = 1;
        
        -- Update inventory with adjusted quantities
        UPDATE AdvancedProducts 
        SET InStock = InStock - 1,
            ModifiedDate = GETDATE()
        WHERE ProductID = 1;
        
        UPDATE AdvancedProducts 
        SET InStock = InStock - 1,
            ModifiedDate = GETDATE()
        WHERE ProductID = 2;
    END
    
    -- Calculate order total
    UPDATE AdvancedOrders 
    SET TotalAmount = (
        SELECT SUM(LineTotal) 
        FROM AdvancedOrderItems 
        WHERE OrderID = @OrderID
    ),
    ModifiedDate = GETDATE()
    WHERE OrderID = @OrderID;
    
    -- Update customer statistics
    UPDATE AdvancedCustomers 
    SET OrderCount = OrderCount + 1,
        TotalSpent = TotalSpent + (SELECT TotalAmount FROM AdvancedOrders WHERE OrderID = @OrderID),
        LastOrderDate = GETDATE(),
        ModifiedDate = GETDATE()
    WHERE CustomerID = @CustomerID;
    
    COMMIT TRANSACTION OrderProcessing;
    PRINT 'Order processed successfully. Order ID: ' + CAST(@OrderID AS VARCHAR(10));
    
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION OrderProcessing;
    PRINT 'Order processing failed: ' + ERROR_MESSAGE();
    
    -- Log the error
    INSERT INTO DataChangeAudit (TableName, Operation, RecordID, ChangeDate)
    VALUES ('OrderProcessing', 'ERROR', @OrderID, GETDATE());
END CATCH

-- =====================================================
-- BULK OPERATIONS WITH STAGING
-- =====================================================

-- Example 4: ETL Process with staging tables
CREATE PROCEDURE ProcessCustomerImport
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @ProcessedCount INT = 0;
    DECLARE @ErrorCount INT = 0;
    DECLARE @StartTime DATETIME = GETDATE();
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Step 1: Validate staging data
        UPDATE CustomerImportStaging 
        SET IsValid = CASE 
            WHEN LEN(TRIM(FirstName)) > 0 
                AND LEN(TRIM(LastName)) > 0 
                AND Email LIKE '%@%.%'
                AND LEN(Email) > 5
            THEN 1 
            ELSE 0 
        END,
        ValidationErrors = CASE 
            WHEN LEN(TRIM(FirstName)) = 0 THEN 'Missing first name; '
            ELSE ''
        END +
        CASE 
            WHEN LEN(TRIM(LastName)) = 0 THEN 'Missing last name; '
            ELSE ''
        END +
        CASE 
            WHEN Email NOT LIKE '%@%.%' OR LEN(Email) <= 5 THEN 'Invalid email; '
            ELSE ''
        END
        WHERE IsProcessed = 0;
        
        -- Step 2: Process valid records
        MERGE AdvancedCustomers AS target
        USING (
            SELECT FirstName, LastName, Email, Phone
            FROM CustomerImportStaging
            WHERE IsValid = 1 AND IsProcessed = 0
        ) AS source ON (target.Email = source.Email)
        
        WHEN MATCHED THEN
            UPDATE SET 
                FirstName = source.FirstName,
                LastName = source.LastName,
                Phone = source.Phone,
                ModifiedDate = GETDATE(),
                Version = Version + 1
                
        WHEN NOT MATCHED BY TARGET THEN
            INSERT (FirstName, LastName, Email, Phone)
            VALUES (source.FirstName, source.LastName, source.Email, source.Phone);
        
        SET @ProcessedCount = @@ROWCOUNT;
        
        -- Step 3: Mark records as processed
        UPDATE CustomerImportStaging 
        SET IsProcessed = 1
        WHERE IsValid = 1 AND IsProcessed = 0;
        
        -- Step 4: Count errors
        SELECT @ErrorCount = COUNT(*)
        FROM CustomerImportStaging 
        WHERE IsValid = 0 AND IsProcessed = 0;
        
        COMMIT TRANSACTION;
        
        -- Log success
        INSERT INTO DataChangeAudit (TableName, Operation, ChangeDate)
        VALUES ('CustomerImport', 'ETL_SUCCESS', GETDATE());
        
        PRINT 'Import completed successfully';
        PRINT 'Processed: ' + CAST(@ProcessedCount AS VARCHAR(10)) + ' records';
        PRINT 'Errors: ' + CAST(@ErrorCount AS VARCHAR(10)) + ' records';
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        
        INSERT INTO DataChangeAudit (TableName, Operation, ChangeDate)
        VALUES ('CustomerImport', 'ETL_ERROR', GETDATE());
        
        PRINT 'Import failed: ' + ERROR_MESSAGE();
    END CATCH
END

-- Test the ETL procedure
EXEC ProcessCustomerImport;

-- =====================================================
-- OPTIMISTIC LOCKING EXAMPLE
-- =====================================================

-- Example 5: Optimistic locking to handle concurrent updates
CREATE PROCEDURE UpdateCustomerWithVersionCheck
    @CustomerID INT,
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @Email VARCHAR(100),
    @ExpectedVersion INT
AS
BEGIN
    DECLARE @ActualVersion INT;
    DECLARE @RowsAffected INT;
    
    -- Get current version
    SELECT @ActualVersion = Version
    FROM AdvancedCustomers
    WHERE CustomerID = @CustomerID;
    
    -- Check if record exists
    IF @ActualVersion IS NULL
    BEGIN
        THROW 50001, 'Customer not found', 1;
    END
    
    -- Check version for optimistic locking
    IF @ActualVersion != @ExpectedVersion
    BEGIN
        THROW 50002, 'Customer was modified by another user. Please refresh and try again.', 1;
    END
    
    -- Perform update with version increment
    UPDATE AdvancedCustomers 
    SET FirstName = @FirstName,
        LastName = @LastName,
        Email = @Email,
        ModifiedDate = GETDATE(),
        Version = Version + 1
    WHERE CustomerID = @CustomerID 
      AND Version = @ExpectedVersion;
    
    SET @RowsAffected = @@ROWCOUNT;
    
    IF @RowsAffected = 0
    BEGIN
        THROW 50003, 'Update failed due to concurrent modification', 1;
    END
    
    -- Return new version
    SELECT Version AS NewVersion
    FROM AdvancedCustomers
    WHERE CustomerID = @CustomerID;
    
    PRINT 'Customer updated successfully';
END

-- Test optimistic locking
DECLARE @CurrentVersion INT;
SELECT @CurrentVersion = Version FROM AdvancedCustomers WHERE CustomerID = 1;

EXEC UpdateCustomerWithVersionCheck 
    @CustomerID = 1,
    @FirstName = 'John',
    @LastName = 'Smith-Updated',
    @Email = 'john.smith.new@email.com',
    @ExpectedVersion = @CurrentVersion;

-- =====================================================
-- AUDIT TRAIL IMPLEMENTATION
-- =====================================================

-- Example 6: Comprehensive audit trigger
CREATE TRIGGER tr_AdvancedCustomers_Audit
ON AdvancedCustomers
FOR INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Handle INSERT
    IF EXISTS (SELECT 1 FROM inserted) AND NOT EXISTS (SELECT 1 FROM deleted)
    BEGIN
        INSERT INTO DataChangeAudit (TableName, Operation, RecordID, NewValues)
        SELECT 
            'AdvancedCustomers',
            'INSERT',
            i.CustomerID,
            (SELECT i.* FOR XML AUTO, TYPE)
        FROM inserted i;
    END
    
    -- Handle UPDATE
    IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
    BEGIN
        INSERT INTO DataChangeAudit (TableName, Operation, RecordID, OldValues, NewValues)
        SELECT 
            'AdvancedCustomers',
            'UPDATE',
            i.CustomerID,
            (SELECT d.* FOR XML AUTO, TYPE),
            (SELECT i.* FOR XML AUTO, TYPE)
        FROM inserted i
        JOIN deleted d ON i.CustomerID = d.CustomerID;
    END
    
    -- Handle DELETE
    IF EXISTS (SELECT 1 FROM deleted) AND NOT EXISTS (SELECT 1 FROM inserted)
    BEGIN
        INSERT INTO DataChangeAudit (TableName, Operation, RecordID, OldValues)
        SELECT 
            'AdvancedCustomers',
            'DELETE',
            d.CustomerID,
            (SELECT d.* FOR XML AUTO, TYPE)
        FROM deleted d;
    END
END

-- Test the audit trigger
UPDATE AdvancedCustomers 
SET CustomerType = 'Audit Test'
WHERE CustomerID = 1;

-- Check audit log
SELECT TOP 5 *
FROM DataChangeAudit
ORDER BY ChangeDate DESC;

-- =====================================================
-- UPSERT PATTERNS
-- =====================================================

-- Example 7: UPSERT (Insert or Update) pattern
CREATE PROCEDURE UpsertCustomer
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @Email VARCHAR(100),
    @Phone VARCHAR(20) = NULL,
    @CustomerType VARCHAR(20) = 'Standard'
AS
BEGIN
    IF EXISTS (SELECT 1 FROM AdvancedCustomers WHERE Email = @Email)
    BEGIN
        -- Update existing customer
        UPDATE AdvancedCustomers 
        SET FirstName = @FirstName,
            LastName = @LastName,
            Phone = @Phone,
            CustomerType = @CustomerType,
            ModifiedDate = GETDATE(),
            Version = Version + 1
        WHERE Email = @Email;
        
        SELECT 'UPDATED' AS Operation, CustomerID
        FROM AdvancedCustomers
        WHERE Email = @Email;
    END
    ELSE
    BEGIN
        -- Insert new customer
        INSERT INTO AdvancedCustomers (FirstName, LastName, Email, Phone, CustomerType)
        VALUES (@FirstName, @LastName, @Email, @Phone, @CustomerType);
        
        SELECT 'INSERTED' AS Operation, SCOPE_IDENTITY() AS CustomerID;
    END
END

-- Test UPSERT
EXEC UpsertCustomer 
    @FirstName = 'New', 
    @LastName = 'Customer', 
    @Email = 'new.customer@email.com',
    @Phone = '555-0000',
    @CustomerType = 'Premium';

-- Test update of existing
EXEC UpsertCustomer 
    @FirstName = 'Updated', 
    @LastName = 'Customer', 
    @Email = 'new.customer@email.com',
    @Phone = '555-1111',
    @CustomerType = 'VIP';

-- =====================================================
-- DATA SYNCHRONIZATION PATTERNS
-- =====================================================

-- Example 8: Two-way data synchronization
CREATE PROCEDURE SynchronizeCustomerData
    @SourceSystemID VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @SyncStartTime DATETIME = GETDATE();
    
    BEGIN TRY
        BEGIN TRANSACTION;
        
        -- Simulate external data source
        CREATE TABLE #ExternalCustomers (
            ExternalID VARCHAR(50),
            FirstName VARCHAR(50),
            LastName VARCHAR(50),
            Email VARCHAR(100),
            Phone VARCHAR(20),
            LastModified DATETIME
        );
        
        -- Simulate data from external system
        INSERT INTO #ExternalCustomers VALUES
            ('EXT001', 'External', 'Customer1', 'ext1@external.com', '555-EXT1', GETDATE()),
            ('EXT002', 'External', 'Customer2', 'ext2@external.com', '555-EXT2', GETDATE());
        
        -- Bidirectional sync with conflict resolution
        MERGE AdvancedCustomers AS target
        USING #ExternalCustomers AS source 
        ON (target.Email = source.Email)
        
        WHEN MATCHED AND source.LastModified > target.ModifiedDate THEN
            UPDATE SET 
                FirstName = source.FirstName,
                LastName = source.LastName,
                Phone = source.Phone,
                ModifiedDate = GETDATE(),
                Version = Version + 1
                
        WHEN NOT MATCHED BY TARGET THEN
            INSERT (FirstName, LastName, Email, Phone)
            VALUES (source.FirstName, source.LastName, source.Email, source.Phone)
            
        -- Log conflicts (when target is newer)
        WHEN MATCHED AND source.LastModified <= target.ModifiedDate THEN
            UPDATE SET ModifiedDate = ModifiedDate  -- No-op, just for logging
            
        OUTPUT $action AS SyncAction,
               inserted.CustomerID,
               inserted.Email,
               source.ExternalID;
        
        DROP TABLE #ExternalCustomers;
        
        COMMIT TRANSACTION;
        
        PRINT 'Data synchronization completed successfully';
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION;
        PRINT 'Synchronization failed: ' + ERROR_MESSAGE();
    END CATCH
END

-- Test synchronization
EXEC SynchronizeCustomerData @SourceSystemID = 'ExternalSystem1';

-- =====================================================
-- PERFORMANCE OPTIMIZATION EXAMPLES
-- =====================================================

-- Example 9: Batch processing with progress tracking
CREATE PROCEDURE BatchUpdateCustomerStats
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @BatchSize INT = 100;
    DECLARE @ProcessedCount INT = 0;
    DECLARE @TotalToProcess INT;
    DECLARE @StartTime DATETIME = GETDATE();
    
    -- Count total records to process
    SELECT @TotalToProcess = COUNT(*)
    FROM AdvancedCustomers
    WHERE OrderCount != (
        SELECT COUNT(*) FROM AdvancedOrders 
        WHERE AdvancedOrders.CustomerID = AdvancedCustomers.CustomerID
    );
    
    PRINT 'Starting batch update of ' + CAST(@TotalToProcess AS VARCHAR(10)) + ' customers';
    
    WHILE @ProcessedCount < @TotalToProcess
    BEGIN
        UPDATE TOP (@BatchSize) AdvancedCustomers 
        SET OrderCount = (
            SELECT COUNT(*) FROM AdvancedOrders 
            WHERE AdvancedOrders.CustomerID = AdvancedCustomers.CustomerID
        ),
        TotalSpent = ISNULL((
            SELECT SUM(TotalAmount) FROM AdvancedOrders 
            WHERE AdvancedOrders.CustomerID = AdvancedCustomers.CustomerID
        ), 0),
        LastOrderDate = (
            SELECT MAX(OrderDate) FROM AdvancedOrders 
            WHERE AdvancedOrders.CustomerID = AdvancedCustomers.CustomerID
        ),
        ModifiedDate = GETDATE()
        WHERE OrderCount != (
            SELECT COUNT(*) FROM AdvancedOrders 
            WHERE AdvancedOrders.CustomerID = AdvancedCustomers.CustomerID
        );
        
        SET @ProcessedCount = @ProcessedCount + @@ROWCOUNT;
        
        -- Progress report every 10 batches
        IF @ProcessedCount % (10 * @BatchSize) = 0
        BEGIN
            PRINT 'Processed: ' + CAST(@ProcessedCount AS VARCHAR(10)) + 
                  ' of ' + CAST(@TotalToProcess AS VARCHAR(10)) + ' customers';
        END
        
        -- Small delay to reduce system impact
        WAITFOR DELAY '00:00:00.050';  -- 50ms
    END
    
    PRINT 'Batch update completed in ' + 
          CAST(DATEDIFF(SECOND, @StartTime, GETDATE()) AS VARCHAR(10)) + ' seconds';
END

-- Test batch processing
EXEC BatchUpdateCustomerStats;

-- =====================================================
-- CLEANUP AND VERIFICATION
-- =====================================================

-- Example 10: Data integrity verification
CREATE PROCEDURE VerifyDataIntegrity
AS
BEGIN
    SET NOCOUNT ON;
    
    PRINT 'Data Integrity Check Results:';
    PRINT '============================';
    
    -- Check for orphaned order items
    SELECT 'Orphaned Order Items' AS Issue, COUNT(*) AS Count
    FROM AdvancedOrderItems oi
    LEFT JOIN AdvancedOrders o ON oi.OrderID = o.OrderID
    WHERE o.OrderID IS NULL;
    
    -- Check for inconsistent order totals
    SELECT 'Orders with Incorrect Totals' AS Issue, COUNT(*) AS Count
    FROM AdvancedOrders o
    WHERE ABS(o.TotalAmount - ISNULL((
        SELECT SUM(LineTotal) FROM AdvancedOrderItems 
        WHERE OrderID = o.OrderID
    ), 0)) > 0.01;
    
    -- Check customer statistics
    SELECT 'Customers with Incorrect Order Count' AS Issue, COUNT(*) AS Count
    FROM AdvancedCustomers c
    WHERE c.OrderCount != (
        SELECT COUNT(*) FROM AdvancedOrders 
        WHERE CustomerID = c.CustomerID
    );
    
    -- Check for negative inventory
    SELECT 'Products with Negative Inventory' AS Issue, COUNT(*) AS Count
    FROM AdvancedProducts 
    WHERE InStock < 0;
    
    PRINT 'Data integrity check completed';
END

-- Run integrity check
EXEC VerifyDataIntegrity;

-- Show final state of data
SELECT 'Final Data Summary' AS Report;
SELECT 'AdvancedCustomers' AS TableName, COUNT(*) AS RecordCount FROM AdvancedCustomers
UNION ALL
SELECT 'AdvancedProducts', COUNT(*) FROM AdvancedProducts
UNION ALL
SELECT 'AdvancedOrders', COUNT(*) FROM AdvancedOrders
UNION ALL
SELECT 'AdvancedOrderItems', COUNT(*) FROM AdvancedOrderItems
UNION ALL
SELECT 'DataChangeAudit', COUNT(*) FROM DataChangeAudit;

-- Show audit trail summary
SELECT 'Audit Trail Summary' AS Report;
SELECT Operation, COUNT(*) AS OperationCount
FROM DataChangeAudit
GROUP BY Operation
ORDER BY OperationCount DESC;

-- =====================================================
-- CLEANUP - REMOVE EXAMPLE OBJECTS
-- =====================================================

-- Drop triggers first
DROP TRIGGER tr_AdvancedCustomers_Audit;

-- Drop procedures
DROP PROCEDURE ProcessCustomerImport;
DROP PROCEDURE UpdateCustomerWithVersionCheck;
DROP PROCEDURE UpsertCustomer;
DROP PROCEDURE SynchronizeCustomerData;
DROP PROCEDURE BatchUpdateCustomerStats;
DROP PROCEDURE VerifyDataIntegrity;

-- Drop tables (in dependency order)
DROP TABLE DataChangeAudit;
DROP TABLE CustomerImportStaging;
DROP TABLE AdvancedOrderItems;
DROP TABLE AdvancedOrders;
DROP TABLE AdvancedProducts;
DROP TABLE AdvancedCustomers;

-- =====================================================
-- KEY LEARNING POINTS SUMMARY
-- =====================================================

/*
Advanced DML Concepts Demonstrated:

1. MERGE Statement:
   - Basic and complex MERGE operations
   - Conditional logic in MERGE clauses
   - Data synchronization patterns
   - Handling conflicts and business rules

2. Transaction Management:
   - Complex transactions with savepoints
   - Nested transaction handling
   - Error recovery strategies
   - ACID property implementation

3. ETL Patterns:
   - Staging table usage
   - Data validation and cleansing
   - Bulk processing techniques
   - Error handling and logging

4. Concurrency Control:
   - Optimistic locking with version control
   - Handling concurrent modifications
   - Conflict detection and resolution

5. Audit Trails:
   - Comprehensive change tracking
   - Trigger-based auditing
   - XML storage for complex data
   - Audit data analysis

6. UPSERT Patterns:
   - Insert or Update logic
   - Conditional data operations
   - Business rule implementation

7. Data Synchronization:
   - Bidirectional sync patterns
   - Conflict resolution strategies
   - External system integration

8. Performance Optimization:
   - Batch processing techniques
   - Progress tracking and reporting
   - Resource-conscious operations
   - Minimal lock duration

9. Data Integrity:
   - Referential integrity checks
   - Business rule validation
   - Consistency verification
   - Error detection and correction

10. Enterprise Patterns:
    - Stored procedure design
    - Error handling standards
    - Logging and monitoring
    - Maintainable code structure

Best Practices Demonstrated:
- Always use transactions for complex operations
- Implement proper error handling
- Use staging tables for bulk operations
- Version control for optimistic locking
- Comprehensive audit trails
- Performance-conscious batch processing
- Data integrity verification
- Modular, reusable procedures
*/

PRINT '🚀 Advanced DML examples completed successfully!';
PRINT 'You have now mastered enterprise-level data manipulation techniques!';
PRINT 'Next: Move on to Module 03: Select to learn advanced querying techniques';