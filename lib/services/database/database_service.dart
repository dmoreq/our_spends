import '../../models/currency.dart';
import '../../models/expense.dart';
import '../../models/tag.dart';
import '../../repositories/currency_repository.dart';
import '../../repositories/expense_repository.dart';
import '../../repositories/tag_repository.dart';

/// Main database service that coordinates between different repositories.
/// 
/// This class follows the Dependency Inversion Principle by depending on
/// repository interfaces rather than concrete implementations.
class DatabaseService {
  final ExpenseRepository _expenseRepository;
  final TagRepository _tagRepository;
  final CurrencyRepository _currencyRepository;
  
  DatabaseService({
    required ExpenseRepository expenseRepository,
    required TagRepository tagRepository,
    required CurrencyRepository currencyRepository,
  }) : 
    _expenseRepository = expenseRepository,
    _tagRepository = tagRepository,
    _currencyRepository = currencyRepository;
  
  /// Initializes the database service.
  Future<void> initialize() async {
    await _currencyRepository.ensureDefaultCurrencies();
  }
  
  // Expense methods
  Future<List<Expense>> getExpenses({
    DateTime? startDate,
    DateTime? endDate,
    double? minAmount,
    double? maxAmount,
    String? searchQuery,
    int? limit,
    int? offset,
  }) async {
    return await _expenseRepository.getExpenses(
      startDate: startDate,
      endDate: endDate,
      minAmount: minAmount,
      maxAmount: maxAmount,
      searchQuery: searchQuery,
      limit: limit,
      offset: offset,
    );
  }
  
  Future<Expense?> getExpenseById(String id) async {
    return await _expenseRepository.getExpenseById(id);
  }
  
  Future<String> insertExpense(Expense expense) async {
    return await _expenseRepository.insertExpense(expense);
  }
  
  Future<void> updateExpense(Expense expense) async {
    await _expenseRepository.updateExpense(expense);
  }
  
  Future<void> deleteExpense(String id) async {
    await _expenseRepository.deleteExpense(id);
  }
  
  Future<List<Expense>> searchExpenses(String query) async {
    return await _expenseRepository.searchExpenses(query);
  }
  
  Future<double> getMonthlySpending(int year, int month) async {
    return await _expenseRepository.getMonthlySpending(year, month);
  }
  
  Future<List<Map<String, dynamic>>> getSpendingTrends({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return await _expenseRepository.getSpendingTrends(
      startDate: startDate,
      endDate: endDate,
    );
  }
  
  Future<String> exportToCSV({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return await _expenseRepository.exportToCSV(
      startDate: startDate,
      endDate: endDate,
    );
  }
  
  // Tag methods
  Future<List<Tag>> getTags() async {
    return await _tagRepository.getTags();
  }
  
  Future<Tag?> getTagById(String id) async {
    return await _tagRepository.getTagById(id);
  }
  
  Future<void> addTag(Tag tag) async {
    await _tagRepository.addTag(tag);
  }
  
  Future<void> updateTag(Tag tag) async {
    await _tagRepository.updateTag(tag);
  }
  
  Future<void> deleteTag(String tagId) async {
    await _tagRepository.deleteTag(tagId);
  }
  
  Future<List<String>> getExpenseTags(String expenseId) async {
    return await _tagRepository.getExpenseTags(expenseId);
  }
  
  Future<void> setExpenseTags(String expenseId, List<String> tagIds) async {
    await _tagRepository.setExpenseTags(expenseId, tagIds);
  }
  
  // Currency methods
  Future<List<Currency>> getCurrencies() async {
    return await _currencyRepository.getCurrencies();
  }
  
  Future<Currency> getUserPreferredCurrency() async {
    return await _currencyRepository.getUserPreferredCurrency();
  }
  
  Future<void> setUserPreferredCurrency(Currency currency) async {
    await _currencyRepository.setUserPreferredCurrency(currency);
  }
  
  /// Clears all data from the database.
  Future<void> clearAllData() async {
    // This would need to be implemented in each repository
    // For now, we'll leave this as a placeholder
    throw UnimplementedError('clearAllData is not implemented yet');
  }
}