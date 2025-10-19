# 📊 Complete Data Types Guide

Master SQL data types - choose the perfect type for every piece of information you need to store.

---

## 🎯 What You'll Learn
- Every major SQL data type and when to use it
- How to choose the right size for your data
- Common mistakes and how to avoid them
- Real-world examples for each data type
- International considerations

---

## 🔢 Numeric Data Types

### Integer Types
| Type | Range | Storage | Best Use |
|------|-------|---------|----------|
| `TINYINT` | 0 to 255 | 1 byte | Age, Rating (1-10), Status codes |
| `SMALLINT` | -32K to +32K | 2 bytes | Year, Small quantities |
| `INT` | -2B to +2B | 4 bytes | IDs, Most whole numbers |
| `BIGINT` | Very large | 8 bytes | Population, Large system IDs |

```sql
-- Examples
CREATE TABLE Examples (
    Age TINYINT,              -- 0-255 is perfect for age
    Year SMALLINT,            -- Years fit in SMALLINT
    EmployeeID INT,           -- Most ID numbers
    GlobalPopulation BIGINT   -- Very large numbers
);
```

### Decimal Types
| Type | Description | Best Use |
|------|-------------|----------|
| `DECIMAL(p,s)` | Exact precision | Money, percentages, precise calculations |
| `NUMERIC(p,s)` | Same as DECIMAL | Financial data |
| `FLOAT` | Approximate | Scientific measurements |
| `REAL` | Smaller FLOAT | Less precise measurements |

```sql
-- Examples
CREATE TABLE FinancialData (
    Price DECIMAL(8,2),       -- Up to $999,999.99
    Salary DECIMAL(10,2),     -- Up to $99,999,999.99
    TaxRate DECIMAL(5,4),     -- Like 0.0825 (8.25%)
    Distance FLOAT,           -- Approximate measurements
    Temperature REAL          -- Weather data
);
```

### 💡 **Money Rule**: Always use `DECIMAL` for money, never `FLOAT`!

---

## 📝 Text Data Types

### Character Types
| Type | Description | Best Use | Example |
|------|-------------|----------|---------|
| `CHAR(n)` | Fixed length | Codes, abbreviations | `CHAR(2)` for country codes |
| `VARCHAR(n)` | Variable length | Names, descriptions | `VARCHAR(50)` for names |
| `TEXT` | Large text | Long descriptions | Product descriptions |
| `NCHAR(n)` | Unicode fixed | International codes | Unicode country names |
| `NVARCHAR(n)` | Unicode variable | International names | Global customer names |

```sql
-- Examples
CREATE TABLE GlobalCustomers (
    CountryCode CHAR(2),           -- "US", "UK" - always 2 chars
    FirstName VARCHAR(50),         -- Variable length names
    LastName VARCHAR(50),          -- Most names fit in 50
    Email VARCHAR(255),            -- Email standard max
    PhoneNumber VARCHAR(15),       -- International format
    Bio TEXT,                      -- Long personal description
    City NVARCHAR(100)            -- International city names
);
```

### 📏 Text Sizing Guidelines
- **Names**: `VARCHAR(50)` covers 99% of real names
- **Email**: `VARCHAR(255)` is the email standard
- **Phone**: `VARCHAR(15)` handles international formats
- **Descriptions**: Use `TEXT` for unlimited length
- **Codes**: Use `CHAR(n)` when length is always the same

---

## 📅 Date and Time Types

### Core Date/Time Types
| Type | Format | Storage | Best Use |
|------|--------|---------|----------|
| `DATE` | YYYY-MM-DD | 3 bytes | Birthdays, deadlines, events |
| `TIME` | HH:MM:SS | 3-5 bytes | Daily schedules, duration |
| `DATETIME` | Date + Time | 8 bytes | Timestamps, appointments |
| `DATETIME2` | More precise | 6-8 bytes | High precision timestamps |
| `TIMESTAMP` | Auto-updating | 4 bytes | Record creation/modification |

```sql
-- Examples
CREATE TABLE EventSchedule (
    EventDate DATE,               -- 2024-12-25
    StartTime TIME,               -- 14:30:00
    FullEventTime DATETIME,       -- 2024-12-25 14:30:00
    CreatedTimestamp DATETIME2,   -- More precise
    LastModified TIMESTAMP        -- Auto-updates
);
```

### 🕒 When to Use Each
- **DATE**: When you only need the day (birthdays, deadlines)
- **TIME**: When you only need the time (meeting start, store hours)
- **DATETIME**: When you need both (order placement, login times)
- **TIMESTAMP**: For audit trails (created/modified tracking)

