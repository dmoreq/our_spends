import 'package:flutter/material.dart';

class AppTheme {
  // Minimalist color palette
  static const Color _primaryColor = Color(0xFF2C3E50);
  static const Color _secondaryColor = Color(0xFF3498DB);
  static const Color _backgroundColor = Color(0xFFFAFAFA);
  static const Color _surfaceColor = Colors.white;
  static const Color _errorColor = Color(0xFFE74C3C);
  static const Color _textPrimary = Color(0xFF2C3E50);
  static const Color _textSecondary = Color(0xFF7F8C8D);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: _primaryColor,
        secondary: _secondaryColor,
        surface: _surfaceColor,
        error: _errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: _textPrimary,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: _backgroundColor,
      
      // Typography - Apple-inspired clean typography
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w700,
          color: _textPrimary,
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: _textPrimary,
          letterSpacing: -0.25,
        ),
        displaySmall: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: _textPrimary,
          letterSpacing: 0,
        ),
        headlineLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: _textPrimary,
          letterSpacing: 0,
        ),
        headlineMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: _textPrimary,
          letterSpacing: 0,
        ),
        headlineSmall: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: _textPrimary,
          letterSpacing: 0,
        ),
        titleLarge: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: _textPrimary,
          letterSpacing: 0,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: _textPrimary,
          letterSpacing: 0,
        ),
        titleSmall: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: _textPrimary,
          letterSpacing: 0,
        ),
        bodyLarge: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w400,
          color: _textPrimary,
          letterSpacing: 0,
        ),
        bodyMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: _textPrimary,
          letterSpacing: 0,
        ),
        bodySmall: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: _textSecondary,
          letterSpacing: 0,
        ),
        labelLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: _textPrimary,
          letterSpacing: 0,
        ),
        labelMedium: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: _textPrimary,
          letterSpacing: 0,
        ),
        labelSmall: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: _textPrimary,
          letterSpacing: 0,
        ),
      ),

      // AppBar theme - Flat design with no shadows
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: _textPrimary,
          letterSpacing: 0,
        ),
        iconTheme: IconThemeData(color: _textPrimary),
        surfaceTintColor: Colors.transparent,
      ),

      // Card theme - Flat design with no shadows
      cardTheme: CardThemeData(
        color: _surfaceColor,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),

      // Input decoration theme - Clean inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _secondaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _errorColor),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: const TextStyle(color: _textSecondary),
      ),

      // Elevated button theme - Flat design with no shadows
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0,
          ),
        ),
      ),

      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _secondaryColor,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Icon theme
      iconTheme: const IconThemeData(
        color: _textSecondary,
        size: 24,
      ),

      // Floating action button theme - Flat design
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _secondaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: CircleBorder(),
      ),

      // Bottom navigation bar theme - Flat design
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: _surfaceColor,
        selectedItemColor: _secondaryColor,
        unselectedItemColor: _textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
      ),

      // Divider theme
      dividerTheme: DividerThemeData(
        color: Colors.grey.shade200,
        thickness: 1,
        space: 1,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF3498DB),
        secondary: Color(0xFF2ECC71),
        surface: Color(0xFF2C3E50),
        error: Color(0xFFE74C3C),
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xFF1A252F),
      
      // Similar structure for dark theme with appropriate colors
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w300,
          color: Colors.white,
          letterSpacing: -0.5,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w300,
          color: Colors.white,
          letterSpacing: -0.5,
        ),
        headlineLarge: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w400,
          color: Colors.white,
          letterSpacing: -0.25,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w400,
          color: Colors.white,
          letterSpacing: -0.25,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.white,
          letterSpacing: 0,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white,
          letterSpacing: 0.15,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.white,
          letterSpacing: 0.25,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: Color(0xFFBDC3C7),
          letterSpacing: 0.4,
        ),
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.white,
          letterSpacing: 0,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),

      cardTheme: CardThemeData(
        color: const Color(0xFF2C3E50),
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}