-- Module 01: Create Database and Tables
-- 04_Modify_Tables.sql - Table Modification Examples

-- Purpose: Learn to safely modify table structures after creation
-- Teaching Reference: See 01_Teaching/04_Modifying_Tables.md

-- Make sure you're in a database
USE LearningSQL;

-- =====================================================
-- SETUP: Create Tables for Modification Practice
-- =====================================================

-- Create a basic employee table to practice modifications
CREATE TABLE EmployeesPractice (
    EmployeeID INT,
    FirstName VARCHAR(30),       -- We'll make this bigger later
    LastName VARCHAR(30),
    HireDate DATE
);

-- Create a simple product table
CREATE TABLE ProductsPractice (
    ProductID INT,
    ProductName VARCHAR(50),     -- We'll expand this
    Price DECIMAL(6,2)          -- We'll change precision
);

-- Insert some test data
INSERT INTO EmployeesPractice VALUES 
(1, 'John', 'Smith', '2024-01-15'),
(2, 'Sarah', 'Johnson', '2024-02-01'),
(3, 'Michael', 'Brown', '2024-03-10');

INSERT INTO ProductsPractice VALUES 
(1, 'Laptop', 999.99),
(2, 'Mouse', 25.50),
(3, 'Keyboard', 75.00);


-- =====================================================
-- SECTION 1: ADDING COLUMNS
-- =====================================================

-- Example 1: Add Single Column
ALTER TABLE EmployeesPractice
ADD Email VARCHAR(100);

-- Check the change
SELECT * FROM EmployeesPractice;
-- Notice: New column exists but has NULL values

-- Example 2: Add Multiple Columns at Once
ALTER TABLE EmployeesPractice
ADD PhoneNumber VARCHAR(15),
    Department VARCHAR(50),
    Salary DECIMAL(10,2);

-- Example 3: Add Column with Default Value
ALTER TABLE ProductsPractice
ADD IsActive BIT DEFAULT 1;  -- All existing products become active

-- Check the result
SELECT * FROM ProductsPractice;
-- Notice: New column has default value of 1 for existing rows

-- Example 4: Add Column with Default Date
ALTER TABLE EmployeesPractice
ADD CreatedDate DATETIME DEFAULT GETDATE();

-- Example 5: Add Columns for Real Business Needs
ALTER TABLE ProductsPractice
ADD Brand VARCHAR(100),
    Category VARCHAR(50),
    Weight DECIMAL(8,2),
    InStock INT DEFAULT 0,
    ReorderLevel INT DEFAULT 10;


-- =====================================================
-- SECTION 2: MODIFYING EXISTING COLUMNS
-- =====================================================

-- Example 6: Make Text Columns Bigger
-- Check current size first
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'EmployeesPractice' 
  AND COLUMN_NAME IN ('FirstName', 'LastName');

-- Expand name fields from 30 to 50 characters
ALTER TABLE EmployeesPractice
ALTER COLUMN FirstName VARCHAR(50);

ALTER TABLE EmployeesPractice
ALTER COLUMN LastName VARCHAR(50);

-- Example 7: Change Numeric Precision
-- Check current precision
SELECT 
    COLUMN_NAME, 
    DATA_TYPE, 
    NUMERIC_PRECISION, 
    NUMERIC_SCALE
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'ProductsPractice' 
  AND COLUMN_NAME = 'Price';

-- Change price from DECIMAL(6,2) to DECIMAL(8,2) for higher prices
ALTER TABLE ProductsPractice
ALTER COLUMN Price DECIMAL(8,2);

-- Example 8: Change Text to Fixed Length
-- Create a test table for this example
CREATE TABLE CountriesPractice (
    CountryID INT,
    CountryName VARCHAR(100),
    CountryCode VARCHAR(3)      -- We'll change this to CHAR(3)
);

-- Change to fixed length (better for country codes)
ALTER TABLE CountriesPractice
ALTER COLUMN CountryCode CHAR(3);


-- =====================================================
-- SECTION 3: SAFE MODIFICATION PRACTICES
-- =====================================================

-- Example 9: Check Data Before Modifying
-- Before making a column smaller, check if data will fit

