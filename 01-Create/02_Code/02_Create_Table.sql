-- Module 01: Create Database and Tables  
-- 02_Create_Table.sql - Table Creation Examples

-- Purpose: Learn to create tables with proper structure and naming
-- Teaching Reference: See 01_Teaching/02_Creating_Tables.md

-- Make sure you're in a database first
USE LearningSQL;  -- Or your practice database

-- =====================================================
-- SECTION 1: BASIC TABLE CREATION
-- =====================================================

-- Example 1: Simple Employee Table
CREATE TABLE Employees (
    EmployeeID INT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    HireDate DATE
);

-- Example 2: Customer Information Table
CREATE TABLE Customers (
    CustomerID INT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    IsActive BIT
);

-- Example 3: Product Catalog Table
CREATE TABLE Products (
    ProductID INT,
    ProductName VARCHAR(200),
    Price DECIMAL(8,2),
    InStock INT,
    CreatedDate DATETIME
);


-- =====================================================
-- SECTION 2: TABLES WITH DIFFERENT DATA TYPES
-- =====================================================

-- Example 4: Student Records with Various Data Types
CREATE TABLE Students (
    StudentID INT,              -- Whole number for ID
    FirstName VARCHAR(50),      -- Variable text for names
    LastName VARCHAR(50),
    Email VARCHAR(255),         -- Longer field for email
    DateOfBirth DATE,           -- Date only
    GPA DECIMAL(3,2),          -- Precise decimal like 3.75
    EnrollmentDate DATETIME,    -- Date and time
    IsActive BIT,              -- True/False flag
    Notes TEXT                 -- Long text for notes
);

-- Example 5: Order Management Table
CREATE TABLE Orders (
    OrderID INT,
    CustomerID INT,
    OrderDate DATE,
    OrderTime TIME,
    TotalAmount DECIMAL(10,2),
    Status VARCHAR(20),
    ShippingAddress TEXT,
    IsRushOrder BIT
);

-- Example 6: Book Library Table
CREATE TABLE Books (
    BookID INT,
    Title VARCHAR(300),         -- Books can have long titles
    Author VARCHAR(150),
    ISBN CHAR(13),             -- Fixed length for ISBN
    PublicationDate DATE,
    PageCount INT,
    Price DECIMAL(6,2),
    IsAvailable BIT,
    Genre VARCHAR(50),
    Description TEXT
);


-- =====================================================
-- SECTION 3: BUSINESS SCENARIO TABLES
-- =====================================================

-- Scenario 1: Restaurant Management System

-- Table for menu items
CREATE TABLE MenuItems (
    ItemID INT,
    ItemName VARCHAR(100),
    Description TEXT,
    Price DECIMAL(6,2),
    Category VARCHAR(50),       -- Appetizer, Main, Dessert
    IsAvailable BIT,
    PreparationTime INT,        -- Minutes to prepare
    Calories INT,
    IsVegetarian BIT,
    IsGlutenFree BIT
);

-- Table for restaurant tables
CREATE TABLE RestaurantTables (
    TableID INT,
    TableNumber VARCHAR(10),    -- Could be "A1", "B2", etc.
    Capacity INT,
    Location VARCHAR(50),       -- Patio, Indoor, Private
    IsReserved BIT
);

-- Scenario 2: School Management System

-- Student enrollment table
CREATE TABLE StudentEnrollment (
    EnrollmentID INT,
    StudentID INT,
    CourseCode VARCHAR(10),     -- Like "MATH101"
    CourseName VARCHAR(100),
    Semester VARCHAR(20),       -- "Fall 2024"
    Grade CHAR(2),             -- "A+", "B", "C-"
    Credits INT,
    EnrollmentDate DATE,
    DropDate DATE              -- NULL if not dropped
);

-- Faculty information
CREATE TABLE Faculty (
    FacultyID INT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    Department VARCHAR(50),
    HireDate DATE,
    Salary DECIMAL(10,2),
    OfficeNumber VARCHAR(20),
    PhoneExtension VARCHAR(10),
    IsActive BIT
);


-- =====================================================
-- SECTION 4: INTERNATIONAL AND ADVANCED EXAMPLES
-- =====================================================

-- Example 7: International Customer Table
CREATE TABLE GlobalCustomers (
    CustomerID INT,
    FirstName NVARCHAR(100),    -- Unicode for international names
    LastName NVARCHAR(100),
    Email VARCHAR(255),
    CountryCode CHAR(2),        -- ISO country codes: US, UK, JP
    LanguagePreference VARCHAR(10), -- en-US, fr-FR, ja-JP
    TimeZone VARCHAR(50),
    CurrencyCode CHAR(3),       -- USD, EUR, GBP, JPY
    PhoneCountryCode VARCHAR(5), -- +1, +44, +81
    PhoneNumber VARCHAR(20),
    IsActive BIT,
    CreatedDate DATETIME,
    LastLoginDate DATETIME
);

-- Example 8: E-commerce Product Table
CREATE TABLE EcommerceProducts (
    ProductID INT,
    SKU VARCHAR(50),           -- Stock Keeping Unit
    ProductName VARCHAR(200),
    Brand VARCHAR(100),
    Category VARCHAR(50),
    Subcategory VARCHAR(50),
    Price DECIMAL(10,2),
    CompareAtPrice DECIMAL(10,2), -- Original price for sale items
    Cost DECIMAL(10,2),        -- What we paid for it
    Weight DECIMAL(8,2),       -- For shipping calculations
    Dimensions VARCHAR(50),     -- "10x5x3 inches"
    Color VARCHAR(30),
    Size VARCHAR(20),
    Material VARCHAR(100),
    QuantityInStock INT,
    ReorderLevel INT,
    SupplerID INT,
    IsActive BIT,
    IsFeatured BIT,
    IsOnSale BIT,
    CreatedDate DATETIME,
    ModifiedDate DATETIME
);


