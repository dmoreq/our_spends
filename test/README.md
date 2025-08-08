# Our Spends - Test Suite

This directory contains unit tests for the Our Spends application. The tests are organized by component type (models, services, providers) to match the structure of the main application.

## Test Structure

- `models/` - Tests for data models
  - `expense_test.dart` - Tests for the Expense model
  - `category_test.dart` - Tests for the Category model
  - `tag_test.dart` - Tests for the Tag model
  - `chat_message_test.dart` - Tests for the ChatMessage model

- `services/` - Tests for service classes
  - `database_service_test.dart` - Tests for the DatabaseService
  - `expense_query_service_test.dart` - Tests for the ExpenseQueryService
  - `ai_service_test.dart` - Tests for the AIService

- `providers/` - Tests for provider classes
  - `auth_provider_test.dart` - Tests for the AuthProvider
  - `expense_provider_test.dart` - Tests for the ExpenseProvider

- `widget_test.dart` - Basic widget test for the application

## Running Tests

You can run all tests with the following command:

```bash
flutter test
```

To run a specific test file:

```bash
flutter test test/models/expense_test.dart
```

To run tests with coverage:

```bash
flutter test --coverage
```

This will generate a `coverage/lcov.info` file. You can convert this to a more readable format with tools like `lcov` or `genhtml`.

## Test Guidelines

1. **Isolation**: Each test should be independent and not rely on the state from other tests.

2. **Mocking**: Use `SharedPreferences.setMockInitialValues()` to mock local storage.

3. **Naming**: Test names should clearly describe what they're testing.

4. **Structure**: Use `group()` to organize related tests and `setUp()` for common initialization.

5. **Assertions**: Use appropriate assertions like `expect()`, `isA()`, etc.

## Adding New Tests

When adding new features to the application, follow these steps to add tests:

1. Create a new test file in the appropriate directory if needed
2. Add test cases for normal operation, edge cases, and error handling
3. Run the tests to ensure they pass
4. Update this README if you add new test categories