import 'package:flutter/material.dart';

/// Health Data Hub Design System Colors (Stitch Project 311684308991562559)
class HealthColors {
  HealthColors._();

  // Primary Emerald Palette
  static const Color primary = Color(0xFF4EDEA3); // Neon Emerald
  static const Color primaryContainer = Color(0xFF10B981);
  static const Color onPrimary = Color(0xFF003824);
  static const Color onPrimaryContainer = Color(0xFF00422B);
  static const Color primaryFixed = Color(0xFF6FFBBE);
  static const Color primaryFixedDim = Color(0xFF4EDEA3);
  static const Color onPrimaryFixed = Color(0xFF002113);
  static const Color onPrimaryFixedVariant = Color(0xFF005236);

  // Secondary Bio-Teal Palette
  static const Color secondary = Color(0xFF6BD8CB); // Electric Teal
  static const Color secondaryContainer = Color(0xFF29A195);
  static const Color onSecondary = Color(0xFF003732);
  static const Color onSecondaryContainer = Color(0xFF00302B);
  static const Color secondaryFixed = Color(0xFF89F5E7);
  static const Color secondaryFixedDim = Color(0xFF6BD8CB);
  static const Color onSecondaryFixed = Color(0xFF00201D);
  static const Color onSecondaryFixedVariant = Color(0xFF005049);

  // Tertiary Electric Azure Palette
  static const Color tertiary = Color(0xFFADC6FF); // Electric Azure
  static const Color tertiaryContainer = Color(0xFF71A1FF);
  static const Color onTertiary = Color(0xFF002E6A);
  static const Color onTertiaryContainer = Color(0xFF00367A);
  static const Color tertiaryFixed = Color(0xFFD8E2FF);
  static const Color tertiaryFixedDim = Color(0xFFADC6FF);
  static const Color onTertiaryFixed = Color(0xFF001A42);
  static const Color onTertiaryFixedVariant = Color(0xFF004395);

  // Dark Canvas & Obsidian Glass Surfaces
  static const Color background = Color(0xFF0B1326); // Deep Obsidian
  static const Color surface = Color(0xFF0B1326);
  static const Color surfaceDim = Color(0xFF0B1326);
  static const Color surfaceBright = Color(0xFF31394D);
  static const Color surfaceContainerLowest = Color(0xFF060E20);
  static const Color surfaceContainerLow = Color(0xFF131B2E);
  static const Color surfaceContainer = Color(0xFF171F33); // Card Base
  static const Color surfaceContainerHigh = Color(0xFF222A3D);
  static const Color surfaceContainerHighest = Color(0xFF2D3449);
  static const Color surfaceVariant = Color(0xFF2D3449);

  // Light Mode Surfaces (Optional Luminous Mint fallback)
  static const Color lightBackground = Color(0xFFF9F9FF);
  static const Color lightSurface = Color(0xFFF9F9FF);
  static const Color lightSurfaceContainer = Color(0xFFEEEEED);
  static const Color lightSoftTeal = Color(0xFF4F8B8B);
  static const Color lightPrimary = Color(0xFF002627);

  // Text & Content Contrast
  static const Color onBackground = Color(0xFFDAE2FD);
  static const Color onSurface = Color(0xFFDAE2FD);
  static const Color onSurfaceVariant = Color(0xFFBBCABF);
  static const Color outline = Color(0xFF86948A);
  static const Color outlineVariant = Color(0xFF3C4A42);

  // Status & Telemetry
  static const Color error = Color(0xFFFFB4AB); // Coral Alert
  static const Color onError = Color(0xFF690005);
  static const Color errorContainer = Color(0xFF93000A);
  static const Color onErrorContainer = Color(0xFFFFDAD6);

  static const Color amber = Color(0xFFF59E0B);
  static const Color amberLight = Color(0xFFFBBF24);
  static const Color amberDark = Color(0xFF78350F);

  // Glass, Gradients & Glow Borders
  static const Color glassBorder = Color(0x1AFFFFFF); // 10% white border
  static const Color glassSurface = Color(0x99171F33); // 60% card opacity
  static const Color glowPrimary = Color(0x664EDEA3); // 40% emerald glow
  static const Color glowSecondary = Color(0x666BD8CB); // 40% teal glow
  static const Color glowTertiary = Color(0x66ADC6FF); // 40% azure glow

  // Brand Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF4EDEA3), Color(0xFF29A195)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xCC171F33), Color(0x990B1326)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient azureGradient = LinearGradient(
    colors: [Color(0xFFADC6FF), Color(0xFF71A1FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
