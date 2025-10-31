# 02_Update_Operations.md - Mastering Data Modification

## 🎯 Learning Objectives

After completing this lesson, you will be able to:
- Write UPDATE statements to modify existing records
- Use WHERE clauses to target specific records for updates
- Update multiple columns and records simultaneously
- Perform conditional updates based on existing data
- Update data using joins with other tables
- Apply best practices for safe and efficient data modification

## 📖 What is UPDATE?

The UPDATE statement is used to modify existing records in a table. Unlike INSERT which adds new data, UPDATE changes data that's already there. Think of it as editing existing entries in a spreadsheet - you're changing the values in existing rows and columns.

## ⚠️ CRITICAL SAFETY WARNING

**ALWAYS use a WHERE clause with UPDATE statements!** Without a WHERE clause, UPDATE will modify ALL records in the table, which is rarely what you want and can be catastrophic.

```sql
-- DANGEROUS: Updates ALL records
UPDATE Customers SET FirstName = 'John';

-- SAFE: Updates only specific records
UPDATE Customers SET FirstName = 'John' WHERE CustomerID = 1;
```

## 🔧 Basic UPDATE Syntax

### Single Column Update
```sql
UPDATE table_name
SET column_name = new_value
WHERE condition;
```

### Multiple Column Update
```sql
UPDATE table_name
SET column1 = new_value1,
    column2 = new_value2,
    column3 = new_value3
WHERE condition;
```

**Key Components:**
- `UPDATE`: SQL keyword indicating we want to modify data
- `table_name`: The target table containing records to modify
- `SET`: Keyword indicating the column assignments follow
- `column_name = new_value`: The column and its new value
- `WHERE condition`: Specifies which records to update (CRUCIAL!)

## 📝 Real-World Examples

### Example 1: Updating Customer Information
```sql
-- Update a customer's email address
UPDATE Customers 
SET Email = 'newemail@example.com'
WHERE CustomerID = 123;

-- Update multiple customer fields
UPDATE Customers 
SET FirstName = 'Jonathan',
    LastName = 'Smith-Johnson',
    Phone = '555-987-6543',
    LastModified = GETDATE()
WHERE CustomerID = 123;
```

### Example 2: Product Price Updates
```sql
-- Single product price update
UPDATE Products 
SET Price = 899.99
WHERE ProductID = 1001;

-- Bulk price increase for a category
UPDATE Products 
SET Price = Price * 1.1  -- 10% increase
WHERE CategoryID = 5;
```

### Example 3: Order Status Management
```sql
-- Update order status
UPDATE Orders 
SET OrderStatus = 'Shipped',
    ShippedDate = GETDATE(),
    TrackingNumber = 'TRK123456789'
WHERE OrderID = 5001;
```

## 🎭 Advanced UPDATE Techniques

### Conditional Updates with CASE
```sql
-- Apply different discounts based on order amount
UPDATE Orders 
SET Discount = CASE 
    WHEN TotalAmount >= 1000 THEN 0.15  -- 15% discount
    WHEN TotalAmount >= 500 THEN 0.10   -- 10% discount
    WHEN TotalAmount >= 100 THEN 0.05   -- 5% discount
    ELSE 0.00                           -- No discount
END
WHERE OrderStatus = 'Pending';
```

### Updates with Calculations
```sql
-- Update inventory after sales
UPDATE Products 
SET InStock = InStock - 5,
    LastSold = GETDATE()
WHERE ProductID = 2001;

-- Calculate and store total order amounts
UPDATE Orders 
SET TotalAmount = (
    SELECT SUM(Quantity * UnitPrice) 
    FROM OrderDetails 
    WHERE OrderDetails.OrderID = Orders.OrderID
)
WHERE TotalAmount IS NULL;
```

### NULL Handling in Updates
```sql
-- Replace NULL values with defaults
UPDATE Customers 
SET Phone = 'No phone provided'
WHERE Phone IS NULL;

-- Set values to NULL when needed
UPDATE Employees 
SET EndDate = NULL,
    IsActive = 1
WHERE EmployeeID = 1001 AND EndDate IS NOT NULL;
```

## 🔗 UPDATE with JOINs

### Simple JOIN Update
```sql
-- Update customer information from another table
UPDATE Customers 
SET City = ut.City,
    State = ut.State
FROM Customers c
JOIN UserTemp ut ON c.CustomerID = ut.CustomerID
WHERE ut.IsVerified = 1;
```

### Complex JOIN with Multiple Tables
```sql
-- Update product ratings based on reviews
UPDATE Products 
SET AverageRating = r.AvgRating,
    ReviewCount = r.ReviewCount
FROM Products p
JOIN (
    SELECT ProductID, 
           AVG(CAST(Rating AS FLOAT)) AS AvgRating,
           COUNT(*) AS ReviewCount
    FROM Reviews 
    WHERE IsApproved = 1
    GROUP BY ProductID
) r ON p.ProductID = r.ProductID;
```

## 🎯 WHERE Clause Mastery

### Single Condition
```sql
UPDATE Users SET LastLogin = GETDATE() WHERE UserID = 123;
```

