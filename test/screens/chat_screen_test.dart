import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:our_spends/providers/expense_provider.dart';
import 'package:our_spends/providers/language_provider.dart';
import 'package:our_spends/screens/ai_chat_screen.dart';
import 'package:provider/provider.dart';
import 'package:our_spends/l10n/app_localizations.dart';

@GenerateMocks([ExpenseProvider, LanguageProvider])
import 'chat_screen_test.mocks.dart';

void main() {
  group('AIChatScreen Tests', () {
    late MockExpenseProvider mockExpenseProvider;
    late MockLanguageProvider mockLanguageProvider;

    setUp(() {
      mockExpenseProvider = MockExpenseProvider();
      mockLanguageProvider = MockLanguageProvider();
      when(mockLanguageProvider.currentLocale).thenReturn(const Locale('en'));
    });

    Future<void> pumpWidget(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<ExpenseProvider>.value(value: mockExpenseProvider),
              ChangeNotifierProvider<LanguageProvider>.value(value: mockLanguageProvider),
            ],
            child: const AIChatScreen(),
          ),
        ),
      );
    }

    testWidgets('should display initial message', (WidgetTester tester) async {
      await pumpWidget(tester);
      await tester.pumpAndSettle();

      expect(find.text('How can I help you today?'), findsOneWidget);
    });
  });
}