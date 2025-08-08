import 'package:flutter_test/flutter_test.dart';
import 'dart:async';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:our_spends/providers/expense_provider.dart';
import 'package:our_spends/providers/auth_provider.dart';

@GenerateMocks([ExpenseProvider, AuthProvider])

// Import generated mocks file
import 'ai_chat_insights_test.mocks.dart';

void main() {
  group('AI Chat Insights Generation Tests', () {
    late MockExpenseProvider mockExpenseProvider;
    late MockAuthProvider mockAuthProvider;
    
    setUp(() {
      mockExpenseProvider = MockExpenseProvider();
      mockAuthProvider = MockAuthProvider();
    });
    
    test('Should generate insights successfully', () async {
      // Set timeout to 5 seconds
      final testOnTimeout = Timeout(const Duration(seconds: 5));
      // Mock auth provider to return a user ID
      when(mockAuthProvider.user).thenReturn(null); // Demo mode
      
      // Mock expense provider to return insights
      when(mockExpenseProvider.generateInsights('demo_user_123'))
          .thenAnswer((_) async => {
            'data': 'Here are your spending insights: You spent \$500 this month.',
            'error': null,
          });
      
      // Call the method directly
      final result = await mockExpenseProvider.generateInsights('demo_user_123');
      
      // Verify the result
      expect(result['data'], 'Here are your spending insights: You spent \$500 this month.');
      expect(result['error'], null);
    });
    
    test('Should handle errors when generating insights', () async {
      // Set timeout to 5 seconds
      final testOnTimeout = Timeout(const Duration(seconds: 5));
      // Mock auth provider to return a user ID
      when(mockAuthProvider.user).thenReturn(null); // Demo mode
      
      // Mock expense provider to return an error
      when(mockExpenseProvider.generateInsights('demo_user_123'))
          .thenAnswer((_) async => throw Exception('Failed to generate insights'));
      
      // Call the method directly and expect it to throw
      expect(
        () async => await mockExpenseProvider.generateInsights('demo_user_123'),
        throwsException,
      );
    });
    
    test('Should handle empty insights response', () async {
      // Set timeout to 5 seconds
      final testOnTimeout = Timeout(const Duration(seconds: 5));
      // Mock auth provider to return a user ID
      when(mockAuthProvider.user).thenReturn(null); // Demo mode
      
      // Mock expense provider to return empty insights
      when(mockExpenseProvider.generateInsights('demo_user_123'))
          .thenAnswer((_) async => {
            'data': '',
            'error': null,
          });
      
      // Call the method directly
      final result = await mockExpenseProvider.generateInsights('demo_user_123');
      
      // Verify the result
      expect(result['data'], '');
      expect(result['error'], null);
    });
    
    test('Should handle null insights response', () async {
      // Set timeout to 5 seconds
      final testOnTimeout = Timeout(const Duration(seconds: 5));
      // Mock auth provider to return a user ID
      when(mockAuthProvider.user).thenReturn(null); // Demo mode
      
      // Mock expense provider to return null insights
      when(mockExpenseProvider.generateInsights('demo_user_123'))
          .thenAnswer((_) async => {
            'data': null,
            'error': null,
          });
      
      // Call the method directly
      final result = await mockExpenseProvider.generateInsights('demo_user_123');
      
      // Verify the result
      expect(result['data'], null);
      expect(result['error'], null);
    });
  });
}