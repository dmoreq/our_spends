import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/expense.dart';
import '../models/tag.dart';

import '../providers/expense/expense_provider.dart';
import '../providers/tag/tag_provider.dart';
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
      
      // Load existing tags for this expense
      _loadExpenseTags();
    }
  }
  
  Future<void> _loadExpenseTags() async {
    if (widget.expenseToEdit != null) {
      final tagProvider = Provider.of<TagProvider>(context, listen: false);
      final tagIds = await tagProvider.getExpenseTags(widget.expenseToEdit!.id);
      setState(() {
        _selectedTagIds = tagIds;
      });
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
              
                // Tags selection
                _buildInputCard(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                              l10n.tags,
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                            const Spacer(),
                            TextButton.icon(
                              icon: const Icon(Icons.add, size: 18),
                              label: Text(l10n.addTag),
                              onPressed: _showTagSelectionDialog,
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildSelectedTagsSection(),
                      ],
                    ),
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
          item: _titleController.text,
          paymentMethod: _selectedPaymentMethod,
          location: _location,
          notes: _notesController.text.isEmpty ? null : _notesController.text,
          createdAt: widget.expenseToEdit?.createdAt ?? now,
          updatedAt: now,
        );
        
        final result = widget.expenseToEdit != null
          ? await expenseProvider.updateExpense(expense, _selectedTagIds)
          : await expenseProvider.addExpense(expense, _selectedTagIds);
        
        if (result != null) {
          // Save the selected tags for this expense
          final expenseId = expense.id; // Use the expense ID directly
          await Provider.of<TagProvider>(context, listen: false).setExpenseTags(expenseId, _selectedTagIds);
          
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
  
  // Build the section showing selected tags
  Widget _buildSelectedTagsSection() {
    final theme = Theme.of(context);
    
    if (_selectedTagIds.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          AppLocalizations.of(context)!.noTagsSelected,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.5),
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }
    
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _selectedTagIds.map((tagId) {
        return FutureBuilder<Tag?>(          
          future: Provider.of<TagProvider>(context, listen: false).getTagById(tagId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox.shrink();
            final tag = snapshot.data!;
            
            return Chip(
              label: Text(tag.name),
              avatar: Icon(
                IconData(tag.icon, fontFamily: 'MaterialIcons'),
                size: 18,
                color: Color(tag.color),
              ),
              backgroundColor: Color(tag.color).withOpacity(0.1),
              labelStyle: TextStyle(color: Color(tag.color)),
              deleteIconColor: Color(tag.color),
              onDeleted: () {
                setState(() {
                  _selectedTagIds.remove(tagId);
                });
              },
            );
          },
        );
      }).toList(),
    );
  }
  
  // Show dialog to select tags
  void _showTagSelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => TagSelectionDialog(
        selectedTagIds: _selectedTagIds,
        onTagsSelected: (selectedIds) {
          setState(() {
            _selectedTagIds = selectedIds;
          });
        },
      ),
    );
  }
}

// Tag Selection Dialog
class TagSelectionDialog extends StatefulWidget {
  final List<String> selectedTagIds;
  final Function(List<String>) onTagsSelected;
  
  const TagSelectionDialog({
    super.key,
    required this.selectedTagIds,
    required this.onTagsSelected,
  });
  
  @override
  State<TagSelectionDialog> createState() => _TagSelectionDialogState();
}

class _TagSelectionDialogState extends State<TagSelectionDialog> {
  late List<String> _selectedIds;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  
  @override
  void initState() {
    super.initState();
    _selectedIds = List.from(widget.selectedTagIds);
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    
    return AlertDialog(
      title: Text(l10n.selectTags),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search field
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.searchTags,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
            const SizedBox(height: 16),
            
            // Tags list
            Flexible(
              child: FutureBuilder<List<Tag>>(
                future: Provider.of<TagProvider>(context, listen: false).getTags(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.label_off_outlined,
                            size: 48,
                            color: theme.colorScheme.onSurface.withOpacity(0.4),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            l10n.noTagsAvailable,
                            style: theme.textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(context);
                              // Navigate to tag management screen
                              Navigator.pushNamed(context, '/tags');
                            },
                            icon: const Icon(Icons.add),
                            label: Text(l10n.createTag),
                          ),
                        ],
                      ),
                    );
                  }
                  
                  final filteredTags = snapshot.data!
                      .where((tag) => _searchQuery.isEmpty || 
                          tag.name.toLowerCase().contains(_searchQuery))
                      .toList();
                  
                  if (filteredTags.isEmpty) {
                    return Center(
                      child: Text(
                        l10n.noTagsFound,
                        style: theme.textTheme.bodyLarge,
                      ),
                    );
                  }
                  
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: filteredTags.length,
                    itemBuilder: (context, index) {
                      final tag = filteredTags[index];
                      final isSelected = _selectedIds.contains(tag.id);
                      
                      return CheckboxListTile(
                        title: Text(tag.name),
                        secondary: Icon(
                          IconData(tag.icon, fontFamily: 'MaterialIcons'),
                          color: Color(tag.color),
                        ),
                        value: isSelected,
                        onChanged: (selected) {
                          setState(() {
                            if (selected == true) {
                              if (!_selectedIds.contains(tag.id)) {
                                _selectedIds.add(tag.id);
                              }
                            } else {
                              _selectedIds.remove(tag.id);
                            }
                          });
                        },
                        activeColor: theme.colorScheme.primary,
                        checkColor: theme.colorScheme.onPrimary,
                      );
                    },
                  );
                },
              ),
            ),
            
            // Create new tag button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  // Navigate to tag creation screen or show tag creation dialog
                  Navigator.pushNamed(context, '/tags');
                },
                icon: const Icon(Icons.add),
                label: Text(l10n.createNewTag),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onTagsSelected(_selectedIds);
            Navigator.pop(context);
          },
          child: Text(l10n.apply),
        ),
      ],
    );
  }
}