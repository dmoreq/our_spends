# 🤖 AI Integration Setup Guide

This guide will help you set up the AI integration for your Family Expense Tracker app. The app supports multiple AI providers, giving you flexibility in choosing which service to use.

## 📋 Supported AI Providers

The app currently supports the following AI providers:

1. **Gemini** (Google AI)
2. **OpenAI** (ChatGPT)
3. **Claude** (Anthropic)
4. **DeepSeek**

## 🔑 Getting API Keys

### Gemini API Key

1. **Visit Google AI Studio**
   - Go to [https://ai.google.dev/](https://ai.google.dev/)
   - Click on "Get API key in Google AI Studio"

2. **Create API Key**
   - Sign in with your Google account
   - Click "Create API Key"
   - Choose "Create API key in new project" or select an existing project
   - Copy the generated API key

### OpenAI API Key

1. **Visit OpenAI Platform**
   - Go to [https://platform.openai.com/api-keys](https://platform.openai.com/api-keys)
   - Sign in to your OpenAI account (or create one)

2. **Create API Key**
   - Click "Create new secret key"
   - Give your key a name (optional)
   - Copy the generated API key (note: it will only be shown once)

### Claude API Key

1. **Visit Anthropic Console**
   - Go to [https://console.anthropic.com/](https://console.anthropic.com/)
   - Sign in or create an account

2. **Create API Key**
   - Navigate to the API Keys section
   - Click "Create Key"
   - Copy the generated API key

### DeepSeek API Key

1. **Visit DeepSeek Platform**
   - Go to [https://platform.deepseek.com/](https://platform.deepseek.com/)
   - Sign in or create an account

2. **Create API Key**
   - Navigate to the API section
   - Generate a new API key
   - Copy the generated key

## ⚙️ Configuring AI Providers in the App

### Method 1: Using the Settings UI (Recommended)

1. **Open the App**
   - Launch the Family Expense Tracker app

2. **Navigate to AI Settings**
   - Tap on the Settings icon
   - Select "AI Settings"

3. **Configure Provider**
   - Select your preferred AI provider from the dropdown
   - Enter your API key in the corresponding field
   - Tap "Test Connection" to verify it works
   - Tap "Save" to store your settings

### Method 2: Direct Code Configuration

Alternatively, you can configure the API keys directly in the code:

1. **Open `lib/config/api_config.dart`**

2. **Replace API Keys**
   ```dart
   // Gemini AI (Google)
   static const String geminiApiKey = 'your_gemini_api_key_here';
   
   // OpenAI ChatGPT
   static const String openaiApiKey = 'your_openai_api_key_here';
   
   // Anthropic Claude
   static const String claudeApiKey = 'your_claude_api_key_here';
   
   // DeepSeek
   static const String deepseekApiKey = 'your_deepseek_api_key_here';
   ```

3. **Set Default Provider** (Optional)
   ```dart
   // Default AI Provider
   static const String defaultProvider = 'gemini'; // Options: 'gemini', 'openai', 'claude', 'deepseek'
   ```

## 🚀 Features

### ✨ AI Capabilities

- **Smart Chat Interface**: Natural conversation with AI about expenses
- **Expense Detection**: AI automatically detects when you mention purchases
- **Spending Insights**: Generate personalized financial insights
- **Context Awareness**: AI knows about your expense history
- **Multi-Language Support**: Works in English and Vietnamese

### 💬 Example Conversations

**User**: "I just bought coffee for $5"
**AI**: "I'll help you track that coffee purchase! Would you like me to add it to your expenses?"

**User**: "How am I doing with my spending this month?"
**AI**: "Based on your expenses, you've spent $450 this month. Your top category is food at $180..."

## 🔧 Customization Options

### Model Configuration

Each AI provider uses a specific model by default:

- **Gemini**: `gemini-1.5-flash` (fast, efficient)
- **OpenAI**: `gpt-4o-mini` (good balance of capability and cost)
- **Claude**: `claude-3-haiku-20240307` (fast, efficient)
- **DeepSeek**: `deepseek-chat` (general purpose)

To change these defaults, modify the `defaultModels` map in `lib/config/api_config.dart`.

## 🔒 Security Best Practices

1. **Never commit API keys** to version control
2. **Use environment variables** in production:
   ```dart
   static const String apiKey = String.fromEnvironment('API_KEY');
   ```
3. **Implement rate limiting** for production apps
4. **Monitor API usage** in your provider's dashboard

## 🐛 Troubleshooting

### Common Issues

1. **"API Key not found" error**
   - Verify your API key is correctly set in the app settings or `api_config.dart`
   - Ensure the key has proper permissions

2. **"Rate limit exceeded" error**
   - You've reached your provider's usage limit
   - Wait and try again later, or upgrade your plan

3. **Slow responses**
   - Try switching to a faster model (e.g., Gemini Flash or Claude Haiku)
   - Check your internet connection

4. **Provider not responding**
   - The app will automatically fall back to Gemini if another provider fails
   - Check the provider's status page for outages

## 📝 Additional Resources

- [Gemini API Documentation](https://ai.google.dev/docs)
- [OpenAI API Documentation](https://platform.openai.com/docs/api-reference)
- [Claude API Documentation](https://docs.anthropic.com/claude/reference/getting-started-with-the-api)
- [DeepSeek API Documentation](https://platform.deepseek.com/docs)