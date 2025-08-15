# 🤖 AI Integration Setup Guide

This guide will help you set up the AI integration for your Our Spends app. The app supports multiple AI providers, giving you flexibility in choosing which service to use.

## 📋 Supported AI Providers

The app currently supports the following AI providers:

1. **Gemini** (Google AI)
2. **OpenAI** (ChatGPT)
3. **Claude** (Anthropic)
4. **DeepSeek**

## 🔑 Getting API Keys

To use the AI features, you need an API key from one of the supported providers.

### Gemini API Key

1.  Go to **[Google AI Studio](https://ai.google.dev/)**.
2.  Click on **"Get API key in Google AI Studio"**.
3.  Sign in with your Google account.
4.  Click **"Create API Key"** and copy the generated key.

### OpenAI API Key

1.  Go to the **[OpenAI Platform](https://platform.openai.com/api-keys)**.
2.  Sign in to your OpenAI account.
3.  Click **"Create new secret key"** and copy the key.

### Claude API Key

1.  Go to the **[Anthropic Console](https://console.anthropic.com/)**.
2.  Sign in to your account.
3.  Navigate to the API Keys section and click **"Create Key"**.

### DeepSeek API Key

1.  Go to the **[DeepSeek Platform](https://platform.deepseek.com/)**.
2.  Sign in and navigate to the API section.
3.  Generate and copy a new API key.

## ⚙️ Configuring AI Providers in the App

### Method 1: Using the Settings UI (Recommended)

1.  Open the Our Spends app.
2.  Navigate to **Settings > AI Settings**.
3.  Select your preferred AI provider.
4.  Enter your API key.
5.  Tap **"Test Connection"** to verify, then **"Save"**.

### Method 2: Direct Code Configuration

You can also configure the API keys directly in the code:

1.  Open `lib/config/api_config.dart`.
2.  Replace the placeholder keys with your actual keys:

    ```dart
    // lib/config/api_config.dart
    static const String geminiApiKey = 'your_gemini_api_key_here';
    static const String openaiApiKey = 'your_openai_api_key_here';
    static const String claudeApiKey = 'your_claude_api_key_here';
    static const String deepseekApiKey = 'your_deepseek_api_key_here';
    ```

3.  You can also set a default provider:

    ```dart
    static const String defaultProvider = 'gemini'; // Options: 'gemini', 'openai', 'claude', 'deepseek'
    ```

## 🚀 Features

### ✨ AI Capabilities

*   **Smart Chat Interface**: Converse naturally with an AI about your expenses.
*   **Expense Detection**: The AI automatically detects when you mention purchases.
*   **Smart Search**: Use natural language to search your expenses.
*   **Spending Insights**: Generate personalized financial insights.
*   **Context Awareness**: The AI remembers your conversation and expense history.
*   **Multi-Language Support**: Works in English and Vietnamese.

### 💬 Example Conversations

**User**: "I just bought coffee for $5"
**AI**: "I'll help you track that coffee purchase! Would you like me to add it to your expenses?"

**User**: "How am I doing with my spending this month?"
**AI**: "Based on your expenses, you've spent $450 this month. Your top category is food at $180..."

## 🔧 Customization Options

### Model Configuration

The app uses the following default models:

*   **Gemini**: `gemini-1.5-flash`
*   **OpenAI**: `gpt-4o-mini`
*   **Claude**: `claude-3-haiku-20240307`
*   **DeepSeek**: `deepseek-chat`

To change these, modify the `defaultModels` map in `lib/config/api_config.dart`.

## 🔒 Security Best Practices

1.  **Never commit API keys** to version control.
2.  Use environment variables for production builds.
3.  Monitor your API usage in your provider's dashboard.

## 🐛 Troubleshooting

### Common Issues

1.  **"API Key not found"**: Verify your key is set correctly in the app or `api_config.dart`.
2.  **"Rate limit exceeded"**: You've reached your provider's usage limit.
3.  **Slow responses**: Try a faster model or check your internet connection.
4.  **Provider not responding**: The app will fall back to Gemini if another provider fails.

## 📝 Additional Resources

*   [Gemini API Documentation](https://ai.google.dev/docs)
*   [OpenAI API Documentation](https://platform.openai.com/docs/api-reference)
*   [Claude API Documentation](https://docs.anthropic.com/claude/reference/getting-started-with-the-api)
*   [DeepSeek API Documentation](https://platform.deepseek.com/docs)