-- =====================================================
-- SECTION 5: VIEWING TABLE STRUCTURES
-- =====================================================

-- Example 9: Check What Tables You've Created
SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_TYPE = 'BASE TABLE'
  AND TABLE_CATALOG = DB_NAME()  -- Current database only
ORDER BY TABLE_NAME;

-- Example 10: View Structure of a Specific Table
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    IS_NULLABLE,
    COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Students'
ORDER BY ORDINAL_POSITION;

-- Example 11: Quick Structure Check
-- SQL Server method
EXEC sp_help 'Employees';

-- Alternative method that works across SQL systems
SELECT 
    COLUMN_NAME AS Column_Name,
    DATA_TYPE AS Data_Type,
    CASE 
        WHEN CHARACTER_MAXIMUM_LENGTH IS NOT NULL 
        THEN CAST(CHARACTER_MAXIMUM_LENGTH AS VARCHAR(10))
        WHEN NUMERIC_PRECISION IS NOT NULL 
        THEN CAST(NUMERIC_PRECISION AS VARCHAR(10)) + ',' + CAST(NUMERIC_SCALE AS VARCHAR(10))
        ELSE ''
    END AS Size_Info
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Products'
ORDER BY ORDINAL_POSITION;


-- =====================================================
-- SECTION 6: TABLE NAMING BEST PRACTICES
-- =====================================================

-- Example 12: Consistent Naming Patterns

-- Option 1: Singular table names
CREATE TABLE Employee_Singular (
    EmployeeID INT,
    Name VARCHAR(100)
);

CREATE TABLE Department_Singular (
    DepartmentID INT,
    Name VARCHAR(100)
);

-- Option 2: Plural table names  
CREATE TABLE Employees_Plural (
    EmployeeID INT,
    Name VARCHAR(100)
);

CREATE TABLE Departments_Plural (
    DepartmentID INT,
    Name VARCHAR(100)
);

-- Choose one style and stick with it throughout your database!


-- =====================================================
-- SECTION 7: COMMON TABLE PATTERNS
-- =====================================================

-- Pattern 1: User Account Management
CREATE TABLE UserAccounts (
    UserID INT,
    Username VARCHAR(50),
    Email VARCHAR(255),
    PasswordHash VARCHAR(255),   -- Never store plain passwords!
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DateOfBirth DATE,
    CreatedDate DATETIME,
    LastLoginDate DATETIME,
    IsActive BIT,
    IsEmailVerified BIT,
    FailedLoginAttempts INT
);

-- Pattern 2: Address Information
CREATE TABLE Addresses (
    AddressID INT,
    CustomerID INT,
    AddressType VARCHAR(20),    -- Home, Work, Billing, Shipping
    AddressLine1 VARCHAR(200),
    AddressLine2 VARCHAR(200),
    City VARCHAR(100),
    StateProvince VARCHAR(100),
    PostalCode VARCHAR(20),
    Country VARCHAR(100),
    IsDefault BIT              -- Is this the primary address?
);

-- Pattern 3: Audit/History Tracking
CREATE TABLE AuditLog (
    AuditID INT,
    TableName VARCHAR(100),
    RecordID INT,
    Action VARCHAR(20),        -- INSERT, UPDATE, DELETE
    ChangeDate DATETIME,
    ChangedBy VARCHAR(100),
    OldValues TEXT,            -- JSON or description of old values
    NewValues TEXT             -- JSON or description of new values
);


-- =====================================================
-- SECTION 8: PRACTICE CHALLENGES
-- =====================================================

-- Challenge 1: Create a Movie Database Table
-- TODO: Create a table called "Movies" with these requirements:
-- - Movie ID, Title, Director, Release Year, Rating (1-10), Genre, Duration in minutes
-- - Choose appropriate data types for each field

-- Your solution here:
-- CREATE TABLE Movies (...);

-- Challenge 2: Create a Personal Budget Table
-- TODO: Create a table for tracking personal expenses:
-- - Transaction ID, Date, Description, Amount, Category, Payment Method
-- - Think about what data types make sense for financial data

-- Your solution here:

-- Challenge 3: Create a Social Media Post Table
-- TODO: Design a table for social media posts:
-- - Post ID, User ID, Content, Post Date, Like Count, Share Count, Is Public
-- - Consider what fields would be needed for a real social platform

-- Your solution here:


-- =====================================================
-- VERIFICATION SECTION
-- =====================================================

-- Check all the tables you've created
SELECT 
    TABLE_NAME,
    TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_TYPE = 'BASE TABLE'
  AND TABLE_CATALOG = DB_NAME()
ORDER BY TABLE_NAME;

-- Count how many tables you have
SELECT COUNT(*) AS TotalTables
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_TYPE = 'BASE TABLE'
  AND TABLE_CATALOG = DB_NAME();

-- Related files:
-- Teaching: 01_Teaching/02_Creating_Tables.md
-- Previous: 01_Create_Database.sql
-- Next: 03_Data_Types_Examples.sql