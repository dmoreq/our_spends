import '../models/expense.dart';

/// Repository interface for Expense-related operations.
/// 
/// This interface follows the Interface Segregation Principle by providing
/// a focused set of methods specific to expense operations.
abstract class ExpenseRepository {
  /// Retrieves all expenses, optionally filtered by various criteria.
  Future<List<Expense>> getExpenses({
    DateTime? startDate,
    DateTime? endDate,
    double? minAmount,
    double? maxAmount,
    String? searchQuery,
    int? limit,
    int? offset,
  });
  
  /// Retrieves a specific expense by ID.
  Future<Expense?> getExpenseById(String id);
  
  /// Inserts a new expense and returns its ID.
  Future<String> insertExpense(Expense expense);
  
  /// Updates an existing expense.
  Future<void> updateExpense(Expense expense);
  
  /// Deletes an expense by ID.
  Future<void> deleteExpense(String id);
  
  /// Searches expenses by a query string.
  Future<List<Expense>> searchExpenses(String query);
  
  /// Gets monthly spending for a specific year and month.
  Future<double> getMonthlySpending(int year, int month);
  
  /// Gets spending trends over time.
  Future<List<Map<String, dynamic>>> getSpendingTrends({
    DateTime? startDate,
    DateTime? endDate,
  });
  
  /// Exports expenses to CSV format.
  Future<String> exportToCSV({
    DateTime? startDate,
    DateTime? endDate,
  });
}