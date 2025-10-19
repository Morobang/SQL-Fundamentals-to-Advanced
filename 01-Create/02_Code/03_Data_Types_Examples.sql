-- Module 01: Create Database and Tables
-- 03_Data_Types_Examples.sql - Comprehensive Data Type Examples

-- Purpose: Master every SQL data type with practical examples
-- Teaching Reference: See 01_Teaching/03_Data_Types_Guide.md

-- Make sure you're in a database
USE LearningSQL;

-- =====================================================
-- SECTION 1: NUMERIC DATA TYPES
-- =====================================================

-- Example 1: Integer Types Comparison
CREATE TABLE IntegerExamples (
    ID INT,
    Age TINYINT,              -- 0-255, perfect for age
    YearFounded SMALLINT,     -- -32K to +32K, good for years
    Population BIGINT,        -- Very large numbers
    EmployeeCount INT         -- Most common integer type
);

-- Sample data to show the differences
INSERT INTO IntegerExamples VALUES (1, 25, 1995, 7800000000, 450);
INSERT INTO IntegerExamples VALUES (2, 67, 1889, 329500000, 1200);

-- Example 2: Decimal and Float Types
CREATE TABLE NumericPrecisionExamples (
    ID INT,
    ProductName VARCHAR(100),
    
    -- Money - always use DECIMAL for exact precision
    Price DECIMAL(8,2),        -- Up to $999,999.99
    TaxRate DECIMAL(5,4),      -- Like 0.0825 for 8.25%
    
    -- Scientific measurements - FLOAT is okay for approximations
    Weight FLOAT,              -- Approximate weight in kg
    Temperature REAL,          -- Weather temperature
    
    -- Large financial amounts
    CompanyValuation DECIMAL(15,2),  -- Billions with cents
    
    -- Percentages
    DiscountPercent DECIMAL(5,2)     -- Up to 999.99%
);

-- Sample data showing precision differences
INSERT INTO NumericPrecisionExamples VALUES 
(1, 'Laptop', 1299.99, 0.0825, 2.156789, 23.4567, 1500000000.00, 15.50),
(2, 'Phone', 899.50, 0.0875, 0.198234, -5.7891, 2300000000.50, 25.00);

-- Example 3: When Precision Matters (Money Calculations)
CREATE TABLE FinancialCalculations (
    TransactionID INT,
    Amount DECIMAL(10,2),      -- Exact precision for money
    InterestRate DECIMAL(6,4), -- Precise interest rates
    Days INT,
    
    -- Calculated fields would maintain precision
    InterestAmount AS (Amount * InterestRate * Days / 365)  -- Computed column
);


-- =====================================================
-- SECTION 2: TEXT DATA TYPES
-- =====================================================

-- Example 4: Text Type Sizing Guide
CREATE TABLE TextSizingExamples (
    ID INT,
    
    -- Fixed length - use for codes
    CountryCode CHAR(2),           -- Always exactly 2: US, UK, JP
    StateCode CHAR(2),             -- CA, NY, TX
    CurrencyCode CHAR(3),          -- USD, EUR, GBP
    
    -- Variable length - use for most text
    FirstName VARCHAR(50),         -- 50 covers 99% of names
    LastName VARCHAR(50),          -- Most names fit comfortably
    Email VARCHAR(255),            -- Email standard maximum
    PhoneNumber VARCHAR(15),       -- International phone formats
    
    -- Large text blocks
    Biography TEXT,                -- Unlimited length descriptions
    ProductDescription TEXT,       -- Long product details
    CustomerNotes TEXT             -- Detailed notes
);

-- Sample data showing different text lengths
INSERT INTO TextSizingExamples VALUES 
(1, 'US', 'CA', 'USD', 'John', 'Smith', 'john.smith@email.com', '+1-555-0123', 
 'John is a software engineer with 10 years of experience...', 
 'This laptop features cutting-edge technology...', 
 'Customer prefers email communication and has requested expedited shipping.');

-- Example 5: International Text Support
CREATE TABLE InternationalText (
    ID INT,
    
    -- Regular ASCII text
    EnglishName VARCHAR(100),
    
    -- Unicode text for international characters
    NativeName NVARCHAR(100),     -- 中文, العربية, Русский
    InternationalAddress NVARCHAR(500),
    
    -- Mixed content
    ProductTitle NVARCHAR(200),   -- Supports all languages
    Description NTEXT             -- Large international text
);

-- Example international data
INSERT INTO InternationalText VALUES 
(1, 'Tokyo', N'東京', N'日本国東京都渋谷区', N'高品質ノートパソコン', N'このコンピューターは...');


-- =====================================================
-- SECTION 3: DATE AND TIME DATA TYPES
-- =====================================================

