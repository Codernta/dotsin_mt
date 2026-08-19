import 'package:flutter/material.dart';
import 'health_colors.dart';

/// Health Data Hub Theme Configuration
class HealthTheme {
  HealthTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: HealthColors.background,
      colorScheme: const ColorScheme.dark(
        primary: HealthColors.primary,
        onPrimary: HealthColors.onPrimary,
        primaryContainer: HealthColors.primaryContainer,
        onPrimaryContainer: HealthColors.onPrimaryContainer,
        secondary: HealthColors.secondary,
        onSecondary: HealthColors.onSecondary,
        secondaryContainer: HealthColors.secondaryContainer,
        onSecondaryContainer: HealthColors.onSecondaryContainer,
        surface: HealthColors.surface,
        onSurface: HealthColors.onSurface,
        surfaceContainer: HealthColors.surfaceContainer,
        surfaceContainerHigh: HealthColors.surfaceContainerHigh,
        surfaceContainerHighest: HealthColors.surfaceContainerHighest,
        error: HealthColors.error,
        onError: HealthColors.onError,
        outline: HealthColors.outline,
        outlineVariant: HealthColors.outlineVariant,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: HealthColors.primary),
      ),
      cardTheme: CardThemeData(
        color: HealthColors.surfaceContainer,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: HealthColors.glassBorder, width: 1),
        ),
      ),
      iconTheme: const IconThemeData(
        color: HealthColors.onSurface,
      ),
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: HealthColors.lightBackground,
      colorScheme: const ColorScheme.light(
        primary: HealthColors.lightPrimary,
        onPrimary: Colors.white,
        primaryContainer: HealthColors.lightSoftTeal,
        secondary: HealthColors.lightSoftTeal,
        surface: HealthColors.lightSurface,
        onSurface: HealthColors.lightPrimary,
        surfaceContainer: HealthColors.lightSurfaceContainer,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        scrolledUnderElevation: 0,
      ),
    );
  }
}
