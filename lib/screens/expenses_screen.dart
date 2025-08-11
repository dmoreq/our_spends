import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/expense.dart';
import '../providers/expense_provider.dart';
import '../l10n/app_localizations.dart';
import 'add_expense_screen.dart';

class ExpensesScreen extends StatelessWidget {
  const ExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.expenses),
        elevation: 0,
      ),
      body: Consumer<ExpenseProvider>(
        builder: (context, expenseProvider, child) {
          if (expenseProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (expenseProvider.errorMessage != null) {
            return Center(child: Text(expenseProvider.errorMessage!));
          }
          
          final expenses = expenseProvider.expenses;
          
          if (expenses.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n.noExpenses,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddExpenseScreen(),
                        ),
                      );
                    },
                    child: Text(l10n.addExpense),
                  ),
                ],
              ),
            );
          }
          
          return ListView.builder(
            itemCount: expenses.length,
            itemBuilder: (context, index) {
              final expense = expenses[index];
              return ExpenseListItem(expense: expense);
            },
          );
        },
      ),
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
    );
  }
}

class ExpenseListItem extends StatelessWidget {
  final Expense expense;
  
  const ExpenseListItem({super.key, required this.expense});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    
    // Format date based on locale
    final formattedDate = _formatDate(expense.date, locale);
    
    // Format currency based on locale and currency code
    final formattedAmount = _formatCurrency(expense.amount, expense.currency, locale);
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(
          expense.item,
          style: theme.textTheme.titleMedium,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(formattedDate),
            Text(expense.category),
          ],
        ),
        trailing: Text(
          formattedAmount,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () {
          _showExpenseDetails(context, expense);
        },
      ),
    );
  }
  
  String _formatDate(DateTime date, String locale) {
    // Simple date formatting based on locale
    if (locale == 'vi') {
      return '${date.day}/${date.month}/${date.year}';
    }
    return '${date.month}/${date.day}/${date.year}';
  }
  
  String _formatCurrency(double amount, String currency, String locale) {
    // Simple currency formatting based on locale and currency
    if (locale == 'vi' && currency == 'VND') {
      return '${amount.toStringAsFixed(0)}đ';
    } else if (currency == 'USD') {
      return '\$${amount.toStringAsFixed(2)}';
    }
    return '$amount $currency';
  }
  
  void _showExpenseDetails(BuildContext context, Expense expense) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;
    
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                expense.item,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                _formatCurrency(expense.amount, expense.currency, locale),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              _buildDetailRow(l10n.category, expense.category),
              _buildDetailRow(l10n.date, _formatDate(expense.date, locale)),
              if (expense.location != null)
                _buildDetailRow(l10n.location, expense.location!),
              if (expense.paymentMethod != null)
                _buildDetailRow(l10n.paymentMethod, expense.paymentMethod!),
              if (expense.notes != null && expense.notes!.isNotEmpty)
                _buildDetailRow(l10n.notes, expense.notes!),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(l10n.close),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}