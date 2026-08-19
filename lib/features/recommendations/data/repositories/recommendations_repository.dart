import '../../domain/entities/protocol_item.dart';

abstract class RecommendationsRepository {
  Future<List<ProtocolItem>> getProtocols();
}

class RecommendationsRepositoryImpl implements RecommendationsRepository {
  @override
  Future<List<ProtocolItem>> getProtocols() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return const [
      ProtocolItem(
        id: 'p1',
        title: 'Improve Cardio Fitness',
        category: 'Cardiovascular',
        impactLevel: 'High Impact',
        duration: '30 mins',
        impact: '+15% Efficiency',
        isCompleted: false,
        iconName: 'favorite',
        description: 'Your VO2 Max estimates have plateaued. Initiating a structured Zone 2 interval protocol will enhance mitochondrial efficiency and baseline endurance.',
      ),
      ProtocolItem(
        id: 'p2',
        title: 'Improve Sleep Consistency',
        category: 'Sleep',
        impactLevel: 'Moderate Impact',
        duration: 'Nightly',
        impact: 'HRV Restoration',
        isCompleted: false,
        iconName: 'bedtime',
        description: 'Circadian drift detected over the last 7 days. Stabilizing sleep onset times and reducing late-night screen exposure will restore nocturnal HRV balance.',
      ),
      ProtocolItem(
        id: 'p3',
        title: 'Electrolyte Mineral Hydration',
        category: 'Nutrition',
        impactLevel: 'High Vitality',
        duration: 'Instant',
        impact: '+15% Plasma Volume',
        isCompleted: true,
        iconName: 'water_drop',
        description: 'Consume 500ml water enriched with balanced bio-available sodium, potassium, and magnesium malate to maintain intracellular osmolarity.',
      ),
      ProtocolItem(
        id: 'p4',
        title: 'Resonant Coherence Breathwork',
        category: 'Recovery',
        impactLevel: 'Vagal Tone',
        duration: '10 mins',
        impact: '+22% HRV Elevation',
        isCompleted: true,
        iconName: 'air',
        description: '5.5 seconds inhale followed by 5.5 seconds exhale to align cardiovascular baroreflex and quiet sympathetic arousal.',
      ),
      ProtocolItem(
        id: 'p5',
        title: 'Morning Natural Light Anchoring',
        category: 'Sleep',
        impactLevel: 'High Impact',
        duration: '15 mins',
        impact: '+12% Cortisol Awakening',
        isCompleted: true,
        iconName: 'wb_sunny',
        description: 'View indirect outdoor morning sunlight within 30 minutes of waking to anchor the suprachiasmatic nucleus circadian master clock.',
      ),
      ProtocolItem(
        id: 'p6',
        title: 'Thermal Sauna Heat Shock',
        category: 'Recovery',
        impactLevel: 'Cellular Cleanup',
        duration: '20 mins',
        impact: '+18% Heat Shock Proteins',
        isCompleted: false,
        iconName: 'hot_tub',
        description: 'Dry sauna at 80°C (176°F) to trigger HSP70, enhance vascular elasticity, and promote cellular autophagy.',
      ),
    ];
  }
}
