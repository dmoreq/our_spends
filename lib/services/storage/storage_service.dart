import 'dart:async';

/// An abstract interface for data storage operations.
/// 
/// This interface follows the Dependency Inversion Principle by allowing
/// high-level modules to depend on abstractions rather than concrete implementations.
abstract class StorageService {
  /// Initializes the storage service.
  Future<void> init();
  
  /// Retrieves a string value from storage by key.
  Future<String?> getString(String key);
  
  /// Saves a string value to storage with the given key.
  Future<bool> setString(String key, String value);
  
  /// Checks if a key exists in storage.
  Future<bool> containsKey(String key);
  
  /// Removes a value from storage by key.
  Future<bool> remove(String key);
  
  /// Clears all values from storage.
  Future<bool> clear();
}