-- See the longest names in our table
SELECT 
    MAX(LEN(FirstName)) AS LongestFirstName,
    MAX(LEN(LastName)) AS LongestLastName
FROM EmployeesPractice;

-- If result is less than new size, it's safe to shrink

-- Example 10: Use Transactions for Safety
BEGIN TRANSACTION;

-- Make a potentially risky change
ALTER TABLE EmployeesPractice
ADD TempColumn VARCHAR(20);

-- Check if it worked as expected
SELECT COLUMN_NAME 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'EmployeesPractice' 
  AND COLUMN_NAME = 'TempColumn';

-- If good: COMMIT;
-- If problems: ROLLBACK;
COMMIT;  -- Proceed since this is just a demo

-- Example 11: Create Backup Before Major Changes
-- Create backup of original structure and data
SELECT * INTO EmployeesBackup FROM EmployeesPractice;

-- Now safe to make major modifications
ALTER TABLE EmployeesPractice
ADD ManagerID INT,
    EmergencyContact VARCHAR(200);


-- =====================================================
-- SECTION 4: RENAMING COLUMNS
-- =====================================================

-- Example 12: Rename Columns (SQL Server method)
-- Rename TempColumn to something more meaningful
EXEC sp_rename 'EmployeesPractice.TempColumn', 'EmployeeCode', 'COLUMN';

-- Example 13: Rename Multiple Columns
EXEC sp_rename 'ProductsPractice.ProductName', 'Name', 'COLUMN';
EXEC sp_rename 'ProductsPractice.IsActive', 'Active', 'COLUMN';

-- Verify the renames
SELECT COLUMN_NAME 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'ProductsPractice'
ORDER BY ORDINAL_POSITION;


-- =====================================================
-- SECTION 5: REMOVING COLUMNS
-- =====================================================

-- Example 14: Drop Single Column
ALTER TABLE EmployeesPractice
DROP COLUMN EmployeeCode;

-- Example 15: Drop Multiple Columns
ALTER TABLE ProductsPractice
DROP COLUMN Weight,
DROP COLUMN ReorderLevel;

-- Example 16: Safe Column Removal
-- Check if column exists before dropping
IF COL_LENGTH('EmployeesPractice', 'TempColumn') IS NOT NULL
    ALTER TABLE EmployeesPractice DROP COLUMN TempColumn;


-- =====================================================
-- SECTION 6: RENAMING TABLES
-- =====================================================

-- Example 17: Rename Table (SQL Server method)
EXEC sp_rename 'EmployeesPractice', 'Employees_Modified';

-- Verify the rename
SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_TYPE = 'BASE TABLE'
  AND TABLE_NAME LIKE '%Employee%';

-- Rename it back for consistency
EXEC sp_rename 'Employees_Modified', 'EmployeesPractice';


-- =====================================================
-- SECTION 7: REAL-WORLD MODIFICATION SCENARIOS
-- =====================================================

-- Scenario 1: E-commerce Site Expansion
-- Original table was too simple, need to add features

CREATE TABLE SimpleProducts (
    ProductID INT,
    Name VARCHAR(50),
    Price DECIMAL(6,2)
);

-- Expand for full e-commerce functionality
ALTER TABLE SimpleProducts
ADD SKU VARCHAR(50),
    Description TEXT,
    Brand VARCHAR(100),
    Category VARCHAR(50),
    Weight DECIMAL(8,2),
    Dimensions VARCHAR(50),
    InStock INT,
    IsActive BIT DEFAULT 1,
    IsFeatured BIT DEFAULT 0,
    CreatedDate DATETIME DEFAULT GETDATE(),
    ModifiedDate DATETIME;

-- Make price field handle larger amounts
ALTER TABLE SimpleProducts
ALTER COLUMN Price DECIMAL(10,2);

-- Make name field longer for detailed product names
ALTER TABLE SimpleProducts
ALTER COLUMN Name VARCHAR(200);

-- Scenario 2: User System Security Upgrade
CREATE TABLE BasicUsers (
    UserID INT,
    Username VARCHAR(30),
    Password VARCHAR(50),      -- Original: plain text (bad!)
    Email VARCHAR(100)
);

