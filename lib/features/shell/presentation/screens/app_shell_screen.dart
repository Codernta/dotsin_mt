import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/health_colors.dart';
import '../../../../core/theme/health_typography.dart';
import '../../../body_explore/presentation/screens/body_explore_screen.dart';
import '../../../insights/presentation/screens/insights_screen.dart';
import '../../../overview/presentation/screens/overview_screen.dart';
import '../../../recommendations/presentation/screens/recommendations_screen.dart';
import '../cubit/navigation_cubit.dart';

class AppShellScreen extends StatelessWidget {
  const AppShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HealthColors.background,
      body: Stack(
        children: [
          // Main Body Screens with animated tab transition
          BlocBuilder<NavigationCubit, AppTab>(
            builder: (context, currentTab) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 320),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.02, 0.0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  );
                },
                child: _getScreenForTab(currentTab),
              );
            },
          ),

          // Floating Glass Bottom Navigation Bar
          Positioned(
            left: 20,
            right: 20,
            bottom: 24,
            child: SafeArea(
              child: _buildFloatingBottomNavBar(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getScreenForTab(AppTab tab) {
    switch (tab) {
      case AppTab.overview:
        return const OverviewScreen(key: ValueKey('overview'));
      case AppTab.explore:
        return const BodyExploreScreen(key: ValueKey('explore'));
      case AppTab.insights:
        return const InsightsScreen(key: ValueKey('insights'));
      case AppTab.protocols:
        return const RecommendationsScreen(key: ValueKey('protocols'));
    }
  }

  Widget _buildFloatingBottomNavBar(BuildContext context) {
    return BlocBuilder<NavigationCubit, AppTab>(
      builder: (context, currentTab) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(36),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: HealthColors.surfaceContainer.withOpacity(0.85),
                borderRadius: BorderRadius.circular(36),
                border: Border.all(
                  color: HealthColors.glassBorder,
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.35),
                    blurRadius: 28,
                    offset: const Offset(0, 10),
                  ),
                  BoxShadow(
                    color: HealthColors.primary.withOpacity(0.1),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildNavItem(
                    context: context,
                    tab: AppTab.overview,
                    currentTab: currentTab,
                    icon: Icons.dashboard_rounded,
                    label: 'Overview',
                  ),
                  _buildNavItem(
                    context: context,
                    tab: AppTab.explore,
                    currentTab: currentTab,
                    icon: Icons.accessibility_new_rounded,
                    label: 'Health',
                  ),
                  _buildNavItem(
                    context: context,
                    tab: AppTab.insights,
                    currentTab: currentTab,
                    icon: Icons.insights_rounded,
                    label: 'Insights',
                  ),
                  _buildNavItem(
                    context: context,
                    tab: AppTab.protocols,
                    currentTab: currentTab,
                    icon: Icons.checklist_rounded,
                    label: 'Protocols',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required AppTab tab,
    required AppTab currentTab,
    required IconData icon,
    required String label,
  }) {
    final isSelected = tab == currentTab;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.symmetric(
        horizontal: isSelected ? 16 : 10,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: isSelected ? HealthColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(26),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: HealthColors.primary.withOpacity(0.4),
                  blurRadius: 10,
                ),
              ]
            : null,
      ),
      child: InkWell(
        onTap: () => context.read<NavigationCubit>().selectTab(tab),
        borderRadius: BorderRadius.circular(26),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected
                  ? HealthColors.onPrimary
                  : HealthColors.onSurfaceVariant.withOpacity(0.7),
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: HealthTypography.labelCaps(
                  color: HealthColors.onPrimary,
                ).copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
