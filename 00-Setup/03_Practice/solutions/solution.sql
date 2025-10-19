-- Module 00: Setup and Fundamentals
-- Exercise Solutions

-- =====================================================
-- SETUP VERIFICATION SOLUTIONS
-- =====================================================

-- Solution 1: Environment Check
-- SQL Server:
SELECT @@VERSION AS DatabaseVersion;

-- MySQL:
-- SELECT VERSION() AS DatabaseVersion;

-- PostgreSQL:
-- SELECT version() AS DatabaseVersion;


-- Solution 2: Create Your Personal Database
CREATE DATABASE TshigidimasaDB;
-- Note: Replace "TshigidimasaDB" with your own name


-- Solution 3: Switch to Your Database
USE TshigidimasaDB;


-- =====================================================
-- FIRST TABLE SOLUTIONS
-- =====================================================

-- Solution 4: Create a "Books" Table
CREATE TABLE Books (
    BookID INT,
    Title VARCHAR(200),
    Author VARCHAR(100),
    PublishedYear INT,
    Price DECIMAL(10,2)
);


-- Solution 5: Add Sample Books
INSERT INTO Books VALUES (1, 'To Kill a Mockingbird', 'Harper Lee', 1960, 12.99);
INSERT INTO Books VALUES (2, 'The Great Gatsby', 'F. Scott Fitzgerald', 1925, 10.50);
INSERT INTO Books VALUES (3, 'Harry Potter and the Sorcerer''s Stone', 'J.K. Rowling', 1997, 15.99);
INSERT INTO Books VALUES (4, 'The Catcher in the Rye', 'J.D. Salinger', 1951, 13.25);
INSERT INTO Books VALUES (5, 'A Game of Thrones', 'George R.R. Martin', 1996, 18.99);


-- Solution 6: View Your Data
SELECT * FROM Books;


-- =====================================================
-- BASIC QUERY SOLUTIONS
-- =====================================================

-- Solution 7: Selective Display
SELECT Title, Author FROM Books;


-- Solution 8: Filter by Year
SELECT * FROM Books WHERE PublishedYear > 2000;


-- Solution 9: Sort Your Books
SELECT * FROM Books ORDER BY Title;


-- Solution 10: Count Your Collection
SELECT COUNT(*) AS TotalBooks FROM Books;


-- =====================================================
-- EXPLORATION SOLUTIONS
-- =====================================================

-- Solution 11: Database Exploration
-- SQL Server:
SELECT name AS DatabaseName FROM sys.databases;

-- MySQL:
-- SHOW DATABASES;

-- PostgreSQL:
-- SELECT datname AS DatabaseName FROM pg_database;


-- Solution 12: Table Exploration
-- SQL Server:
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE';

-- MySQL:
-- SHOW TABLES;

-- PostgreSQL:
-- SELECT tablename FROM pg_tables WHERE schemaname = 'public';


-- Solution 13: Table Structure
-- SQL Server:
EXEC sp_help 'Books';
-- OR
SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Books';

-- MySQL:
-- DESCRIBE Books;

-- PostgreSQL:
-- \d Books
-- OR SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'books';


-- =====================================================
-- CREATIVITY SOLUTIONS
-- =====================================================

-- Solution 14: Personal Information Table
CREATE TABLE MyInfo (
    InfoType VARCHAR(50),
    Description VARCHAR(200)
);

INSERT INTO MyInfo VALUES ('Hobby', 'Learning SQL and database design');
INSERT INTO MyInfo VALUES ('Skill', 'Problem solving and analytical thinking');
INSERT INTO MyInfo VALUES ('Goal', 'Become a SQL expert and data analyst');
INSERT INTO MyInfo VALUES ('Interest', 'Technology and automation');
INSERT INTO MyInfo VALUES ('Strength', 'Persistence and continuous learning');

-- View the personal info
SELECT * FROM MyInfo;


-- Solution 15: Data Analysis
-- Oldest book:
SELECT * FROM Books WHERE PublishedYear = (SELECT MIN(PublishedYear) FROM Books);

-- Newest book:
SELECT * FROM Books WHERE PublishedYear = (SELECT MAX(PublishedYear) FROM Books);

-- Average price:
SELECT AVG(Price) AS AveragePrice FROM Books;

-- All three in one query:
SELECT 
    MIN(PublishedYear) AS OldestYear,
    MAX(PublishedYear) AS NewestYear,
    AVG(Price) AS AveragePrice
FROM Books;


-- =====================================================
-- CHALLENGE SOLUTIONS
-- =====================================================

-- Bonus Solution 1: Advanced Filtering
SELECT * 
FROM Books 
WHERE PublishedYear BETWEEN 1990 AND 2010 
  AND Price < 20.00;


-- Bonus Solution 2: Text Search
SELECT * 
FROM Books 
WHERE Title LIKE '%The%';


-- Bonus Solution 3: Data Modification
UPDATE Books 
SET Price = Price + 5.00 
WHERE BookID = 1;

-- Verify the update:
SELECT * FROM Books WHERE BookID = 1;


-- =====================================================
-- EXPLANATION SECTION
-- =====================================================

-- Why these solutions work:

-- 1. Environment checks help you confirm your setup is working
-- 2. CREATE DATABASE establishes your workspace
-- 3. CREATE TABLE defines the structure for your data
-- 4. INSERT adds actual data to work with
-- 5. SELECT with WHERE filters data based on conditions
-- 6. ORDER BY sorts results for better readability
-- 7. Aggregate functions (COUNT, AVG, MIN, MAX) summarize data
-- 8. LIKE operator enables text pattern matching
-- 9. UPDATE modifies existing data
-- 10. System tables/views provide metadata about your database

-- Alternative approaches:
-- - You could use different data types (CHAR vs VARCHAR)
-- - Different databases have different system tables
-- - Some operations can be combined into more complex queries
-- - Always consider data validation and constraints in real applications

-- Next steps:
-- - Practice these commands until they feel natural
-- - Try variations with your own data
-- - Experiment with different WHERE conditions
-- - Ready for Module 01: Creating more sophisticated database structures!
