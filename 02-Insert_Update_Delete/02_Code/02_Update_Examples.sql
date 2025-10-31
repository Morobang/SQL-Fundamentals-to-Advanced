-- Module 02: Insert, Update & Delete
-- 02_Update_Examples.sql - Comprehensive UPDATE Operation Examples

-- Instructions: Study these examples to understand UPDATE operations in practice
-- Run these examples in your practice database to see how they work
-- Prerequisites: Complete 01_Insert_Examples.sql and read 01_Teaching/02_Update_Operations.md

-- Make sure you're in a practice database
USE TshigidimasaDB;  -- Change to your practice database name

-- =====================================================
-- SETUP: ENSURE WE HAVE DATA TO UPDATE
-- =====================================================

-- First, let's make sure we have the tables and data from INSERT examples
-- If you haven't run 01_Insert_Examples.sql, do that first!

-- Verify we have data to work with
IF NOT EXISTS (SELECT 1 FROM SampleCustomers)
BEGIN
    PRINT 'ERROR: No sample data found. Please run 01_Insert_Examples.sql first!';
    RETURN;
END

PRINT 'Sample data verified. Proceeding with UPDATE examples...';

-- =====================================================
-- BASIC UPDATE EXAMPLES
-- =====================================================

-- Example 1: Simple single column update
-- Update a customer's phone number
UPDATE SampleCustomers 
SET Phone = '555-NEW-PHONE'
WHERE CustomerID = 1;

-- Verify the change
SELECT CustomerID, FirstName, LastName, Phone 
FROM SampleCustomers 
WHERE CustomerID = 1;

-- Example 2: Multiple column update
-- Update customer information for customer ID 2
UPDATE SampleCustomers 
SET FirstName = 'Janet',
    LastName = 'Doe-Smith',
    Email = 'janet.doe.smith@email.com',
    CustomerType = 'VIP'
WHERE CustomerID = 2;

-- Verify the changes
SELECT CustomerID, FirstName, LastName, Email, CustomerType 
FROM SampleCustomers 
WHERE CustomerID = 2;

-- Example 3: Update with current timestamp
-- Update customer's last activity date
UPDATE SampleCustomers 
SET DateJoined = GETDATE()  -- Update to current date/time
WHERE CustomerID = 3;

-- =====================================================
-- SAFETY FIRST: ALWAYS TEST WITH SELECT
-- =====================================================

-- Example 4: The safe way to update - test first!

-- STEP 1: Always test your WHERE clause with SELECT first
SELECT CustomerID, FirstName, LastName, CustomerType
FROM SampleCustomers 
WHERE LastName = 'Johnson';

-- STEP 2: Count how many records will be affected
SELECT COUNT(*) AS RecordsToUpdate
FROM SampleCustomers 
WHERE LastName = 'Johnson';

-- STEP 3: If the count looks right, proceed with UPDATE
UPDATE SampleCustomers 
SET CustomerType = 'Premium'
WHERE LastName = 'Johnson';

-- STEP 4: Verify the update worked
SELECT CustomerID, FirstName, LastName, CustomerType
FROM SampleCustomers 
WHERE LastName = 'Johnson';

-- =====================================================
-- UPDATE WITH DIFFERENT WHERE CONDITIONS
-- =====================================================

-- Example 5: Update multiple records with AND condition
UPDATE SampleCustomers 
SET CustomerType = 'Gold'
WHERE IsActive = 1 AND DateJoined < '2024-10-18';

-- Example 6: Update with OR condition
UPDATE SampleCustomers 
SET CustomerType = 'Special'
WHERE LastName = 'Wilson' OR LastName = 'Davis';

-- Example 7: Update with LIKE pattern matching
UPDATE SampleCustomers 
SET CustomerType = 'Bulk'
WHERE FirstName LIKE 'Bulk%';

-- Example 8: Update with IN clause
UPDATE SampleCustomers 
SET IsActive = 0
WHERE CustomerID IN (15, 16, 17);  -- Assuming these IDs exist

