import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';

/// A reusable widget for selecting dates.
/// 
/// This widget follows the Single Responsibility Principle by focusing only on
/// date selection UI and functionality.
class DatePickerField extends StatelessWidget {
  /// The currently selected date.
  final DateTime selectedDate;
  
  /// Callback when date changes.
  final Function(DateTime) onDateChanged;
  
  /// Optional label for the field.
  final String? label;
  
  const DatePickerField({
    Key? key,
    required this.selectedDate,
    required this.onDateChanged,
    this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final dateFormat = DateFormat.yMMMd();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Text(
            label!,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        InkWell(
          onTap: () => _selectDate(context),
          child: InputDecorator(
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              suffixIcon: const Icon(Icons.calendar_today),
            ),
            child: Text(dateFormat.format(selectedDate)),
          ),
        ),
      ],
    );
  }
  
  Future<void> _selectDate(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 1)),
      helpText: l10n.selectDate,
    );
    
    if (picked != null && picked != selectedDate) {
      onDateChanged(picked);
    }
  }
}