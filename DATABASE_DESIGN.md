# Expense Tracking Database Design

## Overview

This document describes the comprehensive database design for the Our Spends application. The system uses SQLite for local storage with CSV export capabilities and provides a query interface for the AI chatbot.

## Database Schema

### 1. Expenses Table (`expenses`)

The main table storing all expense records:

```sql
CREATE TABLE expenses (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  date TEXT NOT NULL,
  amount REAL NOT NULL,
  currency TEXT NOT NULL DEFAULT 'VND',
  category TEXT NOT NULL,
  subcategory TEXT,
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
)
```

**Fields:**
- `id`: Unique identifier for each expense
- `user_id`: Links expense to specific user
- `date`: Date when expense occurred
- `amount`: Expense amount (numeric)
- `currency`: Currency code (default: VND)
- `category`: Main expense category
- `subcategory`: Optional subcategory for detailed classification
- `item`: Brief description of what was purchased
- `description`: Detailed description
- `location`: Where the expense occurred
- `payment_method`: How payment was made (cash, card, etc.)
- `receipt_url`: Link to receipt image/document
- `is_recurring`: Boolean flag for recurring expenses
- `recurring_frequency`: Frequency for recurring expenses
- `notes`: Additional notes
- `created_at`: Record creation timestamp
- `updated_at`: Last modification timestamp
- `sync_status`: Synchronization status (0=local, 1=synced)

### 2. Categories Table (`categories`)

Predefined and custom expense categories:

```sql
CREATE TABLE categories (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL UNIQUE,
  icon TEXT,
  color TEXT,
  budget_limit REAL,
  is_active INTEGER DEFAULT 1,
  created_at TEXT NOT NULL
)
```

**Default Categories:**
- Food & Dining 🍽️
- Transportation 🚗
- Shopping 🛍️
- Entertainment 🎬
- Bills & Utilities 💡
- Healthcare 🏥
- Education 📚
- Travel ✈️
- Family & Kids 👨‍👩‍👧‍👦
- Other 📦

### 3. Tags Table (`tags`)

Flexible tagging system for expenses:

```sql
CREATE TABLE tags (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL UNIQUE,
  color TEXT,
  created_at TEXT NOT NULL
)
```

### 4. Expense Tags Junction Table (`expense_tags`)

Many-to-many relationship between expenses and tags:

```sql
CREATE TABLE expense_tags (
  expense_id TEXT NOT NULL,
  tag_id TEXT NOT NULL,
  PRIMARY KEY (expense_id, tag_id),
  FOREIGN KEY (expense_id) REFERENCES expenses (id) ON DELETE CASCADE,
  FOREIGN KEY (tag_id) REFERENCES tags (id) ON DELETE CASCADE
)
```

## Database Indexes

For optimal query performance:

```sql
CREATE INDEX idx_expenses_user_id ON expenses (user_id);
CREATE INDEX idx_expenses_date ON expenses (date);
CREATE INDEX idx_expenses_category ON expenses (category);
CREATE INDEX idx_expenses_amount ON expenses (amount);
```

## Services Architecture

### 1. DatabaseService (`lib/services/database_service.dart`)

Core database operations:

**Key Methods:**
- `insertExpense(Expense expense)`: Add new expense
- `getExpenses(String userId, {...filters})`: Retrieve expenses with filters
- `updateExpense(Expense expense)`: Update existing expense
- `deleteExpense(String id)`: Remove expense
- `getExpensesByCategory(String userId)`: Category-wise spending
- `getSpendingTrends(String userId)`: Spending trends over time
- `searchExpenses(String userId, String query)`: Text search
- `exportToCSV(String userId)`: Export data to CSV
- `getDatabaseStats(String userId)`: Database statistics

**Filtering Options:**
- Date range (startDate, endDate)
- Category filtering
- Amount range (minAmount, maxAmount)
- Pagination (limit, offset)

### 2. ExpenseQueryService (`lib/services/expense_query_service.dart`)

Natural language query interface for the chatbot:

