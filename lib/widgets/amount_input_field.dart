import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/currency.dart';
import '../l10n/app_localizations.dart';

/// A reusable widget for entering monetary amounts with currency selection.
/// 
/// This widget follows the Single Responsibility Principle by focusing only on
/// amount input and currency selection UI and functionality.
class AmountInputField extends StatelessWidget {
  /// Text controller for the amount input.
  final TextEditingController controller;
  
  /// The currently selected currency.
  final Currency selectedCurrency;
  
  /// Available currencies to choose from.
  final List<Currency> availableCurrencies;
  
  /// Callback when currency changes.
  final Function(Currency) onCurrencyChanged;
  
  /// Validator function for the amount input.
  final String? Function(String?)? validator;
  
  const AmountInputField({
    Key? key,
    required this.controller,
    required this.selectedCurrency,
    required this.availableCurrencies,
    required this.onCurrencyChanged,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Currency dropdown
        Container(
          width: 80,
          margin: const EdgeInsets.only(right: 8),
          child: DropdownButtonFormField<String>(
            value: selectedCurrency.code,
            decoration: InputDecoration(
              labelText: l10n.currency,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items: availableCurrencies.map((currency) {
              return DropdownMenuItem<String>(
                value: currency.code,
                child: Text(currency.code),
              );
            }).toList(),
            onChanged: (String? value) {
              if (value != null) {
                final newCurrency = availableCurrencies.firstWhere(
                  (currency) => currency.code == value,
                );
                onCurrencyChanged(newCurrency);
              }
            },
          ),
        ),
        
        // Amount input field
        Expanded(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: l10n.amount,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              prefixText: selectedCurrency.symbol,
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[\d.,]')),
            ],
            validator: validator ?? (value) {
              if (value == null || value.isEmpty) {
                return l10n.pleaseEnterAmount;
              }
              try {
                final amount = double.parse(value.replaceAll(',', '.'));
                if (amount <= 0) {
                  return l10n.amountMustBePositive;
                }
              } catch (e) {
                return l10n.pleaseEnterValidAmount;
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}