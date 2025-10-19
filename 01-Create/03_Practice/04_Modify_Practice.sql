-- Module 01: Create Database and Tables
-- 04_Modify_Practice.sql - Table Modification Practice

-- Instructions: Master table modifications through hands-on practice
-- Difficulty: 🟢 Beginner to 🔴 Advanced
-- Prerequisites: Read 01_Teaching/04_Modifying_Tables.md

-- Make sure you're in a practice database first
USE TshigidimasaDB;  -- Change to your personal database name

-- =====================================================
-- SETUP: CREATE INITIAL TABLES FOR MODIFICATION
-- =====================================================

-- We'll create some tables to practice modifications on
CREATE TABLE PracticeCustomers (
    CustomerID INT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100)
);

CREATE TABLE PracticeProducts (
    ProductID INT,
    ProductName VARCHAR(100),
    Price DECIMAL(10,2)
);

CREATE TABLE PracticeEmployees (
    EmployeeID INT,
    Name VARCHAR(100),
    Department VARCHAR(50)
);

-- =====================================================
-- SECTION 1: ADDING COLUMNS 🟢
-- =====================================================

-- Exercise 1.1: Add Single Columns
-- TODO: Add these columns to PracticeCustomers table:
-- - Phone VARCHAR(20)
-- - DateJoined DATE
-- - IsActive BIT


-- Exercise 1.2: Add Multiple Columns at Once
-- TODO: Add these columns to PracticeProducts:
-- - Description TEXT
-- - InStock INT
-- - CreatedDate DATETIME


-- Exercise 1.3: Add Columns with Default Values
-- TODO: Add these columns to PracticeEmployees with defaults:
-- - Salary DECIMAL(10,2) with default 50000
-- - HireDate DATE with default current date
-- - IsFullTime BIT with default 1 (true)


-- Exercise 1.4: Strategic Column Addition
-- TODO: You're building an e-commerce site and need to track more customer info.
-- Add columns for:
-- - CustomerType (Premium, Standard, Basic) - with default 'Standard'
-- - TotalSpent (running total of purchases) - with default 0
-- - LastLoginDate (when they last visited) - nullable
-- - PreferredLanguage (EN, ES, FR, etc.) - with default 'EN'
-- - MarketingOptIn (email marketing permission) - with default 0


-- =====================================================
-- SECTION 2: MODIFYING EXISTING COLUMNS 🟡
-- =====================================================

-- Exercise 2.1: Change Data Types
-- TODO: The Email column in PracticeCustomers is too small for some emails.
-- Change it from VARCHAR(100) to VARCHAR(200)


-- Exercise 2.2: Change Column Sizes
-- TODO: The ProductName in PracticeProducts needs to be longer for international names.
-- Change it from VARCHAR(100) to VARCHAR(300)


-- Exercise 2.3: Add NOT NULL to Existing Column
-- TODO: FirstName and LastName should be required in PracticeCustomers.
-- Make them NOT NULL (you may need to handle existing NULL values first)


-- Exercise 2.4: Change Numeric Precision
-- TODO: The Price in PracticeProducts needs more precision for international currencies.
-- Change from DECIMAL(10,2) to DECIMAL(12,4)


-- Exercise 2.5: Complex Column Modifications
-- TODO: Create a new test table for complex modifications:

CREATE TABLE ComplexModifyTest (
    ID INT,
    OldNumber SMALLINT,
    OldText VARCHAR(20),
    OldDate VARCHAR(10),  -- Stored as text, should be DATE
    OldMoney FLOAT        -- Stored as float, should be DECIMAL
);

-- Insert some test data
INSERT INTO ComplexModifyTest VALUES 
(1, 100, 'Short text', '2024-01-15', 99.99),
(2, 200, 'Another text', '2024-02-20', 149.95);

-- TODO: Modify these columns to better data types:
-- OldNumber: SMALLINT to INT
-- OldText: VARCHAR(20) to VARCHAR(100)  
-- OldDate: VARCHAR(10) to proper DATE
-- OldMoney: FLOAT to DECIMAL(10,2)


-- =====================================================
-- SECTION 3: DROPPING COLUMNS 🟢
-- =====================================================

-- Exercise 3.1: Simple Column Removal
-- TODO: Create a test table with extra columns, then remove them:

CREATE TABLE DropColumnTest (
    ID INT,
    KeepThis VARCHAR(50),
    TempColumn1 INT,      -- Remove this
    KeepThisToo DATE,
    TempColumn2 VARCHAR(100), -- Remove this
    AlsoKeep DECIMAL(10,2)
);

-- TODO: Drop TempColumn1 and TempColumn2


-- Exercise 3.2: Careful Column Removal
-- TODO: You've been asked to remove some columns from PracticeEmployees,
-- but first you need to check if they contain important data:

