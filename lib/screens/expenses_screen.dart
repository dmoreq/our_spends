import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../models/expense.dart';
import '../models/category.dart';
import '../l10n/app_localizations.dart';
import 'add_expense_screen.dart';

class ExpensesScreen extends StatelessWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddExpenseScreen(),
            ),
          );
        },
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
        ],
      ),
      body: FutureBuilder<void>(
        future: Provider.of<ExpenseProvider>(context, listen: false).initializationDone,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: theme.colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.error,
                    style: theme.textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => Provider.of<ExpenseProvider>(context, listen: false).loadExpenses(),
            child: Consumer<ExpenseProvider>(
              builder: (context, expenseProvider, child) {
                if (expenseProvider.isLoading && expenseProvider.expenses.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (expenseProvider.errorMessage != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: theme.colorScheme.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          expenseProvider.errorMessage!,
                          style: theme.textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                final expenses = expenseProvider.expenses;

                if (expenses.isEmpty) {
                  return _buildEmptyState(context, l10n);
                }

                return _buildExpenseList(context, expenses);
              },
            ),
          );
        },
      ),
    );
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
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
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
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddExpenseScreen(),
                ),
              );
            },
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

  Widget _buildExpenseList(BuildContext context, List<Expense> expenses) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        final expense = expenses[index];
        return ExpenseListItem(expense: expense);
      },
    );
  }
}

class ExpenseListItem extends StatefulWidget {
  final Expense expense;
  final Function(Expense)? onDelete;
  
  const ExpenseListItem({super.key, required this.expense, this.onDelete});

  @override
  State<ExpenseListItem> createState() => _ExpenseListItemState();
}

class _ExpenseListItemState extends State<ExpenseListItem> {
  String? _formattedAmount;

  @override
  void initState() {
    super.initState();
    _initializeFormattedAmount();
  }

  Future<void> _initializeFormattedAmount() async {
    final formattedAmount = await _formatCurrency();
    if (mounted) {
      setState(() {
        _formattedAmount = formattedAmount;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    
    // Format date based on locale - show only day/month
    final shortDate = locale == 'vi' 
        ? '${widget.expense.date.day}/${widget.expense.date.month}'
        : '${widget.expense.date.month}/${widget.expense.date.day}';
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: InkWell(
          onTap: () {
            _showExpenseDetails(context, widget.expense);
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Title and short date
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.expense.item,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        shortDate,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                // Amount
                FutureBuilder<String>(
                  future: _formatCurrency(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      );
                    }
                    return Text(
                      snapshot.data ?? '',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food':
      case 'restaurant':
      case 'dining':
        return Icons.restaurant;
      case 'transport':
      case 'transportation':
      case 'travel':
        return Icons.directions_car;
      case 'shopping':
      case 'retail':
        return Icons.shopping_bag;
      case 'entertainment':
      case 'fun':
        return Icons.movie;
      case 'health':
      case 'medical':
        return Icons.local_hospital;
      case 'education':
      case 'learning':
        return Icons.school;
      case 'utilities':
      case 'bills':
        return Icons.receipt;
      case 'groceries':
      case 'grocery':
        return Icons.local_grocery_store;
      default:
        return Icons.attach_money;
    }
  }
  
  String _formatDate(DateTime date, String locale) {
    // Simple date formatting based on locale
    if (locale == 'vi') {
      return '${date.day}/${date.month}/${date.year}';
    }
    return '${date.month}/${date.day}/${date.year}';
  }
  
  Future<String> _formatCurrency() async {
    return await Provider.of<ExpenseProvider>(context, listen: false)
        .formatCurrency(widget.expense.amount, widget.expense.currency);
  }
  
  void _showExpenseDetails(BuildContext context, Expense expense) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    final theme = Theme.of(context);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Header with icon and title
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      _getCategoryIcon(expense.category),
                      color: theme.colorScheme.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          expense.item,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        FutureBuilder<String>(
                          future: _formatCurrency(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator(strokeWidth: 2);
                            }
                            return Text(
                              snapshot.data ?? '',
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Details section
               _buildDetailCard(context, [
                 _buildDetailRow(context, Icons.category_outlined, l10n.category, expense.category),
                 _buildDetailRow(context, Icons.calendar_today_outlined, l10n.date, _formatDate(expense.date, locale)),
                 if (expense.location != null)
                   _buildDetailRow(context, Icons.location_on_outlined, l10n.location, expense.location!),
                 if (expense.paymentMethod != null)
                   _buildDetailRow(context, Icons.payment_outlined, l10n.paymentMethod, expense.paymentMethod!),
               ]),
               if (expense.notes != null && expense.notes!.isNotEmpty) ...[
                 const SizedBox(height: 16),
                 _buildDetailCard(context, [
                   _buildDetailRow(context, Icons.note_outlined, l10n.notes, expense.notes!),
                 ]),
               ],
              const SizedBox(height: 32),
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddExpenseScreen(expenseToEdit: expense),
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit_outlined),
                      label: Text(l10n.edit),
                    ),
                  ),
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(l10n.deleteExpenseConfirmation),
                            content: Text(l10n.deleteExpenseMessage),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(l10n.cancel),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.pop(context); // Close dialog
                                  Navigator.pop(context); // Close bottom sheet
                                  final expenseProvider = Provider.of<ExpenseProvider>(context, listen: false);
                                  await expenseProvider.deleteExpense(expense.id);
                                },
                                child: Text(
                                  l10n.delete,
                                  style: TextStyle(color: theme.colorScheme.error),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: Icon(Icons.delete_outline, color: theme.colorScheme.error),
                      label: Text(l10n.delete, style: TextStyle(color: theme.colorScheme.error)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Close'),
                    ),
                  ),
                ],
              ),
              // Add bottom padding for safe area
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildDetailCard(BuildContext context, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: children,
      ),
    );
  }
  
  Widget _buildDetailRow(BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}