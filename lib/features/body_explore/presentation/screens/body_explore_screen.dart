import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/health_colors.dart';
import '../../../../core/theme/health_typography.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/mesh_background.dart';
import '../../../organ_detail/presentation/screens/organ_detail_screen.dart';
import '../../domain/entities/organ_node.dart';
import '../bloc/body_explore_bloc.dart';

class BodyExploreScreen extends StatelessWidget {
  const BodyExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MeshBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            'Explore Your Health',
            style: HealthTypography.headlineMedium(color: HealthColors.primary),
          ),
          centerTitle: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline_rounded, color: HealthColors.onSurfaceVariant),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: HealthColors.surfaceContainerHigh,
                    content: Text(
                      'Tap any organ node on the body to inspect clinical biomarkers.',
                      style: HealthTypography.bodyMedium(color: HealthColors.primary),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<BodyExploreBloc, BodyExploreState>(
          builder: (context, state) {
            if (state is BodyExploreLoading || state is BodyExploreInitial) {
              return const Center(
                child: CircularProgressIndicator(color: HealthColors.primary),
              );
            }
            if (state is BodyExploreError) {
              return Center(
                child: Text(state.message, style: const TextStyle(color: HealthColors.error)),
              );
            }
            if (state is BodyExploreLoaded) {
              return _buildBodyExploreContent(context, state);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildBodyExploreContent(BuildContext context, BodyExploreLoaded state) {
    return Column(
      children: [
        // Subtitle
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          child: Row(
            children: [
              Text(
                'Interactive Anatomical Map',
                style: HealthTypography.bodyMedium(color: HealthColors.onSurfaceVariant),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: HealthColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.touch_app_rounded, size: 12, color: HealthColors.primary),
                    const SizedBox(width: 4),
                    Text(
                      '${state.organs.length} Systems Active',
                      style: HealthTypography.labelCaps(color: HealthColors.primary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // Interactive Human Canvas & Hotspots
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GlassCard(
              borderRadius: 28,
              padding: EdgeInsets.zero,
              child: Stack(
                children: [
                  // Human Anatomical Silhouette Canvas
                  CustomPaint(
                    size: Size.infinite,
                    painter: _HumanBodyPainter(),
                  ),

                  // Organ Hotspot Nodes
                  ...state.organs.map((organ) {
                    final isSelected = organ.id == state.selectedOrgan.id;
                    return Positioned(
                      left: organ.xPercent * 340 - 24,
                      top: organ.yPercent * 360 - 24,
                      child: _OrganHotspotWidget(
                        organ: organ,
                        isSelected: isSelected,
                        onTap: () {
                          context
                              .read<BodyExploreBloc>()
                              .add(SelectOrganEvent(organ));
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Organ Detail Preview Sheet
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildOrganPreviewCard(context, state.selectedOrgan),
          ),
        ),

        const SizedBox(height: 80), // Bottom nav bar clearance
      ],
    );
  }

  Widget _buildOrganPreviewCard(BuildContext context, OrganNode organ) {
    return GlassCard(
      borderRadius: 24,
      padding: const EdgeInsets.all(20),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          HealthColors.surfaceContainerHigh.withOpacity(0.85),
          HealthColors.surfaceContainer.withOpacity(0.7),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: HealthColors.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: HealthColors.primary.withOpacity(0.3),
                      ),
                    ),
                    child: Icon(
                      _getIcon(organ.iconName),
                      color: HealthColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        organ.title,
                        style: HealthTypography.headlineSmall(
                          color: HealthColors.onSurface,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: HealthColors.primary,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            organ.status,
                            style: HealthTypography.labelCaps(
                              color: HealthColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: HealthColors.surfaceContainerLowest.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: HealthColors.glassBorder),
                ),
                child: Row(
                  children: [
                    Text(
                      '${organ.score.round()}',
                      style: HealthTypography.headlineSmall(
                        color: HealthColors.primary,
                      ),
                    ),
                    Text(
                      '/100',
                      style: HealthTypography.labelCaps(
                        color: HealthColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Summary text
          Text(
            organ.summary,
            style: HealthTypography.bodyMedium(
              color: HealthColors.onSurfaceVariant,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          // Action Button
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: HealthColors.primary,
                foregroundColor: HealthColors.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 4,
                shadowColor: HealthColors.primary.withOpacity(0.4),
              ),
              onPressed: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        OrganDetailScreen(organId: organ.id),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.05, 0.0),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'View Diagnostics',
                    style: HealthTypography.bodyLarge(
                      color: HealthColors.onPrimary,
                    ).copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.arrow_forward_rounded, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0);
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
        return Icons.local_dining_rounded;
      case 'water_drop':
        return Icons.water_drop_rounded;
      case 'bubble_chart':
      default:
        return Icons.bubble_chart_rounded;
    }
  }
}

class _OrganHotspotWidget extends StatefulWidget {
  final OrganNode organ;
  final bool isSelected;
  final VoidCallback onTap;

  const _OrganHotspotWidget({
    required this.organ,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_OrganHotspotWidget> createState() => _OrganHotspotWidgetState();
}

class _OrganHotspotWidgetState extends State<_OrganHotspotWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.isSelected;

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          final pulse = _pulseController.value;
          return SizedBox(
            width: 54,
            height: 54,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Glowing Pulse Ring
                if (isSelected)
                  Container(
                    width: 32 + (pulse * 20),
                    height: 32 + (pulse * 20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: HealthColors.primary.withOpacity((1 - pulse) * 0.7),
                        width: 2,
                      ),
                    ),
                  ),

                // Center Node Button
                Container(
                  width: isSelected ? 42 : 32,
                  height: isSelected ? 42 : 32,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? HealthColors.primary
                        : HealthColors.surfaceContainerHigh.withOpacity(0.9),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? Colors.white
                          : HealthColors.glassBorder,
                      width: isSelected ? 2 : 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isSelected
                            ? HealthColors.primary.withOpacity(0.5)
                            : Colors.black.withOpacity(0.3),
                        blurRadius: isSelected ? 12 : 6,
                      ),
                    ],
                  ),
                  child: Icon(
                    _getIcon(widget.organ.iconName),
                    size: isSelected ? 22 : 16,
                    color: isSelected
                        ? HealthColors.onPrimary
                        : HealthColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
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
        return Icons.local_dining_rounded;
      case 'water_drop':
        return Icons.water_drop_rounded;
      case 'bubble_chart':
      default:
        return Icons.bubble_chart_rounded;
    }
  }
}

class _HumanBodyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final centerX = w / 2;

    final bodyPaint = Paint()
      ..color = HealthColors.surfaceVariant.withOpacity(0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final glowPaint = Paint()
      ..color = HealthColors.primary.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    // Anatomical Stylized Path
    final path = Path();

    // Head
    path.addOval(
      Rect.fromCenter(
        center: Offset(centerX, h * 0.12),
        width: w * 0.22,
        height: h * 0.14,
      ),
    );

    // Neck & Shoulders
    path.moveTo(centerX - w * 0.06, h * 0.18);
    path.quadraticBezierTo(
      centerX - w * 0.28,
      h * 0.22,
      centerX - w * 0.32,
      h * 0.30,
    );

    // Torso Left
    path.quadraticBezierTo(
      centerX - w * 0.22,
      h * 0.48,
      centerX - w * 0.18,
      h * 0.65,
    );

    // Hips to Leg Left
    path.lineTo(centerX - w * 0.20, h * 0.90);
    path.lineTo(centerX - w * 0.05, h * 0.90);
    path.lineTo(centerX, h * 0.68);

    // Leg Right
    path.lineTo(centerX + w * 0.05, h * 0.90);
    path.lineTo(centerX + w * 0.20, h * 0.90);

    // Torso Right
    path.lineTo(centerX + w * 0.18, h * 0.65);
    path.quadraticBezierTo(
      centerX + w * 0.22,
      h * 0.48,
      centerX + w * 0.32,
      h * 0.30,
    );
    path.quadraticBezierTo(
      centerX + w * 0.28,
      h * 0.22,
      centerX + w * 0.06,
      h * 0.18,
    );

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, bodyPaint);

    // Ribcage / Chest Guideline
    final chestPath = Path();
    chestPath.addArc(
      Rect.fromCenter(
        center: Offset(centerX, h * 0.34),
        width: w * 0.34,
        height: h * 0.18,
      ),
      0,
      math.pi,
    );
    canvas.drawPath(
      chestPath,
      Paint()
        ..color = HealthColors.surfaceVariant.withOpacity(0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
