import '../models/currency.dart';

/// Repository interface for Currency-related operations.
/// 
/// This interface follows the Interface Segregation Principle by providing
/// a focused set of methods specific to currency operations.
abstract class CurrencyRepository {
  /// Retrieves all available currencies.
  Future<List<Currency>> getCurrencies();
  
  /// Gets the user's preferred currency.
  Future<Currency> getUserPreferredCurrency();
  
  /// Sets the user's preferred currency.
  Future<void> setUserPreferredCurrency(Currency currency);
  
  /// Ensures default currencies exist in the repository.
  Future<void> ensureDefaultCurrencies();
}