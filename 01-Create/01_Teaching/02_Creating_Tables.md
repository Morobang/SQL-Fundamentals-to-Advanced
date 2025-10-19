# 📋 Creating Tables

Learn how to design and create tables - the foundation where your data actually lives.

---

## 🎯 What You'll Learn
- How to create tables with columns
- How to choose the right data types
- Table naming best practices
- How to view table structures
- How to create tables for real-world scenarios

---

## 🧠 Understanding Tables

### What is a Table?
A **table** is like a spreadsheet inside your database. It has:
- **Columns** (like spreadsheet columns) that define what kind of information you store
- **Rows** (like spreadsheet rows) that contain actual data records

### Table Structure Example
```
Employees Table:
┌────────────┬───────────┬──────────┬─────────────┐
│ EmployeeID │ FirstName │ LastName │ HireDate    │
├────────────┼───────────┼──────────┼─────────────┤
│ 1          │ John      │ Smith    │ 2024-01-15  │
│ 2          │ Sarah     │ Johnson  │ 2024-02-01  │
└────────────┴───────────┴──────────┴─────────────┘
```

---

## 🛠️ Basic Table Creation

### Simple Syntax
```sql
CREATE TABLE TableName (
    Column1 DataType,
    Column2 DataType,
    Column3 DataType
);
```

### Real Example
```sql
CREATE TABLE Employees (
    EmployeeID INT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    HireDate DATE
);
```

---

## 📊 Essential Data Types

### 🔢 Numbers
| Type | Use For | Example |
|------|---------|---------|
| `INT` | Whole numbers | Employee ID, Age, Quantity |
| `DECIMAL(10,2)` | Money, precise decimals | Salary: $45,250.75 |
| `FLOAT` | Approximate decimals | Scientific measurements |

### 📝 Text
| Type | Use For | Example |
|------|---------|---------|
| `VARCHAR(50)` | Names, short descriptions | FirstName, City |
| `CHAR(2)` | Fixed codes | Country codes: "US", "UK" |
| `TEXT` | Long descriptions | Product descriptions, notes |

### 📅 Dates
| Type | Use For | Example |
|------|---------|---------|
| `DATE` | Dates only | Birth date, hire date |
| `DATETIME` | Date and time | Order timestamp |
| `TIME` | Time only | Meeting start time |

### ✅ True/False
| Type | Use For | Example |
|------|---------|---------|
| `BIT` | Yes/No values | IsActive, IsCompleted |

---

## 🏗️ Real-World Table Examples

### Customer Information Table
```sql
CREATE TABLE Customers (
    CustomerID INT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    DateOfBirth DATE,
    IsActive BIT
);
```

### Product Catalog Table
```sql
CREATE TABLE Products (
    ProductID INT,
    ProductName VARCHAR(200),
    Price DECIMAL(8,2),
    InStock INT,
    Description TEXT,
    CreatedDate DATETIME
);
```

### Order Records Table
```sql
CREATE TABLE Orders (
    OrderID INT,
    CustomerID INT,
    OrderDate DATE,
    TotalAmount DECIMAL(10,2),
    Status VARCHAR(20),
    ShippingAddress TEXT
);
```

---

## 📏 Choosing the Right Data Type Size

### Text Field Sizing Guide
```sql
-- Names and short info
FirstName VARCHAR(50)        -- Most names fit in 50 characters
Email VARCHAR(255)           -- Email standard maximum
Phone VARCHAR(15)            -- International phone numbers

-- Codes and identifiers
CountryCode CHAR(2)          -- Always exactly 2 characters
PostalCode VARCHAR(10)       -- Various lengths globally
```

### Number Field Sizing Guide
```sql
-- Regular numbers
Age INT                      -- 0 to ~2 billion is plenty
Quantity INT                 -- Most quantities fit in INT

-- Money amounts
Price DECIMAL(8,2)          -- Up to $999,999.99
Salary DECIMAL(10,2)        -- Up to $99,999,999.99
```

---

## 📝 Table Naming Best Practices

### ✅ Good Table Names
```sql
CREATE TABLE Employees;      -- Clear and descriptive
CREATE TABLE CustomerOrders; -- Shows what it contains
CREATE TABLE ProductReviews; -- Indicates relationship
```

### Choose One Style and Stick With It
```sql
-- Option 1: Singular nouns
CREATE TABLE Employee;
CREATE TABLE Customer;
CREATE TABLE Order;

-- Option 2: Plural nouns
CREATE TABLE Employees;
CREATE TABLE Customers;
CREATE TABLE Orders;
```

### ❌ Avoid These Patterns
```sql
-- Don't use spaces
CREATE TABLE "Customer Info";  ❌

-- Don't use confusing abbreviations
CREATE TABLE CustOrdProd;      ❌

-- Don't use reserved words
CREATE TABLE User;             ❌ (Use Users instead)
```

---

## 🔍 Viewing Table Information

### Check Table Structure
```sql
-- See all columns and their data types
SELECT COLUMN_NAME, DATA_TYPE, CHARACTER_MAXIMUM_LENGTH
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'YourTableName';
```

### List All Tables
```sql
-- See all tables in current database
SELECT TABLE_NAME 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_TYPE = 'BASE TABLE';
```

---

## 🧪 Hands-On Practice

### Step 1: Create a Simple Table
```sql
CREATE TABLE Students (
    StudentID INT,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    EnrollmentDate DATE
);
```

### Step 2: View Your Table Structure
```sql
SELECT COLUMN_NAME, DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Students';
```

---

## 🚀 Try It Yourself

**Practice with the code examples in:** `02_Code/02_Create_Table.sql`

This file contains hands-on examples of:
- Creating tables for different business scenarios
- Using various data types appropriately
- Naming tables professionally
- Viewing table structures

**Also explore:** `02_Code/03_Data_Types_Examples.sql`
- Comprehensive examples of every data type
- When to use each type
- Common sizing decisions

---

## ✅ Knowledge Check

After practicing, you should be able to:
- [ ] Create a table with multiple columns
- [ ] Choose appropriate data types for different kinds of information
- [ ] Size VARCHAR fields appropriately
- [ ] Use proper table naming conventions
- [ ] View the structure of tables you've created

---

## 🔗 What's Next?

Once you're comfortable creating tables, move on to:
**🔧 04_Modifying_Tables.md** - Learn how to change tables after you've created them

---

*Part of Module 01: Create Database and Tables*