-- Add some temporary columns first
ALTER TABLE PracticeEmployees 
ADD TempData VARCHAR(100),
    OldField INT,
    UnusedColumn BIT;

-- TODO: Before dropping these columns:
-- 1. Check if they contain any non-NULL data
-- 2. Verify with business users that data can be lost
-- 3. Consider backing up the data first
-- 4. Then drop the columns


-- =====================================================
-- SECTION 4: RENAMING COLUMNS AND TABLES 🟡
-- =====================================================

-- Exercise 4.1: Rename Columns
-- TODO: The column names in our tables could be better.
-- Rename these columns in PracticeCustomers:
-- FirstName → GivenName
-- LastName → FamilyName

-- Note: The syntax varies by database system. In SQL Server:
-- EXEC sp_rename 'TableName.OldColumnName', 'NewColumnName', 'COLUMN';


-- Exercise 4.2: Rename Tables
-- TODO: Rename our practice tables to better names:
-- PracticeCustomers → CustomerProfiles
-- PracticeProducts → ProductCatalog  
-- PracticeEmployees → StaffMembers

-- Note: In SQL Server use sp_rename, in MySQL use RENAME TABLE


-- Exercise 4.3: Systematic Renaming Project
-- TODO: You inherited a database with terrible naming. Create and fix this table:

CREATE TABLE bad_naming_example (
    id INT,
    fn VARCHAR(50),    -- first name
    ln VARCHAR(50),    -- last name  
    em VARCHAR(100),   -- email
    ph VARCHAR(20),    -- phone
    addr TEXT,         -- address
    dob DATE,          -- date of birth
    sal DECIMAL(10,2), -- salary
    dept VARCHAR(50),  -- department
    mgr INT            -- manager ID
);

-- TODO: Rename all columns to descriptive names:
-- id → EmployeeID
-- fn → FirstName
-- etc.


-- =====================================================
-- SECTION 5: ADDING AND REMOVING CONSTRAINTS 🟡
-- =====================================================

-- Exercise 5.1: Add Primary Keys
-- TODO: Our practice tables don't have primary keys. Add them:
-- CustomerProfiles: CustomerID as primary key
-- ProductCatalog: ProductID as primary key
-- StaffMembers: EmployeeID as primary key


-- Exercise 5.2: Add Check Constraints
-- TODO: Add business rule constraints:

-- For CustomerProfiles:
-- - Email must contain '@' symbol
-- - CustomerType must be 'Premium', 'Standard', or 'Basic'

-- For ProductCatalog:
-- - Price must be greater than 0
-- - InStock must be >= 0

-- For StaffMembers:
-- - Salary must be > 0
-- - Department must be in approved list


-- Exercise 5.3: Add Unique Constraints
-- TODO: Ensure data uniqueness:
-- - Email in CustomerProfiles should be unique
-- - ProductName in ProductCatalog should be unique within the same category


-- Exercise 5.4: Add Default Constraints
-- TODO: Add helpful defaults:
-- - CreatedDate should default to current date/time
-- - IsActive should default to 1 (true)
-- - Status columns should have meaningful defaults


-- Exercise 5.5: Remove Constraints
-- TODO: Sometimes constraints need to be removed. Practice:
-- 1. Create a test table with various constraints
-- 2. List all constraints on the table
-- 3. Remove specific constraints
-- 4. Verify the constraint removal worked

CREATE TABLE ConstraintTest (
    ID INT PRIMARY KEY,
    Email VARCHAR(100) UNIQUE,
    Age INT CHECK (Age >= 0 AND Age <= 150),
    Status VARCHAR(20) DEFAULT 'Active'
);

-- TODO: Remove the age check constraint
-- TODO: Remove the unique constraint on email


-- =====================================================
-- SECTION 6: COLUMN ORDER AND POSITIONING 🟢
-- =====================================================

-- Exercise 6.1: Column Positioning (MySQL specific)
-- TODO: In MySQL, you can specify where to add new columns:

-- Add a new column after a specific column
-- ALTER TABLE TableName ADD COLUMN NewColumn DataType AFTER ExistingColumn;

-- Add a new column as the first column
-- ALTER TABLE TableName ADD COLUMN NewColumn DataType FIRST;

-- Note: This varies by database system


-- Exercise 6.2: Reorganizing Table Structure
-- TODO: Sometimes you need to reorganize columns for better logical grouping.
-- Create a table with poor column organization, then reorganize:

CREATE TABLE PoorlyOrganized (
    ID INT,
    LastModified DATETIME,
    FirstName VARCHAR(50),
    CreatedDate DATETIME,
    LastName VARCHAR(50),
    IsActive BIT,
    Email VARCHAR(100),
    Phone VARCHAR(20)
);

