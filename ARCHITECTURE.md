# Application Architecture

## 1. Overview

The Our Spends application is built using Flutter and follows a clean, scalable, and maintainable architecture. This document outlines the guiding principles, layers, and key components that make up the application.

## 2. Guiding Principles

*   **Separation of Concerns**: Each part of the application has a distinct responsibility, making the codebase easier to understand, manage, and test.
*   **Scalability**: The architecture is designed to accommodate future features and growth without requiring major refactoring.
*   **Testability**: Components are loosely coupled, allowing for effective unit, widget, and integration testing.
*   **Maintainability**: A clear and consistent structure ensures that new developers can quickly get up to speed.

## 3. Architecture Layers

The application is divided into three primary layers:

### 3.1. Presentation Layer

This layer is responsible for the user interface and user experience.

*   **Screens**: Top-level UI components that represent a full page in the app (e.g., `HomeScreen`, `ExpensesScreen`).
*   **Widgets**: Reusable UI components that are composed to build screens (e.g., `ExpenseListItem`, `TagSelector`).
*   **Theme**: Defines the application's visual identity, including colors, fonts, and component styles.

### 3.2. Business Logic Layer

This layer contains the core application logic and state management.

*   **Providers**: Manages the application's state using the `provider` package. Each provider is responsible for a specific domain (e.g., `ExpenseProvider`, `TagProvider`).
*   **Services**: Encapsulates business logic and coordinates interactions between the data layer and the presentation layer (e.g., `AIService`, `ExpenseService`).

### 3.3. Data Layer

This layer is responsible for data persistence, retrieval, and management.

*   **Repositories**: Abstract the data source (local or remote) and provide a clean API for the business logic layer to access data.
*   **Models**: Define the data structures for the application's domain entities (e.g., `Expense`, `Tag`).
*   **Storage Services**: Concrete implementations for data persistence, such as `SharedPreferencesStorage` for key-value storage.

## 4. Key Components

### 4.1. Models

*   `Expense`: Represents a single expense record.
*   `Tag`: A flexible tag for categorizing expenses.
*   `ChatMessage`: Represents a message in the AI chat interface.
*   `Currency`: Represents a currency and its formatting options.

### 4.2. Providers

*   `ExpenseProvider`: Manages the state of expenses, including adding, updating, and deleting them.
*   `TagProvider`: Manages the state of tags.
*   `CurrencyProvider`: Manages the selected currency and format.
*   `ThemeProvider`: Manages the application's theme (light/dark mode).
*   `LanguageProvider`: Manages the application's locale.

### 4.3. Services

*   `AIService`: A multi-provider AI service that integrates with Gemini, OpenAI, Claude, and DeepSeek.
*   `ExpenseService`: Handles business logic related to expenses, such as querying and filtering.
*   `DatabaseService`: Provides an abstraction over the local database.
*   `StorageService`: A generic service for key-value storage, implemented by `SharedPreferencesStorage`.

### 4.4. Repositories

*   `ExpenseRepository`: Manages data operations for expenses.
*   `TagRepository`: Manages data operations for tags.
*   `CurrencyRepository`: Manages data operations for currency settings.

## 5. Data Flow

The data flows through the application in a unidirectional manner:

1.  **UI Events**: The user interacts with a widget on a screen.
2.  **Provider Action**: The widget calls a method on a provider.
3.  **Business Logic**: The provider executes business logic, potentially calling one or more services.
4.  **Data Access**: Services interact with repositories to fetch or persist data.
5.  **State Update**: The provider updates its state, and the UI automatically rebuilds to reflect the changes.

## 6. AI Integration

The AI integration is designed to be modular and extensible.

```
+-----------------+
|   AIService     |
+-------+---------+
        |
        v
+-------+---------+
|  Provider API   |
+-------+---------+
        |
        v
+---------------------------------------+
| +-----------+ +-----------+ +-------+ |
| |  Gemini   | |  OpenAI   | | Claude| |
| +-----------+ +-----------+ +-------+ |
+---------------------------------------+
```

*   **AIService**: Provides a unified interface for all AI providers.
*   **Provider Switching**: Allows the user to dynamically switch between AI providers.
*   **Fallback Mechanism**: Automatically falls back to a default provider if the selected one fails.

## 7. Database

The application uses `shared_preferences` for local data storage. For more complex data, a database solution like `sqflite` could be integrated.

See [DATABASE_DESIGN.md](./DATABASE_DESIGN.md) for more details.

## 8. Internationalization

The app supports English and Vietnamese using Flutter's built-in localization. Localization files are in the `lib/l10n` directory.