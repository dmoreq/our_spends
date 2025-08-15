import '../models/expense.dart';
import '../models/tag.dart';
import '../repositories/expense_repository.dart';
import '../repositories/tag_repository.dart';

/// Service class that handles expense-related business logic.
/// 
/// This class follows the Single Responsibility Principle by focusing only on
/// expense-related business logic, separate from UI concerns.
class ExpenseService {
  final ExpenseRepository _expenseRepository;
  final TagRepository _tagRepository;
  
  ExpenseService({
    required ExpenseRepository expenseRepository,
    required TagRepository tagRepository,
  }) : 
    _expenseRepository = expenseRepository,
    _tagRepository = tagRepository;
  
  /// Creates a new expense with the given tags.
  Future<String> createExpense(Expense expense, List<String> tagIds) async {
    final expenseId = await _expenseRepository.insertExpense(expense);
    await _tagRepository.setExpenseTags(expenseId, tagIds);
    return expenseId;
  }
  
  /// Updates an existing expense with the given tags.
  Future<void> updateExpense(Expense expense, List<String> tagIds) async {
    await _expenseRepository.updateExpense(expense);
    await _tagRepository.setExpenseTags(expense.id, tagIds);
  }
  
  /// Deletes an expense and its tag associations.
  Future<void> deleteExpense(String expenseId) async {
    await _expenseRepository.deleteExpense(expenseId);
    // Clear tag associations
    await _tagRepository.setExpenseTags(expenseId, []);
  }
  
  /// Gets an expense with its associated tags.
  Future<Map<String, dynamic>> getExpenseWithTags(String expenseId) async {
    final expense = await _expenseRepository.getExpenseById(expenseId);
    if (expense == null) {
      throw Exception('Expense not found');
    }
    
    final tagIds = await _tagRepository.getExpenseTags(expenseId);
    final tags = <Tag>[];
    
    for (final tagId in tagIds) {
      final tag = await _tagRepository.getTagById(tagId);
      if (tag != null) {
        tags.add(tag);
      }
    }
    
    return {
      'expense': expense,
      'tagIds': tagIds,
      'tags': tags,
    };
  }
  
  /// Gets all expenses with their associated tags.
  Future<List<Map<String, dynamic>>> getAllExpensesWithTags({
    DateTime? startDate,
    DateTime? endDate,
    double? minAmount,
    double? maxAmount,
    String? searchQuery,
    int? limit,
    int? offset,
  }) async {
    final expenses = await _expenseRepository.getExpenses(
      startDate: startDate,
      endDate: endDate,
      minAmount: minAmount,
      maxAmount: maxAmount,
      searchQuery: searchQuery,
      limit: limit,
      offset: offset,
    );
    
    final result = <Map<String, dynamic>>[];
    
    for (final expense in expenses) {
      final tagIds = await _tagRepository.getExpenseTags(expense.id);
      final tags = <Tag>[];
      
      for (final tagId in tagIds) {
        final tag = await _tagRepository.getTagById(tagId);
        if (tag != null) {
          tags.add(tag);
        }
      }
      
      result.add({
        'expense': expense,
        'tagIds': tagIds,
        'tags': tags,
      });
    }
    
    return result;
  }
  
  /// Gets expenses grouped by tag.
  Future<Map<String, List<Expense>>> getExpensesGroupedByTag({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final expenses = await _expenseRepository.getExpenses(
      startDate: startDate,
      endDate: endDate,
    );
    
    final result = <String, List<Expense>>{};
    
    for (final expense in expenses) {
      final tagIds = await _tagRepository.getExpenseTags(expense.id);
      
      for (final tagId in tagIds) {
        if (!result.containsKey(tagId)) {
          result[tagId] = [];
        }
        result[tagId]!.add(expense);
      }
      
      // Handle expenses with no tags
      if (tagIds.isEmpty) {
        if (!result.containsKey('untagged')) {
          result['untagged'] = [];
        }
        result['untagged']!.add(expense);
      }
    }
    
    return result;
  }
  
  /// Gets the tag IDs associated with an expense.
  Future<List<String>> getExpenseTags(String expenseId) async {
    return await _tagRepository.getExpenseTags(expenseId);
  }
}