-- TODO: In systems that support it, reorganize to group related columns together


-- =====================================================
-- SECTION 7: ADVANCED MODIFICATION SCENARIOS 🔴
-- =====================================================

-- Exercise 7.1: Table Schema Evolution
-- TODO: Simulate a real application evolution:

-- Version 1: Simple user table
CREATE TABLE AppUsers_V1 (
    UserID INT PRIMARY KEY,
    Username VARCHAR(50),
    Email VARCHAR(100),
    CreatedDate DATE
);

-- TODO: Evolve to Version 2 by adding:
-- - Password hashing support
-- - User profile information
-- - Social media links
-- - Preferences and settings


-- TODO: Evolve to Version 3 by adding:
-- - Multi-factor authentication
-- - GDPR compliance fields
-- - Account status tracking
-- - Audit trail information


-- Exercise 7.2: Performance-Driven Modifications
-- TODO: Optimize table structure for performance:

-- Create a table that simulates performance issues
CREATE TABLE SlowTable (
    ID BIGINT,           -- Too big for small data set
    SearchText TEXT,     -- Should be indexed VARCHAR for searches
    FilterDate VARCHAR(20), -- String date is slow for filtering
    SortOrder FLOAT,     -- Float comparison is slower than INT
    Status VARCHAR(50)   -- Long text for simple status
);

-- TODO: Modify for better performance:
-- 1. Right-size the data types
-- 2. Add appropriate indexes
-- 3. Consider partitioning strategies
-- 4. Optimize for common query patterns


-- Exercise 7.3: Data Migration During Modifications
-- TODO: Practice safe data transformations:

-- Create table with data that needs transformation
CREATE TABLE DataTransformTest (
    ID INT,
    FullName VARCHAR(100),        -- Need to split into first/last
    PhoneNumber VARCHAR(50),      -- Need to standardize format
    JoinedDate VARCHAR(20),       -- Need to convert to proper date
    Settings TEXT                 -- Need to convert to JSON
);

-- Insert test data
INSERT INTO DataTransformTest VALUES 
(1, 'John Smith', '555-123-4567', '2024-01-15', 'theme=dark;lang=en'),
(2, 'Jane Doe', '(555) 987-6543', '01/20/2024', 'theme=light;lang=fr');

-- TODO: Safely transform this data:
-- 1. Add new columns with correct structure
-- 2. Migrate data using UPDATE statements
-- 3. Verify data integrity
-- 4. Drop old columns
-- 5. Rename new columns to final names


-- =====================================================
-- SECTION 8: ERROR HANDLING AND ROLLBACK 🔴
-- =====================================================

-- Exercise 8.1: Safe Modification Practices
-- TODO: Practice safe modification procedures:

-- 1. Always backup before major changes
-- 2. Use transactions for complex modifications
-- 3. Test modifications on copy of production data
-- 4. Have rollback plan ready

-- Example safe modification pattern:
BEGIN TRANSACTION;

-- Your modifications here
-- ALTER TABLE ...

-- Test the changes
-- SELECT * FROM TableName WHERE ...

-- If everything looks good:
-- COMMIT;

-- If something went wrong:
-- ROLLBACK;


-- Exercise 8.2: Handling Modification Conflicts
-- TODO: Practice resolving common modification conflicts:

-- Create scenarios that commonly cause issues:
CREATE TABLE ConflictTest (
    ID INT,
    RequiredField VARCHAR(50),
    NumericField INT
);

-- Insert test data with potential conflicts
INSERT INTO ConflictTest VALUES 
(1, NULL, 100),        -- NULL in field we want to make NOT NULL
(2, 'Valid', -50),     -- Negative number if we add positive check
(3, 'Way too long text that exceeds new limit', 200); -- Text too long for smaller VARCHAR

-- TODO: Resolve each conflict:
-- 1. Handle NULLs before adding NOT NULL constraint
-- 2. Fix invalid data before adding check constraints  
-- 3. Truncate or expand data before changing sizes


-- =====================================================
-- SECTION 9: BATCH MODIFICATIONS 🔴
-- =====================================================

-- Exercise 9.1: Modify Multiple Tables at Once
-- TODO: Sometimes you need to modify several related tables:

-- Create a set of related tables
CREATE TABLE BatchTest_Users (
    UserID INT,
    Username VARCHAR(50)
);

CREATE TABLE BatchTest_Orders (
    OrderID INT,
    UserID INT,
    OrderDate DATE
);

CREATE TABLE BatchTest_Products (
    ProductID INT,
    ProductName VARCHAR(100)
);

-- TODO: Add the same audit columns to all tables:
-- - CreatedBy VARCHAR(50)
-- - CreatedDate DATETIME
-- - ModifiedBy VARCHAR(50)  
-- - ModifiedDate DATETIME

