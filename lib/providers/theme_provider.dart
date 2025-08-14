import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  String _colorScheme = 'purple';
  
  ThemeMode get themeMode => _themeMode;
  String get colorScheme => _colorScheme;
  
  // Supported theme modes
  static const List<Map<String, dynamic>> supportedThemes = [
    {'mode': ThemeMode.system, 'name': 'Mặc định hệ thống', 'icon': Icons.brightness_auto},
    {'mode': ThemeMode.light, 'name': 'Sáng', 'icon': Icons.light_mode},
    {'mode': ThemeMode.dark, 'name': 'Tối', 'icon': Icons.dark_mode},
  ];

  // Supported color schemes - simplified for Vietnamese users
  static const List<Map<String, dynamic>> supportedColorSchemes = [
    {'name': 'Xanh lam', 'value': 'blue', 'color': Color(0xFF2196F3)},
    {'name': 'Xanh lá', 'value': 'green', 'color': Color(0xFF4CAF50)},
    {'name': 'Đỏ', 'value': 'red', 'color': Color(0xFFE53935)},
  ];

  
  ThemeProvider() {
    _loadTheme();
  }
  
  // Load saved theme from SharedPreferences
  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeModeIndex = prefs.getInt('theme_mode') ?? 0; // Default to system
      final colorScheme = prefs.getString('color_scheme') ?? 'purple'; // Default to purple
      _themeMode = ThemeMode.values[themeModeIndex];
      _colorScheme = colorScheme;
      notifyListeners();
    } catch (e) {
      // If there's an error, default to system theme and purple color scheme
      _themeMode = ThemeMode.system;
      _colorScheme = 'purple';
    }
  }

  Future<void> setColorScheme(String colorScheme) async {
    if (_colorScheme != colorScheme) {
      _colorScheme = colorScheme;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('color_scheme', colorScheme);
      notifyListeners();
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