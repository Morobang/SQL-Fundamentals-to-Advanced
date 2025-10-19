-- Module 01: Create Database and Tables
-- 01_Database_Practice.sql - Database Creation Practice

-- Instructions: Complete these exercises to master database creation and management
-- Difficulty: 🟢 Beginner to 🟡 Intermediate
-- Prerequisites: Read 01_Teaching/01_Creating_Database.md

-- =====================================================
-- SECTION 1: BASIC DATABASE CREATION 🟢
-- =====================================================

-- Exercise 1.1: Create Your Personal Database
-- TODO: Create a database with your name (e.g., "TshigidimasaDB")


-- Exercise 1.2: Switch to Your Database
-- TODO: Write the command to use your new personal database


-- Exercise 1.3: Verify Current Database
-- TODO: Write a query to display the name of the current database you're using


-- Exercise 1.4: Create Project Databases
-- TODO: Create databases for these scenarios:
-- - A library management system
-- - A restaurant point-of-sale system
-- - A personal fitness tracker


-- =====================================================
-- SECTION 2: DATABASE NAMING PRACTICE 🟢
-- =====================================================

-- Exercise 2.1: Fix Bad Database Names
-- TODO: The following database names are poorly chosen. 
-- For each bad name, write a CREATE DATABASE statement with a better name:

-- Bad names to improve:
-- "My Database"
-- "123Sales"
-- "Data&Analytics"
-- "temp"

-- Your improved CREATE DATABASE statements:


-- Exercise 2.2: Choose Appropriate Names
-- TODO: Create databases with good names for these business scenarios:
-- - Online bookstore
-- - Hospital patient management
-- - School grade tracking
-- - Real estate property listings
-- - Social media platform


-- =====================================================
-- SECTION 3: DATABASE EXPLORATION 🟢
-- =====================================================

-- Exercise 3.1: List All Your Databases
-- TODO: Write a query to show all databases you've created (exclude system databases)


-- Exercise 3.2: Database Information
-- TODO: Write a query to show:
-- - Current database name
-- - Current date and time
-- - Your username


-- Exercise 3.3: Count Your Databases
-- TODO: Write a query to count how many databases you've created today


-- =====================================================
-- SECTION 4: WORKING WITH MULTIPLE DATABASES 🟡
-- =====================================================

-- Exercise 4.1: Database Switching Practice
-- TODO: Complete this sequence:
-- 1. Create a database called "TestDB1"
-- 2. Switch to TestDB1
-- 3. Verify you're in TestDB1
-- 4. Create a database called "TestDB2" 
-- 5. Switch to TestDB2
-- 6. Verify you're in TestDB2
-- 7. Switch back to TestDB1


-- Exercise 4.2: Database Creation Pattern
-- TODO: Write a reusable pattern that:
-- 1. Checks if a database exists
-- 2. Creates it only if it doesn't exist
-- 3. Switches to using it
-- 4. Confirms you're connected
-- Test your pattern with a database called "PatternTestDB"


-- =====================================================
-- SECTION 5: SAFE DATABASE MANAGEMENT 🟡
-- =====================================================

-- Exercise 5.1: Safe Database Deletion
-- TODO: Write commands to safely delete these databases (check if they exist first):
-- - Any test databases you created
-- - A database that might not exist called "NonExistentDB"


-- Exercise 5.2: Database Cleanup
-- TODO: Create a cleanup script that:
-- 1. Lists all databases with "Test" in the name
-- 2. Safely drops all test databases you created
-- 3. Confirms they were deleted


-- =====================================================
-- SECTION 6: REAL-WORLD SCENARIOS 🟡
-- =====================================================

-- Scenario 6.1: Development Environment Setup
-- TODO: A software company needs databases for different environments:
-- - Development environment for testing new features
-- - Staging environment for final testing
-- - Training environment for new employees
-- Create appropriately named databases for each environment

-- Project name: "CustomerPortal"
-- Your database names:


-- Scenario 6.2: Multi-Client Database Setup
-- TODO: A consulting company manages databases for multiple clients:
-- - ABC Manufacturing (inventory system)
-- - XYZ Hospital (patient records)
-- - Tech StartUp Inc (user management)
-- Create databases with names that identify both client and purpose


-- =====================================================
-- SECTION 7: ADVANCED DATABASE CREATION 🔴
-- =====================================================

-- Exercise 7.1: Database with Specific Settings
-- TODO: Create a database called "InternationalDB" with:
-- - Appropriate collation for international characters
-- - Research what collation settings mean and choose one


-- Exercise 7.2: Database Validation Script
-- TODO: Write a script that:
-- 1. Takes a database name as input
-- 2. Checks if it follows good naming conventions
-- 3. Creates the database if the name is valid
-- 4. Provides feedback on why a name might be invalid


-- =====================================================
-- SECTION 8: TROUBLESHOOTING PRACTICE 🟡
-- =====================================================

-- Exercise 8.1: Handle Creation Errors
-- TODO: Write code that handles these scenarios gracefully:
-- 1. Trying to create a database that already exists
-- 2. Trying to use a database that doesn't exist
-- 3. Checking if you have permission to create databases


-- Exercise 8.2: Database Recovery Scenario
-- TODO: Imagine you accidentally deleted a database. Write steps to:
-- 1. Check if the database really is gone
-- 2. Recreate it with the same name
-- 3. Document what happened for future reference


-- =====================================================
-- VERIFICATION SECTION ✅
-- =====================================================

-- Check Your Work:
-- 1. List all databases you created during this practice
SELECT name AS MyDatabases 
FROM sys.databases 
WHERE name NOT IN ('master', 'tempdb', 'model', 'msdb')
ORDER BY name;

-- 2. Count how many you created
SELECT COUNT(*) AS DatabasesCreated
FROM sys.databases 
WHERE name NOT IN ('master', 'tempdb', 'model', 'msdb');

-- 3. Show current database
SELECT DB_NAME() AS CurrentDatabase, GETDATE() AS CompletionTime;


-- =====================================================
-- REFLECTION QUESTIONS 💭
-- =====================================================

-- After completing these exercises, consider:
-- 1. What makes a good database name?
-- 2. Why is it important to check if a database exists before creating/dropping it?
-- 3. How would you organize databases for a large company with multiple projects?
-- 4. What are the risks of not following naming conventions?

-- Write your thoughts as comments here:


-- =====================================================
-- NEXT STEPS 🚀
-- =====================================================

-- Once you're comfortable with database creation:
-- 1. Check your solutions in: solutions/01_Database_Solutions.sql
-- 2. Move on to: 02_Tables_Practice.sql
-- 3. Keep practicing until database creation feels natural!

-- Remember: These databases will be used in future exercises,
-- so don't delete them unless you're sure you're done practicing!