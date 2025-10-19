-- Module 01: Create Database and Tables
-- Exercise Solutions

-- =====================================================
-- WARM-UP SOLUTIONS - Database Creation
-- =====================================================

-- Solution 1: Create Your Personal Database
CREATE DATABASE MyPersonalDB;
-- Alternative: CREATE DATABASE TshigidimasaDB;


-- Solution 2: Switch to Your Database
USE MyPersonalDB;


-- Solution 3: Verify Current Database
SELECT DB_NAME() AS CurrentDatabase;


-- =====================================================
-- BASIC TABLE CREATION SOLUTIONS
-- =====================================================

-- Solution 4: Create a Simple Movies Table
CREATE TABLE Movies (
    MovieID INT,
    Title VARCHAR(200),
    Director VARCHAR(100),
    ReleaseYear INT,
    Rating DECIMAL(3,1)  -- Allows values like 8.5, 10.0
);


-- Solution 5: Create a Bookstore Table
CREATE TABLE Books (
    BookID INT,
    Title VARCHAR(250),
    Author VARCHAR(100),
    ISBN CHAR(13),              -- Fixed length for ISBN
    Price DECIMAL(8,2),         -- Allows prices up to 999,999.99
    PublicationDate DATE,
    IsAvailable BIT
);


-- =====================================================
-- DATA TYPE SELECTION SOLUTIONS
-- =====================================================

-- Solution 6: Students Table with Appropriate Data Types
CREATE TABLE Students (
    StudentID INT,                  -- Unique number
    FirstName VARCHAR(50),          -- Common first name length
    LastName VARCHAR(50),           -- Common last name length
    Email VARCHAR(255),             -- Email can be long
    DateOfBirth DATE,               -- Date only needed
    GPA DECIMAL(3,2),              -- Like 3.75 (max 4.00)
    IsActive BIT,                   -- True/False
    EnrollmentDate DATETIME,        -- Date and time
    MiddleInitial CHAR(1),          -- Exactly one character
    Notes TEXT                      -- Long advisor notes
);


-- Solution 7: Sports Team Database
CREATE TABLE Players (
    PlayerID INT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    JerseyNumber INT,              -- Small range but INT is fine
    Position VARCHAR(5),           -- "QB", "RB", etc.
    Height INT,                    -- Height in inches
    Weight INT,                    -- Weight in pounds
    DateOfBirth DATE,
    Salary DECIMAL(12,2),          -- Large salaries with cents
    IsActive BIT,
    ContractEndDate DATE
);


-- =====================================================
-- TABLE MODIFICATION SOLUTIONS
-- =====================================================

-- Solution 8: Add Columns to Movies Table
ALTER TABLE Movies
ADD Genre VARCHAR(50);

ALTER TABLE Movies
ADD DurationMinutes INT;


-- Solution 9: Modify Column Size
ALTER TABLE Movies
ALTER COLUMN Director VARCHAR(150);


-- Solution 10: Remove a Column
ALTER TABLE Movies
DROP COLUMN DurationMinutes;


-- =====================================================
-- REAL-WORLD SCENARIO SOLUTIONS
-- =====================================================

-- Solution 11: Employee Management System
CREATE TABLE Employees (
    EmployeeID INT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    HireDate DATE,
    Salary DECIMAL(10,2),
    Department VARCHAR(50),
    JobTitle VARCHAR(100),
    ManagerID INT,                 -- References another employee
    Address VARCHAR(200),
    City VARCHAR(50),
    State VARCHAR(50),
    ZipCode VARCHAR(10),
    DateOfBirth DATE,
    EmergencyContact VARCHAR(100),
    EmergencyPhone VARCHAR(15),
    IsActive BIT,
    TerminationDate DATE,
    CreatedDate DATETIME,
    ModifiedDate DATETIME
);


-- Solution 12: Inventory Management System
CREATE TABLE Products (
    ProductID INT,
    ProductName VARCHAR(200),
    ProductCode VARCHAR(50),       -- SKU or barcode
    Description TEXT,
    Category VARCHAR(50),
    Price DECIMAL(10,2),
    Cost DECIMAL(10,2),           -- What we paid for it
    QuantityInStock INT,
    ReorderLevel INT,             -- When to reorder
    SupplierID INT,
    SupplierName VARCHAR(100),
    CreatedDate DATETIME,
    ModifiedDate DATETIME,
    IsActive BIT,
    IsDiscontinued BIT,
    Weight DECIMAL(8,2),          -- For shipping
    Dimensions VARCHAR(50),        -- Like "10x5x3 inches"
    Location VARCHAR(50)           -- Warehouse location
);


