# Contributing to Our Spends

Thank you for considering contributing to the Our Spends project! This document provides guidelines and instructions for contributing.

## Code of Conduct

Please be respectful and considerate of others when contributing to this project. We aim to foster an inclusive and welcoming community.

## How Can I Contribute?

### Reporting Bugs

Bugs are tracked as GitHub issues. When you create an issue, please include:

- A clear and descriptive title
- Steps to reproduce the issue
- Expected behavior vs. actual behavior
- Screenshots if applicable
- Any relevant logs or error messages
- Your environment (Flutter version, device/emulator, OS)

### Suggesting Enhancements

Enhancement suggestions are also tracked as GitHub issues. When suggesting an enhancement, please include:

- A clear and descriptive title
- A detailed description of the proposed functionality
- Any potential implementation details you can provide
- Why this enhancement would be useful to most users

### Pull Requests

1. Fork the repository
2. Create a new branch for your feature or bugfix (`git checkout -b feature/your-feature-name`)
3. Make your changes
4. Run tests and ensure they pass
5. Commit your changes with clear, descriptive commit messages
6. Push to your branch
7. Submit a pull request to the main repository

## Development Setup

### Prerequisites

- Flutter SDK (^3.8.1)
- Dart SDK (^3.8.1)
- An IDE (VS Code, Android Studio, etc.)
- Git

### Setup Steps

1. Clone the repository
   ```bash
   git clone https://github.com/yourusername/family_expense_tracker.git
   cd family_expense_tracker
   ```

2. Install dependencies
   ```bash
   flutter pub get
   ```

3. Run the app
   ```bash
   flutter run
   ```

## Coding Guidelines

### Style Guide

- Follow the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful variable and function names
- Write comments for complex logic
- Keep functions small and focused on a single task

### Testing

- Write unit tests for new functionality
- Ensure all tests pass before submitting a pull request
- Run tests with `flutter test`

### Documentation

- Update documentation for any changes to the API or functionality
- Use dartdoc comments for public APIs
- Keep the README.md up to date

## Project Structure

```
lib/
├── config/       # Configuration files
├── l10n/         # Localization files
├── models/       # Data models
├── providers/    # State management
├── screens/      # UI screens
├── services/     # Business logic and API services
├── theme/        # App theme
├── widgets/      # Reusable UI components
└── main.dart     # App entry point
```

## Feature Development Guidelines

### Adding a New Feature

1. Create a new branch for your feature
2. Implement the feature with appropriate tests
3. Update documentation
4. Submit a pull request

### Adding a New AI Provider

To add support for a new AI provider:

1. Create a new service class in `lib/services/` (e.g., `new_provider_service.dart`)
2. Implement the required methods (see existing providers for reference)
3. Update `AIService` in `ai_service.dart` to include your new provider
4. Add the provider to `supportedProviders` in `api_config.dart`
5. Update the AI settings screen to include the new provider

## Release Process

1. Version numbers follow [Semantic Versioning](https://semver.org/)
2. Update the version in `pubspec.yaml`
3. Create a changelog entry
4. Tag the release in git

## Questions?

If you have any questions about contributing, please open an issue or contact the project maintainers.

Thank you for contributing to Our Spends!