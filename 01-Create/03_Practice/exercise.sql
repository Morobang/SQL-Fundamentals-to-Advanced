-- Module 01: Create Database and Tables
-- Practice Exercises

-- Instructions: Complete the SQL tasks below to practice database and table creation
-- Check your answers in the solutions folder when done

-- =====================================================
-- WARM-UP EXERCISES - Database Creation
-- =====================================================

-- Exercise 1: Create Your Personal Database
-- TODO: Create a database named "MyPersonalDB" (or use your name)


-- Exercise 2: Switch to Your Database
-- TODO: Write the command to use your new database


-- Exercise 3: Verify Current Database
-- TODO: Write a query to display the name of the current database


-- =====================================================
-- BASIC TABLE CREATION EXERCISES
-- =====================================================

-- Exercise 4: Create a Simple Movies Table
-- TODO: Create a table called "Movies" with these columns:
-- - MovieID (integer)
-- - Title (variable text, max 200 characters)
-- - Director (variable text, max 100 characters)
-- - ReleaseYear (integer)
-- - Rating (decimal with 1 decimal place, like 8.5)


-- Exercise 5: Create a Bookstore Table
-- TODO: Create a table called "Books" with these columns:
-- - BookID (integer)
-- - Title (variable text, max 250 characters)
-- - Author (variable text, max 100 characters)
-- - ISBN (fixed text, exactly 13 characters)
-- - Price (decimal with 2 decimal places)
-- - PublicationDate (date only)
-- - IsAvailable (true/false value)


-- =====================================================
-- DATA TYPE SELECTION EXERCISES
-- =====================================================

-- Exercise 6: Choose Appropriate Data Types
-- TODO: Create a table called "Students" with appropriate data types for:
-- - StudentID (unique number for each student)
-- - FirstName (student's first name)
-- - LastName (student's last name)
-- - Email (email address)
-- - DateOfBirth (birth date)
-- - GPA (grade point average, like 3.75)
-- - IsActive (whether student is currently enrolled)
-- - EnrollmentDate (when they enrolled, including time)
-- - MiddleInitial (just one letter)
-- - Notes (long text for advisor notes)


-- Exercise 7: Sports Team Database
-- TODO: Create a table called "Players" for a sports team:
-- - PlayerID (unique identifier)
-- - FirstName (player's first name)
-- - LastName (player's last name)
-- - JerseyNumber (small integer, 1-99)
-- - Position (short text code like "QB", "RB")
-- - Height (in inches, whole number)
-- - Weight (in pounds, whole number)
-- - DateOfBirth (birth date)
-- - Salary (money amount with cents)
-- - IsActive (playing this season?)
-- - ContractEndDate (when contract expires)


-- =====================================================
-- TABLE MODIFICATION EXERCISES
-- =====================================================

-- Exercise 8: Add Columns to Movies Table
-- TODO: Add these columns to your Movies table:
-- - Genre (variable text, max 50 characters)
-- - DurationMinutes (integer for movie length)


-- Exercise 9: Modify Column Size
-- TODO: Change the Director column in Movies table to allow 150 characters instead of 100


-- Exercise 10: Remove a Column
-- TODO: Remove the DurationMinutes column from the Movies table


-- =====================================================
-- REAL-WORLD SCENARIO EXERCISES
-- =====================================================

-- Exercise 11: Employee Management System
-- TODO: Create a comprehensive "Employees" table for a company:
-- Include columns for: ID, names, contact info, hire date, salary, department, 
-- manager info, and any other fields you think a company would need
-- Choose appropriate data types for each column


-- Exercise 12: Inventory Management System
-- TODO: Create a "Products" table for a retail store:
-- Include: product identification, description, pricing, stock levels,
-- supplier info, dates, and status flags
-- Think about what data types make sense for inventory tracking


-- Exercise 13: Library System
-- TODO: Create a "LibraryBooks" table with these requirements:
-- - Unique book identifier
-- - Book details (title, author, ISBN, publication info)
-- - Physical details (pages, format)
-- - Library management (acquisition date, condition, location)
-- - Availability status
-- Choose appropriate data types and consider realistic field sizes


-- =====================================================
-- SCHEMA EXPLORATION EXERCISES
-- =====================================================

-- Exercise 14: Examine Your Work
-- TODO: Write queries to:
-- a) List all tables you've created in this database
-- b) Show the structure of your "Movies" table
-- c) Show the structure of your "Students" table


-- Exercise 15: Table Information Query
-- TODO: Write a query to show column names, data types, and maximum lengths
-- for all columns in your "Employees" table


-- =====================================================
-- DESIGN CHALLENGE EXERCISES
-- =====================================================

-- Exercise 16: Restaurant System Design
-- TODO: Design and create tables for a restaurant management system:
-- Think about: Menu items, customers, orders, staff, tables, reservations
-- Create at least 3 related tables with appropriate columns and data types


-- Exercise 17: School Management System
-- TODO: Design tables for a school system:
-- Consider: Students, teachers, courses, classrooms, schedules, grades
-- Create at least 4 tables with thoughtful column choices


-- =====================================================
-- CLEANUP AND SAFETY EXERCISES
-- =====================================================

-- Exercise 18: Safe Table Removal
-- TODO: Write commands to safely drop the "LibraryBooks" table
-- (Check if it exists first, then drop it)


-- Exercise 19: Recreate and Improve
-- TODO: Drop and recreate your "Movies" table with these improvements:
-- - Add a "Budget" column (decimal for movie budget)
-- - Add a "BoxOffice" column (decimal for earnings)
-- - Make sure Title allows 300 characters
-- - Add a "Country" column (variable text, max 50 characters)


-- =====================================================
-- BONUS CHALLENGES
-- =====================================================

-- Bonus Challenge 1: Complex Data Types
-- TODO: Create a "UserProfiles" table that includes:
-- - All common personal information
-- - Timestamps for creation and last modification
-- - Multiple contact methods
-- - Preference settings
-- - Account status indicators
-- Focus on choosing the most appropriate data type for each field


-- Bonus Challenge 2: International Considerations
-- TODO: Create a "Customers" table designed for international use:
-- Consider how to handle different address formats, phone number formats,
-- currency types, date formats, and character sets
-- Research and implement appropriate data types and sizes


-- Bonus Challenge 3: Audit and History
-- TODO: Create an "AuditTrail" table that could track changes to other tables:
-- Think about what information you'd need to track who changed what and when
-- Design columns that could store before/after values


-- =====================================================
-- HINTS SECTION
-- =====================================================

-- Hint for Exercise 4: Use INT, VARCHAR(200), VARCHAR(100), INT, DECIMAL(3,1)
-- Hint for Exercise 6: Email should be VARCHAR(255), GPA should be DECIMAL(3,2)
-- Hint for Exercise 8: Use ALTER TABLE Movies ADD ColumnName DataType;
-- Hint for Exercise 9: Use ALTER TABLE Movies ALTER COLUMN Director VARCHAR(150);
-- Hint for Exercise 14a: Use INFORMATION_SCHEMA.TABLES
-- Hint for Exercise 14b: Use INFORMATION_SCHEMA.COLUMNS
-- Hint for Exercise 18: Use IF OBJECT_ID('TableName', 'U') IS NOT NULL

-- Remember: Think about realistic data sizes and appropriate precision for numbers!
