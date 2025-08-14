import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/expense.dart';
import '../models/tag.dart';
import '../providers/expense_provider.dart';
import '../l10n/app_localizations.dart';
import 'tag_management_screen.dart';

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
  String _selectedPaymentMethod = 'Cash';
  String? _location;
  List<String> _selectedTagIds = [];
  bool _isLoading = false;
  
  final List<String> _paymentMethods = [
    'Cash',
    'Bank Card',
    'Bank Transfer',
    'E-Wallet',
  ];

  Future<void> _loadExpenseTags() async {
    if (widget.expenseToEdit != null) {
      final tagIds = await Provider.of<ExpenseProvider>(context, listen: false)
          .getExpenseTags(widget.expenseToEdit!.id);
      setState(() {
        _selectedTagIds = tagIds;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.expenseToEdit != null) {
      _titleController.text = widget.expenseToEdit!.item;
      _amountController.text = widget.expenseToEdit!.amount.toString();
      _notesController.text = widget.expenseToEdit!.notes ?? '';
      _selectedDate = widget.expenseToEdit!.date;
      _selectedPaymentMethod = widget.expenseToEdit!.paymentMethod ?? 'Cash';
      _location = widget.expenseToEdit!.location;
      _loadExpenseTags();
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
      constraints: const BoxConstraints(minHeight: 72),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, MediaQuery.of(context).viewInsets.bottom + 32.0),
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
                    labelStyle: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    hintText: l10n.expenseTitlePlaceholder,
                    prefixIcon: const Icon(Icons.receipt_long_outlined, size: 24),
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
                const SizedBox(height: 20),
                
                // Amount field
                _buildInputCard(
                  child: TextFormField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    labelText: l10n.expenseAmountLabel,
                    labelStyle: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    hintText: l10n.expenseAmountPlaceholder,
                    prefixIcon: const Icon(Icons.attach_money_outlined, size: 24),
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
                const SizedBox(height: 20),
              
                // Date picker
                _buildInputCard(
                  child: InkWell(
                  onTap: () => _selectDate(context),
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                            size: 24,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.expenseDateLabel,
                                  style: theme.textTheme.labelMedium?.copyWith(
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
                            size: 18,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                          ),
                      ],
                    ),
                  ),
                ),
                ),
                const SizedBox(height: 20),
              
                // Tags selection
                Container(
                constraints: const BoxConstraints(minHeight: 72),
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                child: FutureBuilder<List<Tag>>(
                  future: Provider.of<ExpenseProvider>(context, listen: false).getTags(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData) {
                      return const Center(child: Text('No tags available'));
                    }
                    final tags = snapshot.data!;
                    return Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.local_offer_outlined,
                                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                    size: 24,
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    l10n.expenseCategoryLabel,
                                    style: theme.textTheme.labelMedium?.copyWith(
                                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const TagManagementScreen(),
                                    ),
                                  );
                                  // Force rebuild of the FutureBuilder when returning from tag management
                                  setState(() {});
                                },
                                tooltip: 'Add new tag',
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width - 64, // Account for padding and margins
                            ),
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: tags.map((tag) {
                                final isSelected = _selectedTagIds.contains(tag.id);
                                return FilterChip(
                                label: Text(tag.name),
                                selected: isSelected,
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      _selectedTagIds.add(tag.id);
                                    } else {
                                      _selectedTagIds.remove(tag.id);
                                    }
                                  });
                                },
                                avatar: Icon(
                                  IconData(tag.icon, fontFamily: 'MaterialIcons'),
                                  size: 18,
                                ),
                                backgroundColor: Color(tag.color).withOpacity(0.1),
                                selectedColor: Color(tag.color).withOpacity(0.2),
                                checkmarkColor: Color(tag.color),
                                labelStyle: TextStyle(
                                  color: isSelected
                                      ? Color(tag.color)
                                      : theme.colorScheme.onSurface,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  );
                  },
                ),
              ),
                const SizedBox(height: 20),
              
              // Payment method dropdown
              _buildInputCard(
                child: DropdownButtonFormField<String>(
                  value: _selectedPaymentMethod,
                  decoration: InputDecoration(
                    labelText: l10n.paymentMethod,
                    labelStyle: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
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
              const SizedBox(height: 20),
              
              // Location field
              _buildInputCard(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: l10n.location,
                    labelStyle: theme.textTheme.labelMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
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
              const SizedBox(height: 20),
              
                // Notes field
                Container(
                  constraints: const BoxConstraints(minHeight: 72),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
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
                      labelStyle: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      hintText: l10n.expenseNotesPlaceholder,
                      prefixIcon: const Icon(Icons.notes_outlined),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(20),
                    ),
                    maxLines: 3,
                    minLines: 1,
                    textAlignVertical: TextAlignVertical.top,
                  ),
                ),
                const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    ));

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
          category: _selectedTagIds.isNotEmpty ? _selectedTagIds.first : 'Other', // For backward compatibility
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
          await expenseProvider.setExpenseTags(expense.id, _selectedTagIds);
          
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