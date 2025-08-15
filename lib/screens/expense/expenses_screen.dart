import 'package:flutter/material.dart';
import '../../models/expense.dart';
import '../../models/tag.dart';
import '../../l10n/app_localizations.dart';
import '../../services/service_provider.dart';
import '../../services/expense_service.dart';
import 'add_expense_screen.dart';
import '../../widgets/expense_list_item.dart';

/// The expenses screen that uses the service architecture.
/// 
/// This screen displays a list of expenses and provides options to add, edit, and delete expenses.
/// It uses the ExpenseService for data operations, improving separation of concerns.
class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final List<Expense> _expenses = [];
  final List<Tag> _tags = [];
  bool _isLoading = true;
  String? _errorMessage;
  late ExpenseService _expenseService;
  
  @override
  void initState() {
    super.initState();
    _expenseService = ServiceProvider.instance.expenseService;
    _loadExpenses();
  }
  
  Future<void> _loadExpenses() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      final expensesWithTags = await _expenseService.getAllExpensesWithTags();
      final tagsList = <Tag>[];
      
      // Extract unique tags from all expenses
      for (final item in expensesWithTags) {
        final tags = item['tags'] as List<Tag>;
        for (final tag in tags) {
          if (!tagsList.any((t) => t.id == tag.id)) {
            tagsList.add(tag);
          }
        }
      }
      
      setState(() {
        _expenses.clear();
        _expenses.addAll(expensesWithTags.map((e) => e['expense'] as Expense));
        _tags.clear();
        _tags.addAll(tagsList);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load expenses: $e';
        _isLoading = false;
      });
    }
  }
  
  Future<void> _deleteExpense(String expenseId) async {
    try {
      await _expenseService.deleteExpense(expenseId);
      setState(() {
        _expenses.removeWhere((e) => e.id == expenseId);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Expense deleted')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete expense: $e')),
        );
      }
    }
  }
  
  void _navigateToAddExpense() {
    // Use the feature-specific AddExpenseScreen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddExpenseScreen(initialTagIds: []),
      ),
    ).then((_) => _loadExpenses());
  }
  
  void _navigateToEditExpense(Expense expense, List<String> tagIds) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddExpenseScreen(expense: expense, initialTagIds: tagIds),
      ),
    ).then((_) => _loadExpenses());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddExpense,
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text(
          l10n.expenses,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            onPressed: () {
              // TODO: Navigate to analytics/reports screen
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadExpenses,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadExpenses,
        child: _buildBody(context, l10n),
      ),
    );
  }
  
  Widget _buildBody(BuildContext context, AppLocalizations l10n) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              _errorMessage!,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadExpenses,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    
    if (_expenses.isEmpty) {
      return _buildEmptyState(context, l10n);
    }
    
    return _buildExpenseList(context);
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withAlpha(25),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.noExpenses,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start tracking your expenses by adding your first one',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withAlpha(153),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _navigateToAddExpense,
            icon: const Icon(Icons.add),
            label: Text(l10n.addExpense),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              textStyle: theme.textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseList(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _expenses.length,
      itemBuilder: (context, index) {
        final expense = _expenses[index];
        
        return FutureBuilder<List<String>>(
          future: _expenseService.getExpenseTags(expense.id),
          builder: (context, snapshot) {
            // Default empty list if data isn't loaded yet
            final tagIds = snapshot.data ?? [];
            final expenseTags = _tags.where((tag) => tagIds.contains(tag.id)).toList();
            
            return Dismissible(
              key: Key(expense.id),
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 16),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              direction: DismissDirection.endToStart,
              confirmDismiss: (direction) async {
                return await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Expense'),
                    content: const Text('Are you sure you want to delete this expense?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
              },
              onDismissed: (direction) {
                _deleteExpense(expense.id);
              },
              child: ExpenseListItem(
                expense: expense,
                tags: expenseTags,
                onTap: () async {
                  final tagIds = await _expenseService.getExpenseTags(expense.id);
                  if (mounted) {
                    _navigateToEditExpense(expense, tagIds);
                  }
                },
              ),
            );
          },
        );
      },
    );
  }
}