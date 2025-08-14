import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/expense.dart';
import '../providers/expense_provider.dart';

import '../l10n/app_localizations.dart';

class AddExpenseScreen extends StatefulWidget {
  final Expense? expenseToEdit;

  const AddExpenseScreen({super.key, this.expenseToEdit});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  
  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = 'Ăn uống';
  String _selectedPaymentMethod = 'Tiền mặt';
  String? _location;
  
  bool _isLoading = false;
  
  final List<String> _categories = [
    'Ăn uống',
    'Đi lại',
    'Mua sắm',
    'Giải trí',
    'Tiện ích sinh hoạt',
    'Y tế',
    'Du lịch',
    'Giáo dục',
    'Chi phí khác',
  ];
  

  
  final List<String> _paymentMethods = [
    'Tiền mặt',
    'Thẻ ngân hàng',
    'Chuyển khoản',
    'Ví điện tử',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.expenseToEdit != null) {
      _titleController.text = widget.expenseToEdit!.item;
      _amountController.text = widget.expenseToEdit!.amount.toString();
      _notesController.text = widget.expenseToEdit!.notes ?? '';
      _selectedDate = widget.expenseToEdit!.date;
      _selectedCategory = widget.expenseToEdit!.category;
      _selectedPaymentMethod = widget.expenseToEdit!.paymentMethod ?? 'Tiền mặt';
      _location = widget.expenseToEdit!.location;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Widget _buildInputCard({required Widget child}) {
    return Container(
      height: 80, // Standardized height for all input fields
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Center(child: child), // Center alignment for consistent look
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.expenseToEdit != null ? l10n.editExpense : l10n.addExpense),
        leading: IconButton(
          icon: const Icon(Icons.close_outlined),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            TextButton(
              onPressed: _submitForm,
              child: Text(
                l10n.save,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildInputCard(
                  child: TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: l10n.expenseTitleLabel,
                      hintText: l10n.expenseTitlePlaceholder,
                      prefixIcon: const Icon(Icons.receipt_long_outlined),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(20),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.fieldRequired;
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Amount field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildInputCard(
                  child: TextFormField(
                    controller: _amountController,
                    decoration: InputDecoration(
                      labelText: l10n.expenseAmountLabel,
                      hintText: l10n.expenseAmountPlaceholder,
                      prefixIcon: const Icon(Icons.attach_money_outlined),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(20),
                      suffixText: 'VND',
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        // Remove any non-numeric characters except decimal point
                        final cleanValue = value.replaceAll(RegExp(r'[^\d.]'), '');
                        // Ensure only one decimal point
                        final parts = cleanValue.split('.');
                        String formattedValue = parts[0];
                        if (parts.length > 1) {
                          formattedValue += '.' + parts[1];
                        }
                        if (formattedValue != value) {
                          _amountController.value = TextEditingValue(
                            text: formattedValue,
                            selection: TextSelection.collapsed(offset: formattedValue.length),
                          );
                        }
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.fieldRequired;
                      }
                      final number = double.tryParse(value);
                      if (number == null) {
                        return l10n.invalidNumber;
                      }
                      if (number <= 0) {
                        return 'Amount must be greater than 0';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Date picker
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildInputCard(
                  child: InkWell(
                    onTap: () => _selectDate(context),
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.expenseDateLabel,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _formatDate(_selectedDate),
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
                    
              // Category dropdown
              _buildInputCard(
                child: DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: InputDecoration(
                    labelText: l10n.expenseCategoryLabel,
                    prefixIcon: const Icon(Icons.category_outlined),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(20),
                  ),
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(_getCategoryTranslation(category, l10n)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedCategory = value;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),
              
              // Payment method dropdown
              _buildInputCard(
                child: DropdownButtonFormField<String>(
                  value: _selectedPaymentMethod,
                  decoration: InputDecoration(
                    labelText: l10n.paymentMethod,
                    prefixIcon: const Icon(Icons.payment_outlined),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(20),
                  ),
                  items: _paymentMethods.map((method) {
                    return DropdownMenuItem(
                      value: method,
                      child: Text(method),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedPaymentMethod = value;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),
              
              // Location field
              _buildInputCard(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: l10n.location,
                    hintText: l10n.locationPlaceholder,
                    prefixIcon: const Icon(Icons.location_on_outlined),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(20),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _location = value.isEmpty ? null : value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),
              
              // Notes field
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: TextFormField(
                  controller: _notesController,
                  decoration: InputDecoration(
                    labelText: l10n.expenseNotesLabel,
                    hintText: l10n.expenseNotesPlaceholder,
                    prefixIcon: const Icon(Icons.notes_outlined),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(20),
                  ),
                  maxLines: 3,
                ),
              ),
              const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
    );
  }
  
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
  
  String _formatDate(DateTime date) {
    final locale = Localizations.localeOf(context).languageCode;
    if (locale == 'vi') {
      return '${date.day}/${date.month}/${date.year}';
    }
    return '${date.month}/${date.day}/${date.year}';
  }
  
  String _getCategoryTranslation(String category, AppLocalizations l10n) {
    // Không cần dịch vì danh mục đã được Việt hóa
    return category;
  }
  
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      try {
        final expenseProvider = Provider.of<ExpenseProvider>(context, listen: false);
        
        final userId = 'demo-user';
        
        final now = DateTime.now();
        final expense = Expense(
          id: widget.expenseToEdit?.id ?? now.millisecondsSinceEpoch.toString(),
          userId: userId,
          date: _selectedDate,
          amount: double.parse(_amountController.text),
          currency: widget.expenseToEdit?.currency ?? 'VND',
          category: _selectedCategory,
          item: _titleController.text,
          paymentMethod: _selectedPaymentMethod,
          location: _location,
          notes: _notesController.text.isEmpty ? null : _notesController.text,
          createdAt: widget.expenseToEdit?.createdAt ?? now,
          updatedAt: now,
        );
        
        final expenseId = widget.expenseToEdit != null
          ? await expenseProvider.updateExpense(expense)
          : await expenseProvider.addExpense(expense);
        
        if (expenseId != null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(widget.expenseToEdit != null
                ? AppLocalizations.of(context)!.expenseUpdatedSuccess
                : AppLocalizations.of(context)!.expenseAddedSuccess)),
            );
            Navigator.pop(context);
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(widget.expenseToEdit != null
                ? AppLocalizations.of(context)!.expenseUpdatedError
                : AppLocalizations.of(context)!.expenseAddedError)),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${AppLocalizations.of(context)!.error}: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }
}