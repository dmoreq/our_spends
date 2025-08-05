import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/expense.dart';
import '../models/category.dart';
import '../models/tag.dart';

class DatabaseService {
  static const String _expensesKey = 'expenses_data';
  static const String _categoriesKey = 'categories_data';
  static const String _tagsKey = 'tags_data';
  static const String _expenseTagsKey = 'expense_tags_data';

  // In-memory cache for better performance
  List<Expense>? _expensesCache;
  List<Category>? _categoriesCache;
  List<Tag>? _tagsCache;
  Map<String, List<String>>? _expenseTagsCache;

  // Initialize database (create default categories)
  Future<void> init() async {
    await _ensureDefaultCategories();
  }

  // Load data from SharedPreferences
  Future<List<Expense>> _loadExpenses() async {
    if (_expensesCache != null) return _expensesCache!;
    
    final prefs = await SharedPreferences.getInstance();
    final expensesJson = prefs.getString(_expensesKey);
    
    if (expensesJson == null) {
      _expensesCache = [];
      return _expensesCache!;
    }
    
    final List<dynamic> expensesList = json.decode(expensesJson);
    _expensesCache = expensesList.map((json) => Expense.fromJson(json)).toList();
    return _expensesCache!;
  }

  Future<void> _saveExpenses(List<Expense> expenses) async {
    final prefs = await SharedPreferences.getInstance();
    final expensesJson = json.encode(expenses.map((e) => e.toJson()).toList());
    await prefs.setString(_expensesKey, expensesJson);
    _expensesCache = expenses;
  }

  Future<List<Category>> _loadCategories() async {
    if (_categoriesCache != null) return _categoriesCache!;
    
    final prefs = await SharedPreferences.getInstance();
    final categoriesJson = prefs.getString(_categoriesKey);
    
    if (categoriesJson == null) {
      _categoriesCache = [];
      return _categoriesCache!;
    }
    
    final List<dynamic> categoriesList = json.decode(categoriesJson);
    _categoriesCache = categoriesList.map((json) => Category.fromJson(json)).toList();
    return _categoriesCache!;
  }

  Future<void> _saveCategories(List<Category> categories) async {
    final prefs = await SharedPreferences.getInstance();
    final categoriesJson = json.encode(categories.map((c) => c.toJson()).toList());
    await prefs.setString(_categoriesKey, categoriesJson);
    _categoriesCache = categories;
  }

  Future<List<Tag>> _loadTags() async {
    if (_tagsCache != null) return _tagsCache!;
    
    final prefs = await SharedPreferences.getInstance();
    final tagsJson = prefs.getString(_tagsKey);
    
    if (tagsJson == null) {
      _tagsCache = [];
      return _tagsCache!;
    }
    
    final List<dynamic> tagsList = json.decode(tagsJson);
    _tagsCache = tagsList.map((json) => Tag.fromJson(json)).toList();
    return _tagsCache!;
  }

  Future<void> _saveTags(List<Tag> tags) async {
    final prefs = await SharedPreferences.getInstance();
    final tagsJson = json.encode(tags.map((t) => t.toJson()).toList());
    await prefs.setString(_tagsKey, tagsJson);
    _tagsCache = tags;
  }

  Future<Map<String, List<String>>> _loadExpenseTags() async {
    if (_expenseTagsCache != null) return _expenseTagsCache!;
    
    final prefs = await SharedPreferences.getInstance();
    final expenseTagsJson = prefs.getString(_expenseTagsKey);
    
    if (expenseTagsJson == null) {
      _expenseTagsCache = {};
      return _expenseTagsCache!;
    }
    
    final Map<String, dynamic> expenseTagsMap = json.decode(expenseTagsJson);
    _expenseTagsCache = expenseTagsMap.map((key, value) => 
        MapEntry(key, List<String>.from(value)));
    return _expenseTagsCache!;
  }

  Future<void> _saveExpenseTags(Map<String, List<String>> expenseTags) async {
    final prefs = await SharedPreferences.getInstance();
    final expenseTagsJson = json.encode(expenseTags);
    await prefs.setString(_expenseTagsKey, expenseTagsJson);
    _expenseTagsCache = expenseTags;
  }

