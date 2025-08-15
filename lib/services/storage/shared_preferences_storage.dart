import 'package:shared_preferences/shared_preferences.dart';
import 'storage_service.dart';

/// A concrete implementation of [StorageService] using SharedPreferences.
/// 
/// This class follows the Liskov Substitution Principle by properly
/// implementing all methods defined in the [StorageService] interface.
class SharedPreferencesStorage implements StorageService {
  late SharedPreferences _prefs;
  bool _initialized = false;
  
  /// Initializes the SharedPreferences instance.
  Future<void> init() async {
    if (!_initialized) {
      _prefs = await SharedPreferences.getInstance();
      _initialized = true;
    }
  }
  
  /// Ensures the SharedPreferences instance is initialized before operations.
  Future<void> _ensureInitialized() async {
    if (!_initialized) {
      await init();
    }
  }
  
  @override
  Future<String?> getString(String key) async {
    await _ensureInitialized();
    return _prefs.getString(key);
  }
  
  @override
  Future<bool> setString(String key, String value) async {
    await _ensureInitialized();
    return await _prefs.setString(key, value);
  }
  
  @override
  Future<bool> containsKey(String key) async {
    await _ensureInitialized();
    return _prefs.containsKey(key);
  }
  
  @override
  Future<bool> remove(String key) async {
    await _ensureInitialized();
    return await _prefs.remove(key);
  }
  
  @override
  Future<bool> clear() async {
    await _ensureInitialized();
    return await _prefs.clear();
  }
}