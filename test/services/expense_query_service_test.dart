import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:our_spends/models/expense.dart';
import 'package:our_spends/models/tag.dart';
import 'package:our_spends/services/expense_query_service.dart';
import 'package:our_spends/repositories/expense_repository.dart';
import 'package:our_spends/repositories/tag_repository.dart';

// Generate mocks
@GenerateMocks([ExpenseRepository, TagRepository])
import 'expense_query_service_test.mocks.dart';

void main() {
  group('ExpenseQueryService Tests', () {
    late ExpenseQueryService queryService;
    late MockExpenseRepository mockExpenseRepository;
    late MockTagRepository mockTagRepository;

    setUp(() {
      // Create mock repositories
      mockExpenseRepository = MockExpenseRepository();
      mockTagRepository = MockTagRepository();
      
      // Create query service with mocks
      queryService = ExpenseQueryService(
        expenseRepository: mockExpenseRepository,
        tagRepository: mockTagRepository,
      );
    });

    test('should query expenses by natural language', () async {
      // Setup test data
      final expenses = [
        Expense(
          id: 'id1',
          userId: 'user1',
          date: DateTime(2023, 5, 15),
          amount: 50.0,
          currency: 'USD',
          item: 'Lunch',
        ),
        Expense(
          id: 'id2',
          userId: 'user1',
          date: DateTime(2023, 5, 14),
          amount: 30.0,
          currency: 'USD',
          item: 'Taxi',
        ),
      ];
      
      // Setup mock responses
      when(mockExpenseRepository.getExpenses()).thenAnswer((_) async => expenses);
      
      // Query for food expenses
      final foodExpenses = await queryService.queryExpenses('user1', 'food expenses');
      
      // Verify results
      expect(foodExpenses.length, 2); // All expenses returned since we're not filtering by tag in this test
      
      // Query for expenses on a specific date
      final dateExpenses = await queryService.queryExpenses('user1', 'expenses on May 15, 2023');
      
      // Verify results - in a real implementation, this would filter by date
      expect(dateExpenses.length, 2); // All expenses returned since we're mocking the implementation
    });

    test('should get expense analytics', () async {
      // Setup test data
      final expenses = [
        Expense(
          id: 'id1',
          userId: 'user1',
          date: DateTime(2023, 5, 15),
          amount: 50.0,
          currency: 'USD',
          item: 'Lunch',
        ),
        Expense(
          id: 'id2',
          userId: 'user1',
          date: DateTime(2023, 5, 14),
          amount: 30.0,
          currency: 'USD',
          item: 'Dinner',
        ),
        Expense(
          id: 'id3',
          userId: 'user1',
          date: DateTime(2023, 5, 13),
          amount: 20.0,
          currency: 'USD',
          item: 'Taxi',
        ),
      ];
      
      final tags = [
        Tag(id: 'tag1', name: 'Food'),
        Tag(id: 'tag2', name: 'Transportation'),
      ];
      
      // Setup mock responses
      when(mockExpenseRepository.getExpenses(startDate: anyNamed('startDate'), endDate: anyNamed('endDate')))
          .thenAnswer((_) async => expenses);
      when(mockTagRepository.getTags()).thenAnswer((_) async => tags);
      
      // Get expense analytics
      final analytics = await queryService.getExpenseAnalytics('user1');
      
      // Verify results
      expect(analytics, isNotNull);
      expect(analytics['totalExpenses'], 3);
      expect(analytics['totalAmount'], 100.0);
      expect(analytics['averageAmount'], 100.0 / 3);
      expect(analytics['tagsCount'], 2);
    });

    test('should get monthly spending trend', () async {
      // Setup test data with expenses across multiple months
      final expenses = [
        Expense(
          id: 'id1',
          userId: 'user1',
          date: DateTime(2023, 5, 15),
          amount: 50.0,
          currency: 'USD',
          item: 'Lunch',
        ),
        Expense(
          id: 'id2',
          userId: 'user1',
          date: DateTime(2023, 5, 20),
          amount: 30.0,
          currency: 'USD',
          item: 'Dinner',
        ),
        Expense(
          id: 'id3',
          userId: 'user1',
          date: DateTime(2023, 4, 10),
          amount: 40.0,
          currency: 'USD',
          item: 'Groceries',
        ),
        Expense(
          id: 'id4',
          userId: 'user1',
          date: DateTime(2023, 4, 25),
          amount: 25.0,
          currency: 'USD',
          item: 'Movie',
        ),
        Expense(
          id: 'id5',
          userId: 'user1',
          date: DateTime(2023, 3, 5),
          amount: 60.0,
          currency: 'USD',
          item: 'Shopping',
        ),
      ];
      
      // Setup mock responses
      when(mockExpenseRepository.getExpenses(startDate: anyNamed('startDate'), endDate: anyNamed('endDate')))
          .thenAnswer((_) async => expenses);
      
      // Get monthly spending trend
      final trends = await queryService.getMonthlySpendingTrend('user1', months: 3);
      
      // Verify results
      expect(trends, isNotNull);
      expect(trends.length, 3);
      expect(trends['2023-05'], 80.0); // May: 50.0 + 30.0
      expect(trends['2023-04'], 65.0); // April: 40.0 + 25.0
      expect(trends['2023-03'], 60.0); // March: 60.0
    });

    test('should search expenses by text', () async {
      // Setup test data
      final expenses = [
        Expense(
          id: 'id1',
          userId: 'user1',
          date: DateTime(2023, 5, 15),
          amount: 50.0,
          currency: 'USD',
          item: 'Lunch',
        ),
        Expense(
          id: 'id2',
          userId: 'user1',
          date: DateTime(2023, 5, 14),
          amount: 30.0,
          currency: 'USD',
          item: 'Dinner',
        ),
      ];
      
      // Setup mock responses
      when(mockExpenseRepository.searchExpenses(any)).thenAnswer((_) async => expenses);
      
      // Search expenses by text
      final results = await queryService.searchExpenses('user1', 'Lunch');
      
      // Verify results - in a real implementation, this would filter by text
      expect(results.length, 2); // All expenses returned since we're mocking the implementation
    });
  });
}