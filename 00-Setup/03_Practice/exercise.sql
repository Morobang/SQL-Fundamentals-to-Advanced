-- Module 00: Setup and Fundamentals
-- Practice Exercises

-- Instructions: Complete the SQL tasks below to practice your setup
-- Check your answers in the solutions folder when done

-- =====================================================
-- SETUP VERIFICATION EXERCISES
-- =====================================================

-- Exercise 1: Environment Check
-- TODO: Write a query to check what database system you're using
-- Hint: Different systems have different commands for this


-- Exercise 2: Create Your Personal Database
-- TODO: Create a database with your own name (e.g., "TshigidimasaDB")


-- Exercise 3: Switch to Your Database
-- TODO: Write the command to start using your new database


-- =====================================================
-- FIRST TABLE EXERCISES
-- =====================================================

-- Exercise 4: Create a "Books" Table
-- TODO: Create a table called "Books" with these columns:
-- - BookID (integer)
-- - Title (text, up to 200 characters)
-- - Author (text, up to 100 characters)
-- - PublishedYear (integer)
-- - Price (decimal with 2 decimal places)


-- Exercise 5: Add Sample Books
-- TODO: Insert at least 3 books into your Books table
-- Use any books you like (real or fictional)


-- Exercise 6: View Your Data
-- TODO: Write a query to see all books in your table


-- =====================================================
-- BASIC QUERY EXERCISES
-- =====================================================

-- Exercise 7: Selective Display
-- TODO: Show only the Title and Author columns from your Books table


-- Exercise 8: Filter by Year
-- TODO: Find all books published after the year 2000


-- Exercise 9: Sort Your Books
-- TODO: Display all books sorted by Title alphabetically


-- Exercise 10: Count Your Collection
-- TODO: Write a query to count how many books are in your table


-- =====================================================
-- EXPLORATION EXERCISES
-- =====================================================

-- Exercise 11: Database Exploration
-- TODO: Write a query to list all databases on your system
-- (The command will depend on your database system)


-- Exercise 12: Table Exploration
-- TODO: Write a query to list all tables in your current database


-- Exercise 13: Table Structure
-- TODO: Find out how to view the structure/schema of your Books table
-- (Different database systems use different commands)


-- =====================================================
-- CREATIVITY EXERCISES
-- =====================================================

-- Exercise 14: Personal Information Table
-- TODO: Create a table called "MyInfo" with columns for:
-- - InfoType (like "Hobby", "Skill", "Goal")
-- - Description (text description)
-- Add at least 5 rows about yourself


-- Exercise 15: Data Analysis
-- TODO: Using your Books table, find:
-- - The oldest book
-- - The newest book
-- - The average price of your books


-- =====================================================
-- CHALLENGE EXERCISES
-- =====================================================

-- Bonus Challenge 1: Advanced Filtering
-- TODO: Find books published between 1990 and 2010 AND with price less than $20


-- Bonus Challenge 2: Text Search
-- TODO: Find all books where the title contains the word "The"
-- Hint: Look up the LIKE operator


-- Bonus Challenge 3: Data Modification
-- TODO: Update the price of one specific book (increase it by $5)


-- =====================================================
-- HINTS SECTION
-- =====================================================

-- Hint for Exercise 1: 
-- SQL Server: SELECT @@VERSION
-- MySQL: SELECT VERSION()
-- PostgreSQL: SELECT version()

-- Hint for Exercise 4:
-- Use appropriate data types: INT for integers, VARCHAR(n) for text, DECIMAL(10,2) for prices

-- Hint for Exercise 8:
-- Use WHERE PublishedYear > 2000

-- Hint for Exercise 15:
-- Use MIN(), MAX(), and AVG() functions

-- Hint for Bonus Challenge 2:
-- Use WHERE Title LIKE '%The%'

-- Remember: Don't peek at solutions until you've tried each exercise!
