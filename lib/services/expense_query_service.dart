import '../models/expense.dart';
import '../repositories/expense_repository.dart';
import '../repositories/tag_repository.dart';

class ExpenseQueryService {
  final ExpenseRepository _expenseRepository;
  final TagRepository _tagRepository;

  ExpenseQueryService({
    required ExpenseRepository expenseRepository,
    required TagRepository tagRepository,
  })
      : _expenseRepository = expenseRepository,
        _tagRepository = tagRepository;

  // Query expenses by natural language
  Future<List<Expense>> queryExpenses(String userId, String query) async {
    // Parse natural language query and convert to database parameters
    final queryParams = _parseQuery(query);
    
    final allExpenses = await _expenseRepository.getExpenses();
    
    return allExpenses.where((expense) {
      if (queryParams['startDate'] != null && expense.date.isBefore(queryParams['startDate'])) {
        return false;
      }
      
      if (queryParams['endDate'] != null && expense.date.isAfter(queryParams['endDate'])) {
        return false;
      }
      
      if (queryParams['minAmount'] != null && expense.amount < queryParams['minAmount']) {
        return false;
      }
      
      if (queryParams['maxAmount'] != null && expense.amount > queryParams['maxAmount']) {
        return false;
      }
      
      return true;
    }).toList();
  }

  // Get expense analytics
  Future<Map<String, dynamic>> getExpenseAnalytics(String userId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    // Using available methods in the repository to build stats
    final expenses = await _expenseRepository.getExpenses(
      startDate: startDate,
      endDate: endDate,
    );
    final tags = await _tagRepository.getTags();
    
    final totalExpenses = expenses.length;
    final totalAmount = expenses.fold<double>(0, (sum, expense) => sum + expense.amount);
    final avgAmount = totalExpenses > 0 ? totalAmount / totalExpenses : 0.0;
    
    final now = DateTime.now();
    final thisMonth = expenses.where((e) => 
        e.date.year == now.year && e.date.month == now.month).toList();
    final thisMonthTotal = thisMonth.fold<double>(0, (sum, expense) => sum + expense.amount);
    
    return {
      'totalExpenses': totalExpenses,
      'totalAmount': totalAmount,
      'averageAmount': avgAmount,
      'thisMonthTotal': thisMonthTotal,
      'thisMonthCount': thisMonth.length,
      'tagsCount': tags.length,
    };
  }

  // Get monthly spending trend
  Future<Map<String, double>> getMonthlySpendingTrend(String userId, {
    int months = 12,
  }) async {
    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month - months, 1);
    final expenses = await _expenseRepository.getExpenses(
      startDate: startDate,
      endDate: now,
    );
    
    // Calculate trends from expenses
    final trends = <String, double>{};
    for (var expense in expenses) {
      final monthKey = '${expense.date.year}-${expense.date.month.toString().padLeft(2, '0')}';
      trends[monthKey] = (trends[monthKey] ?? 0) + expense.amount;
    }
    
    return trends;
  }

  // Search expenses by text
  Future<List<Expense>> searchExpenses(String userId, String searchText) async {
    final allExpenses = await _expenseRepository.getExpenses();
    return allExpenses.where((expense) =>
      expense.item.toLowerCase().contains(searchText.toLowerCase())
    ).toList();
  }

  // Parse natural language query into database parameters
  Map<String, dynamic> _parseQuery(String query) {
    final Map<String, dynamic> params = {};
    final queryLower = query.toLowerCase();

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
    final dateRange = _getDateRange(expenses);

    String summary = "Found ${expenses.length} expense(s) ";
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