-- Example 9: Update with date range
UPDATE SampleOrders 
SET OrderStatus = 'Reviewed'
WHERE OrderDate BETWEEN '2024-10-15' AND '2024-10-16';

-- =====================================================
-- CALCULATED AND CONDITIONAL UPDATES
-- =====================================================

-- Example 10: Update with calculation
-- Apply 10% price increase to all products
UPDATE SampleProducts 
SET Price = Price * 1.10
WHERE CategoryID = 1;

-- Example 11: Update with CASE statement
-- Apply different discounts based on current price
UPDATE SampleProducts 
SET Price = CASE 
    WHEN Price > 1000 THEN Price * 0.90  -- 10% discount for expensive items
    WHEN Price > 100 THEN Price * 0.95   -- 5% discount for mid-range
    ELSE Price                           -- No discount for cheap items
END
WHERE IsActive = 1;

-- Example 12: Conditional update based on stock levels
-- Update status based on inventory
UPDATE SampleProducts 
SET Description = Description + ' - LOW STOCK!'
WHERE InStock < 10 
  AND Description NOT LIKE '%LOW STOCK%';

-- Example 13: Update with mathematical functions
-- Round prices to nearest dollar
UPDATE SampleProducts 
SET Price = ROUND(Price, 0)
WHERE CategoryID = 3;

-- =====================================================
-- UPDATE WITH SUBQUERIES
-- =====================================================

-- Example 14: Update based on related table data
-- Update customer type based on their order history
UPDATE SampleCustomers 
SET CustomerType = 'High Value'
WHERE CustomerID IN (
    SELECT CustomerID 
    FROM SampleOrders 
    WHERE TotalAmount > 500
);

-- Example 15: Update with correlated subquery
-- Update order total based on order details
UPDATE SampleOrders 
SET TotalAmount = (
    SELECT SUM(Quantity * UnitPrice) 
    FROM SampleOrderDetails 
    WHERE SampleOrderDetails.OrderID = SampleOrders.OrderID
)
WHERE OrderID IN (
    SELECT DISTINCT OrderID FROM SampleOrderDetails
);

-- Example 16: Update with EXISTS
-- Mark customers as VIP if they have multiple orders
UPDATE SampleCustomers 
SET CustomerType = 'VIP Customer'
WHERE EXISTS (
    SELECT 1 
    FROM SampleOrders 
    WHERE SampleOrders.CustomerID = SampleCustomers.CustomerID
    GROUP BY CustomerID
    HAVING COUNT(*) > 1
);

-- =====================================================
-- UPDATE WITH JOINs
-- =====================================================

-- Example 17: Update using JOIN (SQL Server syntax)
-- Update product stock based on order quantities
UPDATE p
SET InStock = p.InStock - od.TotalOrdered
FROM SampleProducts p
JOIN (
    SELECT ProductID, SUM(Quantity) AS TotalOrdered
    FROM SampleOrderDetails
    GROUP BY ProductID
) od ON p.ProductID = od.ProductID;

-- Example 18: Complex JOIN update
-- Update customer info based on their most recent order
UPDATE c
SET CustomerType = 'Recent Buyer'
FROM SampleCustomers c
JOIN (
    SELECT CustomerID, MAX(OrderDate) AS LastOrderDate
    FROM SampleOrders
    GROUP BY CustomerID
) recent ON c.CustomerID = recent.CustomerID
WHERE recent.LastOrderDate >= DATEADD(DAY, -7, GETDATE());

-- =====================================================
-- BULK UPDATE SCENARIOS
-- =====================================================

-- Example 19: Bulk status update
-- Mark all old orders as archived
UPDATE SampleOrders 
SET OrderStatus = 'Archived'
WHERE OrderDate < DATEADD(MONTH, -1, GETDATE())
  AND OrderStatus IN ('Completed', 'Shipped');

-- Example 20: Bulk price adjustment
-- Apply inflation adjustment to all products
DECLARE @InflationRate DECIMAL(5,4) = 1.0350;  -- 3.5% increase