  // Ensure default categories exist
  Future<void> _ensureDefaultCategories() async {
    final categories = await _loadCategories();
    
    if (categories.isEmpty) {
      final defaultCategories = [
        Category(
          id: '1',
          name: 'Food & Dining',
          description: 'Restaurants, groceries, and food delivery',
          icon: '🍽️',
          color: '#FF6B6B',
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        Category(
          id: '2',
          name: 'Transportation',
          description: 'Gas, public transport, ride-sharing',
          icon: '🚗',
          color: '#4ECDC4',
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        Category(
          id: '3',
          name: 'Shopping',
          description: 'Clothing, electronics, general shopping',
          icon: '🛍️',
          color: '#45B7D1',
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        Category(
          id: '4',
          name: 'Entertainment',
          description: 'Movies, games, subscriptions',
          icon: '🎬',
          color: '#96CEB4',
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        Category(
          id: '5',
          name: 'Bills & Utilities',
          description: 'Rent, electricity, internet, phone',
          icon: '💡',
          color: '#FFEAA7',
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        Category(
          id: '6',
          name: 'Healthcare',
          description: 'Medical expenses, pharmacy, insurance',
          icon: '🏥',
          color: '#DDA0DD',
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        Category(
          id: '7',
          name: 'Education',
          description: 'Books, courses, school fees',
          icon: '📚',
          color: '#98D8C8',
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
        Category(
          id: '8',
          name: 'Other',
          description: 'Miscellaneous expenses',
          icon: '📦',
          color: '#A8A8A8',
          isActive: true,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];
      
      await _saveCategories(defaultCategories);
    }
  }

  // CRUD Operations for Expenses
  Future<List<Expense>> getExpenses({
    String? categoryId,
    DateTime? startDate,
    DateTime? endDate,
    double? minAmount,
    double? maxAmount,
    String? searchQuery,
    int? limit,
    int? offset,
  }) async {
    final expenses = await _loadExpenses();
    
    var filteredExpenses = expenses.where((expense) {
      if (categoryId != null && expense.category != categoryId) return false;
      if (startDate != null && expense.date.isBefore(startDate)) return false;
      if (endDate != null && expense.date.isAfter(endDate)) return false;
      if (minAmount != null && expense.amount < minAmount) return false;
      if (maxAmount != null && expense.amount > maxAmount) return false;
      if (searchQuery != null && searchQuery.isNotEmpty) {
        final query = searchQuery.toLowerCase();
        if (!(expense.description?.toLowerCase().contains(query) ?? false) &&
            !(expense.notes?.toLowerCase().contains(query) ?? false) &&
            !(expense.location?.toLowerCase().contains(query) ?? false) &&
            !expense.item.toLowerCase().contains(query)) {
          return false;
        }
      }
      return true;
    }).toList();

    // Sort by date (newest first)
    filteredExpenses.sort((a, b) => b.date.compareTo(a.date));

    if (offset != null) {
      filteredExpenses = filteredExpenses.skip(offset).toList();
    }
    if (limit != null) {
      filteredExpenses = filteredExpenses.take(limit).toList();
    }

    return filteredExpenses;
  }

  Future<Expense?> getExpenseById(String id) async {
    final expenses = await _loadExpenses();
    try {
      return expenses.firstWhere((expense) => expense.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<String> insertExpense(Expense expense) async {
    final expenses = await _loadExpenses();
    final newExpense = expense.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    expenses.add(newExpense);
    await _saveExpenses(expenses);
    return newExpense.id;
  }

  Future<void> updateExpense(Expense expense) async {
    final expenses = await _loadExpenses();
    final index = expenses.indexWhere((e) => e.id == expense.id);
    if (index != -1) {
      expenses[index] = expense.copyWith(updatedAt: DateTime.now());
      await _saveExpenses(expenses);
    }
  }

  Future<void> deleteExpense(String id) async {
    final expenses = await _loadExpenses();
    expenses.removeWhere((expense) => expense.id == id);
    await _saveExpenses(expenses);
    
    // Also remove from expense tags
    final expenseTags = await _loadExpenseTags();
    expenseTags.remove(id);
    await _saveExpenseTags(expenseTags);
  }

  // Analytics methods
  Future<Map<String, dynamic>> getDatabaseStats() async {
    final expenses = await _loadExpenses();
    final categories = await _loadCategories();
    final tags = await _loadTags();
    
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
      'categoriesCount': categories.length,
      'tagsCount': tags.length,
    };
  }

  Future<List<Map<String, dynamic>>> getExpensesByCategory({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final expenses = await _loadExpenses();
    final categories = await _loadCategories();
    
    var filteredExpenses = expenses.where((expense) {
      if (startDate != null && expense.date.isBefore(startDate)) return false;
      if (endDate != null && expense.date.isAfter(endDate)) return false;
      return true;
    }).toList();

    final categoryMap = <String, double>{};
    final categoryNames = <String, String>{};
    
    for (final category in categories) {
      categoryNames[category.id] = category.name;
      categoryMap[category.id] = 0.0;
    }

    for (final expense in filteredExpenses) {
      categoryMap[expense.category] = 
          (categoryMap[expense.category] ?? 0.0) + expense.amount;
    }

    return categoryMap.entries
        .where((entry) => entry.value > 0)
        .map((entry) => {
          'categoryId': entry.key,
          'categoryName': categoryNames[entry.key] ?? 'Unknown',
          'totalAmount': entry.value,
          'count': filteredExpenses.where((e) => e.category == entry.key).length,
        })
        .toList()
      ..sort((a, b) => (b['totalAmount'] as double).compareTo(a['totalAmount'] as double));
  }

  Future<List<Map<String, dynamic>>> getSpendingTrends({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final expenses = await _loadExpenses();
    
    var filteredExpenses = expenses.where((expense) {
      if (startDate != null && expense.date.isBefore(startDate)) return false;
      if (endDate != null && expense.date.isAfter(endDate)) return false;
      return true;
    }).toList();

    final monthlySpending = <String, double>{};
    
    for (final expense in filteredExpenses) {
      final monthKey = '${expense.date.year}-${expense.date.month.toString().padLeft(2, '0')}';
      monthlySpending[monthKey] = (monthlySpending[monthKey] ?? 0.0) + expense.amount;
    }

    return monthlySpending.entries
        .map((entry) => {
          'month': entry.key,
          'totalAmount': entry.value,
        })
        .toList()
      ..sort((a, b) => (a['month'] as String).compareTo(b['month'] as String));
  }

  Future<double> getMonthlySpending(int year, int month) async {
    final expenses = await _loadExpenses();
    return expenses
        .where((expense) => expense.date.year == year && expense.date.month == month)
        .fold<double>(0, (sum, expense) => sum + expense.amount);
  }

  Future<List<Expense>> searchExpenses(String query) async {
    return await getExpenses(searchQuery: query);
  }

  // Category operations
  Future<List<Category>> getCategories() async {
    return await _loadCategories();
  }

  Future<Category?> getCategoryById(String id) async {
    final categories = await _loadCategories();
    try {
      return categories.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }

  // Tag operations
  Future<List<Tag>> getTags() async {
    return await _loadTags();
  }

  Future<Tag?> getTagById(String id) async {
    final tags = await _loadTags();
    try {
      return tags.firstWhere((tag) => tag.id == id);
    } catch (e) {
      return null;
    }
  }

  // Export to CSV
  Future<String> exportToCSV({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final expenses = await getExpenses(startDate: startDate, endDate: endDate);
    final categories = await _loadCategories();
    final categoryMap = {for (var cat in categories) cat.id: cat.name};

    final csvData = StringBuffer();
    csvData.writeln('Date,Amount,Category,Subcategory,Description,Location,Payment Method,Notes');

    for (final expense in expenses) {
      final categoryName = categoryMap[expense.category] ?? 'Unknown';
      csvData.writeln([
        expense.date.toIso8601String().split('T')[0],
        expense.amount.toString(),
        _escapeCsvField(categoryName),
        _escapeCsvField(expense.subcategory ?? ''),
        _escapeCsvField(expense.description ?? ''),
        _escapeCsvField(expense.location ?? ''),
        _escapeCsvField(expense.paymentMethod ?? ''),
        _escapeCsvField(expense.notes ?? ''),
      ].join(','));
    }

    return csvData.toString();
  }

  String _escapeCsvField(String field) {
    if (field.contains(',') || field.contains('"') || field.contains('\n')) {
      return '"${field.replaceAll('"', '""')}"';
    }
    return field;
  }

  // Clear all data
  Future<void> clearAllData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_expensesKey);
    await prefs.remove(_categoriesKey);
    await prefs.remove(_tagsKey);
    await prefs.remove(_expenseTagsKey);
    
    _expensesCache = null;
    _categoriesCache = null;
    _tagsCache = null;
    _expenseTagsCache = null;
  }

  // Close/cleanup (for compatibility)
  Future<void> close() async {
    // Nothing to close for SharedPreferences
  }
}