---

## ✅ Boolean and Binary Types

### Boolean Types
| Type | Description | Storage | Best Use |
|------|-------------|---------|----------|
| `BIT` | True/False | 1 bit | Status flags, yes/no questions |
| `BOOLEAN` | True/False | 1 byte | Some databases use this instead |

```sql
-- Examples
CREATE TABLE UserAccount (
    IsActive BIT,           -- Account active?
    EmailVerified BIT,      -- Email confirmed?
    NewsletterOptIn BIT,    -- Wants newsletters?
    IsPremiumUser BIT       -- Premium subscription?
);
```

### Binary Types
| Type | Description | Best Use |
|------|-------------|----------|
| `BINARY(n)` | Fixed binary | Hash values, checksums |
| `VARBINARY(n)` | Variable binary | Small files, images |
| `IMAGE` | Large binary | Large files (deprecated, use VARBINARY) |

---

## 🌍 International Considerations

### Unicode Support
```sql
-- For international applications
CREATE TABLE InternationalUsers (
    FirstName NVARCHAR(100),      -- Unicode names (中文, العربية)
    LastName NVARCHAR(100),       -- Supports all languages
    City NVARCHAR(100),           -- International city names
    Address NVARCHAR(500),        -- Various address formats
    Notes NTEXT                   -- Large Unicode text
);
```

### Currency and Regional Data
```sql
CREATE TABLE GlobalSales (
    Amount DECIMAL(15,2),         -- Large enough for any currency
    CurrencyCode CHAR(3),         -- ISO codes: USD, EUR, JPY
    ExchangeRate DECIMAL(10,6),   -- Precise exchange rates
    CountryCode CHAR(2),          -- ISO country codes
    LocaleCode VARCHAR(10)        -- en-US, fr-FR, ja-JP
);
```

---

## 🎯 Data Type Decision Guide

### Quick Decision Tree
1. **Is it a number?**
   - Whole number? → `INT`
   - Money? → `DECIMAL(10,2)`
   - Measurement? → `FLOAT`

2. **Is it text?**
   - Name/short text? → `VARCHAR(50)`
   - Email? → `VARCHAR(255)`
   - Long description? → `TEXT`
   - Fixed code? → `CHAR(n)`

3. **Is it a date?**
   - Just date? → `DATE`
   - Date and time? → `DATETIME`
   - Just time? → `TIME`

4. **Is it yes/no?**
   - Use `BIT`

---

## ❌ Common Data Type Mistakes

### Mistake 1: Using Wrong Type for Money
```sql
-- ❌ Wrong - loses precision
Price FLOAT

-- ✅ Right - exact precision
Price DECIMAL(8,2)
```

### Mistake 2: Text Fields Too Small
```sql
-- ❌ Risky - names can be longer
FirstName VARCHAR(10)

-- ✅ Safe - reasonable space
FirstName VARCHAR(50)
```

### Mistake 3: Using INT for Everything
```sql
-- ❌ Wasteful
Age INT           -- TINYINT is enough
Year INT          -- SMALLINT is enough

-- ✅ Right-sized
Age TINYINT       -- 0-255 is perfect
Year SMALLINT     -- Covers all years
```

### Mistake 4: Storing Phone Numbers as Numbers
```sql
-- ❌ Wrong - loses formatting and leading zeros
PhoneNumber INT

-- ✅ Right - preserves formatting
PhoneNumber VARCHAR(15)
```

---

## 🧪 Hands-On Practice

Try creating tables with various data types:

```sql
-- Practice table with all major types
CREATE TABLE DataTypePractice (
    ID INT,
    Name VARCHAR(50),
    Age TINYINT,
    Salary DECIMAL(10,2),
    IsActive BIT,
    BirthDate DATE,
    CreatedAt DATETIME,
    Description TEXT
);
```

---

## 🚀 Try It Yourself

**Practice with the code examples in:** `02_Code/03_Data_Types_Examples.sql`

This file contains:
- Examples of every data type in action
- Real-world scenarios for each type
- Common sizing decisions
- International considerations
- Performance implications

---

## ✅ Knowledge Check

After studying this guide, you should be able to:
- [ ] Choose the right numeric type for any number
- [ ] Size text fields appropriately
- [ ] Select proper date/time types
- [ ] Use boolean types for status flags
- [ ] Avoid common data type mistakes
- [ ] Consider international requirements

---

## 🔗 What's Next?

Now that you understand data types, learn how to:
**🔧 04_Modifying_Tables.md** - Change tables after creation using ALTER statements

---

*Part of Module 01: Create Database and Tables*