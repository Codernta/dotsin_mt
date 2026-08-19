import 'package:equatable/equatable.dart';

/// Health Metric Card Data for Bento Grid
class BentoMetric extends Equatable {
  final String id;
  final String title;
  final String value;
  final String unit;
  final String status;
  final double score; // 0 to 100
  final String icon;
  final String trend;
  final bool isOptimal;

  const BentoMetric({
    required this.id,
    required this.title,
    required this.value,
    required this.unit,
    required this.status,
    required this.score,
    required this.icon,
    required this.trend,
    this.isOptimal = true,
  });

  @override
  List<Object?> get props => [id, title, value, unit, status, score, icon, trend, isOptimal];
}

/// Overall Health Summary Entity
class HealthOverviewData extends Equatable {
  final int overallScore;
  final String status;
  final String trendPercentage;
  final bool isTrendPositive;
  final List<BentoMetric> metrics;
  final DateTime lastUpdated;

  const HealthOverviewData({
    required this.overallScore,
    required this.status,
    required this.trendPercentage,
    required this.isTrendPositive,
    required this.metrics,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [
        overallScore,
        status,
        trendPercentage,
        isTrendPositive,
        metrics,
        lastUpdated,
      ];
}
