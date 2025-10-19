-- Module 00: Setup and Fundamentals
-- Example SQL Code for Getting Started

-- Purpose: Demonstrate your very first SQL commands
-- Note: These are clean, beginner-friendly examples

-- =====================================================
-- EXAMPLE 1: Creating Your First Database
-- =====================================================

-- Create a new database called "LearningSQL"
CREATE DATABASE LearningSQL;

-- Switch to using that database
USE LearningSQL;

-- Check that you're in the right database
SELECT DB_NAME() AS CurrentDatabase;


-- =====================================================
-- EXAMPLE 2: Creating Your First Table
-- =====================================================

-- Create a simple table to store student information
CREATE TABLE Students (
    StudentID INT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Age INT,
    Email VARCHAR(100)
);

-- View the structure of your table
-- (This command varies by database system)
-- SQL Server:
-- EXEC sp_help 'Students';

-- MySQL:
-- DESCRIBE Students;

-- PostgreSQL:
-- \d Students;


-- =====================================================
-- EXAMPLE 3: Adding Sample Data
-- =====================================================

-- Insert some example students
INSERT INTO Students VALUES (1, 'Tshigidimisa', 'Morobang', 25, 'tshigi@email.com');
INSERT INTO Students VALUES (2, 'John', 'Smith', 22, 'john@email.com');
INSERT INTO Students VALUES (3, 'Sarah', 'Johnson', 24, 'sarah@email.com');

-- View all the data in your table
SELECT * FROM Students;


-- =====================================================
-- EXAMPLE 4: Basic Queries
-- =====================================================

-- Get just names and ages
SELECT FirstName, LastName, Age FROM Students;

-- Find students older than 23
SELECT * FROM Students WHERE Age > 23;

-- Sort students by last name
SELECT * FROM Students ORDER BY LastName;

-- Count how many students you have
SELECT COUNT(*) AS TotalStudents FROM Students;


-- =====================================================
-- EXAMPLE 5: System Information Queries
-- =====================================================

-- Check what databases exist
-- SQL Server:
-- SELECT name FROM sys.databases;

-- MySQL:
-- SHOW DATABASES;

-- PostgreSQL:
-- \l

-- Check what tables exist in current database
-- SQL Server:
-- SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE';

-- MySQL:
-- SHOW TABLES;

-- PostgreSQL:
-- \dt


-- =====================================================
-- EXAMPLE 6: Cleanup (Optional)
-- =====================================================

-- Remove the table if you want to start over
-- DROP TABLE Students;

-- Remove the database if you want to start completely fresh
-- DROP DATABASE LearningSQL;

-- Related: See 01_Teaching folder for detailed explanations
-- Practice: Check 03_Practice folder for hands-on exercises
