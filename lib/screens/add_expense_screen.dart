import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/expense.dart';
import '../providers/expense_provider.dart';

import '../l10n/app_localizations.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  
  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = 'Food & Drinks';
  String _selectedCurrency = 'VND';
  String? _selectedPaymentMethod;
  String? _location;
  
  bool _isLoading = false;
  
  final List<String> _categories = [
    'Food & Drinks',
    'Transportation',
    'Shopping',
    'Entertainment',
    'Utilities',
    'Health',
    'Travel',
    'Education',
    'Other',
  ];
  
  final List<String> _currencies = ['VND', 'USD', 'EUR', 'GBP', 'JPY'];
  
  final List<String> _paymentMethods = [
    'Cash',
    'Credit Card',
    'Debit Card',
    'Bank Transfer',
    'Mobile Payment',
    'Other',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Widget _buildInputCard({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.addExpense),
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
              _buildInputCard(
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
              const SizedBox(height: 16),
              
              // Amount and Currency row
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildInputCard(
                      child: TextFormField(
                        controller: _amountController,
                        decoration: InputDecoration(
                          labelText: l10n.expenseAmountLabel,
                          hintText: l10n.expenseAmountPlaceholder,
                          prefixIcon: const Icon(Icons.attach_money_outlined),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(20),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.fieldRequired;
                          }
                          if (double.tryParse(value) == null) {
                            return l10n.invalidNumber;
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildInputCard(
                      child: DropdownButtonFormField<String>(
                        value: _selectedCurrency,
                        decoration: InputDecoration(
                          labelText: l10n.currency,
                          prefixIcon: const Icon(Icons.currency_exchange_outlined),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(20),
                        ),
                        items: _currencies.map((currency) {
                          return DropdownMenuItem(
                            value: currency,
                            child: Text(currency),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedCurrency = value;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Date picker
              _buildInputCard(
                child: InkWell(
                  onTap: () => _selectDate(context),
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.expenseDateLabel,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface.withOpacity(0.6),
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
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: theme.colorScheme.onSurface.withOpacity(0.4),
                        ),
                      ],
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
                    setState(() {
                      _selectedPaymentMethod = value;
                    });
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
              _buildInputCard(
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
    switch (category) {
      case 'Food & Drinks':
        return l10n.expenseCategoryFood;
      case 'Transportation':
        return l10n.expenseCategoryTransport;
      case 'Shopping':
        return l10n.expenseCategoryShopping;
      case 'Entertainment':
        return l10n.expenseCategoryEntertainment;
      case 'Utilities':
        return l10n.expenseCategoryUtilities;
      case 'Health':
        return l10n.expenseCategoryHealth;
      case 'Travel':
        return l10n.expenseCategoryTravel;
      case 'Education':
        return l10n.expenseCategoryEducation;
      case 'Other':
        return l10n.expenseCategoryOther;
      default:
        return category;
    }
  }
  
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      try {
        final expenseProvider = Provider.of<ExpenseProvider>(context, listen: false);
        
        final userId = 'demo-user';
        
        final expense = Expense(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          userId: userId,
          date: _selectedDate,
          amount: double.parse(_amountController.text),
          currency: _selectedCurrency,
          category: _selectedCategory,
          item: _titleController.text,
          paymentMethod: _selectedPaymentMethod,
          location: _location,
          notes: _notesController.text.isEmpty ? null : _notesController.text,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        
        final expenseId = await expenseProvider.addExpense(expense);
        
        if (expenseId != null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppLocalizations.of(context)!.expenseAddedSuccess)),
            );
            Navigator.pop(context);
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(AppLocalizations.of(context)!.expenseAddedError)),
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