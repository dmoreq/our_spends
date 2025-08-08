// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';

import 'package:our_spends/main.dart';
import 'package:our_spends/providers/auth_provider.dart';
import 'package:our_spends/providers/expense_provider.dart';
import 'package:our_spends/providers/language_provider.dart';
import 'package:our_spends/l10n/app_localizations.dart';

// Mock providers
class MockAuthProvider extends Mock implements AuthProvider {
  @override
  bool get isAuthenticated => false;
  
  @override
  bool get isLoading => false;
}

class MockExpenseProvider extends Mock implements ExpenseProvider {}

class MockLanguageProvider extends Mock implements LanguageProvider {
  @override
  Locale get currentLocale => const Locale('en', '');
}

void main() {
  testWidgets('App loads correctly', (WidgetTester tester) async {
    // Using default test timeout
    // Create mock providers
    final mockAuthProvider = MockAuthProvider();
    final mockExpenseProvider = MockExpenseProvider();
    final mockLanguageProvider = MockLanguageProvider();
    
    // Build a test version of our app with mocked providers
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<AuthProvider>.value(value: mockAuthProvider),
          ChangeNotifierProvider<ExpenseProvider>.value(value: mockExpenseProvider),
          ChangeNotifierProvider<LanguageProvider>.value(value: mockLanguageProvider),
        ],
        child: MaterialApp(
          title: 'Our Spends',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: const Scaffold(
            body: Center(
              child: Text('Our Spends'),
            ),
          ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );

    // Verify that the app loads without crashing
    await tester.pumpAndSettle();
    
    // Check if the text is present
    expect(find.text('Our Spends'), findsOneWidget);
  });
}
