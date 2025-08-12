import 'package:flutter/material.dart';

class AppTheme {
  // AI Chat App UI inspired color palette
  static const Color _primaryColor = Color(0xFF8E4DFF);
  static const Color _secondaryColor = Color(0xFFB89CFF);
  static const Color _accentColor = Color(0xFFFF7675);

  // Light Theme Colors
  static const Color _lightBackgroundColor = Color(0xFFFFFFFF);
  static const Color _lightSurfaceColor = Color(0xFFF2F2F2);
  static const Color _lightTextPrimary = Color(0xFF0D0D0D);
  static const Color _lightTextSecondary = Color(0xFF404040);
  static const Color _lightTextTertiary = Color(0xFF999999);

  // Dark Theme Colors
  static const Color _darkBackgroundColor = Color(0xFF0D0D0D);
  static const Color _darkSurfaceColor = Color(0xFF1A1A1A);
  static const Color _darkTextPrimary = Color(0xFFFFFFFF);
  static const Color _darkTextSecondary = Color(0xFFA0A0A0);
  static const Color _darkTextTertiary = Color(0xFF595959);

  static const Color _errorColor = Color(0xFFE17055);
  static const Color _successColor = Color(0xFF00B894);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: _primaryColor,
        secondary: _secondaryColor,
        tertiary: _accentColor,
        surface: _lightSurfaceColor,
        background: _lightBackgroundColor,
        error: _errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: _lightTextPrimary,
        onBackground: _lightTextPrimary,
        onError: Colors.white,
        outline: _lightTextTertiary,
        surfaceContainerHighest: Color(0xFFE0E0E0),
      ),
      scaffoldBackgroundColor: _lightBackgroundColor,
      
      // Typography
      fontFamily: 'Urbanist',
      textTheme: _textTheme.apply(
        bodyColor: _lightTextPrimary,
        displayColor: _lightTextPrimary,
      ),

      // FloatingActionButton theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),

      // NavigationBar theme
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: _darkSurfaceColor,
        elevation: 8,
        shadowColor: const Color(0x1A000000),
        indicatorColor: _primaryColor.withValues(alpha: 0.2),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: _primaryColor,
            );
          }
          return const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: _darkTextSecondary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(
              color: _primaryColor,
              size: 24,
            );
          }
          return IconThemeData(
            color: _darkTextSecondary,
            size: 24,
          );
        }),
      ),

      // AppBar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: _lightBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: Color(0x1A000000),
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Urbanist',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: _lightTextPrimary,
        ),
        iconTheme: IconThemeData(color: _lightTextPrimary, size: 24),
        surfaceTintColor: _lightBackgroundColor,
      ),

      // Card theme
      cardTheme: CardThemeData(
        color: _lightSurfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _lightSurfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _errorColor),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        hintStyle: const TextStyle(color: _lightTextSecondary, fontSize: 16),
        labelStyle: const TextStyle(color: _lightTextSecondary, fontSize: 16),
      ),

      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          elevation: 3,
          shadowColor: _primaryColor.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          textStyle: const TextStyle(
            fontFamily: 'Urbanist',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
        ),
      ),

      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _primaryColor,
          textStyle: const TextStyle(
            fontFamily: 'Urbanist',
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // Chip theme
      chipTheme: ChipThemeData(
        backgroundColor: _lightSurfaceColor,
        disabledColor: Colors.grey.shade300,
        selectedColor: _primaryColor,
        secondarySelectedColor: _primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.grey.shade300),
        ),
        labelStyle: const TextStyle(
          color: _lightTextPrimary,
          fontWeight: FontWeight.w600,
        ),
        secondaryLabelStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        brightness: Brightness.light,
      ),

      // Dialog theme
      dialogTheme: DialogThemeData(
        backgroundColor: _lightBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        titleTextStyle: TextStyle(
          fontFamily: 'Urbanist',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: _lightTextPrimary,
        ),
        contentTextStyle: TextStyle(
          fontFamily: 'Urbanist',
          fontSize: 16,
          color: _lightTextSecondary,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: _primaryColor,
        secondary: _secondaryColor,
        tertiary: _accentColor,
        surface: _darkSurfaceColor,
        background: _darkBackgroundColor,
        error: _errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: _darkTextPrimary,
        onBackground: _darkTextPrimary,
        onError: Colors.white,
        outline: _darkTextTertiary,
        surfaceContainerHighest: Color(0xFF333333),
      ),
      scaffoldBackgroundColor: _darkBackgroundColor,
      
      // Typography
      fontFamily: 'Urbanist',
      textTheme: _textTheme.apply(
        bodyColor: _darkTextPrimary,
        displayColor: _darkTextPrimary,
      ),

      // FloatingActionButton theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: _primaryColor,
        foregroundColor: Colors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),

      // NavigationBar theme
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: _darkSurfaceColor,
        elevation: 8,
        shadowColor: const Color(0x1A000000),
        indicatorColor: _primaryColor.withValues(alpha: 0.2),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: _primaryColor,
            );
          }
          return const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: _darkTextSecondary,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(
              color: _primaryColor,
              size: 24,
            );
          }
          return IconThemeData(
            color: _darkTextSecondary,
            size: 24,
          );
        }),
      ),

      // AppBar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: _darkBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: Color(0x1A000000),
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Urbanist',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: _darkTextPrimary,
        ),
        iconTheme: IconThemeData(color: _darkTextPrimary, size: 24),
        surfaceTintColor: _darkBackgroundColor,
      ),

      // Card theme
      cardTheme: CardThemeData(
        color: _darkSurfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade800, width: 1),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _darkSurfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _errorColor),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        hintStyle: const TextStyle(color: _darkTextSecondary, fontSize: 16),
        labelStyle: const TextStyle(color: _darkTextSecondary, fontSize: 16),
      ),

      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          elevation: 3,
          shadowColor: _primaryColor.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          textStyle: const TextStyle(
            fontFamily: 'Urbanist',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.2,
          ),
        ),
      ),

      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _primaryColor,
          textStyle: const TextStyle(
            fontFamily: 'Urbanist',
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      // Chip theme
      chipTheme: ChipThemeData(
        backgroundColor: _darkSurfaceColor,
        disabledColor: Colors.grey.shade800,
        selectedColor: _primaryColor,
        secondarySelectedColor: _primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.grey.shade800),
        ),
        labelStyle: const TextStyle(
          color: _darkTextPrimary,
          fontWeight: FontWeight.w600,
        ),
        secondaryLabelStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        brightness: Brightness.dark,
      ),

      // Dialog theme
      dialogTheme: DialogThemeData(
        backgroundColor: _darkSurfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        titleTextStyle: TextStyle(
          fontFamily: 'Urbanist',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: _darkTextPrimary,
        ),
        contentTextStyle: TextStyle(
          fontFamily: 'Urbanist',
          fontSize: 16,
          color: _darkTextSecondary,
        ),
      ),
    );
  }

  static const TextTheme _textTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 48,
      fontWeight: FontWeight.w700,
      letterSpacing: -1.5,
    ),
    displayMedium: TextStyle(
      fontSize: 40,
      fontWeight: FontWeight.w700,
      letterSpacing: -1.0,
    ),
    displaySmall: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
    ),
    headlineLarge: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.25,
    ),
    headlineMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
    ),
    headlineSmall: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w700,
    ),
    titleLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w700,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ),
    labelLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    labelMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
    labelSmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
    ),
  );
}