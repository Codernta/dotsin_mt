import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/health_colors.dart';

/// Premium Glassmorphic Card Container
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final double blurSigma;
  final VoidCallback? onTap;
  final BoxBorder? customBorder;
  final List<BoxShadow>? shadows;
  final Color? glowColor;
  final double glowRadius;
  final Gradient? gradient;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.borderRadius = 16,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.blurSigma = 16.0,
    this.onTap,
    this.customBorder,
    this.shadows,
    this.glowColor,
    this.glowRadius = 15.0,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    Widget cardContent = Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? HealthColors.surfaceContainer.withOpacity(0.65),
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius),
        border: customBorder ??
            Border.all(
              color: borderColor ?? HealthColors.glassBorder,
              width: borderWidth,
            ),
        boxShadow: shadows ??
            [
              if (glowColor != null)
                BoxShadow(
                  color: glowColor!.withOpacity(0.25),
                  blurRadius: glowRadius,
                  spreadRadius: -2,
                ),
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
      ),
      child: child,
    );

    if (blurSigma > 0) {
      cardContent = ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: cardContent,
        ),
      );
    }

    if (margin != null) {
      cardContent = Padding(padding: margin!, child: cardContent);
    }

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          splashColor: HealthColors.primary.withOpacity(0.1),
          highlightColor: HealthColors.primary.withOpacity(0.05),
          child: cardContent,
        ),
      );
    }

    return cardContent;
  }
}
