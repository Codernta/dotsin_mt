import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/health_colors.dart';
import '../../../../core/theme/health_typography.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/glowing_gauge.dart';
import '../../../../core/widgets/live_ecg_painter.dart';
import '../../../../core/widgets/mesh_background.dart';
import '../../data/repositories/organ_detail_repository.dart';
import '../../domain/entities/organ_detail.dart';
import '../bloc/organ_detail_bloc.dart';

class OrganDetailScreen extends StatelessWidget {
  final String organId;

  const OrganDetailScreen({super.key, required this.organId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OrganDetailBloc(
        repository: OrganDetailRepositoryImpl(),
      )..add(LoadOrganDetailEvent(organId)),
      child: const _OrganDetailView(),
    );
  }
}

class _OrganDetailView extends StatelessWidget {
  const _OrganDetailView();

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
          title: BlocBuilder<OrganDetailBloc, OrganDetailState>(
            builder: (context, state) {
              if (state is OrganDetailLoaded) {
                return Text(
                  state.detail.title,
                  style: HealthTypography.headlineSmall(color: HealthColors.onSurface),
                );
              }
              return const Text('Diagnostics');
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.share_outlined, color: HealthColors.onSurfaceVariant),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: HealthColors.surfaceContainerHigh,
                    content: Text(
                      'Exporting FHIR biometric data record...',
                      style: HealthTypography.bodyMedium(color: HealthColors.primary),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<OrganDetailBloc, OrganDetailState>(
          builder: (context, state) {
            if (state is OrganDetailLoading || state is OrganDetailInitial) {
              return const Center(
                child: CircularProgressIndicator(color: HealthColors.primary),
              );
            }
            if (state is OrganDetailError) {
              return Center(
                child: Text(state.message, style: const TextStyle(color: HealthColors.error)),
              );
            }
            if (state is OrganDetailLoaded) {
              return _buildDetailContent(context, state.detail);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildDetailContent(BuildContext context, OrganDetailData detail) {
    final isLungs = detail.id == 'lungs';
    final primaryGlowColor = isLungs ? HealthColors.secondary : HealthColors.primary;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      children: [
        // Main Hero Score Card
        Center(
          child: GlassCard(
            borderRadius: 28,
            padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
            glowColor: primaryGlowColor,
            child: Column(
              children: [
                GlowingGauge(
                  score: detail.overallScore.toDouble(),
                  size: 210,
                  strokeWidth: 9,
                  title: 'Overall Score',
                  scoreSuffix: '/100',
                  statusText: detail.statusLabel,
                  primaryColor: primaryGlowColor,
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: primaryGlowColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: primaryGlowColor.withOpacity(0.35),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        detail.overallScore >= 80 ? Icons.check_circle_rounded : Icons.info_outline_rounded,
                        size: 15,
                        color: primaryGlowColor,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        detail.statusLabel,
                        style: HealthTypography.labelCaps(
                          color: primaryGlowColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(duration: 400.ms).scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1)),

        const SizedBox(height: 20),

        // Live Biometric Telemetry Scanner Card
        GlassCard(
          borderRadius: 20,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: HealthColors.error,
                          boxShadow: [
                            BoxShadow(
                              color: HealthColors.error.withOpacity(0.8),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'LIVE BIO-TELEMETRY SCANNER',
                        style: HealthTypography.labelCaps(
                          color: HealthColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Real-Time 60Hz',
                    style: HealthTypography.labelCaps(
                      color: primaryGlowColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  color: HealthColors.surfaceContainerLowest.withOpacity(0.6),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: LiveEcgWaveform(
                    height: 75,
                    bpm: detail.id == 'heart' ? 64 : 72,
                    waveformColor: primaryGlowColor,
                  ),
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 150.ms),

        const SizedBox(height: 20),

        // Biometrics Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.25,
          ),
          itemCount: detail.metrics.length,
          itemBuilder: (context, index) {
            final m = detail.metrics[index];
            return GlassCard(
              borderRadius: 18,
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        m.title,
                        style: HealthTypography.bodyMedium(
                          color: HealthColors.onSurfaceVariant,
                        ),
                      ),
                      Icon(
                        _getMetricIcon(m.iconName),
                        size: 16,
                        color: m.isOptimal ? HealthColors.secondary : HealthColors.amber,
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        m.value,
                        style: HealthTypography.headlineMedium(
                          color: HealthColors.onSurface,
                        ),
                      ),
                      if (m.unit.isNotEmpty) ...[
                        const SizedBox(width: 3),
                        Text(
                          m.unit,
                          style: const TextStyle(
                            fontSize: 11,
                            color: HealthColors.outline,
                          ),
                        ),
                      ],
                    ],
                  ),
                  Text(
                    m.changeText,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: m.isOptimal
                          ? HealthColors.primary
                          : HealthColors.amber,
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: (200 + index * 50).ms);
          },
        ),

        const SizedBox(height: 24),

        // 7-Day Trend Chart
        GlassCard(
          borderRadius: 24,
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                detail.trendTitle,
                style: HealthTypography.headlineSmall(
                  color: HealthColors.onSurface,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 140,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      getDrawingHorizontalLine: (value) => FlLine(
                        color: HealthColors.glassBorder,
                        strokeWidth: 0.8,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 22,
                          interval: 1,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index >= 0 && index < detail.sevenDayTrend.length) {
                              return Text(
                                detail.sevenDayTrend[index].dayLabel,
                                style: HealthTypography.labelCaps(
                                  color: HealthColors.onSurfaceVariant,
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: List.generate(
                          detail.sevenDayTrend.length,
                          (i) => FlSpot(i.toDouble(), detail.sevenDayTrend[i].value),
                        ),
                        isCurved: true,
                        curveSmoothness: 0.35,
                        color: primaryGlowColor,
                        barWidth: 2.5,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              primaryGlowColor.withOpacity(0.25),
                              primaryGlowColor.withOpacity(0.0),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 350.ms),

        const SizedBox(height: 20),

        // Clinical Conditions & Diagnostics (Stitch Feature)
        if (detail.conditions.isNotEmpty) ...[
          Text(
            'Clinical Status & Conditions',
            style: HealthTypography.headlineSmall(color: HealthColors.onSurface),
          ),
          const SizedBox(height: 12),
          ...detail.conditions.map(
            (cond) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GlassCard(
                borderRadius: 18,
                padding: const EdgeInsets.all(16),
                borderColor: cond.isWarning
                    ? HealthColors.amber.withOpacity(0.4)
                    : HealthColors.glassBorder,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      cond.isWarning ? Icons.warning_amber_rounded : Icons.check_circle_outline_rounded,
                      color: cond.isWarning ? HealthColors.amber : HealthColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
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
                                    .copyWith(fontWeight: FontWeight.w600),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: (cond.isWarning ? HealthColors.amber : HealthColors.primary).withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  cond.status,
                                  style: HealthTypography.labelCaps(
                                    color: cond.isWarning ? HealthColors.amber : HealthColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            cond.note,
                            style: HealthTypography.bodyMedium(color: HealthColors.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
        ],

        // Clinical Recommendations
        if (detail.recommendations.isNotEmpty) ...[
          Text(
            'Clinical Recommendations',
            style: HealthTypography.headlineSmall(color: HealthColors.onSurface),
          ),
          const SizedBox(height: 12),
          GlassCard(
            borderRadius: 20,
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: detail.recommendations.map(
                (rec) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.arrow_right_rounded, color: HealthColors.primary, size: 20),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          rec,
                          style: HealthTypography.bodyMedium(color: HealthColors.onSurfaceVariant),
                        ),
                      ),
                    ],
                  ),
                ),
              ).toList(),
            ),
          ),
          const SizedBox(height: 20),
        ],

        // Key Strengths & Biomarkers (Stitch Feature)
        if (detail.strengths.isNotEmpty) ...[
          Text(
            'Strengths & Laboratory Markers',
            style: HealthTypography.headlineSmall(color: HealthColors.onSurface),
          ),
          const SizedBox(height: 12),
          GlassCard(
            borderRadius: 20,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: detail.strengths.map(
                (s) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        s.name,
                        style: HealthTypography.bodyMedium(color: HealthColors.onSurface),
                      ),
                      Row(
                        children: [
                          Text(
                            s.value,
                            style: HealthTypography.bodyMedium(color: HealthColors.primary)
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '(${s.status})',
                            style: const TextStyle(fontSize: 11, color: HealthColors.outline),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ).toList(),
            ),
          ),
          const SizedBox(height: 20),
        ],

        // Clinical AI Interpretation
        GlassCard(
          borderRadius: 20,
          padding: const EdgeInsets.all(18),
          borderColor: HealthColors.secondary.withOpacity(0.35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.lightbulb_rounded,
                    color: HealthColors.secondary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'What This Means',
                    style: HealthTypography.headlineSmall(
                      color: HealthColors.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                detail.clinicalMeaning,
                style: HealthTypography.bodyLarge(
                  color: HealthColors.onSurfaceVariant,
                ).copyWith(height: 1.5),
              ),
            ],
          ),
        ).animate().fadeIn(delay: 400.ms),

        // Associated Gene Markers
        if (detail.geneMarkers.isNotEmpty) ...[
          const SizedBox(height: 20),
          Row(
            children: [
              Text(
                'Associated Genes: ',
                style: HealthTypography.labelCaps(
                  color: HealthColors.onSurfaceVariant,
                ),
              ),
              ...detail.geneMarkers.map(
                (gene) => Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: Chip(
                    label: Text(gene, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                    backgroundColor: HealthColors.surfaceContainerHigh,
                    side: const BorderSide(color: HealthColors.glassBorder),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                  ),
                ),
              ),
            ],
          ),
        ],

        const SizedBox(height: 40),
      ],
    );
  }

  IconData _getMetricIcon(String name) {
    switch (name) {
      case 'favorite':
        return Icons.favorite_rounded;
      case 'monitor_heart':
        return Icons.monitor_heart_rounded;
      case 'bloodtype':
        return Icons.bloodtype_rounded;
      case 'air':
        return Icons.air_rounded;
      case 'local_dining':
        return Icons.local_dining_rounded;
      case 'shield':
        return Icons.shield_rounded;
      case 'biotech':
        return Icons.biotech_rounded;
      case 'pulmonology':
        return Icons.air_rounded;
      case 'trending_down':
        return Icons.trending_down_rounded;
      default:
        return Icons.check_circle_rounded;
    }
  }
}
