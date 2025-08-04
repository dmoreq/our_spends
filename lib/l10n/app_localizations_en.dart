// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Family Expense Tracker';

  @override
  String get loginTitle => 'Welcome';

  @override
  String get loginSubtitle => 'Track your family expenses with AI';

  @override
  String get signInWithGoogle => 'Sign in with Google';

  @override
  String get chatTitle => 'Expense Chat';

  @override
  String get chatHint => 'Tell me about your expense...';

  @override
  String get send => 'Send';

  @override
  String get settings => 'Settings';

  @override
  String get logout => 'Logout';

  @override
  String get currency => 'Currency';

  @override
  String get language => 'Language';

  @override
  String get reports => 'Reports';

  @override
  String get weekly => 'Weekly';

  @override
  String get monthly => 'Monthly';

  @override
  String get yearly => 'Yearly';

  @override
  String get total => 'Total';

  @override
  String get category => 'Category';

  @override
  String get amount => 'Amount';

  @override
  String get noExpenses => 'No expenses found';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get retry => 'Retry';

  @override
  String get cancel => 'Cancel';

  @override
  String get ok => 'OK';

  @override
  String get expenseLogged => 'Expense logged successfully';

  @override
  String get networkError => 'Network error. Please check your connection.';

  @override
  String get authError => 'Authentication failed. Please try again.';

  @override
  String get unknownError => 'An unknown error occurred.';
}
