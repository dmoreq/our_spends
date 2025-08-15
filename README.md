# Our Spends: AI-Powered Expense Tracking

**Our Spends** is a modern, AI-powered expense tracking application built with Flutter. It provides an intuitive and conversational way to manage your finances, combining powerful expense tracking features with a multi-provider AI chatbot.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Flutter Version](https://img.shields.io/badge/Flutter-3.x-blue.svg)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-3.x-blue.svg)](https://dart.dev)

---

## ✨ Key Features

- **AI-Powered Chatbot**: Add expenses, search, and get spending insights using natural language. Supports **Gemini, OpenAI, Claude, and DeepSeek**.
- **Comprehensive Expense Tracking**: Record expenses with categories, tags, dates, and descriptions.
- **Offline-First**: Your data is stored locally on your device for privacy and offline access.
- **Multi-Language Support**: Fully localized in **English** and **Vietnamese**.
- **Customizable Themes**: Switch between light, dark, and system themes.
- **Data Export**: Export your financial data to CSV.

For a complete list of features, see the [Features](./FEATURES.md) document.

## 🚀 Getting Started

### Prerequisites

- **Flutter SDK**: Version 3.x or higher.
- **Dart SDK**: Version 3.x or higher.
- **An IDE**: Android Studio, VS Code, or your preferred editor.
- **AI Provider API Key (Optional)**: To use the AI features, you'll need an API key from Gemini, OpenAI, Claude, or DeepSeek.

### Installation and Setup

1. **Clone the Repository**
   ```bash
   git clone https://github.com/your-username/our-spends.git
   cd our-spends
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure AI Provider**
   - Open the app and navigate to **Settings > AI Provider**.
   - Select your preferred provider and enter your API key.
   - For more details, refer to the [AI Setup Guide](./AI_SETUP.md).

4. **Run the Application**
   ```bash
   flutter run
   ```

## 🏗️ Architecture

The application follows a clean, scalable architecture that separates concerns into three main layers: **Presentation**, **Business Logic**, and **Data**.

- **State Management**: We use the **Provider** package for efficient and reactive state management.
- **Database**: A local **SQLite** database ensures data persistence and offline functionality.
- **Service-Oriented**: Business logic is encapsulated in services (e.g., `DatabaseService`, `AIService`).

For a detailed explanation, please see the [Architecture Document](./ARCHITECTURE.md).

## 📂 Project Structure

```
lib/
├── l10n/           # Localization files
├── models/         # Data models (Expense, Category, etc.)
├── providers/      # State management providers
├── screens/        # UI screens
├── services/       # Business logic and API services
├── utils/          # Utility functions and constants
├── widgets/        # Reusable UI widgets
└── main.dart       # App entry point
```

## 🤝 Contributing

Contributions are welcome! Whether you want to fix a bug, add a feature, or improve the documentation, we appreciate your help.

Please read our [Contributing Guidelines](./CONTRIBUTING.md) to get started.

## 🗺️ Roadmap

- [ ] **Cloud Sync**: Optional synchronization across multiple devices.
- [ ] **Budgeting Tools**: Set and track spending budgets.
- [ ] **Receipt Scanning (OCR)**: Automatically create expenses from receipts.
- [ ] **Advanced Data Visualization**: Interactive charts and graphs.

## 📚 Documentation

- [Architecture](./ARCHITECTURE.md)
- [Database Design](./DATABASE_DESIGN.md)
- [AI Setup Guide](./AI_SETUP.md)
- [Features Overview](./FEATURES.md)
- [Navigation Structure](./NAVIGATION.md)

## 📄 License

This project is licensed under the MIT License. See the [LICENSE](./LICENSE) file for more details.