-- Example 6: Date and Time Usage Scenarios
CREATE TABLE DateTimeExamples (
    ID INT,
    EventName VARCHAR(100),
    
    -- Date only - no time component
    EventDate DATE,               -- 2024-12-25
    
    -- Time only - no date component  
    StartTime TIME,               -- 14:30:00
    EndTime TIME,                 -- 17:00:00
    
    -- Full timestamp
    CreatedDateTime DATETIME,     -- 2024-12-25 14:30:00
    
    -- High precision timestamp
    PreciseTimestamp DATETIME2,   -- Microsecond precision
    
    -- Auto-updating timestamp
    LastModified TIMESTAMP        -- Automatically updates
);

-- Sample scheduling data
INSERT INTO DateTimeExamples (ID, EventName, EventDate, StartTime, EndTime, CreatedDateTime, PreciseTimestamp) 
VALUES 
(1, 'Team Meeting', '2024-12-25', '14:30:00', '15:30:00', '2024-12-20 09:15:00', '2024-12-20 09:15:23.1234567'),
(2, 'Project Deadline', '2024-12-31', '23:59:59', '23:59:59', '2024-12-01 10:00:00', '2024-12-01 10:00:00.0000000');

-- Example 7: Real-World Date Scenarios
CREATE TABLE EmployeeSchedule (
    EmployeeID INT,
    FirstName VARCHAR(50),
    
    -- Various date fields for HR
    HireDate DATE,                -- When they started
    DateOfBirth DATE,             -- Birthday
    LastReviewDate DATE,          -- Performance review
    NextReviewDate DATE,          -- Scheduled review
    
    -- Time tracking
    ShiftStartTime TIME,          -- Daily start time
    ShiftEndTime TIME,            -- Daily end time
    LastClockIn DATETIME,         -- When they last clocked in
    LastClockOut DATETIME         -- When they last clocked out
);


-- =====================================================
-- SECTION 4: BOOLEAN AND BINARY DATA TYPES
-- =====================================================

-- Example 8: Boolean Flags for Business Logic
CREATE TABLE UserPreferences (
    UserID INT,
    Username VARCHAR(50),
    
    -- Status flags
    IsActive BIT,                 -- Account active?
    IsEmailVerified BIT,          -- Email confirmed?
    IsPremiumUser BIT,            -- Premium subscription?
    
    -- Notification preferences
    EmailNotifications BIT,       -- Wants email alerts?
    SMSNotifications BIT,         -- Wants text messages?
    NewsletterSubscription BIT,   -- Subscribed to newsletter?
    
    -- Privacy settings
    ProfilePublic BIT,            -- Public profile?
    ShowEmail BIT,                -- Show email to others?
    AllowMessaging BIT            -- Allow direct messages?
);

-- Example 9: Binary Data for Files
CREATE TABLE UserProfiles (
    UserID INT,
    Username VARCHAR(50),
    
    -- File storage
    ProfilePicture VARBINARY(MAX), -- Image file data
    DocumentHash BINARY(32),       -- SHA-256 hash (always 32 bytes)
    Signature VARBINARY(1000)      -- Digital signature
);


-- =====================================================
-- SECTION 5: SPECIALIZED DATA TYPES
-- =====================================================

-- Example 10: Unique Identifiers
CREATE TABLE DistributedSystem (
    -- Traditional auto-incrementing ID
    LocalID INT,
    
    -- Globally unique identifier
    GlobalID UNIQUEIDENTIFIER,    -- GUID for distributed systems
    
    -- Other unique fields
    ProductCode VARCHAR(50),
    SerialNumber VARCHAR(100)
);

-- Example 11: JSON and XML Data (SQL Server 2016+)
CREATE TABLE ModernDataTypes (
    ID INT,
    Name VARCHAR(100),
    
    -- JSON data storage
    Preferences NVARCHAR(MAX),    -- Store JSON strings
    MetaData NVARCHAR(MAX),       -- Additional JSON metadata
    
    -- XML data storage  
    ConfigurationXML XML          -- Structured XML data
);


-- =====================================================
-- SECTION 6: DATA TYPE DECISION EXAMPLES
-- =====================================================

