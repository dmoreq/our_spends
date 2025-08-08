import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:our_spends/models/expense.dart';
import 'package:our_spends/providers/expense_provider.dart';
import 'package:our_spends/screens/chat_screen.dart';
import 'package:our_spends/services/auth_service.dart';
import 'package:our_spends/services/database_service.dart';
import 'package:provider/provider.dart';

@GenerateMocks([ExpenseProvider, AuthService, DatabaseService])

// Import generated mocks file
import 'chat_screen_test.mocks.dart';

void main() {
  group('ChatScreen Integration Tests', () {
    late MockExpenseProvider mockExpenseProvider;
    late MockAuthService mockAuthService;
    late MockDatabaseService mockDatabaseService;
    
    setUp(() {
      mockExpenseProvider = MockExpenseProvider();
      mockAuthService = MockAuthService();
      mockDatabaseService = MockDatabaseService();
    });
    
    testWidgets('ChatScreen should display user and AI messages', (WidgetTester tester) async {
      // Note: Using default timeout for this test
      // Mock auth service to return a user ID
      when(mockAuthService.currentUser).thenReturn('test-user-id');
      
      // Mock expense provider to return a response
      when(mockExpenseProvider.sendMessage(
        userId: anyNamed('userId'),
        message: anyNamed('message'),
        conversationHistory: anyNamed('conversationHistory'),
        languageCode: anyNamed('languageCode'),
      )).thenAnswer((_) async => {
        'message': 'Hello, how can I help you with your expenses?',
        'hasExpense': false,
        'error': null,
      });
      
      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<ExpenseProvider>.value(value: mockExpenseProvider),
              Provider<AuthService>.value(value: mockAuthService),
              Provider<DatabaseService>.value(value: mockDatabaseService),
            ],
            child: const ChatScreen(),
          ),
        ),
      );
      
      // Wait for the widget to build
      await tester.pumpAndSettle();
      
      // Enter a message
      await tester.enterText(find.byType(TextField), 'Hello');
      
      // Tap the send button
      await tester.tap(find.byIcon(Icons.send));
      
      // Wait for the response
      await tester.pumpAndSettle();
      
      // Verify that the user message is displayed
      expect(find.text('Hello'), findsOneWidget);
      
      // Verify that the AI response is displayed
      expect(find.text('Hello, how can I help you with your expenses?'), findsOneWidget);
    });
    
    testWidgets('ChatScreen should save expense when AI extracts expense information', (WidgetTester tester) async {
      // Note: Using default timeout for this test
      // Mock auth service to return a user ID
      when(mockAuthService.currentUser).thenReturn('test-user-id');
      
      // Mock expense provider to return a response with expense information
      when(mockExpenseProvider.sendMessage(
        userId: anyNamed('userId'),
        message: anyNamed('message'),
        conversationHistory: anyNamed('conversationHistory'),
        languageCode: anyNamed('languageCode'),
      )).thenAnswer((_) async => {
        'message': 'I have recorded your expense of \$50 for groceries.',
        'hasExpense': true,
        'error': null,
        'amount': 50.0,
        'currency': 'USD',
        'description': 'groceries',
        'category': 'food',
        'date': '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}',
        'location': 'Supermarket',
      });
      
      // Mock database service to save expense
      when(mockDatabaseService.addExpense(any))
          .thenAnswer((_) async => 'expense-id');
      
      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<ExpenseProvider>.value(value: mockExpenseProvider),
              Provider<AuthService>.value(value: mockAuthService),
              Provider<DatabaseService>.value(value: mockDatabaseService),
            ],
            child: const ChatScreen(),
          ),
        ),
      );
      
      // Wait for the widget to build
      await tester.pumpAndSettle();
      
      // Enter a message about an expense
      await tester.enterText(find.byType(TextField), 'I spent \$50 on groceries today');
      
      // Tap the send button
      await tester.tap(find.byIcon(Icons.send));
      
      // Wait for the response
      await tester.pumpAndSettle();
      
      // Verify that the user message is displayed
      expect(find.text('I spent \$50 on groceries today'), findsOneWidget);
      
      // Verify that the AI response is displayed
      expect(find.text('I have recorded your expense of \$50 for groceries.'), findsOneWidget);
      
      // Verify that the expense was saved
      verify(mockDatabaseService.addExpense(any)).called(1);
      
      // Verify that a confirmation message is displayed
      expect(find.textContaining('Expense saved'), findsOneWidget);
    });
    
    testWidgets('ChatScreen should handle errors from AI service', (WidgetTester tester) async {
      // Note: Using default timeout for this test
      // Mock auth service to return a user ID
      when(mockAuthService.currentUser).thenReturn('test-user-id');
      
      // Mock expense provider to return an error
      when(mockExpenseProvider.sendMessage(
        userId: anyNamed('userId'),
        message: anyNamed('message'),
        conversationHistory: anyNamed('conversationHistory'),
        languageCode: anyNamed('languageCode'),
      )).thenAnswer((_) async => {
        'message': null,
        'hasExpense': false,
        'error': 'Failed to connect to AI service',
      });
      
      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<ExpenseProvider>.value(value: mockExpenseProvider),
              Provider<AuthService>.value(value: mockAuthService),
              Provider<DatabaseService>.value(value: mockDatabaseService),
            ],
            child: const ChatScreen(),
          ),
        ),
      );
      
      // Wait for the widget to build
      await tester.pumpAndSettle();
      
      // Enter a message
      await tester.enterText(find.byType(TextField), 'Hello');
      
      // Tap the send button
      await tester.tap(find.byIcon(Icons.send));
      
      // Wait for the response
      await tester.pumpAndSettle();
      
      // Verify that the user message is displayed
      expect(find.text('Hello'), findsOneWidget);
      
      // Verify that an error message is displayed
      expect(find.textContaining('Sorry, I encountered an error'), findsOneWidget);
    });
    
    testWidgets('ChatScreen should generate spending insights', (WidgetTester tester) async {
      // Note: Using default timeout for this test
      // Mock auth service to return a user ID
      when(mockAuthService.currentUser).thenReturn('test-user-id');
      
      // Mock expense provider to return insights
      when(mockExpenseProvider.generateInsights(
        userId: anyNamed('userId'),
        languageCode: anyNamed('languageCode'),
      )).thenAnswer((_) async => {
        'message': 'Here are your spending insights: You spent \$500 this month.',
        'error': null,
      });
      
      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<ExpenseProvider>.value(value: mockExpenseProvider),
              Provider<AuthService>.value(value: mockAuthService),
              Provider<DatabaseService>.value(value: mockDatabaseService),
            ],
            child: const ChatScreen(),
          ),
        ),
      );
      
      // Wait for the widget to build
      await tester.pumpAndSettle();
      
      // Find and tap the insights button
      await tester.tap(find.byIcon(Icons.insights));
      
      // Wait for the response
      await tester.pumpAndSettle();
      
      // Verify that the insights are displayed
      expect(find.text('Here are your spending insights: You spent \$500 this month.'), findsOneWidget);
    });
  });
}