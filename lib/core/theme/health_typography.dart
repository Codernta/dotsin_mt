import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'health_colors.dart';

/// Health Data Hub Typography Styles
class HealthTypography {
  HealthTypography._();

  /// Large Health Score Display (48px / 800)
  static TextStyle scoreDisplay({Color color = HealthColors.primary}) {
    return GoogleFonts.manrope(
      fontSize: 48,
      fontWeight: FontWeight.w800,
      height: 56 / 48,
      letterSpacing: -0.02 * 48,
      color: color,
    );
  }

  /// Mobile Health Score Display (40px / 800)
  static TextStyle scoreDisplayMobile({Color color = HealthColors.primary}) {
    return GoogleFonts.manrope(
      fontSize: 40,
      fontWeight: FontWeight.w800,
      height: 48 / 40,
      letterSpacing: -0.02 * 40,
      color: color,
    );
  }

  /// Headline Large (32px / 700)
  static TextStyle headlineLarge({Color color = HealthColors.onBackground}) {
    return GoogleFonts.manrope(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      height: 40 / 32,
      letterSpacing: -0.02 * 32,
      color: color,
    );
  }

  /// Headline Medium (24px / 600)
  static TextStyle headlineMedium({Color color = HealthColors.onBackground}) {
    return GoogleFonts.manrope(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      height: 32 / 24,
      color: color,
    );
  }

  /// Headline Small (18px / 600)
  static TextStyle headlineSmall({Color color = HealthColors.onBackground}) {
    return GoogleFonts.manrope(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      height: 24 / 18,
      color: color,
    );
  }

  /// Body Large (16px / 400)
  static TextStyle bodyLarge({Color color = HealthColors.onSurfaceVariant}) {
    return GoogleFonts.manrope(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 24 / 16,
      color: color,
    );
  }

  /// Body Medium (14px / 400)
  static TextStyle bodyMedium({Color color = HealthColors.onSurfaceVariant}) {
    return GoogleFonts.manrope(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 20 / 14,
      color: color,
    );
  }

  /// Space Grotesk High-Tech Caps & Badges (12px / 600)
  static TextStyle labelCaps({Color color = HealthColors.onSurfaceVariant}) {
    return GoogleFonts.spaceGrotesk(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      height: 16 / 12,
      letterSpacing: 0.08 * 12,
      color: color,
    );
  }

  /// Space Grotesk Telemetry Monospace (14px / 600)
  static TextStyle telemetryValue({Color color = HealthColors.onSurface}) {
    return GoogleFonts.spaceGrotesk(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      height: 18 / 14,
      letterSpacing: 0.04 * 14,
      color: color,
    );
  }
}