UPDATE SampleProducts 
SET Price = Price * @InflationRate
WHERE IsActive = 1;

-- =====================================================
-- NULL HANDLING IN UPDATES
-- =====================================================

-- Example 21: Replace NULL values with defaults
UPDATE SampleCustomers 
SET Phone = 'No phone provided'
WHERE Phone IS NULL;

-- Example 22: Set values to NULL
UPDATE SampleCustomers 
SET Phone = NULL
WHERE Phone = 'No phone provided';

-- Example 23: Conditional NULL handling
UPDATE SampleCustomers 
SET Email = COALESCE(Email, FirstName + '.' + LastName + '@company.com')
WHERE Email IS NULL OR Email = '';

-- =====================================================
-- TRANSACTION EXAMPLES FOR SAFETY
-- =====================================================

-- Example 24: Safe update with transaction
BEGIN TRANSACTION;

-- Show before state
SELECT 'BEFORE UPDATE' AS Status, CustomerType, COUNT(*) AS Count
FROM SampleCustomers 
GROUP BY CustomerType;

-- Perform update
UPDATE SampleCustomers 
SET CustomerType = 'Updated'
WHERE CustomerType = 'Standard';

-- Check results
SELECT 'AFTER UPDATE' AS Status, CustomerType, COUNT(*) AS Count
FROM SampleCustomers 
GROUP BY CustomerType;

-- If results look good, commit; otherwise rollback
PRINT 'Review the results above. Uncomment COMMIT or ROLLBACK as needed:';
-- COMMIT TRANSACTION;    -- Uncomment this to keep changes
ROLLBACK TRANSACTION;   -- Uncomment this to undo changes

-- =====================================================
-- ERROR HANDLING EXAMPLES
-- =====================================================

-- Example 25: UPDATE with error handling
BEGIN TRY
    BEGIN TRANSACTION;
    
    -- This update might fail due to constraints
    UPDATE SampleCustomers 
    SET Email = 'duplicate@email.com'  -- This might violate unique constraint
    WHERE CustomerID BETWEEN 1 AND 5;
    
    COMMIT TRANSACTION;
    PRINT 'Update completed successfully';
    
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Update failed: ' + ERROR_MESSAGE();
    PRINT 'All changes have been rolled back';
END CATCH

-- Example 26: Conditional update with validation
DECLARE @CustomerID INT = 1;
DECLARE @NewEmail VARCHAR(100) = 'updated.email@example.com';

-- Check if email is already in use by another customer
IF NOT EXISTS (
    SELECT 1 FROM SampleCustomers 
    WHERE Email = @NewEmail AND CustomerID != @CustomerID
)
BEGIN
    UPDATE SampleCustomers 
    SET Email = @NewEmail
    WHERE CustomerID = @CustomerID;
    
    PRINT 'Email updated successfully';
END
ELSE
BEGIN
    PRINT 'Email is already in use by another customer';
END

-- =====================================================
-- PERFORMANCE OPTIMIZATION EXAMPLES
-- =====================================================

-- Example 27: Batch updates for large datasets
-- Update in batches to avoid long locks
DECLARE @BatchSize INT = 100;
DECLARE @RowsUpdated INT = @BatchSize;

WHILE @RowsUpdated = @BatchSize
BEGIN
    UPDATE TOP (@BatchSize) SampleProducts 
    SET IsActive = 0
    WHERE InStock = 0 AND IsActive = 1;
    
    SET @RowsUpdated = @@ROWCOUNT;
    
    PRINT 'Updated ' + CAST(@RowsUpdated AS VARCHAR(10)) + ' products';
    
    -- Small delay to reduce system impact
    WAITFOR DELAY '00:00:00.100';  -- 100ms pause
END

-- Example 28: Index-friendly updates
-- Use indexed columns in WHERE clause for better performance
UPDATE SampleCustomers 
SET CustomerType = 'Optimized'
WHERE CustomerID = 5;  -- CustomerID is indexed (Primary Key)

