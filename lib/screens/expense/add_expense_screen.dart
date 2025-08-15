import 'package:flutter/material.dart';

import '../../models/expense.dart';
import '../../services/service_provider.dart';
import '../../services/expense_service.dart';
import '../../widgets/expense_form.dart';

/// AddExpenseScreen that uses the ExpenseForm component.
/// 
/// This screen follows the Single Responsibility Principle by delegating
/// form handling to the ExpenseForm component and using ExpenseService for data operations.
class AddExpenseScreen extends StatefulWidget {
  /// The expense to edit, null if creating a new expense
  final Expense? expense;
  
  /// Initial tag IDs to pre-select when editing an expense
  final List<String> initialTagIds;
  
  const AddExpenseScreen({
    super.key,
    this.expense,
    this.initialTagIds = const [],
  });

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  bool _isSubmitting = false;
  late ExpenseService _expenseService;
  
  @override
  void initState() {
    super.initState();
    _expenseService = ServiceProvider.instance.expenseService;
  }
  
  Future<void> _handleSubmit(Expense expense, List<String> tagIds) async {
    if (_isSubmitting) return;
    
    setState(() {
      _isSubmitting = true;
    });
    
    try {
      if (widget.expense == null) {
        // Creating a new expense
        await _expenseService.createExpense(expense, tagIds);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Expense added successfully')),
          );
          Navigator.pop(context);
        }
      } else {
        // Updating an existing expense
        await _expenseService.updateExpense(expense, tagIds);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Expense updated successfully')),
          );
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.expense == null ? 'Add Expense' : 'Edit Expense'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ExpenseForm(
              expense: widget.expense,
              onSubmit: _handleSubmit,
              onCancel: () => Navigator.pop(context),
            ),
          ),
          if (_isSubmitting)
            Container(
              color: Colors.black.withAlpha(77),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}