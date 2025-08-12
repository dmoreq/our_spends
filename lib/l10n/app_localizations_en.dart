// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Our Spends';

  @override
  String get chatTitle => 'Expense Chat';

  @override
  String get chatHint => 'Tell me about your expense...';

  @override
  String get chatEmptyTitle => 'Start tracking your expenses';

  @override
  String get chatEmptySubtitle =>
      'Tell me about your purchases and I\'ll help you track them';

  @override
  String get send => 'Send';

  @override
  String get settings => 'Settings';

  @override
  String get expenses => 'Expenses';

  @override
  String get error => 'Error';

  @override
  String get noExpenses => 'No Expenses';

  @override
  String get addExpense => 'Add Expense';

  @override
  String get category => 'Category';

  @override
  String get date => 'Date';

  @override
  String get location => 'Location';

  @override
  String get paymentMethod => 'Payment Method';

  @override
  String get notes => 'Notes';

  @override
  String get chat => 'Chat';

  @override
  String get save => 'Save';

  @override
  String get expenseTitleLabel => 'Title';

  @override
  String get expenseTitlePlaceholder => 'e.g., Lunch with colleagues';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get expenseAmountLabel => 'Amount';

  @override
  String get expenseAmountPlaceholder => 'e.g., 15.50';

  @override
  String get invalidNumber => 'Please enter a valid number';

  @override
  String get currency => 'Currency';

  @override
  String get expenseDateLabel => 'Date';

  @override
  String get expenseCategoryLabel => 'Category';

  @override
  String get locationPlaceholder => 'e.g., Cafe Central';

  @override
  String get expenseNotesLabel => 'Notes';

  @override
  String get expenseNotesPlaceholder => 'e.g., Discussed project milestones';

  @override
  String get expenseCategoryFood => 'Food';

  @override
  String get expenseCategoryTransport => 'Transport';

  @override
  String get expenseCategoryShopping => 'Shopping';

  @override
  String get expenseCategoryEntertainment => 'Entertainment';

  @override
  String get expenseCategoryUtilities => 'Utilities';

  @override
  String get expenseCategoryHealth => 'Health';

  @override
  String get expenseCategoryTravel => 'Travel';

  @override
  String get expenseCategoryEducation => 'Education';

  @override
  String get expenseCategoryOther => 'Other';

  @override
  String get expenseAddedSuccess => 'Expense added successfully';

  @override
  String get expenseAddedError => 'Error adding expense';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get selectTheme => 'Select Theme';

  @override
  String get systemTheme => 'System Default';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';

  @override
  String get reports => 'Reports';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get english => 'English';

  @override
  String get vietnamese => 'Vietnamese';

  @override
  String get support => 'Support';

  @override
  String get helpAndFaq => 'Help & FAQ';

  @override
  String get helpAndFaqSubtitle => 'Get help and find answers';

  @override
  String get sendFeedback => 'Send Feedback';

  @override
  String get sendFeedbackSubtitle => 'Share your thoughts with us';

  @override
  String get userProfile => 'User Profile';

  @override
  String get manageAccount => 'Manage your account settings';

  @override
  String get preferences => 'Preferences';

  @override
  String get aiSettings => 'AI Settings';

  @override
  String get aiSettingsSubtitle => 'Configure AI providers and API keys';

  @override
  String get dataAndAnalytics => 'Data & Analytics';

  @override
  String get reportsSubtitle => 'View expense reports and insights';

  @override
  String get dataSync => 'Data Sync';

  @override
  String get dataSyncSubtitle => 'Backup and sync your data';

  @override
  String get aiChat => 'AI Chat';

  @override
  String get initializingAiChat => 'Initializing AI chat...';

  @override
  String failedToInitializeAiProvider(Object error) {
    return 'Failed to initialize AI provider: $error';
  }

  @override
  String anErrorOccurred(Object error) {
    return 'An error occurred: $error';
  }

  @override
  String get aiAssistant => 'AI Assistant';

  @override
  String get alwaysActive => 'Always active';

  @override
  String get typeAMessage => 'Type a message...';

  @override
  String get generateExpenseReport => 'Generate expense report';

  @override
  String get addNewExpense => 'Add a new expense';

  @override
  String get generateInsights => 'Generate Insights';

  @override
  String get clearConversation => 'Clear conversation';

  @override
  String get expenseSavedToYourTracker => '💡 Expense saved to your tracker!';

  @override
  String get generatingSpendingInsights => 'Generating spending insights...';

  @override
  String get spendingInsights => 'Spending Insights';

  @override
  String get couldNotGenerateInsights =>
      'Could not generate insights at this time.';

  @override
  String errorLoadingSettings(Object error) {
    return 'Error loading settings: $error';
  }

  @override
  String get settingsSavedSuccessfully => 'Settings saved successfully!';

  @override
  String errorSavingSettings(Object error) {
    return 'Error saving settings: $error';
  }

  @override
  String get aiProvider => 'AI Provider';

  @override
  String get aiProviderDescription =>
      'This app uses Google Gemini for expense analysis and insights.';

  @override
  String get geminiGoogle => 'Gemini (Google)';

  @override
  String get apiKey => 'API Key';

  @override
  String get enterYourApiKey => 'Enter your API key';

  @override
  String get getYourApiKey => 'Get your API key from Google AI Studio';

  @override
  String get apiTermsOfService =>
      'By using this feature, you agree to the API\'s terms of service.';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get dataUsage => 'Data Usage';

  @override
  String get dataUsageDescription =>
      'Your expense data will be sent to the AI provider for analysis. We do not store your data.';

  @override
  String get learnMore => 'Learn More';

  @override
  String get systemPrompt =>
      'You are a helpful AI assistant for a family expense tracking app. Help users track expenses, answer questions about their spending, and provide financial insights.';

  @override
  String get systemPromptWithContext =>
      'You are a helpful AI assistant for a family expense tracking app. Help users track expenses, answer questions about their spending, and provide financial insights.\n\nHere is information about the user\'s recent expenses:';

  @override
  String expenseInfo(
    Object amount,
    Object category,
    Object currency,
    Object date,
    Object index,
    Object item,
  ) {
    return '\n$index. Item: $item, Amount: $amount $currency, Category: $category, Date: $date';
  }

  @override
  String get extractionInstruction =>
      '\n\nWhen the user mentions a new expense, extract the expense information and let them know you can save it to their expense tracker.';
}
