# 🗄️ Creating Databases

Learn how to create and manage databases - the containers that hold all your tables and data.

---

## 🎯 What You'll Learn
- How to create a new database
- Database naming best practices
- How to switch between databases
- How to verify which database you're using
- How to safely delete databases

---

## 🧠 Understanding Databases

### What is a Database?
A **database** is like a filing cabinet that organizes all your related information. Just like you might have different filing cabinets for different purposes (work documents, personal files, etc.), you create different databases for different projects or applications.

### Database vs. Schema vs. Table
```
🗄️ Database (Filing Cabinet)
├── 📁 Schema/Collection (Drawer/Section)
    ├── 📋 Table 1 (Individual File)
    ├── 📋 Table 2 (Individual File)
    └── 📋 Table 3 (Individual File)
```

**Database**: The entire container for a project
**Schema**: A logical grouping within a database (not used in all SQL systems)
**Table**: Where your actual data rows and columns live

---

## 🛠️ Creating Your First Database

### Basic Syntax
```sql
CREATE DATABASE YourDatabaseName;
```

### Real Examples
```sql
-- For a company
CREATE DATABASE CompanyHR;

-- For a store
CREATE DATABASE RetailStore;

-- For personal projects
CREATE DATABASE MyLearningDB;
```

---

## 📝 Database Naming Rules

### ✅ Good Database Names
```sql
CREATE DATABASE SalesTracker;
CREATE DATABASE InventorySystem;
CREATE DATABASE UserManagement;
```

### ❌ Avoid These Patterns
```sql
-- Don't use spaces
CREATE DATABASE "My Database";  ❌

-- Don't start with numbers
CREATE DATABASE 123Sales;       ❌

-- Don't use special characters
CREATE DATABASE Sales&Marketing; ❌
```

### 🎯 Best Practices
1. **Use descriptive names** that explain the purpose
2. **Use PascalCase** (CapitalizeEachWord) or **snake_case** (words_with_underscores)
3. **Keep it concise** but meaningful
4. **Be consistent** across all your databases

---

## 🔄 Working with Databases

### Switch to a Database
```sql
USE YourDatabaseName;
```

### Check Current Database
```sql
SELECT DB_NAME() AS CurrentDatabase;
```

### List All Databases
```sql
-- SQL Server
SELECT name FROM sys.databases;

-- MySQL
SHOW DATABASES;

-- PostgreSQL
\l
```

---

## 🗑️ Safely Deleting Databases

### Basic Deletion
```sql
DROP DATABASE YourDatabaseName;
```

### Safe Deletion (Check First)
```sql
-- Check if database exists before dropping
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'YourDatabaseName')
    DROP DATABASE YourDatabaseName;
```

### ⚠️ **Warning**: Deleting a database removes ALL tables and data inside it permanently!

---

## 🧪 Hands-On Practice

### Step 1: Create a Practice Database
Open your SQL tool and try this:
```sql
CREATE DATABASE PracticeDB;
```

### Step 2: Switch to Your Database
```sql
USE PracticeDB;
```

### Step 3: Verify You're Using It
```sql
SELECT DB_NAME() AS CurrentDatabase;
```

You should see "PracticeDB" as the result.

---

## 🚀 Try It Yourself

**Practice with the code examples in:** `02_Code/01_Create_Database.sql`

This file contains hands-on examples of:
- Creating databases with different naming styles
- Switching between databases
- Checking database information
- Safe database deletion

---

## ✅ Knowledge Check

After practicing, you should be able to:
- [ ] Create a new database with a proper name
- [ ] Switch to using a specific database
- [ ] Check which database you're currently using
- [ ] List all databases on your system
- [ ] Safely delete a database

---

## 🔗 What's Next?

Once you're comfortable creating and managing databases, move on to:
**📋 02_Creating_Tables.md** - Learn how to create tables inside your databases

---

*Part of Module 01: Create Database and Tables*