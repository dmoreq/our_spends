# Database Design

## 1. Overview

This document outlines the database architecture for the **Our Spends** application. The app utilizes a local **SQLite** database to ensure data privacy and offline functionality, with options for data export.

The database is designed to be simple, efficient, and extensible, providing a solid foundation for tracking expenses, managing categories, and integrating with AI-powered features.

## 2. Guiding Principles

- **Local-First**: All data is stored on the user's device to ensure privacy and offline access.
- **Simplicity**: The schema is designed to be straightforward and easy to understand.
- **Performance**: Indexed for fast queries and optimized for mobile performance.
- **Extensibility**: Easily adaptable to support future features like cloud sync and advanced analytics.

## 3. Database Schema

The database consists of four main tables: `expenses`, `categories`, `tags`, and the `expense_tags` junction table.

### 3.1. `expenses` Table

Stores individual expense records.

```sql
CREATE TABLE expenses (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  date TEXT NOT NULL,
  amount REAL NOT NULL,
  currency TEXT NOT NULL DEFAULT 'VND',
  item TEXT NOT NULL,
  description TEXT,
  location TEXT,
  payment_method TEXT,
  receipt_url TEXT,
  is_recurring INTEGER DEFAULT 0,
  recurring_frequency TEXT,
  notes TEXT,
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  sync_status INTEGER DEFAULT 0
);
```

- **Primary Key**: `id` (UUID)
- **Indexes**: `user_id`, `date`, `amount`

### 3.2. `categories` Table

Manages predefined and user-created expense categories.

```sql
CREATE TABLE categories (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL UNIQUE,
  icon TEXT,
  color TEXT,
  budget_limit REAL,
  is_active INTEGER DEFAULT 1,
  created_at TEXT NOT NULL
);
```

### 3.3. `tags` Table

Allows for flexible, user-defined tagging of expenses.

```sql
CREATE TABLE tags (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL UNIQUE,
  color TEXT,
  created_at TEXT NOT NULL
);
```

### 3.4. `expense_tags` Junction Table

Creates a many-to-many relationship between expenses and tags.

```sql
CREATE TABLE expense_tags (
  expense_id TEXT NOT NULL,
  tag_id TEXT NOT NULL,
  PRIMARY KEY (expense_id, tag_id),
  FOREIGN KEY (expense_id) REFERENCES expenses (id) ON DELETE CASCADE,
  FOREIGN KEY (tag_id) REFERENCES tags (id) ON DELETE CASCADE
);
```

## 4. Services Architecture

### 4.1. `DatabaseService`

The `DatabaseService` is the core component for all database interactions. It abstracts the SQL queries and provides a clean, type-safe API for CRUD operations.

- **`insertExpense(Expense expense)`**: Adds a new expense to the database.
- **`getExpenses(String userId, {...})`**: Retrieves a list of expenses with powerful filtering options (date, amount, etc.).
- **`updateExpense(Expense expense)`**: Updates an existing expense record.
- **`deleteExpense(String id)`**: Removes an expense from the database.
- **`exportToCSV(String userId)`**: Exports user data to a CSV file.

### 4.2. `ExpenseQueryService`

This service provides a higher-level interface for querying expense data, specifically for the AI chatbot. It translates natural language queries into database operations.

- **`queryExpenses(String userId, String query)`**: Parses natural language to fetch relevant expenses.
- **`getExpenseAnalytics(String userId)`**: Computes and returns spending analytics.
- **`generateSummary(List<Expense> expenses, String query)`**: Creates a human-readable summary of query results.

## 5. AI Integration

The database is designed to seamlessly integrate with the AI chatbot for two primary functions:

### 5.1. Expense Extraction

The AI can parse expense details from user messages (e.g., "I bought coffee for 50k"). The extracted information is then used to populate an `Expense` object and save it to the database.

### 5.2. Natural Language Queries

The AI uses the `ExpenseQueryService` to answer user questions about their spending, such as:
- "How much did I spend on food this month?"
- "Show me my top 10 expenses."
- "What were my recent shopping purchases?"

## 6. Data Management

### 6.1. Data Export

Users can export their expense data to a CSV file for backup or use in other applications. The file is saved to the device's local storage.

### 6.2. Security and Privacy

- **Local Storage**: All data is stored exclusively on the user's device.
- **User Isolation**: Data is partitioned by `user_id` to ensure privacy.
- **No Cloud Sync**: By default, no data is sent to the cloud.

## 7. Future Enhancements

- **Cloud Sync**: Optional synchronization with services like Firebase or a private server.
- **Advanced Analytics**: Deeper insights, budget tracking, and predictive analysis.
- **Receipt OCR**: Scan receipts to automatically create expenses.
- **Multi-Currency Support**: Improved handling of different currencies.