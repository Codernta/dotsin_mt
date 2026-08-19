import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/health_colors.dart';

/// Atmospheric Dark Mesh Background with Organic Breathing Glows
class MeshBackground extends StatefulWidget {
  final Widget child;
  final bool enableAnimation;

  const MeshBackground({
    super.key,
    required this.child,
    this.enableAnimation = true,
  });

  @override
  State<MeshBackground> createState() => _MeshBackgroundState();
}

class _MeshBackgroundState extends State<MeshBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    );
    if (widget.enableAnimation) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base dark obsidian layer
        Container(
          width: double.infinity,
          height: double.infinity,
          color: HealthColors.background,
        ),

        // Animated Bio-Atmosphere Radial Gradients
        if (widget.enableAnimation)
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final t = _controller.value;
              final topOffset = math.sin(t * math.pi) * 0.15;
              final rightOffset = math.cos(t * math.pi) * 0.15;

              return Stack(
                children: [
                  // Top Right Luminous Teal Glow
                  Positioned(
                    top: -120 + (topOffset * 100),
                    right: -100 + (rightOffset * 80),
                    child: Container(
                      width: 450,
                      height: 450,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            HealthColors.primary.withOpacity(0.09),
                            HealthColors.secondary.withOpacity(0.04),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.45, 1.0],
                        ),
                      ),
                    ),
                  ),

                  // Bottom Left Bio-Azure Glow
                  Positioned(
                    bottom: -150 - (topOffset * 60),
                    left: -120 - (rightOffset * 60),
                    child: Container(
                      width: 500,
                      height: 500,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            HealthColors.tertiary.withOpacity(0.06),
                            HealthColors.surfaceContainerHigh.withOpacity(0.04),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          )
        else
          Stack(
            children: [
              Positioned(
                top: -80,
                right: -80,
                child: Container(
                  width: 400,
                  height: 400,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        HealthColors.primary.withOpacity(0.08),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

        // Foreground content
        widget.child,
      ],
    );
  }
}