-- Solution 13: Library System
CREATE TABLE LibraryBooks (
    BookID INT,
    ISBN VARCHAR(13),
    Title VARCHAR(300),
    Author VARCHAR(200),           -- Multiple authors possible
    Publisher VARCHAR(100),
    PublicationYear INT,
    Edition VARCHAR(20),
    PageCount INT,
    Format VARCHAR(20),            -- Hardcover, Paperback, etc.
    Subject VARCHAR(100),
    CallNumber VARCHAR(50),        -- Dewey Decimal
    AcquisitionDate DATE,
    Cost DECIMAL(8,2),
    Condition VARCHAR(20),         -- New, Good, Fair, Poor
    Location VARCHAR(50),          -- Which shelf/section
    IsAvailable BIT,
    IsRestricted BIT,             -- Reference only?
    Notes TEXT,
    LastInventoryDate DATE
);


-- =====================================================
-- SCHEMA EXPLORATION SOLUTIONS
-- =====================================================

-- Solution 14: Examine Your Work
-- a) List all tables
SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;

-- b) Show structure of Movies table
SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Movies'
ORDER BY ORDINAL_POSITION;

-- c) Show structure of Students table
SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Students'
ORDER BY ORDINAL_POSITION;


-- Solution 15: Table Information Query
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    CHARACTER_MAXIMUM_LENGTH,
    NUMERIC_PRECISION,
    NUMERIC_SCALE,
    IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Employees'
ORDER BY ORDINAL_POSITION;


-- =====================================================
-- DESIGN CHALLENGE SOLUTIONS
-- =====================================================

-- Solution 16: Restaurant System Design
CREATE TABLE MenuItems (
    ItemID INT,
    ItemName VARCHAR(100),
    Category VARCHAR(50),          -- Appetizer, Main, Dessert
    Description TEXT,
    Price DECIMAL(6,2),
    IsAvailable BIT,
    PrepTime INT,                  -- Minutes to prepare
    Calories INT,
    IsVegetarian BIT,
    IsGlutenFree BIT
);

CREATE TABLE Customers (
    CustomerID INT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Phone VARCHAR(15),
    Email VARCHAR(100),
    Address VARCHAR(200),
    PreferredTable VARCHAR(20),
    Allergies TEXT,
    CreatedDate DATETIME
);

CREATE TABLE Orders (
    OrderID INT,
    CustomerID INT,
    OrderDate DATETIME,
    TableNumber VARCHAR(10),
    WaiterID INT,
    Subtotal DECIMAL(8,2),
    Tax DECIMAL(8,2),
    Tip DECIMAL(8,2),
    Total DECIMAL(8,2),
    PaymentMethod VARCHAR(20),
    Status VARCHAR(20),            -- Ordered, Preparing, Served, Paid
    SpecialInstructions TEXT
);


-- Solution 17: School Management System
CREATE TABLE Teachers (
    TeacherID INT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    Department VARCHAR(50),
    HireDate DATE,
    Salary DECIMAL(10,2),
    IsActive BIT
);

CREATE TABLE Courses (
    CourseID INT,
    CourseName VARCHAR(100),
    CourseCode VARCHAR(10),        -- Like "MATH101"
    Department VARCHAR(50),
    Credits INT,
    Description TEXT,
    Prerequisites VARCHAR(200),
    IsActive BIT
);

CREATE TABLE Classrooms (
    ClassroomID INT,
    RoomNumber VARCHAR(20),
    Building VARCHAR(50),
    Capacity INT,
    HasProjector BIT,
    HasComputers BIT,
    IsAccessible BIT
);

CREATE TABLE CourseSchedule (
    ScheduleID INT,
    CourseID INT,
    TeacherID INT,
    ClassroomID INT,
    Semester VARCHAR(20),          -- Fall 2024, Spring 2025
    DayOfWeek VARCHAR(10),         -- Monday, Tuesday, etc.
    StartTime TIME,
    EndTime TIME,
    MaxStudents INT,
    CurrentEnrollment INT
);


-- =====================================================
-- CLEANUP AND SAFETY SOLUTIONS
-- =====================================================

-- Solution 18: Safe Table Removal
IF OBJECT_ID('LibraryBooks', 'U') IS NOT NULL
    DROP TABLE LibraryBooks;


-- Solution 19: Recreate and Improve
-- Drop existing table
DROP TABLE IF EXISTS Movies;

-- Recreate with improvements
CREATE TABLE Movies (
    MovieID INT,
    Title VARCHAR(300),            -- Increased from 200
    Director VARCHAR(150),         -- As modified earlier
    ReleaseYear INT,
    Rating DECIMAL(3,1),
    Budget DECIMAL(12,2),          -- New: Movie budget
    BoxOffice DECIMAL(12,2),       -- New: Box office earnings
    Country VARCHAR(50),           -- New: Country of origin
    Genre VARCHAR(50)              -- Re-added after earlier removal
);


-- =====================================================
-- BONUS CHALLENGE SOLUTIONS
-- =====================================================

