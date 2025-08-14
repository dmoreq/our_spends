import 'package:flutter/material.dart';

class AppTheme {
  // Color schemes
  static const Map<String, Map<String, Color>> colorSchemes = {
    'purple': {
      'primary': Color(0xFF8E4DFF),
      'secondary': Color(0xFFB89CFF),
      'accent': Color(0xFFFF7675),
    },
    'blue': {
      'primary': Color(0xFF2196F3),
      'secondary': Color(0xFF90CAF9),
      'accent': Color(0xFFFF9800),
    },
    'green': {
      'primary': Color(0xFF4CAF50),
      'secondary': Color(0xFFA5D6A7),
      'accent': Color(0xFFFFC107),
    },
    'orange': {
      'primary': Color(0xFFFF9800),
      'secondary': Color(0xFFFFCC80),
      'accent': Color(0xFF2196F3),
    },
    'pink': {
      'primary': Color(0xFFE91E63),
      'secondary': Color(0xFFF48FB1),
      'accent': Color(0xFF9C27B0),
    },
  };

  static Map<String, Color> _getColorScheme(String scheme) {
    return colorSchemes[scheme] ?? colorSchemes['purple']!;
  }

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

  static ThemeData lightTheme(String colorScheme) {
    final colors = _getColorScheme(colorScheme);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: colors['primary']!,
        secondary: colors['secondary']!,
        tertiary: colors['accent']!,
        surface: _lightSurfaceColor,
        error: _errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: _lightTextPrimary,
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
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors['primary']!,
        foregroundColor: Colors.white,
        elevation: 6,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),

      // NavigationBar theme
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: _darkSurfaceColor,
        elevation: 8,
        shadowColor: const Color(0x1A000000),
        indicatorColor: colors['primary']!.withOpacity(0.2),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: colors['primary']!,
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
            return IconThemeData(
              color: colors['primary']!,
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
          borderSide: BorderSide(color: colors['primary']!, width: 2),
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
          backgroundColor: colors['primary']!,
          foregroundColor: Colors.white,
          elevation: 3,
          shadowColor: colors['primary']!.withOpacity(0.3),
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
          foregroundColor: colors['primary']!,
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
        selectedColor: colors['primary']!,
        secondarySelectedColor: colors['primary']!,
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

  static ThemeData darkTheme(String colorScheme) {
    final colors = _getColorScheme(colorScheme);
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: colors['primary']!,
        secondary: colors['secondary']!,
        tertiary: colors['accent']!,
        surface: _darkSurfaceColor,
        error: _errorColor,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: _darkTextPrimary,
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
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors['primary']!,
        foregroundColor: Colors.white,
        elevation: 6,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),

      // NavigationBar theme
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: _darkSurfaceColor,
        elevation: 8,
        shadowColor: const Color(0x1A000000),
        indicatorColor: colors['primary']!.withOpacity(0.2),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: colors['primary']!,
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
            return IconThemeData(
              color: colors['primary']!,
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
          borderSide: BorderSide(color: colors['primary']!, width: 2),
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
          backgroundColor: colors['primary']!,
          foregroundColor: Colors.white,
          elevation: 3,
          shadowColor: colors['primary']!.withOpacity(0.3),
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
          foregroundColor: colors['primary']!,
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
        selectedColor: colors['primary']!,
        secondarySelectedColor: colors['primary']!,
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