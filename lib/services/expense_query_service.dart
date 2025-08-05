import '../models/expense.dart';
import '../services/database_service.dart';

class ExpenseQueryService {
  final DatabaseService _databaseService = DatabaseService();

  // Query expenses by natural language
  Future<List<Expense>> queryExpenses(String userId, String query) async {
    // Parse natural language query and convert to database parameters
    final queryParams = _parseQuery(query);
    
    return await _databaseService.getExpenses(
      categoryId: queryParams['category'],
      startDate: queryParams['startDate'],
      endDate: queryParams['endDate'],
      minAmount: queryParams['minAmount'],
      maxAmount: queryParams['maxAmount'],
      limit: queryParams['limit'],
    );
  }

  // Get expense analytics
  Future<Map<String, dynamic>> getExpenseAnalytics(String userId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return await _databaseService.getDatabaseStats();
  }

  // Get spending by category
  Future<List<Map<String, dynamic>>> getSpendingByCategory(String userId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    return await _databaseService.getExpensesByCategory(
      startDate: startDate,
      endDate: endDate,
    );
  }

  // Get monthly spending trend
  Future<List<Map<String, dynamic>>> getMonthlySpendingTrend(String userId, {
    int months = 12,
  }) async {
    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month - months, 1);
    return await _databaseService.getSpendingTrends(
      startDate: startDate,
      endDate: now,
    );
  }

  // Search expenses by text
  Future<List<Expense>> searchExpenses(String userId, String searchText) async {
    return await _databaseService.searchExpenses(searchText);
  }

  // Parse natural language query into database parameters
  Map<String, dynamic> _parseQuery(String query) {
    final Map<String, dynamic> params = {};
    final queryLower = query.toLowerCase();

    // Parse categories
    final categories = [
      'food', 'transport', 'shopping', 'entertainment', 'bills',
      'healthcare', 'education', 'travel', 'family', 'other'
    ];
    
    for (final category in categories) {
      if (queryLower.contains(category)) {
        params['category'] = category;
        break;
      }
    }

    // Parse time periods
    if (queryLower.contains('today')) {
      final today = DateTime.now();
      params['startDate'] = DateTime(today.year, today.month, today.day);
      params['endDate'] = DateTime(today.year, today.month, today.day, 23, 59, 59);
    } else if (queryLower.contains('yesterday')) {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      params['startDate'] = DateTime(yesterday.year, yesterday.month, yesterday.day);
      params['endDate'] = DateTime(yesterday.year, yesterday.month, yesterday.day, 23, 59, 59);
    } else if (queryLower.contains('this week')) {
      final now = DateTime.now();
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      params['startDate'] = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
      params['endDate'] = now;
    } else if (queryLower.contains('this month')) {
      final now = DateTime.now();
      params['startDate'] = DateTime(now.year, now.month, 1);
      params['endDate'] = now;
    } else if (queryLower.contains('last month')) {
      final now = DateTime.now();
      final lastMonth = DateTime(now.year, now.month - 1, 1);
      final endOfLastMonth = DateTime(now.year, now.month, 0);
      params['startDate'] = lastMonth;
      params['endDate'] = endOfLastMonth;
    }

    // Parse amount ranges
    final amountRegex = RegExp(r'(\d+(?:\.\d+)?)\s*(?:k|thousand)?');
    final matches = amountRegex.allMatches(queryLower);
    
    if (matches.isNotEmpty) {
      final amounts = matches.map((match) {
        double amount = double.parse(match.group(1)!);
        if (queryLower.contains('k') || queryLower.contains('thousand')) {
          amount *= 1000;
        }
        return amount;
      }).toList();

      if (queryLower.contains('more than') || queryLower.contains('above') || queryLower.contains('over')) {
        params['minAmount'] = amounts.first;
      } else if (queryLower.contains('less than') || queryLower.contains('below') || queryLower.contains('under')) {
        params['maxAmount'] = amounts.first;
      } else if (amounts.length >= 2) {
        params['minAmount'] = amounts.first;
        params['maxAmount'] = amounts.last;
      }
    }

    // Parse limits
    if (queryLower.contains('top 10') || queryLower.contains('first 10')) {
      params['limit'] = 10;
    } else if (queryLower.contains('top 5') || queryLower.contains('first 5')) {
      params['limit'] = 5;
    } else if (queryLower.contains('latest') || queryLower.contains('recent')) {
      params['limit'] = 20;
    }

    return params;
  }

  // Generate summary text for query results
  String generateSummary(List<Expense> expenses, String originalQuery) {
    if (expenses.isEmpty) {
      return "No expenses found matching your query: '$originalQuery'";
    }

    final totalAmount = expenses.fold<double>(0, (sum, expense) => sum + expense.amount);
    final categories = expenses.map((e) => e.category).toSet();
    final dateRange = _getDateRange(expenses);

    String summary = "Found ${expenses.length} expense(s) ";
    
    if (categories.length == 1) {
      summary += "in ${categories.first} category ";
    } else if (categories.length <= 3) {
      summary += "across ${categories.join(', ')} categories ";
    } else {
      summary += "across ${categories.length} different categories ";
    }

    summary += "totaling ${totalAmount.toStringAsFixed(0)} VND";
    
    if (dateRange.isNotEmpty) {
      summary += " $dateRange";
    }

    return summary;
  }

  String _getDateRange(List<Expense> expenses) {
    if (expenses.isEmpty) return "";
    
    final dates = expenses.map((e) => e.date).toList()..sort();
    final earliest = dates.first;
    final latest = dates.last;
    
    if (earliest.year == latest.year && earliest.month == latest.month && earliest.day == latest.day) {
      return "on ${_formatDate(earliest)}";
    } else {
      return "from ${_formatDate(earliest)} to ${_formatDate(latest)}";
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}