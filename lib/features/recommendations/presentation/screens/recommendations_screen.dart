import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/health_colors.dart';
import '../../../../core/theme/health_typography.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/mesh_background.dart';
import '../../domain/entities/protocol_item.dart';
import '../bloc/recommendations_bloc.dart';

class RecommendationsScreen extends StatefulWidget {
  const RecommendationsScreen({super.key});

  @override
  State<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {
  String _selectedCategory = 'All';

  final List<String> _categories = const [
    'All',
    'Cardiovascular',
    'Sleep',
    'Nutrition',
    'Recovery',
  ];

  @override
  Widget build(BuildContext context) {
    return MeshBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            'Recommendations for You',
            style: HealthTypography.headlineSmall(color: HealthColors.primary),
          ),
          centerTitle: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.tune_rounded, color: HealthColors.onSurfaceVariant),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: HealthColors.surfaceContainerHigh,
                    content: Text(
                      'AI Recommendation Engine: Synced with last 14-day biometric data.',
                      style: HealthTypography.bodyMedium(color: HealthColors.primary),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<RecommendationsBloc, RecommendationsState>(
          builder: (context, state) {
            if (state is RecommendationsLoading || state is RecommendationsInitial) {
              return const Center(
                child: CircularProgressIndicator(color: HealthColors.primary),
              );
            }
            if (state is RecommendationsError) {
              return Center(
                child: Text(state.message, style: const TextStyle(color: HealthColors.error)),
              );
            }
            if (state is RecommendationsLoaded) {
              return _buildRecommendationsContent(context, state);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildRecommendationsContent(
    BuildContext context,
    RecommendationsLoaded state,
  ) {
    final filteredProtocols = _selectedCategory == 'All'
        ? state.protocols
        : state.protocols.where((p) => p.category.toLowerCase() == _selectedCategory.toLowerCase()).toList();

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      children: [
        // Subheading
        Text(
          'Personalized pathways to optimize your vitality and systemic balance based on recent telemetry.',
          style: HealthTypography.bodyMedium(color: HealthColors.onSurfaceVariant).copyWith(height: 1.45),
        ).animate().fadeIn(duration: 300.ms),

        const SizedBox(height: 18),

        // Daily Progress Banner Card
        GlassCard(
          borderRadius: 26,
          padding: const EdgeInsets.all(20),
          glowColor: HealthColors.primary,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DAILY BIO-STACK',
                        style: HealthTypography.labelCaps(
                          color: HealthColors.primary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${state.completedCount} of ${state.protocols.length} Completed',
                        style: HealthTypography.headlineSmall(
                          color: HealthColors.onSurface,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: HealthColors.surfaceContainerLowest.withOpacity(0.6),
                      border: Border.all(color: HealthColors.glassBorder),
                    ),
                    child: Center(
                      child: Text(
                        '${(state.completionPercentage * 100).round()}%',
                        style: HealthTypography.headlineSmall(
                          color: HealthColors.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: state.completionPercentage,
                  minHeight: 7,
                  backgroundColor: HealthColors.surfaceVariant.withOpacity(0.5),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    HealthColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.local_fire_department_rounded, color: HealthColors.amber, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '14 Day Habit Streak • +18% Bio-efficiency',
                    style: HealthTypography.labelCaps(color: HealthColors.onSurfaceVariant),
                  ),
                ],
              ),
            ],
          ),
        ).animate().fadeIn(delay: 100.ms, duration: 350.ms).scale(begin: const Offset(0.96, 0.96), end: const Offset(1, 1)),

        const SizedBox(height: 20),

        // Category Filter Chips
        SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _categories.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final cat = _categories[index];
              final isSelected = cat == _selectedCategory;
              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedCategory = cat;
                  });
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? HealthColors.primary
                        : HealthColors.surfaceContainerHigh.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? HealthColors.primary : HealthColors.glassBorder,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: HealthColors.primary.withOpacity(0.3),
                              blurRadius: 8,
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      cat,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? HealthColors.onPrimary : HealthColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ).animate().fadeIn(delay: 150.ms),

        const SizedBox(height: 20),

        // Section Title
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Targeted Interventions',
              style: HealthTypography.headlineSmall(color: HealthColors.onSurface),
            ),
            Text(
              'Tap to toggle',
              style: HealthTypography.labelCaps(color: HealthColors.outline),
            ),
          ],
        ).animate().fadeIn(delay: 200.ms),

        const SizedBox(height: 12),

        // Protocol Item Cards
        ...filteredProtocols.asMap().entries.map((entry) {
          final index = entry.key;
          final protocol = entry.value;
          return _buildProtocolCard(context, protocol, index);
        }),

        const SizedBox(height: 80), // Bottom nav bar clearance
      ],
    );
  }

  Widget _buildProtocolCard(
    BuildContext context,
    ProtocolItem protocol,
    int index,
  ) {
    final isHighImpact = protocol.impactLevel.contains('High');

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        borderRadius: 22,
        padding: const EdgeInsets.all(18),
        borderColor: protocol.isCompleted
            ? HealthColors.primary.withOpacity(0.4)
            : (isHighImpact ? HealthColors.primary.withOpacity(0.25) : HealthColors.glassBorder),
        backgroundColor: protocol.isCompleted
            ? HealthColors.surfaceContainerHigh.withOpacity(0.7)
            : HealthColors.surfaceContainer.withOpacity(0.55),
        onTap: () {
          context.read<RecommendationsBloc>().add(
                ToggleProtocolEvent(protocol.id),
              );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Meta Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: (isHighImpact ? HealthColors.primary : HealthColors.secondary).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: (isHighImpact ? HealthColors.primary : HealthColors.secondary).withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        protocol.impactLevel,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: isHighImpact ? HealthColors.primary : HealthColors.secondary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      protocol.category.toUpperCase(),
                      style: HealthTypography.labelCaps(color: HealthColors.outline),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: HealthColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    protocol.duration,
                    style: const TextStyle(
                      fontSize: 10,
                      color: HealthColors.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // Title & Checkbox
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  margin: const EdgeInsets.only(top: 2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: protocol.isCompleted
                        ? HealthColors.primary
                        : HealthColors.surfaceContainerLowest.withOpacity(0.6),
                    border: Border.all(
                      color: protocol.isCompleted ? HealthColors.primary : HealthColors.outline,
                      width: 1.5,
                    ),
                  ),
                  child: protocol.isCompleted
                      ? const Icon(
                          Icons.check_rounded,
                          color: HealthColors.onPrimary,
                          size: 18,
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        protocol.title,
                        style: HealthTypography.headlineSmall(
                          color: HealthColors.onSurface,
                        ).copyWith(
                          decoration: protocol.isCompleted ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        protocol.description,
                        style: HealthTypography.bodyMedium(
                          color: HealthColors.onSurfaceVariant,
                        ).copyWith(height: 1.45),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Bottom Action Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: HealthColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.trending_up_rounded,
                        size: 13,
                        color: HealthColors.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        protocol.impact,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: HealthColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: protocol.isCompleted ? HealthColors.surfaceContainerHigh : HealthColors.primary,
                    foregroundColor: protocol.isCompleted ? HealthColors.onSurfaceVariant : HealthColors.onPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    elevation: protocol.isCompleted ? 0 : 3,
                  ),
                  onPressed: () {
                    _showStartPlanModal(context, protocol);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        protocol.isCompleted ? 'View Protocol' : 'Start Plan',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward_rounded, size: 14),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: (100 + index * 50).ms).slideY(begin: 0.1, end: 0);
  }

  void _showStartPlanModal(BuildContext context, ProtocolItem protocol) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: HealthColors.surfaceContainerHigh,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(color: HealthColors.glassBorder),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: HealthColors.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      protocol.category.toUpperCase(),
                      style: HealthTypography.labelCaps(color: HealthColors.primary),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: HealthColors.onSurfaceVariant),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                protocol.title,
                style: HealthTypography.headlineMedium(color: HealthColors.onSurface),
              ),
              const SizedBox(height: 8),
              Text(
                protocol.description,
                style: HealthTypography.bodyLarge(color: HealthColors.onSurfaceVariant)
                    .copyWith(height: 1.5),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: HealthColors.surfaceContainerLowest.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: HealthColors.glassBorder),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.speed_rounded, color: HealthColors.primary, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Projected Clinical Impact: ${protocol.impact}',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: HealthColors.primary, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HealthColors.primary,
                    foregroundColor: HealthColors.onPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: HealthColors.surfaceContainerHigh,
                        content: Text(
                          '${protocol.title} protocol activated in your daily bio-stack.',
                          style: HealthTypography.bodyMedium(color: HealthColors.primary),
                        ),
                      ),
                    );
                  },
                  child: const Text('Confirm & Add to Daily Schedule', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
