# Our Spends Architecture

## Overview

The Our Spends application is built using Flutter and follows a clean architecture pattern with a focus on maintainability, testability, and scalability. This document outlines the high-level architecture and key components of the application.

## Architecture Layers

The application is structured into the following layers:

### 1. Presentation Layer

- **Screens**: UI components that represent full pages in the app
- **Widgets**: Reusable UI components
- **Theme**: App-wide styling and theming

### 2. Business Logic Layer

- **Providers**: State management using the Provider pattern
- **Services**: Business logic and external API interactions

### 3. Data Layer

- **Models**: Data structures representing domain entities
- **Repositories**: Data access and persistence

## Key Components

### Models

The core data structures of the application:

- **Expense**: Represents a single expense record with details like amount, category, date, etc.
- **Category**: Represents expense categories with names, icons, and colors
- **Tag**: Flexible tagging system for expenses
- **ChatMessage**: Represents messages in the AI chat interface

### Providers

State management components using the Provider pattern, organized by domain:

- **Expense Domain**:
  - **ExpenseProvider**: Manages expense data and operations
- **Currency Domain**:
  - **CurrencyProvider**: Manages currency data and preferences
- **Tag Domain**:
  - **TagProvider**: Manages tags for expenses
- **Other Providers**:
  - **AuthProvider**: Handles user authentication state
  - **LanguageProvider**: Manages localization preferences
  - **ThemeProvider**: Manages application theme settings

### Services

Business logic and external integrations:

- **AIService**: Multi-provider AI integration service
  - **GeminiService**: Integration with Google's Gemini AI
  - **OpenAIService**: Integration with OpenAI's ChatGPT
  - **ClaudeService**: Integration with Anthropic's Claude
  - **DeepSeekService**: Integration with DeepSeek AI
- **ApiService**: Handles API requests and responses
- **DatabaseService**: Local data persistence using SQLite
- **ExpenseQueryService**: Specialized service for querying expense data

### Screens

Main UI components organized by feature domains:

- **Expense Domain**:
  - **ExpensesScreen**: Expense listing and management
  - **AddExpenseScreen**: Form for adding and editing expenses
- **Chat Domain**:
  - **ChatScreen**: AI chat interface for expense management and insights
  - **AIChatScreen**: Advanced AI interaction for expense analysis
- **Settings Domain**:
  - **SettingsScreen**: App settings
  - **AISettingsScreen**: AI provider configuration
- **Core Components**:
  - **HomeScreen**: Main dashboard with expense summary
  - **AuthWrapper**: Authentication flow management
  - **TagManagementScreen**: Interface for managing expense tags

## Data Flow

1. **User Interaction**: User interacts with UI components in Screens/Widgets
2. **State Management**: Providers handle state changes and business logic
3. **Service Layer**: Services perform operations like API calls or database queries
4. **Data Persistence**: Data is stored locally in SQLite and/or synced to Firebase

## AI Integration Architecture

The AI integration follows a provider pattern with a unified interface:

```
┌─────────────────┐
│    AIService    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Provider API   │
└────────┬────────┘
         │
         ▼
┌─────────────────────────────────────────────────┐
│                                                 │
│  ┌──────────┐ ┌──────────┐ ┌───────┐ ┌───────┐ │
│  │  Gemini  │ │  OpenAI  │ │Claude │ │DeepSeek│ │
│  └──────────┘ └──────────┘ └───────┘ └───────┘ │
│                                                 │
└─────────────────────────────────────────────────┘
```

1. **AIService**: Unified interface for all AI providers
2. **Provider Selection**: Dynamic provider switching with persistent settings
3. **Fallback Mechanism**: Automatic fallback to default provider if selected provider fails
4. **Shared Functionality**: Common prompts and processing logic shared across providers

## Database Architecture

The application uses SQLite for local storage with the following schema:

- **expenses**: Main table for expense records
- **categories**: Predefined and custom expense categories
- **tags**: Flexible tagging system
- **expense_tags**: Junction table for many-to-many relationship

See [DATABASE_DESIGN.md](./DATABASE_DESIGN.md) for detailed schema information.

## Authentication Flow

The app supports both authenticated and demo modes:

1. **Authenticated Mode**: Uses Firebase Authentication with Google Sign-In
2. **Demo Mode**: Uses local storage with a generated demo user ID

## Internationalization

The app supports multiple languages using Flutter's built-in localization:

- English (en)
- Vietnamese (vi)

Localization files are stored in the `lib/l10n` directory using the ARB format.

## Future Architecture Considerations

- **Offline-First Approach**: Enhanced offline capabilities with background sync
- **Advanced Analytics**: Integration with analytics services
- **Webhooks**: Integration with financial services and banks
- **Machine Learning**: On-device ML for expense categorization
- **Biometric Authentication**: Enhanced security with biometric login