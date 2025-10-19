-- Module 01: Create Database and Tables
-- 02_Tables_Practice.sql - Table Creation Practice

-- Instructions: Complete these exercises to master table creation and design
-- Difficulty: 🟢 Beginner to 🔴 Advanced
-- Prerequisites: Read 01_Teaching/02_Creating_Tables.md

-- Make sure you're in a practice database first
USE TshigidimasaDB;  -- Change to your personal database name

-- =====================================================
-- SECTION 1: BASIC TABLE CREATION 🟢
-- =====================================================

-- Exercise 1.1: Simple Student Table
-- TODO: Create a table called "Students" with these columns:
-- - StudentID (integer)
-- - FirstName (variable text, max 50 characters)
-- - LastName (variable text, max 50 characters)
-- - Email (variable text, max 100 characters)
-- - DateOfBirth (date only)


-- Exercise 1.2: Product Catalog Table
-- TODO: Create a table called "Products" with these columns:
-- - ProductID (integer)
-- - ProductName (variable text, max 200 characters)
-- - Price (decimal with 2 decimal places, up to $99,999.99)
-- - InStock (integer)
-- - IsActive (true/false value)


-- Exercise 1.3: Employee Information Table
-- TODO: Create a table called "Employees" with columns for:
-- - Employee ID, First Name, Last Name, Hire Date, Salary, Department


-- =====================================================
-- SECTION 2: DATA TYPE SELECTION PRACTICE 🟡
-- =====================================================

-- Exercise 2.1: Library Books Table
-- TODO: Create a "LibraryBooks" table with appropriate data types for:
-- - BookID (unique identifier)
-- - Title (book titles can be long)
-- - Author (author names)
-- - ISBN (always 13 characters)
-- - PublicationYear (year published)
-- - PageCount (number of pages)
-- - IsAvailable (checked out or not)
-- - DateAdded (when book was added to library)

-- Think carefully about the data type and size for each column!


-- Exercise 2.2: Customer Orders Table
-- TODO: Create a "CustomerOrders" table for an e-commerce site:
-- - OrderID (unique identifier)
-- - CustomerID (reference to customer)
-- - OrderDate (date only)
-- - OrderTime (time only)
-- - TotalAmount (money with cents)
-- - ShippingAddress (can be long)
-- - OrderStatus (short text like "Pending", "Shipped")
-- - IsRushOrder (yes/no flag)


-- Exercise 2.3: Social Media Posts Table
-- TODO: Create a "SocialPosts" table with columns for:
-- - PostID, UserID, PostContent (can be very long), PostDateTime,
--   LikeCount, ShareCount, IsPublic, HashTags


-- =====================================================
-- SECTION 3: NAMING CONVENTIONS PRACTICE 🟢
-- =====================================================

-- Exercise 3.1: Fix Bad Table and Column Names
-- TODO: The following table has poor naming. Recreate it with better names:

CREATE TABLE bad_example (
    id INT,
    fn VARCHAR(10),
    ln VARCHAR(10),
    em VARCHAR(20),
    ph INT,
    addr TEXT
);

-- Create a properly named version called "CustomerContacts":


-- Drop the bad example
DROP TABLE bad_example;


-- Exercise 3.2: Consistent Naming Practice
-- TODO: Create these three tables with consistent naming conventions:
-- Tables needed: Users, User Posts, User Comments
-- Choose either singular or plural naming and stick with it
-- Use either PascalCase or snake_case consistently


-- =====================================================
-- SECTION 4: REAL-WORLD TABLE DESIGN 🟡
-- =====================================================

-- Exercise 4.1: Restaurant Menu System
-- TODO: Design tables for a restaurant:

-- Table 1: MenuItems
-- Include: ID, item name, description, price, category (appetizer/main/dessert),
-- preparation time, calories, dietary flags (vegetarian, gluten-free)

-- Table 2: RestaurantTables  
-- Include: table ID, table number, seating capacity, location (indoor/patio)

-- Table 3: Reservations
-- Include: reservation ID, customer info, table ID, date, time, party size


-- Exercise 4.2: School Management System
-- TODO: Design tables for a school:

-- Table 1: Students
-- Include: comprehensive student information, emergency contacts

-- Table 2: Courses
-- Include: course details, prerequisites, credit hours

-- Table 3: Enrollments
-- Include: which students are enrolled in which courses, grades


-- =====================================================
-- SECTION 5: INTERNATIONAL CONSIDERATIONS 🟡
-- =====================================================

-- Exercise 5.1: Global Customer Table
-- TODO: Create a "GlobalCustomers" table that can handle:
-- - International names (Unicode support)
-- - Various address formats
-- - Different phone number formats
-- - Multiple currencies
-- - Different date formats
-- Think about what data types support international characters


