import 'dart:convert';

import '../../models/currency.dart';
import '../../repositories/currency_repository.dart';
import '../../services/storage/storage_service.dart';

/// Implementation of [CurrencyRepository] using SharedPreferences for storage.
/// 
/// This class follows the Single Responsibility Principle by focusing only on
/// currency-related data operations.
class SharedPreferencesCurrencyRepository implements CurrencyRepository {
  static const String _currenciesKey = 'currencies_data';
  static const String _preferredCurrencyKey = 'preferred_currency';
  
  final StorageService _storageService;
  List<Currency>? _currenciesCache;
  Currency? _preferredCurrencyCache;
  
  SharedPreferencesCurrencyRepository(this._storageService);
  
  /// Loads currencies from storage.
  Future<List<Currency>> _loadCurrencies() async {
    if (_currenciesCache != null) return _currenciesCache!;
    
    final currenciesJson = await _storageService.getString(_currenciesKey);
    
    if (currenciesJson == null) {
      _currenciesCache = [];
      return _currenciesCache!;
    }
    
    final List<dynamic> currenciesList = json.decode(currenciesJson);
    _currenciesCache = currenciesList.map((json) => Currency.fromJson(json)).toList();
    return _currenciesCache!;
  }
  
  /// Saves currencies to storage.
  Future<void> _saveCurrencies(List<Currency> currencies) async {
    final currenciesJson = json.encode(currencies.map((c) => c.toJson()).toList());
    await _storageService.setString(_currenciesKey, currenciesJson);
    _currenciesCache = currencies;
  }
  
  @override
  Future<List<Currency>> getCurrencies() async {
    return await _loadCurrencies();
  }
  
  @override
  Future<Currency> getUserPreferredCurrency() async {
    if (_preferredCurrencyCache != null) return _preferredCurrencyCache!;
    
    final preferredCurrencyJson = await _storageService.getString(_preferredCurrencyKey);
    
    if (preferredCurrencyJson == null) {
      // Default to USD if no preferred currency is set
      final currencies = await _loadCurrencies();
      final usd = currencies.firstWhere(
        (currency) => currency.code == 'USD',
        orElse: () => Currency(code: 'USD', symbol: '\$', name: 'US Dollar', decimalPlaces: 2, symbolOnLeft: true, spaceBetweenAmountAndSymbol: false),
      );
      _preferredCurrencyCache = usd;
      return usd;
    }
    
    _preferredCurrencyCache = Currency.fromJson(json.decode(preferredCurrencyJson));
    return _preferredCurrencyCache!;
  }
  
  @override
  Future<void> setUserPreferredCurrency(Currency currency) async {
    final currencyJson = json.encode(currency.toJson());
    await _storageService.setString(_preferredCurrencyKey, currencyJson);
    _preferredCurrencyCache = currency;
  }
  
  @override
  Future<void> ensureDefaultCurrencies() async {
    final currencies = await _loadCurrencies();
    
    if (currencies.isEmpty) {
      final defaultCurrencies = [
        Currency(code: 'USD', symbol: '\$', name: 'US Dollar', decimalPlaces: 2, symbolOnLeft: true, spaceBetweenAmountAndSymbol: false),
        Currency(code: 'EUR', symbol: '€', name: 'Euro', decimalPlaces: 2, symbolOnLeft: true, spaceBetweenAmountAndSymbol: false),
        Currency(code: 'GBP', symbol: '£', name: 'British Pound', decimalPlaces: 2, symbolOnLeft: true, spaceBetweenAmountAndSymbol: false),
        Currency(code: 'JPY', symbol: '¥', name: 'Japanese Yen', decimalPlaces: 0, symbolOnLeft: true, spaceBetweenAmountAndSymbol: false),
        Currency(code: 'CAD', symbol: 'C\$', name: 'Canadian Dollar', decimalPlaces: 2, symbolOnLeft: true, spaceBetweenAmountAndSymbol: false),
        Currency(code: 'AUD', symbol: 'A\$', name: 'Australian Dollar', decimalPlaces: 2, symbolOnLeft: true, spaceBetweenAmountAndSymbol: false),
        Currency(code: 'INR', symbol: '₹', name: 'Indian Rupee', decimalPlaces: 2, symbolOnLeft: true, spaceBetweenAmountAndSymbol: false),
        Currency(code: 'CNY', symbol: '¥', name: 'Chinese Yuan', decimalPlaces: 2, symbolOnLeft: true, spaceBetweenAmountAndSymbol: false),
      ];
      
      await _saveCurrencies(defaultCurrencies);
    }
    
    // Ensure preferred currency is set
    await getUserPreferredCurrency();
  }
}