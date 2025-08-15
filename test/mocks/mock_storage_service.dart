import 'dart:async';

import 'package:our_spends/services/storage/storage_service.dart';

class MockStorageService implements StorageService {
  final Map<String, String> _storage = {};

  @override
  Future<void> init() async {}

  @override
  Future<String?> getString(String key) async {
    return _storage[key];
  }

  @override
  Future<bool> setString(String key, String value) async {
    _storage[key] = value;
    return true;
  }

  @override
  Future<bool> containsKey(String key) async {
    return _storage.containsKey(key);
  }

  @override
  Future<bool> remove(String key) async {
    _storage.remove(key);
    return true;
  }

  @override
  Future<bool> clear() async {
    _storage.clear();
    return true;
  }
}