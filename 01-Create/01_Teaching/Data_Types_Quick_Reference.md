# 📊 SQL Data Types Quick Reference

## 🔢 Numeric Types

| Type | Range | Use For | Example |
|------|-------|---------|---------|
| `TINYINT` | 0 to 255 | Small numbers | Age, Rating (1-10) |
| `INT` | -2B to +2B | Most numbers | IDs, Quantities, Years |
| `BIGINT` | Very large | Huge numbers | Population, Large IDs |
| `DECIMAL(p,s)` | Exact precision | Money, Percentages | DECIMAL(10,2) for $99,999.99 |
| `FLOAT` | Approximate | Scientific data | Measurements, Coordinates |

## 📝 Text Types

| Type | Description | Use For | Example |
|------|-------------|---------|---------|
| `CHAR(n)` | Fixed length | Codes, Abbreviations | CHAR(2) for "US", "UK" |
| `VARCHAR(n)` | Variable length | Names, Descriptions | VARCHAR(50) for names |
| `TEXT` | Large text | Long descriptions | Product descriptions, notes |
| `NVARCHAR(n)` | Unicode text | International names | NVARCHAR(100) for global names |

## 📅 Date and Time Types

| Type | Format | Use For | Example |
|------|--------|---------|---------|
| `DATE` | YYYY-MM-DD | Birthdays, Deadlines | 2024-12-25 |
| `TIME` | HH:MM:SS | Duration, Time of day | 14:30:00 |
| `DATETIME` | Date + Time | Timestamps | 2024-12-25 14:30:00 |
| `DATETIME2` | More precise | High precision timestamps | Microsecond precision |

## ✅ Other Important Types

| Type | Description | Use For | Example |
|------|-------------|---------|---------|
| `BIT` | True/False | Status flags | IsActive, IsDeleted |
| `UNIQUEIDENTIFIER` | GUID | Global unique IDs | Distributed systems |
| `BINARY` | Raw data | Files, Images | Profile pictures |

---

## 🎯 Quick Decision Guide

**For Names**: `VARCHAR(50)`
**For Email**: `VARCHAR(255)` 
**For Money**: `DECIMAL(10,2)`
**For IDs**: `INT`
**For Yes/No**: `BIT`
**For Dates**: `DATE` 
**For Timestamps**: `DATETIME`
**For Long Text**: `TEXT`
**For Country Codes**: `CHAR(2)`

---

## 💡 Pro Tips

1. **Start with VARCHAR** for most text fields
2. **Use DECIMAL for money** (never FLOAT)
3. **INT is usually fine** for most numbers
4. **Be generous with text sizes** but not wasteful
5. **Always consider future needs**

---

*Keep this handy while designing tables!* 🚀