import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  
  ThemeMode get themeMode => _themeMode;
  
  // Supported theme modes
  static const List<Map<String, dynamic>> supportedThemes = [
    {'mode': ThemeMode.system, 'name': 'System', 'icon': Icons.brightness_auto},
    {'mode': ThemeMode.light, 'name': 'Light', 'icon': Icons.light_mode},
    {'mode': ThemeMode.dark, 'name': 'Dark', 'icon': Icons.dark_mode},
  ];
  
  ThemeProvider() {
    _loadTheme();
  }
  
  // Load saved theme from SharedPreferences
  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeModeIndex = prefs.getInt('theme_mode') ?? 0; // Default to system
      _themeMode = ThemeMode.values[themeModeIndex];
      notifyListeners();
    } catch (e) {
      // If there's an error, default to system theme
      _themeMode = ThemeMode.system;
    }
  }
  
  // Change theme and save to SharedPreferences
  Future<void> changeTheme(ThemeMode mode) async {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
      
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('theme_mode', mode.index);
      } catch (e) {
        // Handle error silently
      }
    }
  }
  
  // Get current theme display name
  String getCurrentThemeName() {
    final theme = supportedThemes.firstWhere(
      (theme) => theme['mode'] == _themeMode,
      orElse: () => supportedThemes[0],
    );
    return theme['name'];
  }
  
  // Get theme name by mode
  String getThemeName(ThemeMode mode) {
    final theme = supportedThemes.firstWhere(
      (theme) => theme['mode'] == mode,
      orElse: () => supportedThemes[0],
    );
    return theme['name'];
  }
}