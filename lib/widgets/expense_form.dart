import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../models/tag.dart';
import '../services/service_provider.dart';
import 'amount_input_field.dart';
import 'date_picker_field.dart';
import 'tag_selector.dart';

/// A reusable form for creating or editing expenses.
/// 
/// This widget encapsulates all the form fields needed for expense creation/editing,
/// promoting reusability and separation of concerns.
class ExpenseForm extends StatefulWidget {
  /// The expense to edit, null if creating a new expense
  final Expense? expense;
  
  /// Callback when form is submitted
  final Function(Expense expense, List<String> tagIds) onSubmit;
  
  /// Optional callback when form is cancelled
  final VoidCallback? onCancel;
  
  const ExpenseForm({
    Key? key,
    this.expense,
    required this.onSubmit,
    this.onCancel,
  }) : super(key: key);

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  final _itemController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _notesController = TextEditingController();
  final _paymentMethodController = TextEditingController();
  final _amountController = TextEditingController();
  
  DateTime _selectedDate = DateTime.now();
  double _amount = 0.0;
  Currency _selectedCurrency = Currency.usd;
  List<Currency> _availableCurrencies = [Currency.usd, Currency.eur];
  List<String> _selectedTagIds = [];
  List<Tag> _availableTags = [];
  bool _isLoading = false;
  String? _errorMessage;
  
  @override
  void initState() {
    super.initState();
    _loadData();
  }
  
  @override
  void dispose() {
    _itemController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _notesController.dispose();
    _paymentMethodController.dispose();
    _amountController.dispose();
    super.dispose();
  }
  
  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      final serviceProvider = ServiceProvider.instance;
      final databaseService = serviceProvider.databaseService;
      
      // Load available tags
      final tags = await databaseService.getAllTags();
      
      // If editing an existing expense, populate form fields
      if (widget.expense != null) {
        final expense = widget.expense!;
        _itemController.text = expense.item;
        _descriptionController.text = expense.description ?? '';
        _locationController.text = expense.location ?? '';
        _notesController.text = expense.notes ?? '';
        _paymentMethodController.text = expense.paymentMethod ?? '';
        _amountController.text = expense.amount.toString();
        _selectedDate = expense.date;
        
        // Find matching currency or default to USD
        _selectedCurrency = _availableCurrencies.firstWhere(
          (c) => c.code == expense.currency,
          orElse: () => Currency.usd
        );
        
        // Load selected tags for this expense
        final tagIds = await databaseService.getExpenseTags(expense.id);
        setState(() {
          _selectedTagIds = tagIds;
          _availableTags = tags;
          _isLoading = false;
        });
      } else {
        // Get default currency for new expenses
        final defaultCurrencyCode = await databaseService.getPreferredCurrency();
        
        // Find matching currency or default to USD
        final defaultCurrency = _availableCurrencies.firstWhere(
          (c) => c.code == defaultCurrencyCode,
          orElse: () => Currency.usd
        );
        
        setState(() {
          _selectedCurrency = defaultCurrency;
          _availableTags = tags;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load data: $e';
        _isLoading = false;
      });
    }
  }
  
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Parse amount from text controller
      final amountValue = double.tryParse(_amountController.text) ?? 0.0;
      
      final expense = Expense(
        id: widget.expense?.id ?? '', // ID will be generated in repository if empty
        userId: widget.expense?.userId ?? '', // User ID will be set in the service
        item: _itemController.text,
        description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
        location: _locationController.text.isEmpty ? null : _locationController.text,
        paymentMethod: _paymentMethodController.text.isEmpty ? null : _paymentMethodController.text,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
        amount: amountValue,
        currency: _selectedCurrency.code,
        date: _selectedDate,
        isRecurring: widget.expense?.isRecurring ?? false,
        recurringFrequency: widget.expense?.recurringFrequency,
        receiptUrl: widget.expense?.receiptUrl,
        createdAt: widget.expense?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
        syncStatus: widget.expense?.syncStatus ?? 0,
      );
      
      widget.onSubmit(expense, _selectedTagIds);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadData,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Item field
          TextFormField(
            controller: _itemController,
            decoration: const InputDecoration(labelText: 'Item'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an item';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Description field
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(labelText: 'Description (optional)'),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          
          // Location field
          TextFormField(
            controller: _locationController,
            decoration: const InputDecoration(labelText: 'Location (optional)'),
          ),
          const SizedBox(height: 16),
          
          // Payment method field
          TextFormField(
            controller: _paymentMethodController,
            decoration: const InputDecoration(labelText: 'Payment Method (optional)'),
          ),
          const SizedBox(height: 16),
          
          // Notes field
          TextFormField(
            controller: _notesController,
            decoration: const InputDecoration(labelText: 'Notes (optional)'),
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          
          // Date picker
          DatePickerField(
            selectedDate: _selectedDate,
            onDateChanged: (date) {
              setState(() {
                _selectedDate = date;
              });
            },
            label: 'Date',
          ),
          const SizedBox(height: 16),
          
          // Amount and currency
          AmountInputField(
            controller: _amountController,
            selectedCurrency: _selectedCurrency,
            availableCurrencies: _availableCurrencies,
            onCurrencyChanged: (currency) {
              setState(() {
                _selectedCurrency = currency;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter an amount';
              }
              if (double.tryParse(value) == null) {
                return 'Please enter a valid number';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          // Tag selector
          TagSelector(
            selectedTagIds: _selectedTagIds,
            onTagsChanged: (tagIds) {
              setState(() {
                _selectedTagIds = tagIds;
              });
            },
            fetchTags: () async {
              return _availableTags;
            },
          ),
          const SizedBox(height: 24),
          
          // Submit and cancel buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (widget.onCancel != null) ...[  
                TextButton(
                  onPressed: widget.onCancel,
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 16),
              ],
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(widget.expense == null ? 'Add Expense' : 'Update Expense'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}