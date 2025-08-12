import 'package:flutter/material.dart';

extension ColorExtensions on Color {
  /// Creates a new color with the given alpha value
  Color withOpacity(double opacity) {
    return Color.fromRGBO(red, green, blue, opacity.clamp(0.0, 1.0));
  }
  
  /// Creates a new color with the given alpha value
  /// This is an alias for withOpacity to maintain compatibility with existing code
  Color withValues({double? alpha}) {
    if (alpha != null) {
      return withOpacity(alpha);
    }
    return this;
  }
}