-- Bonus Solution 1: Complex Data Types
CREATE TABLE UserProfiles (
    UserID INT,
    Username VARCHAR(50),
    Email VARCHAR(255),
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DateOfBirth DATE,
    Gender CHAR(1),                -- M/F/O
    PhonePrimary VARCHAR(15),
    PhoneSecondary VARCHAR(15),
    AddressLine1 VARCHAR(100),
    AddressLine2 VARCHAR(100),
    City VARCHAR(50),
    State VARCHAR(50),
    ZipCode VARCHAR(10),
    Country VARCHAR(50),
    TimeZone VARCHAR(50),
    PreferredLanguage VARCHAR(10),
    EmailNotifications BIT,
    SMSNotifications BIT,
    NewsletterSubscribed BIT,
    AccountStatus VARCHAR(20),     -- Active, Suspended, Closed
    AccountType VARCHAR(20),       -- Free, Premium, Enterprise
    CreatedDate DATETIME,
    ModifiedDate DATETIME,
    LastLoginDate DATETIME,
    LoginCount INT,
    IsEmailVerified BIT,
    IsPhoneVerified BIT,
    ProfilePictureURL VARCHAR(500),
    Bio TEXT,
    Website VARCHAR(200)
);


-- Bonus Solution 2: International Considerations
CREATE TABLE InternationalCustomers (
    CustomerID INT,
    FirstName NVARCHAR(100),       -- Unicode for international names
    LastName NVARCHAR(100),
    CompanyName NVARCHAR(200),
    Email VARCHAR(255),
    CountryCode CHAR(2),           -- ISO 3166-1 alpha-2
    LanguageCode VARCHAR(10),      -- en-US, fr-FR, ja-JP
    CurrencyCode CHAR(3),          -- USD, EUR, JPY
    AddressFormat VARCHAR(20),     -- US, UK, JP (different formats)
    AddressLine1 NVARCHAR(200),
    AddressLine2 NVARCHAR(200),
    City NVARCHAR(100),
    StateProvince NVARCHAR(100),
    PostalCode VARCHAR(20),        -- Various formats globally
    PhoneCountryCode VARCHAR(5),   -- +1, +44, +81
    PhoneNumber VARCHAR(20),
    TaxIDNumber VARCHAR(50),       -- VAT, SSN, etc.
    TimeZoneOffset VARCHAR(10),    -- +05:30, -08:00
    DateFormat VARCHAR(10),        -- MM/DD/YYYY, DD/MM/YYYY
    NumberFormat VARCHAR(10),      -- Decimal separators
    CreatedDate DATETIME2,         -- More precise timestamp
    ModifiedDate DATETIME2
);


-- Bonus Solution 3: Audit and History
CREATE TABLE AuditTrail (
    AuditID INT,
    TableName VARCHAR(100),        -- Which table was changed
    RecordID INT,                  -- Which record was changed
    Action VARCHAR(10),            -- INSERT, UPDATE, DELETE
    ColumnName VARCHAR(100),       -- Which column changed
    OldValue NVARCHAR(MAX),        -- Previous value
    NewValue NVARCHAR(MAX),        -- New value
    ChangedBy VARCHAR(100),        -- Username who made change
    ChangedDate DATETIME2,         -- When change occurred
    ChangeReason TEXT,             -- Why change was made
    IPAddress VARCHAR(45),         -- IPv4 or IPv6
    UserAgent VARCHAR(500),        -- Browser/application info
    SessionID VARCHAR(100),        -- User session identifier
    TransactionID VARCHAR(100)     -- Database transaction ID
);


-- =====================================================
-- EXPLANATION SECTION
-- =====================================================

-- Why these solutions work:

-- 1. Data Type Selection:
--    - VARCHAR for variable-length text (names, descriptions)
--    - CHAR for fixed-length codes (ISBN, country codes)
--    - DECIMAL for precise numbers (money, GPA)
--    - INT for whole numbers (IDs, counts, years)
--    - DATE for dates without time
--    - DATETIME for timestamps
--    - BIT for true/false values
--    - TEXT for long descriptions

-- 2. Field Sizing Considerations:
--    - Names: 50 characters covers most real names
--    - Email: 255 characters per email standards
--    - Descriptions: TEXT for unlimited length
--    - Money: DECIMAL(10,2) handles most business amounts
--    - Phone: VARCHAR(15) handles international formats

-- 3. Real-World Considerations:
--    - Include audit fields (created/modified dates)
--    - Add status flags for soft deletes
--    - Plan for future expansion
--    - Consider international requirements
--    - Think about data relationships

-- 4. Best Practices Applied:
--    - Consistent naming conventions
--    - Appropriate data types for each use case
--    - Reasonable field sizes (not too small, not wasteful)
--    - Future-proofing with status and audit fields

-- Alternative approaches:
-- - Could use GUID/UUID instead of INT for IDs
-- - Could use more specific numeric types (TINYINT, SMALLINT)
-- - Could add check constraints for data validation
-- - Could use computed columns for derived values

-- Next steps:
-- - Add primary keys and constraints (Module 05)
-- - Create relationships between tables (Module 06)
-- - Populate tables with data (Module 02)
-- - Optimize with indexes (Module 12)