-- Security improvements
ALTER TABLE BasicUsers
DROP COLUMN Password;        -- Remove insecure password storage

-- Add secure password fields
ALTER TABLE BasicUsers
ADD PasswordHash VARCHAR(255),      -- Hashed password
    Salt VARCHAR(50),               -- Password salt
    LastLoginDate DATETIME,
    FailedLoginAttempts INT DEFAULT 0,
    IsLocked BIT DEFAULT 0,
    AccountCreatedDate DATETIME DEFAULT GETDATE();

-- Make username and email bigger
ALTER TABLE BasicUsers
ALTER COLUMN Username VARCHAR(50);

ALTER TABLE BasicUsers
ALTER COLUMN Email VARCHAR(255);


-- =====================================================
-- SECTION 8: ADVANCED MODIFICATION TECHNIQUES
-- =====================================================

-- Example 18: Adding Computed Columns
ALTER TABLE ProductsPractice
ADD TotalValue AS (Price * InStock);  -- Automatically calculated

-- Example 19: Adding Columns with Check Constraints
ALTER TABLE EmployeesPractice
ADD Age INT;

-- Add constraint to ensure reasonable age values
ALTER TABLE EmployeesPractice
ADD CONSTRAINT CK_Employee_Age CHECK (Age >= 16 AND Age <= 100);

-- Example 20: Modifying Multiple Tables for Consistency
-- Make sure all our practice tables have audit fields

-- Add to EmployeesPractice if not exists
IF COL_LENGTH('EmployeesPractice', 'ModifiedDate') IS NULL
    ALTER TABLE EmployeesPractice ADD ModifiedDate DATETIME;

-- Add to ProductsPractice if not exists  
IF COL_LENGTH('ProductsPractice', 'ModifiedDate') IS NULL
    ALTER TABLE ProductsPractice ADD ModifiedDate DATETIME;


-- =====================================================
-- SECTION 9: TROUBLESHOOTING MODIFICATIONS
-- =====================================================

-- Example 21: Handle Modification Errors Gracefully
BEGIN TRY
    -- Try to make a column smaller (might fail if data doesn't fit)
    ALTER TABLE EmployeesPractice
    ALTER COLUMN Department VARCHAR(10);  -- Very small!
    
    PRINT 'Column modification successful';
END TRY
BEGIN CATCH
    PRINT 'Error modifying column: ' + ERROR_MESSAGE();
    -- Handle the error - maybe make it bigger instead
    ALTER TABLE EmployeesPractice
    ALTER COLUMN Department VARCHAR(100);
END CATCH;

-- Example 22: Check Dependencies Before Dropping Columns
-- This would be more complex in a real database with foreign keys, indexes, etc.
-- For now, just demonstrate the concept:

SELECT 
    OBJECT_NAME(object_id) AS TableName,
    name AS ColumnName,
    is_nullable,
    is_identity
FROM sys.columns 
WHERE OBJECT_NAME(object_id) = 'EmployeesPractice'
ORDER BY column_id;


-- =====================================================
-- VERIFICATION AND CLEANUP SECTION
-- =====================================================

-- Check final structure of modified tables
SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    NUMERIC_PRECISION,
    NUMERIC_SCALE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME IN ('EmployeesPractice', 'ProductsPractice')
ORDER BY TABLE_NAME, ORDINAL_POSITION;

-- Show sample data to verify modifications didn't break anything
SELECT TOP 2 * FROM EmployeesPractice;
SELECT TOP 2 * FROM ProductsPractice;

-- Count modifications we made
SELECT 
    TABLE_NAME,
    COUNT(*) AS TotalColumns
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME LIKE '%Practice'
GROUP BY TABLE_NAME;

-- Clean up practice tables (optional)
-- DROP TABLE EmployeesPractice;
-- DROP TABLE ProductsPractice;
-- DROP TABLE SimpleProducts;
-- DROP TABLE BasicUsers;
-- DROP TABLE CountriesPractice;
-- DROP TABLE EmployeesBackup;

-- Related files:
-- Teaching: 01_Teaching/04_Modifying_Tables.md
-- Previous: 03_Data_Types_Examples.sql
-- Next: Module 02 - Insert, Update and Delete Data