import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _currentLocale = const Locale('vi', '');
  
  Locale get currentLocale => _currentLocale;
  
  // Supported languages
  static const List<Map<String, String>> supportedLanguages = [
    {'code': 'vi', 'name': 'Vietnamese', 'nativeName': 'Tiếng Việt'},
  ];
  
  LanguageProvider() {
    _loadLanguage();
  }
  
  // Load saved language from SharedPreferences
  Future<void> _loadLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString('language_code') ?? 'vi';
      _currentLocale = Locale(languageCode, '');
      notifyListeners();
    } catch (e) {
      // If there's an error, default to Vietnamese
      _currentLocale = const Locale('vi', '');
    }
  }
  
  // Change language and save to SharedPreferences
  Future<void> changeLanguage(String languageCode) async {
    if (_currentLocale.languageCode != languageCode) {
      _currentLocale = Locale(languageCode, '');
      notifyListeners();
      
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('language_code', languageCode);
      } catch (e) {
        // Handle error silently
      }
    }
  }
  
  // Get current language display name
  String getCurrentLanguageName() {
    final language = supportedLanguages.firstWhere(
      (lang) => lang['code'] == _currentLocale.languageCode,
      orElse: () => supportedLanguages.first,
    );
    return language['nativeName'] ?? 'Tiếng Việt';
  }
  
  // Get language name by code
  String getLanguageName(String code) {
    final language = supportedLanguages.firstWhere(
      (lang) => lang['code'] == code,
      orElse: () => supportedLanguages.first,
    );
    return language['nativeName'] ?? 'Tiếng Việt';
  }
}