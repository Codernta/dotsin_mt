import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/health_colors.dart';

/// Animated Real-Time ECG / Bio-Waveform Visualizer
class LiveEcgWaveform extends StatefulWidget {
  final double height;
  final Color waveformColor;
  final int bpm;
  final bool isLive;

  const LiveEcgWaveform({
    super.key,
    this.height = 70,
    this.waveformColor = HealthColors.primary,
    this.bpm = 72,
    this.isLive = true,
  });

  @override
  State<LiveEcgWaveform> createState() => _LiveEcgWaveformState();
}

class _LiveEcgWaveformState extends State<LiveEcgWaveform>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: Size(double.infinity, widget.height),
          painter: _EcgPainter(
            animationValue: _controller.value,
            waveformColor: widget.waveformColor,
            bpm: widget.bpm,
          ),
        );
      },
    );
  }
}

class _EcgPainter extends CustomPainter {
  final double animationValue;
  final Color waveformColor;
  final int bpm;

  _EcgPainter({
    required this.animationValue,
    required this.waveformColor,
    required this.bpm,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final midY = h * 0.55;

    // Grid lines (subtle medical monitor grid)
    final gridPaint = Paint()
      ..color = HealthColors.surfaceVariant.withOpacity(0.25)
      ..strokeWidth = 0.5;

    for (double x = 0; x < w; x += 24) {
      canvas.drawLine(Offset(x, 0), Offset(x, h), gridPaint);
    }
    for (double y = 0; y < h; y += 18) {
      canvas.drawLine(Offset(0, y), Offset(w, y), gridPaint);
    }

    final path = Path();
    final glowPath = Path();

    // Generate ECG curve points across width
    final points = <Offset>[];
    const step = 2.0;

    for (double x = 0; x <= w; x += step) {
      // Calculate normalized phase
      final phase = (x / 140.0 - animationValue * (bpm / 30.0)) % 1.0;
      double yOffset = 0;

      // P wave (at phase ~0.2)
      if (phase >= 0.15 && phase < 0.25) {
        final p = (phase - 0.2) / 0.05;
        yOffset = -8 * math.exp(-p * p * 4);
      }
      // QRS Complex (at phase ~0.4)
      else if (phase >= 0.36 && phase < 0.46) {
        final p = (phase - 0.41);
        if (p < -0.02) {
          // Q dip
          yOffset = 4;
        } else if (p < 0.015) {
          // R spike
          final rProgress = (p + 0.02) / 0.035;
          yOffset = -h * 0.42 * math.sin(rProgress * math.pi);
        } else {
          // S dip
          yOffset = 6 * (1 - (p - 0.015) / 0.035);
        }
      }
      // T wave (at phase ~0.6)
      else if (phase >= 0.52 && phase < 0.70) {
        final p = (phase - 0.61) / 0.09;
        yOffset = -12 * math.exp(-p * p * 3);
      }

      // Add gentle baseline ripple
      yOffset += math.sin(x * 0.05 + animationValue * 4) * 1.5;

      points.add(Offset(x, (midY + yOffset).clamp(4.0, h - 4.0)));
    }

    if (points.isNotEmpty) {
      path.moveTo(points.first.dx, points.first.dy);
      glowPath.moveTo(points.first.dx, points.first.dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
        glowPath.lineTo(points[i].dx, points[i].dy);
      }
    }

    // Glow Trail Paint
    final glowPaint = Paint()
      ..color = waveformColor.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.5
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawPath(glowPath, glowPaint);

    // Sharp Foreground Wave Paint
    final linePaint = Paint()
      ..color = waveformColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, linePaint);

    // Scanner Head Particle
    final headX = (animationValue * w) % w;
    final headPoint = points.firstWhere(
      (p) => (p.dx - headX).abs() < step * 2,
      orElse: () => Offset(headX, midY),
    );

    final dotGlow = Paint()
      ..color = Colors.white
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(headPoint, 4, dotGlow);

    final dotPaint = Paint()..color = Colors.white;
    canvas.drawCircle(headPoint, 2.5, dotPaint);
  }

  @override
  bool shouldRepaint(_EcgPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.bpm != bpm ||
        oldDelegate.waveformColor != waveformColor;
  }
}
