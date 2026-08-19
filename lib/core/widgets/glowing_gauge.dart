import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/health_colors.dart';
import '../theme/health_typography.dart';

/// Glowing Biometric Score Gauge (Stitch Design Specification)
class GlowingGauge extends StatefulWidget {
  final double score; // 0 to 100
  final double size;
  final double strokeWidth;
  final Color primaryColor;
  final Color trackColor;
  final String title;
  final String statusText;
  final String? trendText;
  final String scoreSuffix;
  final bool isPositiveTrend;
  final Widget? centerChild;
  final bool showGlow;

  const GlowingGauge({
    super.key,
    required this.score,
    this.size = 220,
    this.strokeWidth = 10,
    this.primaryColor = HealthColors.primary,
    this.trackColor = HealthColors.surfaceVariant,
    this.title = 'Overall Health',
    this.statusText = 'Good',
    this.trendText = '+4%',
    this.scoreSuffix = '',
    this.isPositiveTrend = true,
    this.centerChild,
    this.showGlow = true,
  });

  @override
  State<GlowingGauge> createState() => _GlowingGaugeState();
}

class _GlowingGaugeState extends State<GlowingGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _animation = Tween<double>(begin: 0, end: widget.score / 100).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(GlowingGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.score != widget.score) {
      _animation = Tween<double>(
        begin: _animation.value,
        end: widget.score / 100,
      ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
      );
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final currentScore = (_animation.value * 100).round();
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer Ambient Glow
              if (widget.showGlow)
                Container(
                  width: widget.size * 0.75,
                  height: widget.size * 0.75,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: widget.primaryColor.withOpacity(0.25),
                        blurRadius: 36,
                        spreadRadius: 6,
                      ),
                    ],
                  ),
                ),

              // Custom Painter for circular track and arc progress
              CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _GaugePainter(
                  progress: _animation.value,
                  strokeWidth: widget.strokeWidth,
                  primaryColor: widget.primaryColor,
                  trackColor: widget.trackColor,
                ),
              ),

              // Center Content
              if (widget.centerChild != null)
                widget.centerChild!
              else
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.title.isNotEmpty) ...[
                      Text(
                        widget.title.toUpperCase(),
                        style: HealthTypography.labelCaps(
                          color: HealthColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 2),
                    ],
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '$currentScore',
                          style: widget.size < 200
                              ? HealthTypography.scoreDisplayMobile(
                                  color: widget.primaryColor,
                                )
                              : HealthTypography.scoreDisplay(
                                  color: widget.primaryColor,
                                ),
                        ),
                        if (widget.scoreSuffix.isNotEmpty) ...[
                          const SizedBox(width: 2),
                          Text(
                            widget.scoreSuffix,
                            style: HealthTypography.headlineSmall(
                              color: HealthColors.onSurfaceVariant.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (widget.trendText != null && widget.trendText!.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: widget.primaryColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: widget.primaryColor.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              widget.isPositiveTrend
                                  ? Icons.arrow_upward_rounded
                                  : Icons.arrow_downward_rounded,
                              size: 13,
                              color: widget.primaryColor,
                            ),
                            const SizedBox(width: 3),
                            Text(
                              widget.trendText!,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: widget.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color primaryColor;
  final Color trackColor;

  _GaugePainter({
    required this.progress,
    required this.strokeWidth,
    required this.primaryColor,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Track Paint
    final trackPaint = Paint()
      ..color = trackColor.withOpacity(0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    if (progress <= 0) return;

    // Progress Paint with Gradient
    final rect = Rect.fromCircle(center: center, radius: radius);
    final sweepGradient = SweepGradient(
      startAngle: -math.pi / 2,
      endAngle: 3 * math.pi / 2,
      colors: [
        primaryColor.withOpacity(0.7),
        primaryColor,
        HealthColors.secondary,
      ],
      stops: const [0.0, 0.6, 1.0],
      transform: const GradientRotation(-math.pi / 2),
    );

    final progressPaint = Paint()
      ..shader = sweepGradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * progress.clamp(0.0, 1.0);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Start at 12 o'clock
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_GaugePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.trackColor != trackColor;
  }
}