-- AVOID: Updates that can't use indexes efficiently
-- UPDATE SampleCustomers 
-- SET CustomerType = 'Slow'
-- WHERE UPPER(FirstName) = 'JOHN';  -- Function on column prevents index use

-- =====================================================
-- DATA VALIDATION EXAMPLES
-- =====================================================

-- Example 29: Validate before update
-- Only update if data meets business rules
UPDATE SampleProducts 
SET Price = 99.99
WHERE ProductID = 1
  AND InStock > 0  -- Only update products that are in stock
  AND IsActive = 1; -- Only update active products

-- Example 30: Update with data cleansing
-- Clean up data while updating
UPDATE SampleCustomers 
SET FirstName = TRIM(UPPER(LEFT(FirstName, 1)) + LOWER(SUBSTRING(FirstName, 2, 100))),
    LastName = TRIM(UPPER(LEFT(LastName, 1)) + LOWER(SUBSTRING(LastName, 2, 100))),
    Email = LOWER(TRIM(Email))
WHERE CustomerID > 0;

-- =====================================================
-- AUDIT TRAIL EXAMPLES
-- =====================================================

-- Example 31: Create audit table for tracking changes
CREATE TABLE CustomerAudit (
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT,
    OldValues VARCHAR(MAX),
    NewValues VARCHAR(MAX),
    ChangeDate DATETIME DEFAULT GETDATE(),
    ChangedBy VARCHAR(100) DEFAULT USER_NAME()
);

-- Example 32: Update with audit trail
DECLARE @CustomerIDToUpdate INT = 1;

-- Capture old values
DECLARE @OldValues VARCHAR(MAX);
SELECT @OldValues = 
    'FirstName: ' + FirstName + 
    ', LastName: ' + LastName + 
    ', Email: ' + Email + 
    ', CustomerType: ' + CustomerType
FROM SampleCustomers 
WHERE CustomerID = @CustomerIDToUpdate;

-- Perform the update
UPDATE SampleCustomers 
SET CustomerType = 'Audited Update'
WHERE CustomerID = @CustomerIDToUpdate;

-- Capture new values and log the change
DECLARE @NewValues VARCHAR(MAX);
SELECT @NewValues = 
    'FirstName: ' + FirstName + 
    ', LastName: ' + LastName + 
    ', Email: ' + Email + 
    ', CustomerType: ' + CustomerType
FROM SampleCustomers 
WHERE CustomerID = @CustomerIDToUpdate;

-- Insert audit record
INSERT INTO CustomerAudit (CustomerID, OldValues, NewValues)
VALUES (@CustomerIDToUpdate, @OldValues, @NewValues);

-- =====================================================
-- ADVANCED UPDATE PATTERNS
-- =====================================================

-- Example 33: Conditional update with OUTPUT clause
-- Update and capture what was changed
DECLARE @UpdatedCustomers TABLE (
    CustomerID INT,
    OldType VARCHAR(20),
    NewType VARCHAR(20)
);

UPDATE SampleCustomers 
SET CustomerType = 'Batch Updated'
OUTPUT inserted.CustomerID, deleted.CustomerType, inserted.CustomerType 
INTO @UpdatedCustomers
WHERE CustomerType = 'Standard';

-- Show what was changed
SELECT * FROM @UpdatedCustomers;

-- Example 34: Update with ranking/window functions
-- Update products with rank-based pricing
WITH ProductRanking AS (
    SELECT 
        ProductID,
        ROW_NUMBER() OVER (ORDER BY Price DESC) AS PriceRank
    FROM SampleProducts
    WHERE IsActive = 1
)
UPDATE p
SET Description = p.Description + ' (Price Rank: ' + CAST(pr.PriceRank AS VARCHAR(10)) + ')'
FROM SampleProducts p
JOIN ProductRanking pr ON p.ProductID = pr.ProductID;

-- =====================================================
-- VERIFICATION AND TESTING
-- =====================================================

-- Example 35: Comprehensive update verification
-- Check the results of our updates

-- Count customers by type
SELECT 'Customer Types' AS Category, CustomerType, COUNT(*) AS Count
FROM SampleCustomers 
GROUP BY CustomerType
ORDER BY CustomerType;

