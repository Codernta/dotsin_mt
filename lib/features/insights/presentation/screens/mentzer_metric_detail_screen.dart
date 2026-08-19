import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/health_colors.dart';
import '../../../../core/theme/health_typography.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/mesh_background.dart';
import '../../domain/entities/insight_item.dart';

class MentzerMetricDetailScreen extends StatelessWidget {
  final MentzerMetricData metric;

  const MentzerMetricDetailScreen({super.key, required this.metric});

  @override
  Widget build(BuildContext context) {
    return MeshBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: HealthColors.primary),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            metric.title,
            style: HealthTypography.headlineSmall(color: HealthColors.onSurface),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.analytics_outlined, color: HealthColors.primary),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: HealthColors.surfaceContainerHigh,
                    content: Text(
                      'Recalculating Mentzer Index (MCV / RBC count)...',
                      style: HealthTypography.bodyMedium(color: HealthColors.primary),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            // Hero Metric Banner Card
            GlassCard(
              borderRadius: 28,
              padding: const EdgeInsets.all(24),
              glowColor: HealthColors.primary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'CALCULATED BIOMARKER',
                        style: HealthTypography.labelCaps(color: HealthColors.primary),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: HealthColors.primary.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: HealthColors.primary.withOpacity(0.35)),
                        ),
                        child: Text(
                          metric.status,
                          style: HealthTypography.labelCaps(color: HealthColors.primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '${metric.value}',
                        style: HealthTypography.scoreDisplay(color: HealthColors.primary),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        metric.unit,
                        style: HealthTypography.headlineSmall(color: HealthColors.onSurfaceVariant),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    metric.interpretation,
                    style: HealthTypography.bodyMedium(color: HealthColors.onSurfaceVariant)
                        .copyWith(height: 1.5),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.08, end: 0),

            const SizedBox(height: 26),

            // Clinical Ranges Ladder
            Text(
              'Diagnostic Reference Ranges',
              style: HealthTypography.headlineSmall(color: HealthColors.onSurface),
            ).animate().fadeIn(delay: 150.ms),
            const SizedBox(height: 12),

            GlassCard(
              borderRadius: 24,
              padding: const EdgeInsets.all(18),
              child: Column(
                children: metric.ranges.map((r) {
                  final color = r.isCurrentRange
                      ? HealthColors.primary
                      : HealthColors.onSurfaceVariant.withOpacity(0.8);

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: r.isCurrentRange
                          ? HealthColors.primary.withOpacity(0.12)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                      border: r.isCurrentRange
                          ? Border.all(color: HealthColors.primary.withOpacity(0.4), width: 1.2)
                          : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: r.isCurrentRange
                                    ? HealthColors.primary
                                    : HealthColors.surfaceContainerHighest,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              r.label,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: r.isCurrentRange ? FontWeight.bold : FontWeight.w500,
                                color: color,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              r.rangeText,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: r.isCurrentRange ? FontWeight.bold : FontWeight.normal,
                                color: color,
                              ),
                            ),
                            if (r.isCurrentRange) ...[
                              const SizedBox(width: 8),
                              const Icon(Icons.check_circle_rounded, color: HealthColors.primary, size: 16),
                            ],
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ).animate().fadeIn(delay: 250.ms),

            const SizedBox(height: 26),

            // Parameters Generally Impacted
            Text(
              'Parameters Impacted by Index',
              style: HealthTypography.headlineSmall(color: HealthColors.onSurface),
            ).animate().fadeIn(delay: 320.ms),
            const SizedBox(height: 12),

            GlassCard(
              borderRadius: 22,
              padding: const EdgeInsets.all(18),
              borderColor: HealthColors.secondary.withOpacity(0.3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: metric.impactedParameters.map(
                  (param) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        const Icon(Icons.arrow_right_rounded, color: HealthColors.secondary, size: 20),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            param,
                            style: HealthTypography.bodyMedium(color: HealthColors.onSurfaceVariant),
                          ),
                        ),
                      ],
                    ),
                  ),
                ).toList(),
              ),
            ).animate().fadeIn(delay: 380.ms),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
