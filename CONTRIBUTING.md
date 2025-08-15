# Contributing to Our Spends

First off, thank you for considering contributing to Our Spends! We appreciate your time and effort. This guide will help you get started.

## Code of Conduct

We have a [Code of Conduct](CODE_OF_CONDUCT.md) that we expect all contributors to adhere to. Please be respectful and considerate of others.

## How to Contribute

### Reporting Bugs

If you find a bug, please create a GitHub issue with the following:

*   A clear, descriptive title.
*   Steps to reproduce the issue.
*   What you expected to happen versus what actually happened.
*   Screenshots, if applicable.
*   Your environment details (Flutter version, OS, device).

### Suggesting Enhancements

Have an idea for a new feature? Create a GitHub issue with:

*   A clear, descriptive title.
*   A detailed explanation of the proposed feature.
*   Why this enhancement would be useful.

### Submitting Pull Requests

1.  **Fork the repository** and create a new branch from `main`.
2.  **Make your changes** in your feature branch.
3.  **Write tests** for any new functionality.
4.  **Ensure all tests pass** by running `flutter test`.
5.  **Follow the coding guidelines** below.
6.  **Commit your changes** with a clear, descriptive commit message.
7.  **Push your branch** to your fork.
8.  **Submit a pull request** to the main repository.

## Development Setup

1.  **Clone the repository**:
    ```bash
    git clone https://github.com/your-username/our-spends.git
    cd our-spends
    ```
2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```
3.  **Run the app**:
    ```bash
    flutter run
    ```

## Coding Guidelines

*   **Style**: Follow the [Effective Dart: Style](https://dart.dev/guides/language/effective-dart/style) guide.
*   **Naming**: Use meaningful names for variables, functions, and classes.
*   **Simplicity**: Keep functions small and focused on a single task.
*   **Documentation**: Add comments for complex logic and update documentation for any new features.

## Project Structure

```
lib/
├── config/       # API keys and configuration
├── l10n/         # Localization files
├── models/       # Data models
├── providers/    # State management (ChangeNotifier)
├── repositories/ # Data access layer
├── screens/      # UI screens
├── services/     # Business logic services
├── theme/        # App theme and styling
├── utils/        # Utility functions
└── widgets/      # Reusable UI widgets
```

## Adding a New AI Provider

1.  Create a new service class in `lib/services/` that implements the `AIService` interface.
2.  Add your new provider to the `supportedProviders` map in `lib/config/api_config.dart`.
3.  Update the AI settings screen to include the new provider option.

## Questions?

If you have any questions, feel free to open an issue. We're here to help!