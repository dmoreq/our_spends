# 🏠 Our Spends

An AI-powered expense tracking application built with Flutter. This app helps you track, analyze, and optimize your spending with intelligent insights.

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Flutter](https://img.shields.io/badge/Flutter-3.8.1-blue.svg)
![Firebase](https://img.shields.io/badge/Firebase-3.6.0-orange.svg)

## ✨ Features

- **💰 Expense Tracking**: Record and categorize all your family expenses
- **🤖 AI-Powered Insights**: Get personalized spending analysis and recommendations
- **📊 Visual Reports**: View your spending patterns with intuitive charts
- **👨‍👩‍👧‍👦 Multi-User Support**: Track expenses for the whole family
- **🔄 Recurring Expenses**: Set up and track regular payments
- **🌐 Multi-Language**: Supports English and Vietnamese
- **🔌 Multiple AI Providers**: Choose between Gemini, OpenAI, Claude, or DeepSeek

## 📱 Screenshots

*Coming soon*

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (^3.8.1)
- Dart SDK (^3.8.1)
- Firebase account (for authentication and cloud storage)
- AI provider API key (Gemini, OpenAI, Claude, or DeepSeek)

### Installation

1. **Clone the repository**

```bash
git clone https://github.com/yourusername/family_expense_tracker.git
cd family_expense_tracker
```

2. **Install dependencies**

```bash
flutter pub get
```

3. **Configure Firebase** (optional for full functionality)

Replace the demo Firebase configuration in `main.dart` with your actual Firebase project details.

4. **Configure AI Provider**

Follow the instructions in [AI_SETUP.md](./AI_SETUP.md) to set up your preferred AI provider.

5. **Run the app**

```bash
flutter run
```

## 🏗️ Architecture

The app follows a clean architecture pattern with the following components:

- **Models**: Data structures for expenses, categories, and chat messages
- **Providers**: State management using the Provider pattern
- **Services**: Business logic and API interactions
- **Screens**: User interface components
- **Widgets**: Reusable UI elements

### Key Components

- **AI Service**: Multi-provider system supporting Gemini, OpenAI, Claude, and DeepSeek
- **Database Service**: Local SQLite storage with cloud sync capabilities
- **Expense Provider**: Central state management for expense data
- **Authentication**: Firebase authentication with Google Sign-In

## 🔧 Configuration

### AI Providers

The app supports multiple AI providers that can be configured in the settings:

- **Gemini**: Google's generative AI model
- **OpenAI**: ChatGPT models
- **Claude**: Anthropic's Claude models
- **DeepSeek**: DeepSeek AI models

API keys can be configured in the app settings or directly in `lib/config/api_config.dart`.

### Localization

The app supports English and Vietnamese languages. Localization files are located in the `lib/l10n` directory.

## 🤝 Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](./CONTRIBUTING.md) for guidelines.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.

## 📚 Documentation

- [Database Design](./DATABASE_DESIGN.md)
- [AI Setup Guide](./AI_SETUP.md)