### Multiple Conditions (AND)
```sql
UPDATE Products 
SET IsDiscontinued = 1
WHERE InStock = 0 AND LastOrdered < '2023-01-01';
```

### Multiple Conditions (OR)
```sql
UPDATE Customers 
SET CustomerType = 'VIP'
WHERE TotalSpent > 10000 OR OrderCount > 50;
```

### Range Conditions
```sql
-- Update prices for products in a price range
UPDATE Products 
SET Price = Price * 0.9  -- 10% discount
WHERE Price BETWEEN 50.00 AND 200.00;

-- Update old records
UPDATE Orders 
SET IsArchived = 1
WHERE OrderDate < '2022-01-01';
```

### Pattern Matching
```sql
-- Update customers with specific email domains
UPDATE Customers 
SET CustomerType = 'Corporate'
WHERE Email LIKE '%@company.com';

-- Update products with specific naming patterns
UPDATE Products 
SET Category = 'Electronics'
WHERE ProductName LIKE '%laptop%' OR ProductName LIKE '%computer%';
```

### Subquery Conditions
```sql
-- Update customers who have made recent orders
UPDATE Customers 
SET LastOrderDate = GETDATE()
WHERE CustomerID IN (
    SELECT DISTINCT CustomerID 
    FROM Orders 
    WHERE OrderDate >= '2024-01-01'
);
```

## 🔄 Transaction Management for Updates

### Simple Transaction
```sql
BEGIN TRANSACTION;

UPDATE Accounts 
SET Balance = Balance - 100 
WHERE AccountID = 1001;

UPDATE Accounts 
SET Balance = Balance + 100 
WHERE AccountID = 1002;

-- Check if both updates succeeded
IF @@ROWCOUNT = 1
    COMMIT TRANSACTION;
ELSE
    ROLLBACK TRANSACTION;
```

### Complex Transaction with Error Handling
```sql
BEGIN TRY
    BEGIN TRANSACTION;
    
    -- Update inventory
    UPDATE Products 
    SET InStock = InStock - 5 
    WHERE ProductID = 123;
    
    -- Create order record
    INSERT INTO Orders (CustomerID, ProductID, Quantity, OrderDate)
    VALUES (456, 123, 5, GETDATE());
    
    -- If we get here, both operations succeeded
    COMMIT TRANSACTION;
    PRINT 'Order processed successfully';
    
END TRY
BEGIN CATCH
    -- Something went wrong, undo everything
    ROLLBACK TRANSACTION;
    PRINT 'Error processing order: ' + ERROR_MESSAGE();
END CATCH
```

## ⚡ Performance Optimization

### Index-Friendly Updates
```sql
-- GOOD: Uses indexed column in WHERE clause
UPDATE Customers 
SET LastContactDate = GETDATE()
WHERE CustomerID = 123;  -- Assuming CustomerID is indexed

-- AVOID: Updates without using indexes
UPDATE Customers 
SET LastContactDate = GETDATE()
WHERE UPPER(FirstName) = 'JOHN';  -- Function on column prevents index use
```

### Batch Updates for Large Data Sets
```sql
-- Update in batches to avoid long-running transactions
DECLARE @BatchSize INT = 1000;
DECLARE @RowsAffected INT = @BatchSize;

WHILE @RowsAffected = @BatchSize
BEGIN
    UPDATE TOP (@BatchSize) Products 
    SET IsActive = 0
    WHERE LastOrdered < '2022-01-01' AND IsActive = 1;
    
    SET @RowsAffected = @@ROWCOUNT;
    
    -- Optional: Add a small delay to reduce system impact
    WAITFOR DELAY '00:00:01';  -- 1 second delay
END
```

## 🛡️ Best Practices for UPDATE Operations

### 1. Always Test with SELECT First
```sql
-- FIRST: Test your WHERE clause with SELECT
SELECT * FROM Customers WHERE CustomerID = 123;

-- THEN: Apply the same WHERE clause to UPDATE
UPDATE Customers 
SET Email = 'newemail@example.com'
WHERE CustomerID = 123;
```

### 2. Use ROW_COUNT to Verify Updates
```sql
UPDATE Products 
SET Price = 99.99 
WHERE ProductID = 1001;

-- Check how many rows were affected
SELECT @@ROWCOUNT AS RowsUpdated;

-- Should return 1 for single record update
-- 0 means no records matched your WHERE clause
-- >1 might indicate a problem with your WHERE clause
```

### 3. Backup Critical Data Before Major Updates
```sql
-- Create backup before major update
SELECT * INTO CustomersBackup_20241019 
FROM Customers 
WHERE LastOrderDate < '2022-01-01';

-- Then perform the update
UPDATE Customers 
SET IsActive = 0 
WHERE LastOrderDate < '2022-01-01';
```

### 4. Use Explicit Transactions for Related Updates
```sql
-- Always wrap related updates in transactions
BEGIN TRANSACTION;

UPDATE Orders SET OrderStatus = 'Cancelled' WHERE OrderID = 1001;
UPDATE Inventory SET Reserved = Reserved - 5 WHERE ProductID = 123;
UPDATE Customers SET LastCancellation = GETDATE() WHERE CustomerID = 456;

COMMIT TRANSACTION;
```