-- Exercise 5.2: Multi-Language Product Catalog
-- TODO: Create a "InternationalProducts" table that supports:
-- - Product names in multiple languages
-- - Descriptions in various character sets
-- - Prices in different currencies
-- - International shipping considerations


-- =====================================================
-- SECTION 6: TABLE STRUCTURE ANALYSIS 🟢
-- =====================================================

-- Exercise 6.1: Examine Table Structures
-- TODO: Write queries to examine the tables you've created:

-- List all tables in current database:


-- Show structure of your Students table:


-- Show structure of your Products table:


-- Exercise 6.2: Table Information Summary
-- TODO: Create a query that shows for each table you created:
-- - Table name
-- - Number of columns
-- - Column names and data types


-- =====================================================
-- SECTION 7: ADVANCED TABLE SCENARIOS 🔴
-- =====================================================

-- Exercise 7.1: E-commerce Platform Tables
-- TODO: Design a comprehensive e-commerce system with tables for:
-- - Products (with variations like size, color)
-- - Customers (with multiple addresses)
-- - Orders (with multiple items per order)
-- - Reviews (products can have many reviews)
-- - Categories (products belong to categories)

-- Create at least 5 related tables with thoughtful column design


-- Exercise 7.2: Hospital Management System
-- TODO: Design tables for a hospital:
-- - Patients (personal info, medical history considerations)
-- - Doctors (specializations, schedules)
-- - Appointments (date, time, duration)
-- - Medical Records (visit notes, prescriptions)
-- - Insurance (insurance provider information)

-- Consider privacy, security, and regulatory requirements


-- Exercise 7.3: Financial Trading Platform
-- TODO: Design tables for tracking:
-- - User accounts and portfolios
-- - Stock information and prices
-- - Buy/sell transactions
-- - Account balances and transaction history
-- Think about precision requirements for financial data


-- =====================================================
-- SECTION 8: OPTIMIZATION AND BEST PRACTICES 🟡
-- =====================================================

-- Exercise 8.1: Table Design Review
-- TODO: Review one of your complex tables and answer:
-- 1. Are all column names descriptive?
-- 2. Are data types appropriate for the data they'll hold?
-- 3. Are text fields sized reasonably (not too small, not wasteful)?
-- 4. Are there columns you might need in the future?
-- 5. Does the table follow consistent naming conventions?

-- Choose one table and write your analysis as comments:


-- Exercise 8.2: Table Redesign Challenge
-- TODO: Take this poorly designed table and recreate it properly:

CREATE TABLE terrible_design (
    i INT,
    n VARCHAR(5),     -- Name field too small!
    a INT,            -- Age as INT is fine, but terrible name
    e VARCHAR(20),    -- Email field too small!
    p FLOAT,          -- Using FLOAT for money - bad!
    d VARCHAR(10),    -- Date as VARCHAR - bad!
    f INT             -- Flag as INT instead of BIT
);

-- Create a properly designed version:
-- TODO: Create "ProperlyDesigned" table with good column names, 
-- appropriate data types, and reasonable sizing


-- Drop the terrible example
DROP TABLE terrible_design;


-- =====================================================
-- VERIFICATION SECTION ✅
-- =====================================================

-- Check Your Work:

-- 1. Count how many tables you created
SELECT COUNT(*) AS TablesCreated
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_TYPE = 'BASE TABLE'
  AND TABLE_CATALOG = DB_NAME();

-- 2. List all your tables with column counts
SELECT 
    TABLE_NAME,
    (SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = t.TABLE_NAME) AS ColumnCount
FROM INFORMATION_SCHEMA.TABLES t
WHERE TABLE_TYPE = 'BASE TABLE'
  AND TABLE_CATALOG = DB_NAME()
ORDER BY TABLE_NAME;

-- 3. Show data types you used
SELECT DISTINCT DATA_TYPE, COUNT(*) AS UsageCount
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_CATALOG = DB_NAME()
GROUP BY DATA_TYPE
ORDER BY UsageCount DESC;


-- =====================================================
-- REFLECTION QUESTIONS 💭
-- =====================================================

-- After completing these exercises, consider:
-- 1. What factors influence your choice of data type for a column?
-- 2. How do you balance being generous with field sizes vs. not being wasteful?
-- 3. What makes table and column names good vs. bad?
-- 4. How do you think about tables that need to handle international data?
-- 5. What patterns do you notice in designing tables for different industries?

-- Write your thoughts as comments here:


-- =====================================================
-- NEXT STEPS 🚀
-- =====================================================

-- Once you're comfortable with table creation:
-- 1. Check your solutions in: solutions/02_Tables_Solutions.sql
-- 2. Move on to: 03_DataTypes_Practice.sql
-- 3. Start thinking about how these tables might connect to each other

-- Great job building the foundation of your database design skills!