-- Check product price ranges
SELECT 
    'Product Prices' AS Category,
    CASE 
        WHEN Price < 50 THEN 'Under $50'
        WHEN Price < 100 THEN '$50-$100'
        WHEN Price < 500 THEN '$100-$500'
        ELSE 'Over $500'
    END AS PriceRange,
    COUNT(*) AS Count
FROM SampleProducts
GROUP BY 
    CASE 
        WHEN Price < 50 THEN 'Under $50'
        WHEN Price < 100 THEN '$50-$100'
        WHEN Price < 500 THEN '$100-$500'
        ELSE 'Over $500'
    END
ORDER BY PriceRange;

-- Check for data quality issues
SELECT 'Data Quality Check' AS Category, Issue, COUNT(*) AS Count
FROM (
    SELECT 'Customers with NULL email' AS Issue
    FROM SampleCustomers WHERE Email IS NULL
    UNION ALL
    SELECT 'Customers with NULL phone'
    FROM SampleCustomers WHERE Phone IS NULL
    UNION ALL
    SELECT 'Products with zero price'
    FROM SampleProducts WHERE Price = 0
    UNION ALL
    SELECT 'Inactive products'
    FROM SampleProducts WHERE IsActive = 0
) AS Issues
GROUP BY Issue;

-- =====================================================
-- ROLLBACK EXAMPLES (WHAT IF YOU MADE A MISTAKE?)
-- =====================================================

-- Example 36: How to recover from update mistakes

-- Scenario: You accidentally updated too many records
-- Create a backup first (should have done this before updating!)
SELECT CustomerID, FirstName, LastName, Email, CustomerType, DateJoined
INTO CustomerBackup
FROM SampleCustomers;

-- Perform a risky update (simulating a mistake)
UPDATE SampleCustomers 
SET CustomerType = 'MISTAKE'
WHERE CustomerID > 0;  -- This updates ALL customers!

-- Oh no! We updated too many records
-- Restore from backup
UPDATE c
SET CustomerType = b.CustomerType
FROM SampleCustomers c
JOIN CustomerBackup b ON c.CustomerID = b.CustomerID;

-- Verify restoration
SELECT CustomerType, COUNT(*) AS Count
FROM SampleCustomers
GROUP BY CustomerType;

-- Clean up backup table
DROP TABLE CustomerBackup;

-- =====================================================
-- CLEANUP AUDIT TABLE
-- =====================================================

-- Clean up our audit table
DROP TABLE CustomerAudit;

-- =====================================================
-- KEY LEARNING POINTS SUMMARY
-- =====================================================

/*
Key UPDATE Concepts Demonstrated:

1. Basic UPDATE syntax with single and multiple columns
2. Critical importance of WHERE clauses
3. Testing with SELECT before UPDATE
4. Different WHERE condition types (AND, OR, LIKE, IN, ranges)
5. Calculated updates with math and functions
6. Conditional updates with CASE statements
7. Subquery updates and correlated subqueries
8. JOIN-based updates for complex scenarios
9. NULL value handling and replacement
10. Transaction usage for safety
11. Error handling with TRY-CATCH
12. Performance optimization techniques
13. Batch processing for large updates
14. Data validation and cleansing
15. Audit trail implementation
16. Advanced patterns with OUTPUT clause
17. Recovery and rollback strategies

Critical Safety Practices:
- Always backup before major updates
- Test WHERE clauses with SELECT first
- Use transactions for complex updates
- Validate results before committing
- Handle errors gracefully
- Consider performance impact
- Implement audit trails for important changes

Performance Tips:
- Use indexed columns in WHERE clauses
- Process large updates in batches
- Avoid functions on columns in WHERE clauses
- Use appropriate isolation levels
- Monitor lock duration and blocking
*/

PRINT 'UPDATE examples completed successfully!';
PRINT 'Key reminder: ALWAYS test your WHERE clause with SELECT first!';
PRINT 'Next: Study 03_Delete_Examples.sql';