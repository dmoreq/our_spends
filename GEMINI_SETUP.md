# 🤖 Gemini AI Chat Integration Setup

This guide will help you set up the Gemini AI integration for your Family Expense Tracker app.

## 📋 Prerequisites

1. **Flutter SDK** (already installed)
2. **Google AI Studio Account** (free)

## 🔑 Getting Your Gemini API Key

1. **Visit Google AI Studio**
   - Go to [https://ai.google.dev/](https://ai.google.dev/)
   - Click on "Get API key in Google AI Studio"

2. **Create API Key**
   - Sign in with your Google account
   - Click "Create API Key"
   - Choose "Create API key in new project" or select an existing project
   - Copy the generated API key

3. **Configure the App**
   - Open `lib/config/api_config.dart`
   - Replace `YOUR_GEMINI_API_KEY_HERE` with your actual API key:
   ```dart
   static const String geminiApiKey = 'your_actual_api_key_here';
   ```

## 🚀 Features

### ✨ What's Included

- **Smart Chat Interface**: Natural conversation with AI about expenses
- **Expense Detection**: AI automatically detects when you mention purchases
- **Spending Insights**: Generate personalized financial insights
- **Context Awareness**: AI knows about your expense history
- **Real-time Responses**: Fast responses using Gemini 2.5 Flash model

### 💬 Example Conversations

**User**: "I just bought coffee for $5"
**AI**: "I'll help you track that coffee purchase! Would you like me to add it to your expenses?"

**User**: "How am I doing with my spending this month?"
**AI**: "Based on your expenses, you've spent $450 this month. Your top category is food at $180..."

## 🛠️ Installation Steps

1. **Install Dependencies**
   ```bash
   flutter pub get
   ```

2. **Configure API Key** (as described above)

3. **Run the App**
   ```bash
   flutter run -d web
   ```

4. **Test the Chat**
   - Navigate to the Chat tab
   - Try saying "I bought lunch for $12"
   - Click the insights button (📊) to generate spending insights

## 🔧 Customization Options

### Model Configuration
In `lib/services/gemini_service.dart`, you can adjust:

- **Model**: Currently using `gemini-2.5-flash` for speed
- **Temperature**: Controls creativity (0.0-1.0)
- **Max Tokens**: Maximum response length
- **Top K/P**: Controls response diversity

### Prompts
You can customize the AI prompts in `GeminiService` to:
- Change the AI's personality
- Add specific financial advice
- Include different expense categories
- Modify response formats

## 🔒 Security Best Practices

1. **Never commit API keys** to version control
2. **Use environment variables** in production:
   ```dart
   static const String geminiApiKey = String.fromEnvironment('GEMINI_API_KEY');
   ```
3. **Implement rate limiting** for production apps
4. **Monitor API usage** in Google AI Studio

## 🐛 Troubleshooting

### Common Issues

1. **"API Key not found" error**
   - Verify your API key is correctly set in `api_config.dart`
   - Ensure the key has proper permissions

2. **"Network error" messages**
   - Check your internet connection
   - Verify the API key is valid

3. **Slow responses**
   - Consider switching to a faster model
   - Check your network connection

### Getting Help

- **Gemini API Documentation**: [https://ai.google.dev/gemini-api/docs](https://ai.google.dev/gemini-api/docs)
- **Flutter Documentation**: [https://docs.flutter.dev/](https://docs.flutter.dev/)

## 📈 Next Steps

Consider adding these features:
- **Voice input** for hands-free expense tracking
- **Receipt scanning** with image analysis
- **Budget recommendations** based on spending patterns
- **Expense categorization** suggestions
- **Multi-language support** for international users

---

🎉 **You're all set!** Your Family Expense Tracker now has AI-powered chat capabilities.