-- Write a script that adds these to all three tables


-- Exercise 9.2: Conditional Modifications
-- TODO: Modify tables based on their current structure:

-- Write a script that:
-- 1. Checks if a column exists before adding it
-- 2. Checks current data type before modifying
-- 3. Only makes changes that are actually needed

-- Example pattern (syntax varies by database):
-- IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
--                WHERE TABLE_NAME = 'MyTable' AND COLUMN_NAME = 'MyColumn')
-- BEGIN
--     ALTER TABLE MyTable ADD MyColumn VARCHAR(50);
-- END


-- =====================================================
-- SECTION 10: DOCUMENTATION AND TRACKING 🟡
-- =====================================================

-- Exercise 10.1: Document Your Changes
-- TODO: Create a change log table to track modifications:

CREATE TABLE DatabaseChangeLog (
    ChangeID INT IDENTITY(1,1) PRIMARY KEY,
    TableName VARCHAR(100),
    ChangeType VARCHAR(50),    -- 'ADD_COLUMN', 'MODIFY_COLUMN', 'DROP_COLUMN', etc.
    ChangeDescription TEXT,
    ChangedBy VARCHAR(50),
    ChangeDate DATETIME DEFAULT GETDATE(),
    RollbackScript TEXT,
    ChangeReason TEXT
);

-- TODO: Insert log entries for the changes you've made today


-- Exercise 10.2: Generate Modification Scripts
-- TODO: Create reusable scripts for common modifications:

-- Script 1: Add audit columns to any table
-- Script 2: Standardize naming conventions
-- Script 3: Add common constraints
-- Script 4: Optimize data types for size/performance


-- =====================================================
-- VERIFICATION AND CLEANUP 🧹
-- =====================================================

-- Exercise 11.1: Verify Your Modifications
-- TODO: Write queries to verify your changes:

-- Check table structures
SELECT TABLE_NAME, COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME IN ('CustomerProfiles', 'ProductCatalog', 'StaffMembers')
ORDER BY TABLE_NAME, ORDINAL_POSITION;

-- Check constraints
SELECT TABLE_NAME, CONSTRAINT_NAME, CONSTRAINT_TYPE
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_NAME IN ('CustomerProfiles', 'ProductCatalog', 'StaffMembers');


-- Exercise 11.2: Performance Impact Assessment
-- TODO: Compare performance before and after modifications:

-- Test query performance on modified tables
-- Check storage space usage
-- Verify index effectiveness


-- Clean up all practice tables (uncomment if you want to remove everything)
/*
DROP TABLE IF EXISTS PracticeCustomers;
DROP TABLE IF EXISTS PracticeProducts;
DROP TABLE IF EXISTS PracticeEmployees;
DROP TABLE IF EXISTS ComplexModifyTest;
DROP TABLE IF EXISTS DropColumnTest;
DROP TABLE IF EXISTS bad_naming_example;
DROP TABLE IF EXISTS ConstraintTest;
DROP TABLE IF EXISTS PoorlyOrganized;
DROP TABLE IF EXISTS AppUsers_V1;
DROP TABLE IF EXISTS SlowTable;
DROP TABLE IF EXISTS DataTransformTest;
DROP TABLE IF EXISTS ConflictTest;
DROP TABLE IF EXISTS BatchTest_Users;
DROP TABLE IF EXISTS BatchTest_Orders;
DROP TABLE IF EXISTS BatchTest_Products;
DROP TABLE IF EXISTS DatabaseChangeLog;
*/


-- =====================================================
-- REFLECTION QUESTIONS 💭
-- =====================================================

-- After completing these exercises, consider:
-- 1. When is it better to create a new table vs. modifying an existing one?
-- 2. How do you balance backward compatibility with improvement needs?
-- 3. What's your strategy for testing table modifications safely?
-- 4. How do you communicate database changes to application developers?
-- 5. What's the impact of table modifications on existing indexes and constraints?

-- Document your thoughts:


-- =====================================================
-- NEXT STEPS 🚀
-- =====================================================

-- Congratulations! You've completed the Create module. Next steps:
-- 1. Check solutions in: solutions/04_Modify_Solutions.sql
-- 2. Move on to Module 02: Insert (adding data to your tables)
-- 3. Practice with real-world scenarios in your own projects
-- 4. Consider how table design affects data insertion strategies

-- You now have solid skills in:
-- ✅ Creating databases and tables
-- ✅ Choosing appropriate data types
-- ✅ Modifying table structures safely
-- ✅ Managing constraints and relationships
-- ✅ Planning for schema evolution

-- These foundation skills will serve you well as you continue learning SQL!