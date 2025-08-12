import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Our Spends'**
  String get appTitle;

  /// No description provided for @chatTitle.
  ///
  /// In en, this message translates to:
  /// **'Expense Chat'**
  String get chatTitle;

  /// No description provided for @chatHint.
  ///
  /// In en, this message translates to:
  /// **'Tell me about your expense...'**
  String get chatHint;

  /// No description provided for @chatEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Start tracking your expenses'**
  String get chatEmptyTitle;

  /// No description provided for @chatEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tell me about your purchases and I\'ll help you track them'**
  String get chatEmptySubtitle;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @expenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expenses;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @noExpenses.
  ///
  /// In en, this message translates to:
  /// **'No Expenses'**
  String get noExpenses;

  /// No description provided for @addExpense.
  ///
  /// In en, this message translates to:
  /// **'Add Expense'**
  String get addExpense;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @chat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chat;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @expenseTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get expenseTitleLabel;

  /// No description provided for @expenseTitlePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'e.g., Lunch with colleagues'**
  String get expenseTitlePlaceholder;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  /// No description provided for @expenseAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get expenseAmountLabel;

  /// No description provided for @expenseAmountPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'e.g., 15.50'**
  String get expenseAmountPlaceholder;

  /// No description provided for @invalidNumber.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number'**
  String get invalidNumber;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @expenseDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get expenseDateLabel;

  /// No description provided for @expenseCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get expenseCategoryLabel;

  /// No description provided for @locationPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'e.g., Cafe Central'**
  String get locationPlaceholder;

  /// No description provided for @expenseNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get expenseNotesLabel;

  /// No description provided for @expenseNotesPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'e.g., Discussed project milestones'**
  String get expenseNotesPlaceholder;

  /// No description provided for @expenseCategoryFood.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get expenseCategoryFood;

  /// No description provided for @expenseCategoryTransport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get expenseCategoryTransport;

  /// No description provided for @expenseCategoryShopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get expenseCategoryShopping;

  /// No description provided for @expenseCategoryEntertainment.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get expenseCategoryEntertainment;

  /// No description provided for @expenseCategoryUtilities.
  ///
  /// In en, this message translates to:
  /// **'Utilities'**
  String get expenseCategoryUtilities;

  /// No description provided for @expenseCategoryHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get expenseCategoryHealth;

  /// No description provided for @expenseCategoryTravel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get expenseCategoryTravel;

  /// No description provided for @expenseCategoryEducation.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get expenseCategoryEducation;

  /// No description provided for @expenseCategoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get expenseCategoryOther;

  /// No description provided for @expenseAddedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Expense added successfully'**
  String get expenseAddedSuccess;

  /// No description provided for @expenseAddedError.
  ///
  /// In en, this message translates to:
  /// **'Error adding expense'**
  String get expenseAddedError;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @selectTheme.
  ///
  /// In en, this message translates to:
  /// **'Select Theme'**
  String get selectTheme;

  /// No description provided for @systemTheme.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get systemTheme;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkTheme;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @vietnamese.
  ///
  /// In en, this message translates to:
  /// **'Vietnamese'**
  String get vietnamese;

  /// No description provided for @support.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get support;

  /// No description provided for @helpAndFaq.
  ///
  /// In en, this message translates to:
  /// **'Help & FAQ'**
  String get helpAndFaq;

  /// No description provided for @helpAndFaqSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get help and find answers'**
  String get helpAndFaqSubtitle;

  /// No description provided for @sendFeedback.
  ///
  /// In en, this message translates to:
  /// **'Send Feedback'**
  String get sendFeedback;

  /// No description provided for @sendFeedbackSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share your thoughts with us'**
  String get sendFeedbackSubtitle;

  /// No description provided for @userProfile.
  ///
  /// In en, this message translates to:
  /// **'User Profile'**
  String get userProfile;

  /// No description provided for @manageAccount.
  ///
  /// In en, this message translates to:
  /// **'Manage your account settings'**
  String get manageAccount;

  /// No description provided for @preferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferences;

  /// No description provided for @aiSettings.
  ///
  /// In en, this message translates to:
  /// **'AI Settings'**
  String get aiSettings;

  /// No description provided for @aiSettingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Configure AI providers and API keys'**
  String get aiSettingsSubtitle;

  /// No description provided for @dataAndAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Data & Analytics'**
  String get dataAndAnalytics;

  /// No description provided for @reportsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View expense reports and insights'**
  String get reportsSubtitle;

  /// No description provided for @dataSync.
  ///
  /// In en, this message translates to:
  /// **'Data Sync'**
  String get dataSync;

  /// No description provided for @dataSyncSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Backup and sync your data'**
  String get dataSyncSubtitle;

  /// No description provided for @aiChat.
  ///
  /// In en, this message translates to:
  /// **'AI Chat'**
  String get aiChat;

  /// No description provided for @initializingAiChat.
  ///
  /// In en, this message translates to:
  /// **'Initializing AI chat...'**
  String get initializingAiChat;

  /// No description provided for @failedToInitializeAiProvider.
  ///
  /// In en, this message translates to:
  /// **'Failed to initialize AI provider: {error}'**
  String failedToInitializeAiProvider(Object error);

  /// No description provided for @anErrorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred: {error}'**
  String anErrorOccurred(Object error);

  /// No description provided for @aiAssistant.
  ///
  /// In en, this message translates to:
  /// **'AI Assistant'**
  String get aiAssistant;

  /// No description provided for @alwaysActive.
  ///
  /// In en, this message translates to:
  /// **'Always active'**
  String get alwaysActive;

  /// No description provided for @typeAMessage.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get typeAMessage;

  /// No description provided for @generateExpenseReport.
  ///
  /// In en, this message translates to:
  /// **'Generate expense report'**
  String get generateExpenseReport;

  /// No description provided for @addNewExpense.
  ///
  /// In en, this message translates to:
  /// **'Add a new expense'**
  String get addNewExpense;

  /// No description provided for @generateInsights.
  ///
  /// In en, this message translates to:
  /// **'Generate Insights'**
  String get generateInsights;

  /// No description provided for @clearConversation.
  ///
  /// In en, this message translates to:
  /// **'Clear conversation'**
  String get clearConversation;

  /// No description provided for @expenseSavedToYourTracker.
  ///
  /// In en, this message translates to:
  /// **'💡 Expense saved to your tracker!'**
  String get expenseSavedToYourTracker;

  /// No description provided for @generatingSpendingInsights.
  ///
  /// In en, this message translates to:
  /// **'Generating spending insights...'**
  String get generatingSpendingInsights;

  /// No description provided for @spendingInsights.
  ///
  /// In en, this message translates to:
  /// **'Spending Insights'**
  String get spendingInsights;

  /// No description provided for @couldNotGenerateInsights.
  ///
  /// In en, this message translates to:
  /// **'Could not generate insights at this time.'**
  String get couldNotGenerateInsights;

  /// No description provided for @errorLoadingSettings.
  ///
  /// In en, this message translates to:
  /// **'Error loading settings: {error}'**
  String errorLoadingSettings(Object error);

  /// No description provided for @settingsSavedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Settings saved successfully!'**
  String get settingsSavedSuccessfully;

  /// No description provided for @errorSavingSettings.
  ///
  /// In en, this message translates to:
  /// **'Error saving settings: {error}'**
  String errorSavingSettings(Object error);

  /// No description provided for @aiProvider.
  ///
  /// In en, this message translates to:
  /// **'AI Provider'**
  String get aiProvider;

  /// No description provided for @aiProviderDescription.
  ///
  /// In en, this message translates to:
  /// **'This app uses Google Gemini for expense analysis and insights.'**
  String get aiProviderDescription;

  /// No description provided for @geminiGoogle.
  ///
  /// In en, this message translates to:
  /// **'Gemini (Google)'**
  String get geminiGoogle;

  /// No description provided for @apiKey.
  ///
  /// In en, this message translates to:
  /// **'API Key'**
  String get apiKey;

  /// No description provided for @enterYourApiKey.
  ///
  /// In en, this message translates to:
  /// **'Enter your API key'**
  String get enterYourApiKey;

  /// No description provided for @getYourApiKey.
  ///
  /// In en, this message translates to:
  /// **'Get your API key from Google AI Studio'**
  String get getYourApiKey;

  /// No description provided for @apiTermsOfService.
  ///
  /// In en, this message translates to:
  /// **'By using this feature, you agree to the API\'s terms of service.'**
  String get apiTermsOfService;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @dataUsage.
  ///
  /// In en, this message translates to:
  /// **'Data Usage'**
  String get dataUsage;

  /// No description provided for @dataUsageDescription.
  ///
  /// In en, this message translates to:
  /// **'Your expense data will be sent to the AI provider for analysis. We do not store your data.'**
  String get dataUsageDescription;

  /// No description provided for @learnMore.
  ///
  /// In en, this message translates to:
  /// **'Learn More'**
  String get learnMore;

  /// No description provided for @systemPrompt.
  ///
  /// In en, this message translates to:
  /// **'You are a helpful AI assistant for a family expense tracking app. Help users track expenses, answer questions about their spending, and provide financial insights.'**
  String get systemPrompt;

  /// No description provided for @systemPromptWithContext.
  ///
  /// In en, this message translates to:
  /// **'You are a helpful AI assistant for a family expense tracking app. Help users track expenses, answer questions about their spending, and provide financial insights.\n\nHere is information about the user\'s recent expenses:'**
  String get systemPromptWithContext;

  /// No description provided for @expenseInfo.
  ///
  /// In en, this message translates to:
  /// **'\n{index}. Item: {item}, Amount: {amount} {currency}, Category: {category}, Date: {date}'**
  String expenseInfo(
    Object amount,
    Object category,
    Object currency,
    Object date,
    Object index,
    Object item,
  );

  /// No description provided for @extractionInstruction.
  ///
  /// In en, this message translates to:
  /// **'\n\nWhen the user mentions a new expense, extract the expense information and let them know you can save it to their expense tracker.'**
  String get extractionInstruction;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
