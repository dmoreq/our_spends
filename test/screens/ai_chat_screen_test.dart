import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:our_spends/models/expense.dart';
import 'package:our_spends/providers/expense_provider.dart';
import 'package:our_spends/providers/language_provider.dart';
import 'package:our_spends/screens/ai_chat_screen.dart';
import 'package:our_spends/services/database_service.dart';
import 'package:our_spends/services/ai_service.dart';
import 'package:provider/provider.dart';
import 'package:our_spends/l10n/app_localizations.dart';

// Generate mocks for these classes
@GenerateMocks([
  ExpenseProvider,
  LanguageProvider,
  DatabaseService,
  AIService
])

// Import generated mocks file
import 'ai_chat_screen_test.mocks.dart';

void main() {
  group('AIChatScreen Integration Tests', () {
    late MockExpenseProvider mockExpenseProvider;
    late MockLanguageProvider mockLanguageProvider;
    late MockDatabaseService mockDatabaseService;
    late MockAIService mockAIService;
    
    setUp(() {
      mockExpenseProvider = MockExpenseProvider();
      mockLanguageProvider = MockLanguageProvider();
      mockDatabaseService = MockDatabaseService();
      mockAIService = MockAIService();
      
      // Mock language provider
      when(mockLanguageProvider.currentLocale).thenReturn(const Locale('en'));
    });
    
    testWidgets('AIChatScreen should show loading indicator while initializing', (WidgetTester tester) async {
      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<ExpenseProvider>.value(value: mockExpenseProvider),
              ChangeNotifierProvider<LanguageProvider>.value(value: mockLanguageProvider),
              Provider<DatabaseService>.value(value: mockDatabaseService),
              Provider<AIService>.value(value: mockAIService),
            ],
            child: const AIChatScreen(),
          ),
        ),
      );
      
      // Wait for the widget to build
      await tester.pump();
      
      // Verify that the loading indicator is displayed
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}