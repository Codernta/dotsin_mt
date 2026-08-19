import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/health_colors.dart';
import '../../../../core/theme/health_typography.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/glowing_gauge.dart';
import '../../../../core/widgets/mesh_background.dart';
import '../../domain/entities/insight_item.dart';
import '../bloc/insights_bloc.dart';
import 'genotype_detail_screen.dart';
import 'mentzer_metric_detail_screen.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MeshBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            'Genomic & Phenotypic Insights',
            style: HealthTypography.headlineSmall(color: HealthColors.primary),
          ),
          centerTitle: false,
        ),
        body: BlocBuilder<InsightsBloc, InsightsState>(
          builder: (context, state) {
            if (state is InsightsLoading || state is InsightsInitial) {
              return const Center(
                child: CircularProgressIndicator(color: HealthColors.primary),
              );
            }
            if (state is InsightsError) {
              return Center(
                child: Text(state.message, style: const TextStyle(color: HealthColors.error)),
              );
            }
            if (state is InsightsLoaded) {
              return _buildInsightsContent(context, state);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildInsightsContent(BuildContext context, InsightsLoaded state) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      children: [
        // Mode Switcher (Genotype vs Phenotype)
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: HealthColors.surfaceContainerHigh.withOpacity(0.7),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: HealthColors.glassBorder),
          ),
          child: Row(
            children: [
              Expanded(
                child: _buildModeTabButton(
                  context: context,
                  title: 'Genotype',
                  icon: Icons.biotech_rounded,
                  isSelected: state.mode == InsightsMode.genotype,
                  onTap: () {
                    context.read<InsightsBloc>().add(
                          const SwitchInsightsModeEvent(InsightsMode.genotype),
                        );
                  },
                ),
              ),
              Expanded(
                child: _buildModeTabButton(
                  context: context,
                  title: 'Phenotype',
                  icon: Icons.accessibility_new_rounded,
                  isSelected: state.mode == InsightsMode.phenotype,
                  onTap: () {
                    context.read<InsightsBloc>().add(
                          const SwitchInsightsModeEvent(InsightsMode.phenotype),
                        );
                  },
                ),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 250.ms),

        const SizedBox(height: 20),

        if (state.mode == InsightsMode.genotype)
          _buildGenotypeView(context, state.genotype)
        else
          _buildPhenotypeView(context, state.phenotype),

        const SizedBox(height: 80), // Bottom nav bar clearance
      ],
    );
  }

  Widget _buildModeTabButton({
    required BuildContext context,
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(26),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? HealthColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(26),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: HealthColors.primary.withOpacity(0.35),
                    blurRadius: 10,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? HealthColors.onPrimary : HealthColors.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: isSelected ? HealthColors.onPrimary : HealthColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // GENOTYPE VIEW
  Widget _buildGenotypeView(BuildContext context, GenotypeData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Overall Genomic Hero Card
        Center(
          child: GlassCard(
            borderRadius: 28,
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
            glowColor: HealthColors.primary,
            child: Column(
              children: [
                GlowingGauge(
                  score: data.overallScore.toDouble(),
                  size: 210,
                  strokeWidth: 9,
                  title: 'Genomic Score',
                  scoreSuffix: '/100',
                  statusText: data.status,
                  primaryColor: HealthColors.primary,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: HealthColors.primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: HealthColors.primary.withOpacity(0.35)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle_rounded, size: 15, color: HealthColors.primary),
                      const SizedBox(width: 6),
                      Text(
                        data.status,
                        style: HealthTypography.labelCaps(color: HealthColors.primary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  data.summary,
                  textAlign: TextAlign.center,
                  style: HealthTypography.bodyMedium(color: HealthColors.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(duration: 350.ms),

        const SizedBox(height: 24),

        // Genetic Pillars (4 Cards)
        Text(
          'Genetic Adaptation Pillars',
          style: HealthTypography.headlineSmall(color: HealthColors.onSurface),
        ).animate().fadeIn(delay: 100.ms),
        const SizedBox(height: 12),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.15,
          ),
          itemCount: data.pillars.length,
          itemBuilder: (context, index) {
            final pillar = data.pillars[index];
            final color = _parseColor(pillar.colorHex);

            return GlassCard(
              borderRadius: 20,
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(_getIcon(pillar.iconName), color: color, size: 18),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          pillar.status,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pillar.title,
                        style: HealthTypography.bodyMedium(color: HealthColors.onSurface)
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        pillar.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 10, color: HealthColors.onSurfaceVariant),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ).animate().fadeIn(delay: 180.ms),

        const SizedBox(height: 24),

        // Interactive Gene Markers (SLC6A4, DRD4, COMT)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Gene-to-Health Profiles',
              style: HealthTypography.headlineSmall(color: HealthColors.onSurface),
            ),
            Text(
              'Tap for analysis',
              style: HealthTypography.labelCaps(color: HealthColors.outline),
            ),
          ],
        ).animate().fadeIn(delay: 250.ms),
        const SizedBox(height: 12),

        ...data.geneMarkers.map((gene) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GlassCard(
              borderRadius: 22,
              padding: const EdgeInsets.all(16),
              borderColor: HealthColors.primary.withOpacity(0.25),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => GenotypeDetailScreen(gene: gene),
                  ),
                );
              },
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: HealthColors.primary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: HealthColors.primary.withOpacity(0.3)),
                    ),
                    child: Center(
                      child: Text(
                        '${gene.score}%',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 13,
                          color: HealthColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              gene.geneName,
                              style: HealthTypography.headlineSmall(color: HealthColors.onSurface),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: HealthColors.surfaceContainerHigh,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                gene.efficiencyStatus,
                                style: const TextStyle(fontSize: 10, color: HealthColors.primary, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          gene.subtitle,
                          style: const TextStyle(fontSize: 11, color: HealthColors.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: HealthColors.outline),
                ],
              ),
            ),
          );
        }),

        const SizedBox(height: 16),

        // Genetic Strengths List
        Text(
          'Inherent Genetic Strengths',
          style: HealthTypography.headlineSmall(color: HealthColors.onSurface),
        ).animate().fadeIn(delay: 350.ms),
        const SizedBox(height: 12),

        GlassCard(
          borderRadius: 22,
          padding: const EdgeInsets.all(18),
          child: Column(
            children: data.geneticStrengths.map(
              (str) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.verified_rounded, color: HealthColors.primary, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        str,
                        style: HealthTypography.bodyMedium(color: HealthColors.onSurfaceVariant),
                      ),
                    ),
                  ],
                ),
              ),
            ).toList(),
          ),
        ).animate().fadeIn(delay: 400.ms),
      ],
    );
  }

  // PHENOTYPE VIEW
  Widget _buildPhenotypeView(BuildContext context, PhenotypeData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Health Conditions Overview
        Text(
          'Health Conditions & Recovery',
          style: HealthTypography.headlineSmall(color: HealthColors.onSurface),
        ).animate().fadeIn(duration: 300.ms),
        const SizedBox(height: 12),

        ...data.conditions.map(
          (cond) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GlassCard(
              borderRadius: 20,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: HealthColors.secondary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(_getIcon(cond.iconName), color: HealthColors.secondary, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              cond.title,
                              style: HealthTypography.bodyMedium(color: HealthColors.onSurface)
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${cond.score}%',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: HealthColors.primary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          cond.note,
                          style: const TextStyle(fontSize: 11, color: HealthColors.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Exertion / Dopamine Activation Curve Card
        Text(
          'Physical Activity Exertion Curve',
          style: HealthTypography.headlineSmall(color: HealthColors.onSurface),
        ).animate().fadeIn(delay: 200.ms),
        const SizedBox(height: 12),

        GlassCard(
          borderRadius: 24,
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Dopamine & Heart Rate Surge',
                    style: HealthTypography.bodyMedium(color: HealthColors.onSurface)
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Biometric Response',
                    style: HealthTypography.labelCaps(color: HealthColors.primary),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ...data.physicalActivityPhases.map(
                (phase) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: HealthColors.primary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 90,
                        child: Text(
                          phase.phaseName,
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: HealthColors.primary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          phase.dopamineLevel,
                          style: const TextStyle(fontSize: 10, color: HealthColors.primary, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        phase.heartRate,
                        style: const TextStyle(fontSize: 11, color: HealthColors.outline),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 250.ms),

        const SizedBox(height: 24),

        // Mentzer Metric Drilldown Card (Stitch Feature)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Diagnostic Indices',
              style: HealthTypography.headlineSmall(color: HealthColors.onSurface),
            ),
            Text(
              'Tap for full ladder',
              style: HealthTypography.labelCaps(color: HealthColors.outline),
            ),
          ],
        ).animate().fadeIn(delay: 300.ms),
        const SizedBox(height: 12),

        GlassCard(
          borderRadius: 22,
          padding: const EdgeInsets.all(18),
          glowColor: HealthColors.secondary,
          borderColor: HealthColors.secondary.withOpacity(0.35),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => MentzerMetricDetailScreen(metric: data.mentzerMetric),
              ),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.mentzerMetric.title,
                    style: HealthTypography.headlineSmall(color: HealthColors.onSurface),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '${data.mentzerMetric.value}',
                        style: HealthTypography.scoreDisplayMobile(color: HealthColors.primary),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        data.mentzerMetric.unit,
                        style: const TextStyle(fontSize: 12, color: HealthColors.outline),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data.mentzerMetric.status,
                    style: HealthTypography.labelCaps(color: HealthColors.primary),
                  ),
                ],
              ),
              const Icon(Icons.arrow_forward_ios_rounded, color: HealthColors.primary, size: 16),
            ],
          ),
        ).animate().fadeIn(delay: 350.ms),

        const SizedBox(height: 24),

        // Strengths & Improvements List
        Text(
          'Physiological Markers',
          style: HealthTypography.headlineSmall(color: HealthColors.onSurface),
        ).animate().fadeIn(delay: 400.ms),
        const SizedBox(height: 12),

        ...data.strengths.map((item) => _buildLegacyInsightCard(context, item, isStrength: true)),
        ...data.improvements.map((item) => _buildLegacyInsightCard(context, item, isStrength: false)),
      ],
    );
  }

  Widget _buildLegacyInsightCard(BuildContext context, InsightItem item, {required bool isStrength}) {
    final themeColor = isStrength ? HealthColors.primary : HealthColors.amber;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        borderRadius: 20,
        padding: const EdgeInsets.all(16),
        borderColor: themeColor.withOpacity(0.3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.title,
                  style: HealthTypography.bodyMedium(color: HealthColors.onSurface)
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: themeColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    item.tag,
                    style: TextStyle(fontSize: 10, color: themeColor, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              item.description,
              style: const TextStyle(fontSize: 12, color: HealthColors.onSurfaceVariant, height: 1.4),
            ),
          ],
        ),
      ),
    );
  }

  Color _parseColor(String hex) {
    final clean = hex.replaceAll('#', '');
    return Color(int.parse('FF$clean', radix: 16));
  }

  IconData _getIcon(String name) {
    switch (name) {
      case 'favorite':
        return Icons.favorite_rounded;
      case 'air':
        return Icons.air_rounded;
      case 'psychology':
        return Icons.psychology_rounded;
      case 'local_dining':
      case 'restaurant':
        return Icons.restaurant_rounded;
      case 'bolt':
        return Icons.bolt_rounded;
      case 'fitness_center':
        return Icons.fitness_center_rounded;
      case 'accessibility_new':
        return Icons.accessibility_new_rounded;
      case 'directions_walk':
        return Icons.directions_walk_rounded;
      default:
        return Icons.biotech_rounded;
    }
  }
}
