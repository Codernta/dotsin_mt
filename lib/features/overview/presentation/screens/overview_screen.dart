import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/health_colors.dart';
import '../../../../core/theme/health_typography.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/glowing_gauge.dart';
import '../../../../core/widgets/mesh_background.dart';
import '../../../organ_detail/presentation/screens/organ_detail_screen.dart';
import '../../../sensor_hub/presentation/bloc/sensors_bloc.dart';
import '../bloc/overview_bloc.dart';

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MeshBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: _buildTopAppBar(context),
        body: RefreshIndicator(
          color: HealthColors.primary,
          backgroundColor: HealthColors.surfaceContainerHigh,
          onRefresh: () async {
            context.read<OverviewBloc>().add(RefreshOverviewEvent());
          },
          child: BlocBuilder<OverviewBloc, OverviewState>(
            builder: (context, state) {
              if (state is OverviewLoading || state is OverviewInitial) {
                return const Center(
                  child: CircularProgressIndicator(color: HealthColors.primary),
                );
              }
              if (state is OverviewError) {
                return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: HealthColors.error),
                  ),
                );
              }
              if (state is OverviewLoaded) {
                return _buildDashboardContent(context, state);
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildTopAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(70),
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: HealthColors.surface.withOpacity(0.75),
            border: const Border(
              bottom: BorderSide(color: HealthColors.glassBorder, width: 1),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: HealthColors.primary.withOpacity(0.4),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: HealthColors.primary.withOpacity(0.2),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Container(
                        color: HealthColors.surfaceContainerHigh,
                        child: const Icon(
                          Icons.person_rounded,
                          color: HealthColors.primary,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Health Data Hub',
                        style: HealthTypography.headlineSmall(
                          color: HealthColors.primary,
                        ),
                      ),
                      BlocBuilder<SensorsBloc, SensorsState>(
                        builder: (context, sensorState) {
                          final activity = sensorState is SensorsActive
                              ? sensorState.data.activityState
                              : 'Connected';
                          final steps = sensorState is SensorsActive
                              ? sensorState.data.todaySteps
                              : 6420;

                          return Row(
                            children: [
                              Container(
                                width: 7,
                                height: 7,
                                decoration: const BoxDecoration(
                                  color: HealthColors.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '$activity • $steps steps',
                                style: HealthTypography.labelCaps(
                                  color: HealthColors.onSurfaceVariant,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              GlassCard(
                borderRadius: 24,
                padding: const EdgeInsets.all(8),
                backgroundColor: HealthColors.surfaceContainer.withOpacity(0.5),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: HealthColors.surfaceContainerHigh,
                      content: Text(
                        'Sensors streaming at 60Hz. All vitals nominal.',
                        style: HealthTypography.bodyMedium(color: HealthColors.primary),
                      ),
                    ),
                  );
                },
                child: const Icon(
                  Icons.notifications_none_rounded,
                  color: HealthColors.onSurfaceVariant,
                  size: 22,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardContent(BuildContext context, OverviewLoaded state) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      children: [
        // Greeting
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good morning, Alex',
              style: HealthTypography.headlineLarge(color: HealthColors.onSurface),
            ),
            const SizedBox(height: 4),
            Text(
              "Here's your bio-telemetry summary for today.",
              style: HealthTypography.bodyLarge(color: HealthColors.onSurfaceVariant),
            ),
          ],
        ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),

        const SizedBox(height: 28),

        // Hero Gauge Card
        Center(
          child: GlassCard(
            borderRadius: 28,
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            child: Column(
              children: [
                GlowingGauge(
                  score: state.data.overallScore.toDouble(),
                  size: 240,
                  strokeWidth: 10,
                  primaryColor: HealthColors.primary,
                  title: 'Overall Health',
                  statusText: state.data.status,
                  trendText: state.data.trendPercentage,
                  isPositiveTrend: state.data.isTrendPositive,
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  decoration: BoxDecoration(
                    color: HealthColors.surfaceContainerHigh.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: HealthColors.glassBorder),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: HealthColors.primary,
                          boxShadow: [
                            BoxShadow(
                              color: HealthColors.primary.withOpacity(0.8),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Status: ',
                        style: HealthTypography.bodyMedium(
                          color: HealthColors.onSurfaceVariant,
                        ),
                      ),
                      Text(
                        state.data.status,
                        style: HealthTypography.bodyMedium(
                          color: HealthColors.primary,
                        ).copyWith(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(delay: 150.ms, duration: 500.ms).scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1)),

        const SizedBox(height: 28),

        // Live Sensors Ticker Pill
        BlocBuilder<SensorsBloc, SensorsState>(
          builder: (context, sensorState) {
            if (sensorState is! SensorsActive) return const SizedBox.shrink();
            final s = sensorState.data;

            return GlassCard(
              borderRadius: 20,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              backgroundColor: HealthColors.surfaceContainerHigh.withOpacity(0.4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildSensorMetricItem(
                    icon: Icons.monitor_heart_rounded,
                    color: HealthColors.error,
                    value: '${s.liveBpm}',
                    unit: 'bpm',
                    label: 'Live HR',
                  ),
                  _buildDivider(),
                  _buildSensorMetricItem(
                    icon: Icons.speed_rounded,
                    color: HealthColors.secondary,
                    value: '${s.liveHrv}',
                    unit: 'ms',
                    label: 'HRV',
                  ),
                  _buildDivider(),
                  _buildSensorMetricItem(
                    icon: Icons.directions_walk_rounded,
                    color: HealthColors.primary,
                    value: '${s.todaySteps}',
                    unit: 'steps',
                    label: 'Today',
                  ),
                  _buildDivider(),
                  _buildSensorMetricItem(
                    icon: Icons.battery_charging_full_rounded,
                    color: HealthColors.tertiary,
                    value: '${s.batteryLevel}',
                    unit: '%',
                    label: 'Device',
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 250.ms);
          },
        ),

        const SizedBox(height: 32),

        // Section Title: Your Health
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Your Health',
              style: HealthTypography.headlineMedium(color: HealthColors.onSurface),
            ),
            Text(
              'Tap for diagnostics',
              style: HealthTypography.labelCaps(color: HealthColors.outline),
            ),
          ],
        ).animate().fadeIn(delay: 300.ms),

        const SizedBox(height: 16),

        // Bento Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 1.05,
          ),
          itemCount: state.data.metrics.length,
          itemBuilder: (context, index) {
            final metric = state.data.metrics[index];
            return _buildBentoCard(context, metric, index);
          },
        ),

        const SizedBox(height: 80), // Padding for floating bottom bar
      ],
    );
  }

  Widget _buildSensorMetricItem({
    required IconData icon,
    required Color color,
    required String value,
    required String unit,
    required String label,
  }) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(width: 2),
            Text(
              unit,
              style: const TextStyle(fontSize: 10, color: HealthColors.outline),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: HealthTypography.labelCaps(color: HealthColors.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 24,
      color: HealthColors.glassBorder,
    );
  }

  Widget _buildBentoCard(BuildContext context, dynamic metric, int index) {
    IconData iconData;
    Color iconColor;

    switch (metric.id) {
      case 'heart':
        iconData = Icons.favorite_rounded;
        iconColor = HealthColors.error;
        break;
      case 'lungs':
        iconData = Icons.air_rounded;
        iconColor = HealthColors.secondary;
        break;
      case 'blood':
        iconData = Icons.water_drop_rounded;
        iconColor = HealthColors.secondary;
        break;
      case 'fitness':
        iconData = Icons.directions_run_rounded;
        iconColor = HealthColors.primary;
        break;
      case 'metabolic':
        iconData = Icons.local_dining_rounded;
        iconColor = HealthColors.tertiary;
        break;
      case 'genomic':
      default:
        iconData = Icons.biotech_rounded;
        iconColor = HealthColors.primary;
        break;
    }

    return GlassCard(
      borderRadius: 20,
      padding: const EdgeInsets.all(16),
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                OrganDetailScreen(organId: metric.id),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.04, 0.0),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.easeOutCubic,
                    ),
                  ),
                  child: child,
                ),
              );
            },
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: iconColor.withOpacity(0.25),
                    width: 1,
                  ),
                ),
                child: Icon(iconData, color: iconColor, size: 20),
              ),
              Row(
                children: [
                  Text(
                    metric.value,
                    style: HealthTypography.headlineSmall(
                      color: HealthColors.onSurface,
                    ),
                  ),
                  if (metric.unit.isNotEmpty) ...[
                    const SizedBox(width: 2),
                    Text(
                      metric.unit,
                      style: const TextStyle(
                        fontSize: 11,
                        color: HealthColors.outline,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),

          // Title & Progress
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                metric.title,
                style: HealthTypography.bodyMedium(color: HealthColors.onSurface)
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (metric.score / 100).clamp(0.0, 1.0),
                  minHeight: 4,
                  backgroundColor: HealthColors.surfaceVariant.withOpacity(0.6),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    metric.isOptimal ? iconColor : HealthColors.amber,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    metric.status,
                    style: const TextStyle(
                      fontSize: 10,
                      color: HealthColors.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    metric.trend,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: metric.isOptimal
                          ? HealthColors.primary
                          : HealthColors.amber,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: (200 + index * 60).ms).slideY(begin: 0.15, end: 0);
  }
}