**Key Methods:**
- `queryExpenses(String userId, String query)`: Parse natural language queries
- `getExpenseAnalytics(String userId)`: Get spending analytics
- `getSpendingByCategory(String userId)`: Category breakdown
- `getMonthlySpendingTrend(String userId)`: Monthly trends
- `searchExpenses(String userId, String searchText)`: Text search
- `generateSummary(List<Expense> expenses, String originalQuery)`: Generate human-readable summaries

**Natural Language Query Examples:**
- "Show me food expenses this month"
- "What did I spend on transport last week?"
- "Find expenses over 100k VND"
- "Show my top 10 expenses"
- "What are my recent shopping purchases?"

### 3. Enhanced Expense Model (`lib/models/expense.dart`)

Extended expense model with additional fields:

```dart
class Expense {
  final String id;
  final String userId;
  final DateTime date;
  final double amount;
  final String currency;
  final String category;
  final String? subcategory;
  final String item;
  final String? description;
  final String? location;
  final String? paymentMethod;
  final String? receiptUrl;
  final bool isRecurring;
  final String? recurringFrequency;
  final String? notes;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int syncStatus;
}
```

## AI Integration

### Expense Extraction

The AI chatbot can extract expense information from natural language:

**Input:** "I bought coffee for 50k at Starbucks"
**Output:**
```json
{
  "hasExpense": true,
  "amount": 50000,
  "description": "coffee",
  "category": "food",
  "location": "Starbucks",
  "confidence": 0.9
}
```

### Query Processing

The chatbot can answer questions about expenses:

**Examples:**
- "How much did I spend on food this month?"
- "What's my biggest expense category?"
- "Show me all expenses from last week"
- "Find my coffee purchases"

### Analytics Generation

The AI provides insights based on spending patterns:
- Spending trends
- Category analysis
- Budget recommendations
- Saving suggestions

## Data Export/Import

### CSV Export

Expenses can be exported to CSV format:

```csv
Date,Amount,Currency,Category,Item,Description,Location,Payment Method,Notes
2024-01-15,50000,VND,food,coffee,Morning coffee,Starbucks,card,
2024-01-15,200000,VND,transport,taxi,Ride to office,District 1,cash,
```

### File Storage

CSV files are saved to the device's documents directory with timestamps:
- `expenses_1642234567890.csv`

## Usage Examples

### 1. Adding an Expense via Chat

**User:** "I spent 150k on groceries at Vinmart"

**System Process:**
1. AI extracts expense info
2. Creates Expense object
3. Stores in database
4. Confirms with user

### 2. Querying Expenses

**User:** "Show me my food expenses this month"

**System Process:**
1. Parse query parameters
2. Query database with filters
3. Generate summary
4. Return results to user

### 3. Getting Analytics

**User:** "What are my spending insights?"

**System Process:**
1. Retrieve user's expenses
2. Calculate analytics
3. Generate AI insights
4. Present to user

## Performance Considerations

1. **Indexing**: Proper indexes on frequently queried columns
2. **Pagination**: Large datasets are paginated
3. **Caching**: Recent queries can be cached
4. **Batch Operations**: Multiple inserts use transactions

## Security & Privacy

1. **Local Storage**: Data stored locally on device
2. **User Isolation**: Each user's data is separate
3. **No Cloud Sync**: Data remains on device (configurable)
4. **Encryption**: Consider encrypting sensitive data

## Future Enhancements

1. **Cloud Sync**: Firebase/Firestore integration
2. **Receipt OCR**: Automatic receipt scanning
3. **Budget Tracking**: Monthly/category budgets
4. **Recurring Expenses**: Automatic recurring expense handling
5. **Multi-Currency**: Better currency conversion support
6. **Data Visualization**: Charts and graphs
7. **Export Formats**: PDF, Excel support

## Testing the Database

To test the database functionality:

1. **Start the app**: `flutter run -d web-server --web-port=3000`
2. **Open browser**: Navigate to `http://localhost:3000`
3. **Chat with AI**: Send messages like "I bought lunch for 80k"
4. **Query data**: Ask "What did I spend today?"
5. **Check storage**: Expenses should be saved and queryable

The database system provides a robust foundation for expense tracking with AI integration, making it easy for users to manage their finances through natural conversation.