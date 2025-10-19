-- Module 01: Create Database and Tables
-- 03_DataTypes_Practice.sql - Data Types Deep Dive Practice

-- Instructions: Master SQL data types through hands-on exercises
-- Difficulty: 🟢 Beginner to 🔴 Advanced
-- Prerequisites: Read 01_Teaching/03_Data_Types_Guide.md

-- Make sure you're in a practice database first
USE TshigidimasaDB;  -- Change to your personal database name

-- =====================================================
-- SECTION 1: NUMERIC DATA TYPES 🟢
-- =====================================================

-- Exercise 1.1: Age vs. ID Numbers
-- TODO: Create a table that demonstrates the difference between:
-- TINYINT (age), SMALLINT (year), INT (ID), BIGINT (large ID)

CREATE TABLE NumericDemo (
    -- TODO: Add columns with different integer types
    -- PersonID (needs to handle millions of records)
    -- Age (0-150 range)
    -- YearBorn (4-digit year)
    -- GlobalID (very large numbers, like social security equivalent)
);


-- Exercise 1.2: Money and Measurements
-- TODO: Create a table for a furniture store with different decimal types:

CREATE TABLE FurnitureInventory (
    ItemID INT,
    -- TODO: Add these with appropriate decimal types:
    -- Price (money - needs exact precision)
    -- Weight (can have decimal, but doesn't need high precision)
    -- Dimensions (length, width, height - precise measurements needed)
    -- Discount (percentage - 0.00 to 100.00)
    -- Rating (1.0 to 5.0 stars)
);


-- Exercise 1.3: Financial Precision Practice
-- TODO: Create tables that handle money correctly:

-- Banking Table (needs exact precision)
CREATE TABLE BankAccounts (
    AccountID INT,
    -- TODO: Add columns for:
    -- Balance (exact money amounts)
    -- InterestRate (precise percentage)
    -- MinimumBalance (exact money amount)
);

-- Sports Statistics (approximate is okay)
CREATE TABLE PlayerStats (
    PlayerID INT,
    -- TODO: Add columns for:
    -- BattingAverage (3 decimal places usually enough)
    -- Points (whole numbers)
    -- GameTime (minutes and seconds)
);


-- =====================================================
-- SECTION 2: TEXT DATA TYPES 🟢
-- =====================================================

-- Exercise 2.1: Text Size Planning
-- TODO: Choose appropriate text types for a social media platform:

CREATE TABLE SocialMediaPosts (
    PostID INT,
    -- TODO: Choose VARCHAR vs TEXT for:
    -- Username (what's typical username length?)
    -- PostTitle (typical social media title?)
    -- PostContent (could be very long)
    -- HashTags (how long do hashtag lists get?)
    -- ShortBio (user bio text)
    -- WebsiteURL (URL length considerations)
);


-- Exercise 2.2: Fixed vs. Variable Length Practice
-- TODO: Create a table that shows when to use CHAR vs VARCHAR:

CREATE TABLE ProductCodes (
    ProductID INT,
    -- TODO: Decide CHAR vs VARCHAR for:
    -- CountryCode (always 2 letters: US, CA, UK)
    -- PostalCode (varies by country: 12345 vs K1A 0A6)
    -- ProductSKU (always exactly 8 characters: AB123456)
    -- ProductName (varies widely)
    -- ColorCode (hex colors are always #RRGGBB format)
    -- SerialNumber (could be various formats)
);


-- Exercise 2.3: International Text Support
-- TODO: Create tables that handle international characters:

CREATE TABLE InternationalCustomers (
    CustomerID INT,
    -- TODO: Handle these international scenarios:
    -- Name (Chinese, Arabic, Russian characters)
    -- Address (various scripts and lengths)
    -- Notes (might contain emojis and special characters)
);

-- Test with some international data:
-- INSERT INTO InternationalCustomers VALUES 
-- (1, N'张伟', N'北京市朝阳区...', N'VIP客户 ⭐');


-- =====================================================
-- SECTION 3: DATE AND TIME DATA TYPES 🟡
-- =====================================================

-- Exercise 3.1: Date vs DateTime vs Time
-- TODO: Create an event management system with appropriate date/time types:

CREATE TABLE EventSchedule (
    EventID INT,
    -- TODO: Choose appropriate types for:
    -- EventDate (just the date, no time needed)
    -- EventDateTime (specific date and time)
    -- EventTime (just time, no date - like "2:30 PM")
    -- Duration (how long the event lasts)
    -- CreatedTimestamp (when record was created - high precision)
    -- LastModified (when record was last updated)
);


-- Exercise 3.2: Time Zone Considerations
-- TODO: Create a table for a global company:

CREATE TABLE GlobalMeetings (
    MeetingID INT,
    -- TODO: Consider time zones for:
    -- MeetingDateTime (when should you store UTC vs local time?)
    -- CreatedAt (server timestamp)
    -- UserLocalTime (what time user sees)
    -- Think: How would you handle different time zones?
);


-- Exercise 3.3: Historical vs. Current Dates
-- TODO: Create tables that handle different date scenarios:

-- Historical Table (could have very old dates)
CREATE TABLE HistoricalEvents (
    EventID INT,
    -- TODO: Handle dates that could be:
    -- Very old (like 1776-07-04)
    -- Future dates (like year 2050)
    -- Unknown dates (how to handle missing dates?)
    -- Approximate dates (like "sometime in 1995")
);

-- Modern App Table (recent dates only)
CREATE TABLE UserSessions (
    SessionID INT,
    -- TODO: Track user activity with:
    -- LoginTime
    -- LastActivity  
    -- LogoutTime (might be NULL if session timeout)
);


-- =====================================================
-- SECTION 4: BOOLEAN AND BIT DATA TYPES 🟢
-- =====================================================

-- Exercise 4.1: True/False Flags
-- TODO: Create a user preferences table with many boolean options:

CREATE TABLE UserPreferences (
    UserID INT,
    -- TODO: Add boolean columns for:
    -- EmailNotifications (yes/no)
    -- SMSAlerts (yes/no)
    -- PublicProfile (yes/no)
    -- TwoFactorAuth (enabled/disabled)
    -- DarkMode (on/off)
    -- AutoSave (enabled/disabled)
    -- Consider: BIT vs BOOLEAN (if available)
);


-- Exercise 4.2: Status and State Management
-- TODO: Create a table that tracks various states:

CREATE TABLE OrderStatus (
    OrderID INT,
    -- TODO: Track order states:
    -- IsPaid (yes/no)
    -- IsShipped (yes/no)
    -- IsDelivered (yes/no)
    -- IsCancelled (yes/no)
    -- IsRefunded (yes/no)
    -- RequiresSignature (yes/no)
    -- IsGift (yes/no)
);


-- =====================================================
-- SECTION 5: LARGE DATA TYPES 🟡
-- =====================================================

-- Exercise 5.1: When to Use Large Object Types
-- TODO: Create tables that need to store large data:

CREATE TABLE DocumentStorage (
    DocumentID INT,
    -- TODO: Store different large data types:
    -- DocumentContent (large text documents)
    -- BinaryData (file contents)
    -- JsonData (complex JSON structures)
    -- XMLData (XML documents)
    -- Consider: TEXT vs VARCHAR(MAX) vs BLOB types
);


-- Exercise 5.2: Media Storage Table
-- TODO: Design for a media sharing platform:

CREATE TABLE MediaFiles (
    FileID INT,
    -- TODO: Handle different media types:
    -- FileName (reasonable size)
    -- FileDescription (could be long)
    -- FileData (actual file contents - very large)
    -- Metadata (JSON with file properties)
    -- Thumbnail (small image data)
);


-- =====================================================
-- SECTION 6: DATA TYPE CONVERSION PRACTICE 🟡
-- =====================================================

-- Exercise 6.1: Type Conversion Scenarios
-- TODO: Practice converting between data types:

-- Create a test table with various types
CREATE TABLE ConversionPractice (
    ID INT,
    NumberAsText VARCHAR(20),
    DateAsText VARCHAR(20),
    MoneyAsFloat FLOAT,
    BooleanAsInt INT
);

-- Insert test data
INSERT INTO ConversionPractice VALUES 
(1, '12345', '2024-01-15', 99.99, 1),
(2, '67890', '2024-02-20', 149.95, 0);

-- TODO: Write queries that convert:
-- NumberAsText to actual INT

-- DateAsText to actual DATE

-- MoneyAsFloat to proper DECIMAL(10,2)

-- BooleanAsInt to proper BIT/BOOLEAN


-- Exercise 6.2: Handling Invalid Conversions
-- TODO: Practice safe type conversions:

-- What happens when conversion fails?
-- Try converting 'abc' to number
-- Try converting 'not-a-date' to date
-- How to handle these gracefully?


-- =====================================================
-- SECTION 7: REAL-WORLD DATA TYPE CHALLENGES 🔴
-- =====================================================

-- Exercise 7.1: E-commerce Product Catalog
-- TODO: Design a comprehensive product table with careful data type choices:

CREATE TABLE EcommerceProducts (
    -- TODO: Consider each field carefully:
    -- ProductID (how many products might you have?)
    -- SKU (format and length?)
    -- Name (international product names?)
    -- Description (could be very detailed?)
    -- Price (exact precision needed?)
    -- Weight (shipping calculations?)
    -- Dimensions (length x width x height?)
    -- InStock (current inventory?)
    -- IsActive (available for sale?)
    -- CreatedDate (when added?)
    -- ModifiedDate (last updated?)
    -- CategoryID (reference to categories?)
    -- BrandName (brand names?)
    -- Model (model numbers/names?)
    -- Color (color names?)
    -- Size (clothing/shoe sizes?)
    -- Material (what it's made of?)
    -- CountryOfOrigin (manufacturing country?)
    -- WarrantyMonths (warranty period?)
    -- IsFragile (shipping consideration?)
    -- MinAge (age restrictions?)
    -- MaxAge (age restrictions?)
    -- Gender (target gender?)
    -- Season (seasonal products?)
    -- Tags (search tags?)
    -- Images (product photos?)
    -- Videos (product videos?)
    -- Documents (manuals, specs?)
    -- Reviews (customer reviews?)
    -- AverageRating (calculated rating?)
    -- TotalReviews (review count?)
    -- ViewCount (how many times viewed?)
    -- PurchaseCount (how many times bought?)
    -- LastPurchaseDate (most recent sale?)
);


-- Exercise 7.2: Healthcare Patient Records
-- TODO: Design patient tables with strict data type requirements:

CREATE TABLE PatientRecords (
    -- TODO: Healthcare has strict requirements:
    -- PatientID (unique identifier)
    -- MedicalRecordNumber (hospital-specific ID)
    -- FirstName (international names)
    -- LastName (international names)
    -- DateOfBirth (could be very old)
    -- Gender (various options)
    -- BloodType (specific formats)
    -- Height (precise measurements)
    -- Weight (precise, changes over time)
    -- BloodPressure (systolic/diastolic)
    -- HeartRate (beats per minute)
    -- Temperature (body temperature)
    -- Allergies (could be long list)
    -- Medications (current medications)
    -- MedicalHistory (extensive text)
    -- EmergencyContact (contact info)
    -- InsuranceInfo (insurance details)
    -- AdmissionDate (when admitted)
    -- DischargeDate (when discharged, might be null)
    -- RoomNumber (current room)
    -- AttendingPhysician (doctor name)
    -- Diagnosis (medical diagnosis)
    -- TreatmentPlan (treatment details)
    -- Notes (doctor's notes)
    -- IsActive (current patient?)
    -- CreatedBy (who created record)
    -- CreatedDate (when created)
    -- ModifiedBy (who last modified)
    -- ModifiedDate (when last modified)
);


-- Exercise 7.3: Financial Trading System
-- TODO: Design tables for high-precision financial data:

CREATE TABLE TradingTransactions (
    -- TODO: Financial data needs extreme precision:
    -- TransactionID (unique trade ID)
    -- AccountID (trading account)
    -- Symbol (stock/crypto symbol)
    -- TransactionType (buy/sell)
    -- Quantity (shares/units)
    -- Price (exact price per share)
    -- TotalAmount (total transaction value)
    -- Commission (brokerage fee)
    -- Fees (other fees)
    -- NetAmount (after fees)
    -- Currency (USD, EUR, etc.)
    -- ExchangeRate (if currency conversion)
    -- Timestamp (exact time of trade)
    -- OrderID (original order reference)
    -- ExecutionTime (how long to execute)
    -- MarketPrice (market price at time)
    -- Spread (bid-ask spread)
    -- Volume (market volume)
    -- Notes (trading notes)
    -- IsSimulated (paper trading?)
    -- Strategy (trading strategy used)
    -- ProfitLoss (P&L calculation)
    -- TaxLot (tax calculation info)
    -- SettlementDate (when trade settles)
    -- Status (pending/completed/cancelled)
);


-- =====================================================
-- SECTION 8: DATA TYPE OPTIMIZATION 🔴
-- =====================================================

-- Exercise 8.1: Storage Space Analysis
-- TODO: Compare storage requirements for different data type choices:

-- Create tables with different approaches to storing the same data
CREATE TABLE Inefficient (
    ID BIGINT,                    -- Overkill for small table
    Name VARCHAR(1000),           -- Wasteful for typical names
    Age INT,                      -- Could be TINYINT
    Price FLOAT,                  -- Imprecise for money
    IsActive VARCHAR(10),         -- Should be BIT
    CreatedDate VARCHAR(50)       -- Should be proper DATE
);

CREATE TABLE Efficient (
    ID INT,                       -- Appropriate size
    Name VARCHAR(100),            -- Reasonable for names
    Age TINYINT,                  -- Perfect for age (0-255)
    Price DECIMAL(10,2),          -- Exact for money
    IsActive BIT,                 -- Perfect for true/false
    CreatedDate DATE              -- Proper date type
);

-- TODO: Calculate storage differences between these approaches


-- Exercise 8.2: Performance Impact of Data Types
-- TODO: Consider how data type choices affect performance:

-- Think about:
-- 1. Index size differences
-- 2. Memory usage in queries
-- 3. Network transfer costs
-- 4. Backup/restore time
-- 5. Replication overhead

-- Write your analysis as comments:


-- =====================================================
-- SECTION 9: VALIDATION AND CONSTRAINTS 🟡
-- =====================================================

-- Exercise 9.1: Data Type with Built-in Validation
-- TODO: Use data types that provide automatic validation:

CREATE TABLE ValidatedData (
    ID INT,
    -- TODO: Use data types that enforce rules:
    -- Email (what validates email format?)
    -- URL (what validates URL format?)
    -- PhoneNumber (international phone formats?)
    -- CreditCard (credit card number format?)
    -- SSN (social security number format?)
    -- PostalCode (postal code formats?)
);


-- Exercise 9.2: Custom Validation with Check Constraints
-- TODO: Combine data types with check constraints:

CREATE TABLE ConstrainedData (
    ID INT,
    -- TODO: Add constraints that work with data types:
    -- Age (TINYINT with CHECK for reasonable range)
    -- Email (VARCHAR with CHECK for @ symbol)
    -- Rating (DECIMAL with CHECK for 1.0-5.0 range)
    -- Percentage (DECIMAL with CHECK for 0-100 range)
    -- Price (DECIMAL with CHECK for positive values)
);


-- =====================================================
-- SECTION 10: COMPATIBILITY AND MIGRATION 🔴
-- =====================================================

-- Exercise 10.1: Cross-Database Data Type Mapping
-- TODO: Research how your data types map to other databases:

-- Create a reference table showing equivalent types:
CREATE TABLE DataTypeMapping (
    ConceptName VARCHAR(100),
    SQLServer VARCHAR(50),
    MySQL VARCHAR(50),
    PostgreSQL VARCHAR(50),
    Oracle VARCHAR(50),
    SQLite VARCHAR(50)
);

-- TODO: Fill in mappings for common types:
-- INSERT INTO DataTypeMapping VALUES 
-- ('Small Integer', 'TINYINT', 'TINYINT', 'SMALLINT', 'NUMBER(3)', 'INTEGER');
-- Add more mappings...


-- Exercise 10.2: Migration Planning
-- TODO: Plan a data type migration scenario:

-- Old table with poor data type choices
CREATE TABLE OldCustomers (
    ID VARCHAR(20),           -- Should be INT
    Name VARCHAR(20),         -- Too small
    Email VARCHAR(30),        -- Too small
    Phone VARCHAR(15),        -- Might be okay
    JoinDate VARCHAR(20),     -- Should be DATE
    IsVIP VARCHAR(5),         -- Should be BIT
    Balance VARCHAR(20)       -- Should be DECIMAL
);

-- TODO: Design the migration to better data types:
CREATE TABLE NewCustomers (
    -- Design improved version here
);

-- TODO: Write the migration strategy:
-- 1. How to convert the data?
-- 2. How to handle invalid data?
-- 3. How to minimize downtime?
-- 4. How to roll back if needed?


-- =====================================================
-- VERIFICATION AND TESTING 🟢
-- =====================================================

-- Exercise 11.1: Test Your Data Type Choices
-- TODO: Create comprehensive tests for your tables:

-- Test 1: Insert valid data into each table
-- Test 2: Try to insert invalid data (should fail)
-- Test 3: Test boundary conditions (max/min values)
-- Test 4: Test NULL handling
-- Test 5: Test performance with realistic data volumes


-- Exercise 11.2: Document Your Decisions
-- TODO: For each table you created, document:
-- 1. Why you chose each data type
-- 2. What alternatives you considered
-- 3. What assumptions you made about the data
-- 4. How the choices might need to change as requirements evolve

-- Write your documentation here:


-- =====================================================
-- CLEANUP SECTION 🧹
-- =====================================================

-- TODO: Drop all practice tables if you want to clean up:
-- (Uncomment only if you want to remove everything)

/*
DROP TABLE IF EXISTS NumericDemo;
DROP TABLE IF EXISTS FurnitureInventory;
DROP TABLE IF EXISTS BankAccounts;
DROP TABLE IF EXISTS PlayerStats;
DROP TABLE IF EXISTS SocialMediaPosts;
DROP TABLE IF EXISTS ProductCodes;
DROP TABLE IF EXISTS InternationalCustomers;
DROP TABLE IF EXISTS EventSchedule;
DROP TABLE IF EXISTS GlobalMeetings;
DROP TABLE IF EXISTS HistoricalEvents;
DROP TABLE IF EXISTS UserSessions;
DROP TABLE IF EXISTS UserPreferences;
DROP TABLE IF EXISTS OrderStatus;
DROP TABLE IF EXISTS DocumentStorage;
DROP TABLE IF EXISTS MediaFiles;
DROP TABLE IF EXISTS ConversionPractice;
DROP TABLE IF EXISTS EcommerceProducts;
DROP TABLE IF EXISTS PatientRecords;
DROP TABLE IF EXISTS TradingTransactions;
DROP TABLE IF EXISTS Inefficient;
DROP TABLE IF EXISTS Efficient;
DROP TABLE IF EXISTS ValidatedData;
DROP TABLE IF EXISTS ConstrainedData;
DROP TABLE IF EXISTS DataTypeMapping;
DROP TABLE IF EXISTS OldCustomers;
DROP TABLE IF EXISTS NewCustomers;
*/


-- =====================================================
-- REFLECTION QUESTIONS 💭
-- =====================================================

-- After completing these exercises, consider:
-- 1. How do business requirements influence data type choices?
-- 2. What's the balance between being precise and being flexible?
-- 3. How do you plan for future growth in your data type decisions?
-- 4. When is it worth changing data types in existing tables?
-- 5. How do you handle international and cultural differences in data?

-- Write your thoughts here:


-- =====================================================
-- NEXT STEPS 🚀
-- =====================================================

-- Once you've mastered data types:
-- 1. Check solutions in: solutions/03_DataTypes_Solutions.sql
-- 2. Move on to: 04_Modify_Practice.sql (table modifications)
-- 3. Start thinking about data relationships between tables
-- 4. Consider how data types affect indexing and performance

-- Excellent work mastering the foundation of all database design!