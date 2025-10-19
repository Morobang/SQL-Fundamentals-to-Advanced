-- Module 01: Create Database and Tables
-- 01_Create_Database.sql - Database Creation Examples

-- Purpose: Learn to create, manage, and work with databases
-- Teaching Reference: See 01_Teaching/01_Creating_Database.md

-- =====================================================
-- SECTION 1: BASIC DATABASE CREATION
-- =====================================================

-- Example 1: Simple Database Creation
CREATE DATABASE LearningSQL;

-- Example 2: Create a Database for Different Projects
CREATE DATABASE CompanyHR;
CREATE DATABASE RetailStore;
CREATE DATABASE PersonalFinance;


-- =====================================================
-- SECTION 2: WORKING WITH DATABASES
-- =====================================================

-- Example 3: Switch to a Specific Database
USE LearningSQL;

-- Example 4: Check Which Database You're Currently Using
SELECT DB_NAME() AS CurrentDatabase;

-- Example 5: Create and Switch in One Session
CREATE DATABASE ProjectTracker;
USE ProjectTracker;
SELECT DB_NAME() AS CurrentDatabase;  -- Should show "ProjectTracker"


-- =====================================================
-- SECTION 3: DATABASE NAMING EXAMPLES
-- =====================================================

-- Example 6: Good Database Naming Patterns
CREATE DATABASE SalesAnalytics;      -- Clear purpose
CREATE DATABASE InventoryManagement; -- Descriptive
CREATE DATABASE UserAuthentication;  -- Specific function

-- Example 7: Different Naming Conventions
-- PascalCase (recommended)
CREATE DATABASE CustomerRelations;
CREATE DATABASE ProductCatalog;

-- snake_case (alternative)
CREATE DATABASE customer_relations;
CREATE DATABASE product_catalog;


-- =====================================================
-- SECTION 4: EXPLORING DATABASES
-- =====================================================

-- Example 8: List All Databases on Your System
-- SQL Server method:
SELECT name AS DatabaseName 
FROM sys.databases
WHERE name NOT IN ('master', 'tempdb', 'model', 'msdb')  -- Hide system databases
ORDER BY name;

-- Alternative for different SQL systems:
-- MySQL: SHOW DATABASES;
-- PostgreSQL: \l


-- =====================================================
-- SECTION 5: DATABASE WITH SPECIFIC SETTINGS
-- =====================================================

-- Example 9: Database with Collation (Character Set Rules)
CREATE DATABASE InternationalDB
COLLATE SQL_Latin1_General_CP1_CI_AS;  -- Case-insensitive, accent-sensitive

-- Example 10: Database for Specific Region
CREATE DATABASE EuropeanSales
COLLATE SQL_Latin1_General_CP1_CI_AS;


-- =====================================================
-- SECTION 6: PRACTICAL EXERCISE SEQUENCE
-- =====================================================

-- Exercise Sequence: Create Your Practice Environment

-- Step 1: Create your personal database
CREATE DATABASE [YourName]_Practice;  -- Replace [YourName] with your actual name
-- Example: CREATE DATABASE Tshigidimisa_Practice;

-- Step 2: Switch to your database
USE [YourName]_Practice;

-- Step 3: Verify you're in the right place
SELECT DB_NAME() AS MyCurrentDatabase;

-- Step 4: Check what databases you now have
SELECT name AS MyDatabases 
FROM sys.databases
WHERE name LIKE '%Practice%' OR name LIKE '%Learning%'
ORDER BY name;


-- =====================================================
-- SECTION 7: SAFE DATABASE DELETION
-- =====================================================

-- Example 11: Check if Database Exists Before Dropping
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'TestDatabase')
BEGIN
    -- Make sure we're not in the database we want to drop
    USE master;
    DROP DATABASE TestDatabase;
    PRINT 'TestDatabase has been dropped successfully.';
END
ELSE
BEGIN
    PRINT 'TestDatabase does not exist.';
END

-- Example 12: Safe Cleanup of Practice Databases
-- First, switch to master database
USE master;

-- Drop test databases if they exist
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'RetailStore')
    DROP DATABASE RetailStore;

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'PersonalFinance')
    DROP DATABASE PersonalFinance;


-- =====================================================
-- SECTION 8: DATABASE CREATION BEST PRACTICES
-- =====================================================

-- Example 13: Complete Database Setup Pattern
-- Step 1: Check if database already exists
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'BestPracticeDB')
BEGIN
    -- Step 2: Create database
    CREATE DATABASE BestPracticeDB;
    PRINT 'BestPracticeDB created successfully.';
END
ELSE
BEGIN
    PRINT 'BestPracticeDB already exists.';
END

-- Step 3: Switch to the database
USE BestPracticeDB;

-- Step 4: Verify connection
SELECT 
    DB_NAME() AS CurrentDatabase,
    GETDATE() AS ConnectionTime,
    USER_NAME() AS ConnectedAs;


-- =====================================================
-- SECTION 9: REAL-WORLD SCENARIOS
-- =====================================================

-- Scenario 1: Setting up databases for a small business
CREATE DATABASE Accounting_2024;
CREATE DATABASE CustomerData;
CREATE DATABASE InventoryTracking;
CREATE DATABASE EmployeeRecords;

-- Scenario 2: Development environment setup
CREATE DATABASE MyProject_Development;
CREATE DATABASE MyProject_Testing;
-- Note: Production database would be created by database administrator

-- Scenario 3: Learning environment with multiple modules
CREATE DATABASE SQL_Module01_Practice;
CREATE DATABASE SQL_Module02_Practice;
CREATE DATABASE SQL_Advanced_Practice;


-- =====================================================
-- SECTION 10: TROUBLESHOOTING EXAMPLES
-- =====================================================

-- Example 14: What to do if database creation fails
-- Common issue: Database already exists
-- Solution: Check first, then decide
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'MyNewDatabase')
BEGIN
    PRINT 'Database MyNewDatabase already exists. Choose a different name or drop the existing one.';
END
ELSE
BEGIN
    CREATE DATABASE MyNewDatabase;
    PRINT 'Database MyNewDatabase created successfully.';
END

-- Example 15: Handling permission issues
-- If you get permission errors, you might need:
-- 1. Administrator privileges
-- 2. Proper database server connection
-- 3. Correct authentication

-- Check your permissions:
SELECT 
    HAS_PERMS_BY_NAME(null, null, 'CREATE DATABASE') AS CanCreateDatabase,
    IS_SRVROLEMEMBER('dbcreator') AS IsDatabaseCreator,
    IS_SRVROLEMEMBER('sysadmin') AS IsSystemAdmin;


-- =====================================================
-- YOUR PRACTICE AREA
-- =====================================================

-- TODO: Create a database for your own project
-- Ideas: PersonalBudget, RecipeCollection, BookLibrary, MovieTracker
-- 
-- Your code here:


-- Remember to check your work:
-- 1. Use your new database
-- 2. Verify you're connected to it
-- 3. List your databases to see what you've created

-- Related files:
-- Teaching: 01_Teaching/01_Creating_Database.md
-- Next: 02_Create_Table.sql