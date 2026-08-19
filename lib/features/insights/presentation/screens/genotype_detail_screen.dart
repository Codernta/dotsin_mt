import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/health_colors.dart';
import '../../../../core/theme/health_typography.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/glowing_gauge.dart';
import '../../../../core/widgets/mesh_background.dart';
import '../../domain/entities/insight_item.dart';

class GenotypeDetailScreen extends StatelessWidget {
  final GeneMarkerDetail gene;

  const GenotypeDetailScreen({super.key, required this.gene});

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
            gene.geneName,
            style: HealthTypography.headlineSmall(color: HealthColors.onSurface),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.biotech_rounded, color: HealthColors.primary),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: HealthColors.surfaceContainerHigh,
                    content: Text(
                      'Accessing NCBI GenBank alignment database...',
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
            // Gene Title Subheading
            Text(
              gene.subtitle,
              style: HealthTypography.bodyLarge(color: HealthColors.onSurfaceVariant),
            ).animate().fadeIn(duration: 300.ms),

            const SizedBox(height: 20),

            // Hero Genotype Score Card
            Center(
              child: GlassCard(
                borderRadius: 28,
                padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
                glowColor: HealthColors.primary,
                child: Column(
                  children: [
                    GlowingGauge(
                      score: gene.score.toDouble(),
                      size: 210,
                      strokeWidth: 9,
                      title: 'Genotype Score',
                      scoreSuffix: '%',
                      statusText: gene.efficiencyStatus,
                      primaryColor: HealthColors.primary,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: HealthColors.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: HealthColors.primary.withOpacity(0.35),
                        ),
                      ),
                      child: Text(
                        gene.efficiencyStatus,
                        style: HealthTypography.labelCaps(
                          color: HealthColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ).animate().fadeIn(delay: 100.ms, duration: 400.ms).scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1)),

            const SizedBox(height: 24),

            // Functional Genetic Overview
            GlassCard(
              borderRadius: 22,
              padding: const EdgeInsets.all(18),
              borderColor: HealthColors.secondary.withOpacity(0.35),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.biotech_rounded, color: HealthColors.secondary, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Gene Function & Phenotypic Expression',
                        style: HealthTypography.headlineSmall(color: HealthColors.onSurface),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    gene.description,
                    style: HealthTypography.bodyLarge(
                      color: HealthColors.onSurfaceVariant,
                    ).copyWith(height: 1.55),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 200.ms),

            const SizedBox(height: 20),

            // Clinical Impact Card
            GlassCard(
              borderRadius: 22,
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.psychology_rounded, color: HealthColors.primary, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Neurobiology & Training Adaptation',
                        style: HealthTypography.headlineSmall(color: HealthColors.onSurface),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    gene.clinicalImpact,
                    style: HealthTypography.bodyMedium(
                      color: HealthColors.onSurfaceVariant,
                    ).copyWith(height: 1.5),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 280.ms),

            const SizedBox(height: 20),

            // Epigenetic & Lifestyle Recommendations
            Text(
              'Epigenetic Optimization Protocols',
              style: HealthTypography.headlineSmall(color: HealthColors.onSurface),
            ).animate().fadeIn(delay: 350.ms),
            const SizedBox(height: 12),

            GlassCard(
              borderRadius: 22,
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: gene.recommendations.map(
                  (rec) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle_outline_rounded, color: HealthColors.primary, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            rec,
                            style: HealthTypography.bodyMedium(color: HealthColors.onSurfaceVariant)
                                .copyWith(height: 1.45),
                          ),
                        ),
                      ],
                    ),
                  ),
                ).toList(),
              ),
            ).animate().fadeIn(delay: 380.ms),

            const SizedBox(height: 20),

            // Impacted Systems Chips
            Row(
              children: [
                Text(
                  'Impacted Pathways: ',
                  style: HealthTypography.labelCaps(color: HealthColors.onSurfaceVariant),
                ),
                ...gene.impactedSystems.map(
                  (sys) => Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Chip(
                      label: Text(sys, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                      backgroundColor: HealthColors.surfaceContainerHigh,
                      side: const BorderSide(color: HealthColors.glassBorder),
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                    ),
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 450.ms),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
