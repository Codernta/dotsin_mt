import '../../domain/entities/health_overview.dart';

abstract class HealthOverviewRepository {
  Future<HealthOverviewData> getHealthOverview();
}

class HealthOverviewRepositoryImpl implements HealthOverviewRepository {
  @override
  Future<HealthOverviewData> getHealthOverview() async {
    // Simulated realistic clinical data matching Stitch project
    await Future.delayed(const Duration(milliseconds: 150));
    return HealthOverviewData(
      overallScore: 82,
      status: 'Good',
      trendPercentage: '+4%',
      isTrendPositive: true,
      lastUpdated: DateTime.now(),
      metrics: const [
        BentoMetric(
          id: 'heart',
          title: 'Heart',
          value: '86',
          unit: 'bpm',
          status: 'Optimal range',
          score: 86,
          icon: 'favorite',
          trend: 'Stable',
          isOptimal: true,
        ),
        BentoMetric(
          id: 'lungs',
          title: 'Lungs',
          value: '74',
          unit: '%',
          status: 'Fair',
          score: 74,
          icon: 'air',
          trend: 'Monitor',
          isOptimal: false,
        ),
        BentoMetric(
          id: 'blood',
          title: 'Blood',
          value: '91',
          unit: 'SpO2',
          status: 'Excellent',
          score: 91,
          icon: 'water_drop',
          trend: 'All clear',
          isOptimal: true,
        ),
        BentoMetric(
          id: 'fitness',
          title: 'Fitness',
          value: '88',
          unit: '/100',
          status: 'Active',
          score: 88,
          icon: 'directions_run',
          trend: '+2%',
          isOptimal: true,
        ),
        BentoMetric(
          id: 'metabolic',
          title: 'Metabolic',
          value: '79',
          unit: '/100',
          status: 'Good',
          score: 79,
          icon: 'local_dining',
          trend: 'Stable',
          isOptimal: true,
        ),
        BentoMetric(
          id: 'genomic',
          title: 'Genomic',
          value: 'Low Risk',
          unit: '',
          status: 'APOE / BRCA1 clear',
          score: 94,
          icon: 'biotech',
          trend: 'Optimal',
          isOptimal: true,
        ),
      ],
    );
  }
}