-- Example 12: E-commerce Product Table (Comprehensive)
CREATE TABLE ComprehensiveProducts (
    -- Identifiers
    ProductID INT,                -- Primary identifier
    SKU VARCHAR(50),             -- Stock Keeping Unit
    UPC CHAR(12),                -- Universal Product Code (fixed length)
    
    -- Basic info
    ProductName NVARCHAR(200),   -- International product names
    Brand VARCHAR(100),          -- Brand name
    Model VARCHAR(100),          -- Model number/name
    
    -- Categorization
    CategoryID INT,              -- Link to categories table
    Subcategory VARCHAR(100),    -- Text subcategory
    Tags TEXT,                   -- Searchable keywords
    
    -- Pricing
    BasePrice DECIMAL(10,2),     -- Standard price
    SalePrice DECIMAL(10,2),     -- Sale price (nullable)
    Cost DECIMAL(10,2),          -- Our cost
    Currency CHAR(3),            -- USD, EUR, etc.
    
    -- Physical properties
    Weight DECIMAL(8,3),         -- Weight in kg (3 decimal places)
    Length DECIMAL(6,2),         -- Dimensions in cm
    Width DECIMAL(6,2),
    Height DECIMAL(6,2),
    Color VARCHAR(50),           -- Color name
    Size VARCHAR(20),            -- Size designation
    
    -- Inventory
    QuantityInStock INT,         -- Current stock
    ReorderLevel INT,            -- When to reorder
    MaxStockLevel INT,           -- Maximum to keep
    
    -- Supplier info
    SupplierID INT,              -- Link to suppliers table
    SupplierPartNumber VARCHAR(100), -- Their part number
    
    -- Status flags
    IsActive BIT,                -- Currently selling?
    IsFeatured BIT,              -- Show prominently?
    IsDigitalProduct BIT,        -- Download vs physical?
    RequiresShipping BIT,        -- Needs to be shipped?
    
    -- Dates
    CreatedDate DATETIME,        -- When added to catalog
    ModifiedDate DATETIME,       -- Last update
    DiscontinuedDate DATE,       -- When stopped selling
    
    -- Rich content
    ShortDescription TEXT,       -- Brief description
    LongDescription TEXT,        -- Detailed description
    SpecificationsJSON NVARCHAR(MAX), -- Technical specs as JSON
    
    -- SEO and marketing
    MetaTitle VARCHAR(200),      -- Page title for SEO
    MetaDescription VARCHAR(500), -- SEO description
    SearchKeywords TEXT          -- Additional search terms
);


-- =====================================================
-- SECTION 7: COMMON DATA TYPE MISTAKES
-- =====================================================

-- Example 13: Common Mistakes and Corrections

-- MISTAKE 1: Using wrong type for money
CREATE TABLE BadMoneyExample (
    ProductID INT,
    Price FLOAT                  -- ❌ BAD: Loses precision!
);

CREATE TABLE GoodMoneyExample (
    ProductID INT,
    Price DECIMAL(10,2)          -- ✅ GOOD: Exact precision
);

-- MISTAKE 2: Text fields too small
CREATE TABLE BadTextSizing (
    CustomerID INT,
    FirstName VARCHAR(10),       -- ❌ BAD: Some names are longer!
    Email VARCHAR(50)            -- ❌ BAD: Emails can be longer!
);

CREATE TABLE GoodTextSizing (
    CustomerID INT,
    FirstName VARCHAR(50),       -- ✅ GOOD: Reasonable size
    Email VARCHAR(255)           -- ✅ GOOD: Email standard
);

-- MISTAKE 3: Using INT for everything
CREATE TABLE BadNumberTypes (
    UserID INT,
    Age INT,                     -- ❌ WASTEFUL: TINYINT is enough
    Year INT,                    -- ❌ WASTEFUL: SMALLINT is enough
    IsActive INT                 -- ❌ WRONG TYPE: Should be BIT
);

CREATE TABLE GoodNumberTypes (
    UserID INT,                  -- ✅ GOOD: Need full range for IDs
    Age TINYINT,                -- ✅ GOOD: 0-255 is perfect for age
    Year SMALLINT,              -- ✅ GOOD: Handles all years
    IsActive BIT                -- ✅ GOOD: True/false flag
);


-- =====================================================
-- VERIFICATION AND TESTING SECTION
-- =====================================================

-- Check all the tables we created
SELECT 
    TABLE_NAME,
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = t.TABLE_NAME) AS ColumnCount
FROM INFORMATION_SCHEMA.TABLES t
WHERE TABLE_TYPE = 'BASE TABLE'
  AND TABLE_CATALOG = DB_NAME()
  AND TABLE_NAME LIKE '%Examples'
ORDER BY TABLE_NAME;

-- View data types in a specific table
SELECT 
    COLUMN_NAME,
    DATA_TYPE,
    CASE 
        WHEN CHARACTER_MAXIMUM_LENGTH IS NOT NULL 
        THEN CAST(CHARACTER_MAXIMUM_LENGTH AS VARCHAR(10))
        WHEN NUMERIC_PRECISION IS NOT NULL 
        THEN CAST(NUMERIC_PRECISION AS VARCHAR(10)) + ',' + CAST(NUMERIC_SCALE AS VARCHAR(10))
        ELSE 'N/A'
    END AS Size_Precision
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'ComprehensiveProducts'
ORDER BY ORDINAL_POSITION;

-- Related files:
-- Teaching: 01_Teaching/03_Data_Types_Guide.md  
-- Previous: 02_Create_Table.sql
-- Next: 04_Modify_Tables.sql