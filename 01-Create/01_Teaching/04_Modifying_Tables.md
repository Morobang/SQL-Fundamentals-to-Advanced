# 🔧 Modifying Tables

Learn how to change table structures after creation - add columns, modify data types, and remove columns safely.

---

## 🎯 What You'll Learn
- How to add new columns to existing tables
- How to modify column data types and sizes
- How to remove columns safely
- How to rename columns and tables
- Best practices for table modifications

---

## 🧠 Why Modify Tables?

In real-world development, you often need to change table structures:
- **Add new features** → Add new columns
- **Fix sizing issues** → Make columns bigger/smaller
- **Remove unused data** → Drop unnecessary columns
- **Improve naming** → Rename columns for clarity

### ⚠️ **Important**: Always backup your data before major modifications!

---

## ➕ Adding Columns

### Basic Syntax
```sql
ALTER TABLE TableName
ADD ColumnName DataType;
```

### Single Column Example
```sql
-- Add phone number to existing Employees table
ALTER TABLE Employees
ADD PhoneNumber VARCHAR(15);
```

### Multiple Columns at Once
```sql
-- Add several columns together
ALTER TABLE Employees
ADD Department VARCHAR(50),
    ManagerID INT,
    StartDate DATE;
```

### Adding Columns with Default Values
```sql
-- Add column with default value for existing rows
ALTER TABLE Products
ADD IsActive BIT DEFAULT 1;  -- All existing products become active

ALTER TABLE Customers
ADD CreatedDate DATETIME DEFAULT GETDATE();  -- Current timestamp
```

---

## 🔄 Modifying Existing Columns

### Change Data Type
```sql
-- Make email field larger
ALTER TABLE Customers
ALTER COLUMN Email VARCHAR(255);

-- Change salary precision
ALTER TABLE Employees
ALTER COLUMN Salary DECIMAL(12,2);
```

### Change Column Size
```sql
-- Increase name field size
ALTER TABLE Employees
ALTER COLUMN FirstName VARCHAR(100);

-- Change from variable to fixed length
ALTER TABLE Countries
ALTER COLUMN CountryCode CHAR(3);
```

### 💡 **Note**: You can usually make columns bigger, but making them smaller might lose data!

---

## 🏷️ Renaming Columns

### SQL Server Method
```sql
-- Rename a column
EXEC sp_rename 'TableName.OldColumnName', 'NewColumnName', 'COLUMN';

-- Example
EXEC sp_rename 'Employees.PhoneNumber', 'Phone', 'COLUMN';
```

### MySQL Method
```sql
-- MySQL uses different syntax
ALTER TABLE Employees
CHANGE PhoneNumber Phone VARCHAR(15);
```

### PostgreSQL Method
```sql
-- PostgreSQL method
ALTER TABLE Employees
RENAME COLUMN PhoneNumber TO Phone;
```

---

## 🗑️ Removing Columns

### Drop Single Column
```sql
-- Remove a column completely
ALTER TABLE Employees
DROP COLUMN MiddleName;
```

### Drop Multiple Columns
```sql
-- Remove several columns at once
ALTER TABLE Products
DROP COLUMN OldPrice,
DROP COLUMN DeprecatedField;
```

### Safe Column Removal
```sql
-- Check if column exists before dropping (SQL Server)
IF COL_LENGTH('Employees', 'TempColumn') IS NOT NULL
    ALTER TABLE Employees DROP COLUMN TempColumn;
```

---

## 🏷️ Renaming Tables

### SQL Server
```sql
-- Rename entire table
EXEC sp_rename 'OldTableName', 'NewTableName';

-- Example
EXEC sp_rename 'Employee', 'Employees';
```

### MySQL
```sql
-- MySQL table rename
ALTER TABLE OldTableName RENAME TO NewTableName;
```

### PostgreSQL
```sql
-- PostgreSQL table rename
ALTER TABLE OldTableName RENAME TO NewTableName;
```

---

## 🛡️ Safe Modification Practices

### 1. Always Check Current Structure First
```sql
-- See current table structure
SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'YourTableName'
ORDER BY ORDINAL_POSITION;
```

### 2. Test on Sample Data
```sql
-- Create a test table first
CREATE TABLE TestEmployees AS SELECT * FROM Employees WHERE 1=0;  -- Structure only
-- Or: SELECT TOP 0 * INTO TestEmployees FROM Employees;  -- SQL Server
```

