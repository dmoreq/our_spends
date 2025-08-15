import 'package:flutter/material.dart';
import '../../models/currency.dart';
import '../../repositories/currency_repository.dart';
import '../../services/service_provider.dart';

/// A provider that manages currency data and operations.
/// 
/// This class follows the separation of concerns principle by focusing only on
/// currency-related operations, which were previously mixed with expense operations
/// in the ExpenseProvider.
class CurrencyProvider extends ChangeNotifier {
  final CurrencyRepository _currencyRepository;
  
  bool _isLoading = false;
  String? _errorMessage;
  Currency? _userPreferredCurrency;
  
  CurrencyProvider({
    CurrencyRepository? currencyRepository,
  }) : _currencyRepository = currencyRepository ?? ServiceProvider.instance.currencyRepository {
    _loadUserPreferredCurrency();
  }
  
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  /// Loads the user's preferred currency.
  Future<void> _loadUserPreferredCurrency() async {
    try {
      _setLoading(true);
      _userPreferredCurrency = await _currencyRepository.getUserPreferredCurrency();
      _setLoading(false);
    } catch (e) {
      _setError('Failed to load preferred currency: ${e.toString()}');
    }
  }
  
  /// Gets the user's preferred currency.
  Future<Currency> getUserPreferredCurrency() async {
    if (_userPreferredCurrency == null) {
      await _loadUserPreferredCurrency();
    }
    return _userPreferredCurrency ?? Currency.vnd; // Default to VND if not set
  }
  
  /// Sets the user's preferred currency.
  Future<void> setUserPreferredCurrency(Currency currency) async {
    try {
      _setLoading(true);
      await _currencyRepository.setUserPreferredCurrency(currency);
      _userPreferredCurrency = currency;
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('Failed to set preferred currency: ${e.toString()}');
    }
  }
  
  /// Formats an amount according to the user's preferred currency.
  Future<String> formatAmount(double amount) async {
    final currency = await getUserPreferredCurrency();
    return currency.formatAmount(amount);
  }
  
  /// Formats an amount according to the specified currency.
  String formatAmountWithCurrency(double amount, Currency currency) {
    return currency.formatAmount(amount);
  }
  
  /// Converts an amount from one currency to another.
  Future<double> convertCurrency(double amount, String fromCurrency, String toCurrency) async {
    try {
      // For now, we'll use a simplified conversion
      // In a real app, this would use exchange rates from an API
      final sourceCurrency = Currency.vnd; // Default source currency
      final targetCurrency = await getUserPreferredCurrency();
      return sourceCurrency.convertTo(amount, targetCurrency);
    } catch (e) {
      _setError('Failed to convert currency: ${e.toString()}');
      return amount; // Return original amount on error
    }
  }
  
  /// Gets all available currencies.
  List<Currency> getAvailableCurrencies() {
    // For now, we'll return a fixed list of currencies
    // In a real app, this might come from an API or database
    return [
      Currency.vnd,
      Currency.usd,
      Currency.eur,
    ];
  }
  
  // Private methods for internal use
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    _isLoading = false;
    notifyListeners();
  }

}