import '../repositories/currency_repository.dart';
import '../repositories/expense_repository.dart';
import '../repositories/implementations/shared_preferences_currency_repository.dart';
import '../repositories/implementations/shared_preferences_expense_repository.dart';
import '../repositories/implementations/shared_preferences_tag_repository.dart';
import '../repositories/tag_repository.dart';
import '../services/expense_service.dart';
import '../services/storage/shared_preferences_storage.dart';
import '../services/storage/storage_service.dart';

/// Service provider that implements dependency injection for the application.
/// 
/// This class follows the Dependency Inversion Principle by providing
/// concrete implementations for abstract interfaces.
class ServiceProvider {
  static final ServiceProvider _instance = ServiceProvider._internal();
  
  /// Static instance getter for easy access
  static ServiceProvider get instance => _instance;
  
  factory ServiceProvider() {
    return _instance;
  }
  
  ServiceProvider._internal();
  
  // Lazy-loaded singletons
  StorageService? _storageService;
  ExpenseRepository? _expenseRepository;
  TagRepository? _tagRepository;
  CurrencyRepository? _currencyRepository;
  ExpenseService? _expenseService;
  
  /// Initializes all services.
  Future<void> initialize() async {
    // Initialize storage service
    _storageService = SharedPreferencesStorage();
    await _storageService!.init();
    
    // Initialize repositories
    _expenseRepository = SharedPreferencesExpenseRepository(_storageService!);
    _tagRepository = SharedPreferencesTagRepository(_storageService!);
    _currencyRepository = SharedPreferencesCurrencyRepository(_storageService!);
    
    // Ensure default currencies exist
    await _currencyRepository!.ensureDefaultCurrencies();
    
    // Initialize expense service
    _expenseService = ExpenseService(
      expenseRepository: _expenseRepository!,
      tagRepository: _tagRepository!,
    );
  }
  
  /// Gets the storage service.
  StorageService get storageService {
    if (_storageService == null) {
      throw StateError('StorageService not initialized. Call initialize() first.');
    }
    return _storageService!;
  }
  
  /// Gets the expense repository.
  ExpenseRepository get expenseRepository {
    if (_expenseRepository == null) {
      throw StateError('ExpenseRepository not initialized. Call initialize() first.');
    }
    return _expenseRepository!;
  }
  
  /// Gets the tag repository.
  TagRepository get tagRepository {
    if (_tagRepository == null) {
      throw StateError('TagRepository not initialized. Call initialize() first.');
    }
    return _tagRepository!;
  }
  
  /// Gets the currency repository.
  CurrencyRepository get currencyRepository {
    if (_currencyRepository == null) {
      throw StateError('CurrencyRepository not initialized. Call initialize() first.');
    }
    return _currencyRepository!;
  }
  
  /// Gets the expense service.
  ExpenseService get expenseService {
    if (_expenseService == null) {
      throw StateError('ExpenseService not initialized. Call initialize() first.');
    }
    return _expenseService!;
  }
}