### 5. Validate Data Types and Constraints
```sql
-- WRONG: Trying to put text in numeric column
UPDATE Products SET Price = 'expensive' WHERE ProductID = 1;

-- CORRECT: Use appropriate data types
UPDATE Products SET Price = 999.99 WHERE ProductID = 1;
```

## ⚠️ Common Mistakes and How to Avoid Them

### Mistake 1: Forgetting WHERE Clause
```sql
-- DISASTER: Updates ALL customers
UPDATE Customers SET FirstName = 'John';

-- CORRECT: Updates specific customer
UPDATE Customers SET FirstName = 'John' WHERE CustomerID = 1;
```

### Mistake 2: Wrong WHERE Condition
```sql
-- WRONG: Updates multiple records when expecting one
UPDATE Users SET Email = 'new@email.com' WHERE FirstName = 'John';

-- CORRECT: Use unique identifier
UPDATE Users SET Email = 'new@email.com' WHERE UserID = 123;
```

### Mistake 3: Not Handling Concurrent Updates
```sql
-- PROBLEM: Another user might change data between your read and update
-- Solution: Use optimistic locking with version numbers or timestamps

UPDATE Products 
SET Price = 99.99,
    Version = Version + 1
WHERE ProductID = 1001 AND Version = @OriginalVersion;

IF @@ROWCOUNT = 0
    PRINT 'Record was modified by another user';
```

## 🔍 Verification and Testing

### Verify Your Updates
```sql
-- Before update: Check current values
SELECT CustomerID, FirstName, LastName, Email 
FROM Customers 
WHERE CustomerID = 123;

-- Perform update
UPDATE Customers 
SET Email = 'newemail@example.com'
WHERE CustomerID = 123;

-- After update: Verify changes
SELECT CustomerID, FirstName, LastName, Email 
FROM Customers 
WHERE CustomerID = 123;
```

### Test Edge Cases
```sql
-- Test updating records that don't exist
UPDATE Customers SET Email = 'test@email.com' WHERE CustomerID = 99999;
SELECT @@ROWCOUNT; -- Should return 0

-- Test updating with NULL values
UPDATE Customers SET MiddleName = NULL WHERE CustomerID = 123;

-- Test updating with special characters
UPDATE Products SET Description = 'Product with "quotes" & special chars' 
WHERE ProductID = 1;
```

## 🎯 Real-World Scenarios

### E-commerce Inventory Management
```sql
-- Process product returns
UPDATE Products 
SET InStock = InStock + @ReturnedQuantity,
    LastRestocked = GETDATE()
WHERE ProductID = @ProductID;

-- Apply seasonal discounts
UPDATE Products 
SET SalePrice = Price * 0.8,  -- 20% off
    OnSale = 1,
    SaleStartDate = GETDATE(),
    SaleEndDate = DATEADD(DAY, 30, GETDATE())
WHERE CategoryID IN (1, 3, 5);  -- Specific categories
```

### User Account Management
```sql
-- Activate newly verified accounts
UPDATE Users 
SET IsActive = 1,
    EmailVerified = 1,
    ActivatedDate = GETDATE()
WHERE VerificationToken = @VerificationToken;

-- Suspend inactive accounts
UPDATE Users 
SET IsActive = 0,
    SuspensionReason = 'Inactivity',
    SuspendedDate = GETDATE()
WHERE LastLoginDate < DATEADD(MONTH, -6, GETDATE())
  AND IsActive = 1;
```

### Financial Transactions
```sql
-- Process payment
BEGIN TRANSACTION;

UPDATE Orders 
SET PaymentStatus = 'Paid',
    PaidDate = GETDATE(),
    PaymentMethod = @PaymentMethod
WHERE OrderID = @OrderID;

UPDATE CustomerAccounts 
SET Balance = Balance - @PaymentAmount,
    LastTransactionDate = GETDATE()
WHERE CustomerID = @CustomerID;

COMMIT TRANSACTION;
```

## 🔗 Integration with Other Operations

UPDATE operations often work together with:
- **SELECT**: To identify records that need updating
- **INSERT**: To add audit trails of changes
- **DELETE**: To remove outdated records after updates
- **MERGE**: To combine insert/update operations

## 📚 What's Next?

Now that you understand how to modify existing data, you're ready to learn about safely removing data with DELETE operations. The WHERE clause skills you've mastered here are crucial for safe deletion practices.

## 💡 Key Takeaways

1. **Always use WHERE clauses** to avoid updating all records
2. **Test with SELECT first** to verify your WHERE conditions
3. **Use transactions** for related updates
4. **Check @@ROWCOUNT** to verify the expected number of rows were affected
5. **Backup critical data** before major updates
6. **Handle NULL values** explicitly
7. **Consider performance** for large batch updates
8. **Use proper data types** and respect constraints

Ready to practice? Head over to `02_Code/02_Update_Examples.sql` to see these concepts in action, then challenge yourself with `03_Practice/02_Update_Practice.sql`!

---

*Next: [03_Delete_Operations.md](03_Delete_Operations.md) - Learn to remove data safely and efficiently.*