### 3. Use Transactions for Safety
```sql
-- Start transaction
BEGIN TRANSACTION;

-- Make your changes
ALTER TABLE Employees ADD NewColumn VARCHAR(50);

-- Check if it worked correctly
SELECT * FROM Employees;

-- If good: COMMIT;
-- If problems: ROLLBACK;
```

---

## 📋 Real-World Modification Scenarios

### Scenario 1: E-commerce Site Expansion
```sql
-- Original Products table was too simple
-- Need to add more product details

ALTER TABLE Products
ADD Brand VARCHAR(100),
    Weight DECIMAL(8,2),
    Dimensions VARCHAR(50),
    Color VARCHAR(30),
    Material VARCHAR(100),
    WarrantyMonths INT;
```

### Scenario 2: User System Improvements
```sql
-- Upgrade user table for better functionality

-- Add security fields
ALTER TABLE Users
ADD PasswordHash VARCHAR(255),
    Salt VARCHAR(50),
    LastLoginDate DATETIME,
    FailedLoginAttempts INT DEFAULT 0;

-- Make email bigger for international addresses
ALTER TABLE Users
ALTER COLUMN Email VARCHAR(320);  -- New email standard
```

### Scenario 3: Fixing Design Mistakes
```sql
-- Original table had sizing issues

-- Fix name fields that were too small
ALTER TABLE Customers
ALTER COLUMN FirstName VARCHAR(100),
ALTER COLUMN LastName VARCHAR(100);

-- Remove column that's no longer needed
ALTER TABLE Orders
DROP COLUMN ObsoleteField;

-- Add missing audit fields
ALTER TABLE Orders
ADD CreatedDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME;
```

---

## ⚠️ Common Modification Pitfalls

### Pitfall 1: Making Columns Too Small
```sql
-- ❌ Dangerous - might truncate data
ALTER TABLE Customers
ALTER COLUMN FirstName VARCHAR(10);  -- Some names are longer!

-- ✅ Check data first
SELECT MAX(LEN(FirstName)) FROM Customers;  -- See longest name
-- Then resize appropriately
```

### Pitfall 2: Dropping Columns with Data
```sql
-- ❌ Data loss risk
ALTER TABLE Products DROP COLUMN Price;  -- All price data lost!

-- ✅ Back up important data first
SELECT ProductID, Price INTO PriceBackup FROM Products;
-- Then drop if really needed
```

### Pitfall 3: Not Considering Dependencies
```sql
-- ❌ Might break existing queries/applications
ALTER TABLE Employees DROP COLUMN Department;

-- ✅ Check what might use this column first
-- Look for views, stored procedures, application code
```

---

## 🧪 Hands-On Practice

### Practice Exercise: Improve a Simple Table
```sql
-- Start with basic table
CREATE TABLE BasicCustomers (
    ID INT,
    Name VARCHAR(20),    -- Too small!
    Contact VARCHAR(50)  -- Vague column name
);

-- Improve it step by step:
-- 1. Make name field bigger
ALTER TABLE BasicCustomers
ALTER COLUMN Name VARCHAR(100);

-- 2. Add separate name fields
ALTER TABLE BasicCustomers
ADD FirstName VARCHAR(50),
    LastName VARCHAR(50);

-- 3. Rename contact to be more specific
EXEC sp_rename 'BasicCustomers.Contact', 'Email', 'COLUMN';

-- 4. Add phone number
ALTER TABLE BasicCustomers
ADD Phone VARCHAR(15);

-- 5. Add audit fields
ALTER TABLE BasicCustomers
ADD CreatedDate DATETIME DEFAULT GETDATE(),
    IsActive BIT DEFAULT 1;
```

---

## 🚀 Try It Yourself

**Practice with the code examples in:** `02_Code/04_Modify_Tables.sql`

This file contains:
- Step-by-step table modification examples
- Safe modification techniques
- Real-world scenarios
- Error handling and rollback examples
- Best practices in action

---

## ✅ Knowledge Check

After practicing, you should be able to:
- [ ] Add new columns to existing tables
- [ ] Modify column data types and sizes safely
- [ ] Remove columns without breaking the database
- [ ] Rename columns and tables
- [ ] Use transactions for safe modifications
- [ ] Check table structure before and after changes

---

## 🔗 What's Next?

Now that you can create and modify tables, you're ready to:
**Module 02: Insert, Update and Delete Data** - Learn how to work with the actual data in your tables

---

*Part of Module 01: Create Database and Tables*