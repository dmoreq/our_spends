# Our Spends Navigation Structure

## Overview

Our Spends uses a simple and intuitive navigation structure to provide easy access to all features. The app is organized into three main screens accessible via a bottom navigation bar.

## Main Navigation

### Bottom Navigation Bar

The bottom navigation bar provides access to the three primary screens of the application:

1. **Expenses** - The main dashboard showing expense summaries and listings
2. **Chat** - AI-powered chat interface for expense management and insights
3. **Settings** - App configuration and preferences

## Screen Details

### Expenses Screen

The Expenses screen serves as the main dashboard of the application and provides:

- A summary of recent expenses
- Categorized expense listings
- Filtering and sorting options
- A floating action button to add new expenses

#### Sub-navigation from Expenses Screen

- **Add Expense** - Accessed via the floating action button
- **Expense Details** - Accessed by tapping on an expense item
- **Analytics** - Accessed via the analytics icon in the app bar (future implementation)

### Chat Screen

The Chat screen provides an AI-powered interface for:

- Adding expenses through natural language
- Searching for specific expenses
- Getting spending insights and analysis
- Receiving personalized financial recommendations

The Chat screen combines search functionality with AI assistance, eliminating the need for a separate search screen.

### Settings Screen

The Settings screen provides access to:

- **Language Settings** - Change the app language
- **Theme Settings** - Toggle between light and dark mode
- **AI Provider Settings** - Configure AI providers and API keys
- **Export/Import** - Data management options
- **About** - App information and version

## Navigation Implementation

The navigation structure is implemented in the `HomeScreen` widget, which uses:

- A `PageView` to manage the three main screens
- A `NavigationBar` for bottom navigation
- A `FloatingActionButton` that appears only on the Expenses screen

## Navigation Flow

```
┌─────────────────────────────────────────────────────┐
│                     HomeScreen                       │
└───────────────────────┬─────────────────────────────┘
                        │
            ┌───────────┼───────────────┐
            │           │               │
┌───────────▼───┐ ┌─────▼─────┐ ┌───────▼───────┐
│ ExpensesScreen │ │ ChatScreen │ │ SettingsScreen │
└───────┬───────┘ └───────────┘ └───────────────┘
        │
        │
┌───────▼────────┐
│ AddExpenseScreen │
└──────────────────┘
```

## Future Navigation Enhancements

- **Deep Linking** - Direct access to specific screens from external sources
- **Tabbed Navigation** - Sub-navigation within the Expenses screen for different views
- **Gesture Navigation** - Swipe gestures for navigating between screens
- **Search Integration** - Enhanced search capabilities within the Chat screen