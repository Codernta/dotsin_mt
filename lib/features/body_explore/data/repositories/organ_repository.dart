import '../../domain/entities/organ_node.dart';

abstract class OrganRepository {
  Future<List<OrganNode>> getOrgans();
  Future<OrganNode?> getOrganById(String id);
}

class OrganRepositoryImpl implements OrganRepository {
  final List<OrganNode> _organs = const [
    OrganNode(
      id: 'heart',
      title: 'Heart',
      system: OrganSystem.cardiovascular,
      score: 86,
      status: 'Optimal Status',
      summary:
          'Your cardiovascular health is looking strong. Resting heart rate is consistently in a healthy range, indicating good recovery and parasympathetic resilience.',
      iconName: 'favorite',
      xPercent: 0.52,
      yPercent: 0.36,
      primaryColorHex: '#4EDEA3',
      todayFocusTitle: "Today's Focus",
      todayFocusAction: 'Zone 2 Cardio (25 mins)',
    ),
    OrganNode(
      id: 'lungs',
      title: 'Lungs',
      system: OrganSystem.respiratory,
      score: 74,
      status: 'Fair Status',
      summary:
          'Respiratory efficiency is moderate with VO2 max in the 75th percentile. Mild shallow breathing observed during desk work sessions.',
      iconName: 'air',
      xPercent: 0.40,
      yPercent: 0.32,
      primaryColorHex: '#6BD8CB',
      todayFocusTitle: 'Breathwork Protocol',
      todayFocusAction: 'Box Breathing (4-4-4-4)',
    ),
    OrganNode(
      id: 'brain',
      title: 'Brain',
      system: OrganSystem.neurological,
      score: 92,
      status: 'Optimal Status',
      summary:
          'Cognitive readiness and autonomic balance indicate high recovery index and optimal REM/Deep sleep cycles.',
      iconName: 'psychology',
      xPercent: 0.50,
      yPercent: 0.12,
      primaryColorHex: '#ADC6FF',
      todayFocusTitle: 'Mental Focus',
      todayFocusAction: 'Deep Work Block (90 mins)',
    ),
    OrganNode(
      id: 'liver',
      title: 'Liver & Metabolic',
      system: OrganSystem.digestive,
      score: 81,
      status: 'Optimal Status',
      summary:
          'Enzyme levels (ALT/AST) and metabolic detox markers indicate healthy liver filtration and balanced glucose spikes.',
      iconName: 'local_dining',
      xPercent: 0.44,
      yPercent: 0.48,
      primaryColorHex: '#4EDEA3',
      todayFocusTitle: 'Metabolic Optimization',
      todayFocusAction: '14-Hour Intermittent Fast',
    ),
    OrganNode(
      id: 'kidneys',
      title: 'Kidneys & Hydration',
      system: OrganSystem.renal,
      score: 88,
      status: 'Optimal Status',
      summary:
          'Estimated GFR and electrolyte balance are in top tier. Intracellular hydration is well-maintained throughout training.',
      iconName: 'water_drop',
      xPercent: 0.58,
      yPercent: 0.52,
      primaryColorHex: '#6BD8CB',
      todayFocusTitle: "Hydration Check-in",
      todayFocusAction: 'Drink 500ml with Electrolytes',
    ),
    OrganNode(
      id: 'intestine',
      title: 'Gut Microbiome',
      system: OrganSystem.digestive,
      score: 78,
      status: 'Good Status',
      summary:
          'Digestive diversity score is stable with healthy short-chain fatty acid production. Minimal inflammatory bloating detected.',
      iconName: 'bubble_chart',
      xPercent: 0.50,
      yPercent: 0.62,
      primaryColorHex: '#ADC6FF',
      todayFocusTitle: 'Gut Health Routine',
      todayFocusAction: 'Add fermented kefir / fiber',
    ),
  ];

  @override
  Future<List<OrganNode>> getOrgans() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _organs;
  }

  @override
  Future<OrganNode?> getOrganById(String id) async {
    try {
      return _organs.firstWhere((element) => element.id == id);
    } catch (_) {
      return _organs.first;
    }
  }
}
