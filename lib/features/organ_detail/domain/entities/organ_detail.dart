import 'package:equatable/equatable.dart';

class BiometricMetric extends Equatable {
  final String title;
  final String value;
  final String unit;
  final String status;
  final String changeText;
  final bool isOptimal;
  final String iconName;

  const BiometricMetric({
    required this.title,
    required this.value,
    required this.unit,
    required this.status,
    required this.changeText,
    required this.isOptimal,
    required this.iconName,
  });

  @override
  List<Object?> get props => [title, value, unit, status, changeText, isOptimal, iconName];
}

class TrendDataPoint extends Equatable {
  final String dayLabel;
  final double value;

  const TrendDataPoint({
    required this.dayLabel,
    required this.value,
  });

  @override
  List<Object?> get props => [dayLabel, value];
}

class ClinicalConditionItem extends Equatable {
  final String title;
  final String status;
  final String note;
  final bool isWarning;

  const ClinicalConditionItem({
    required this.title,
    required this.status,
    required this.note,
    this.isWarning = false,
  });

  @override
  List<Object?> get props => [title, status, note, isWarning];
}

class StrengthBiomarkerItem extends Equatable {
  final String name;
  final String value;
  final String status;

  const StrengthBiomarkerItem({
    required this.name,
    required this.value,
    required this.status,
  });

  @override
  List<Object?> get props => [name, value, status];
}

class OrganDetailData extends Equatable {
  final String id;
  final String title;
  final int overallScore;
  final String statusLabel;
  final String category;
  final List<BiometricMetric> metrics;
  final List<TrendDataPoint> sevenDayTrend;
  final String trendTitle;
  final String clinicalMeaning;
  final List<String> recommendations;
  final List<ClinicalConditionItem> conditions;
  final List<StrengthBiomarkerItem> strengths;
  final List<String> geneMarkers;

  const OrganDetailData({
    required this.id,
    required this.title,
    required this.overallScore,
    required this.statusLabel,
    required this.category,
    required this.metrics,
    required this.sevenDayTrend,
    required this.trendTitle,
    required this.clinicalMeaning,
    this.recommendations = const [],
    this.conditions = const [],
    this.strengths = const [],
    this.geneMarkers = const [],
  });

  @override
  List<Object?> get props => [
        id,
        title,
        overallScore,
        statusLabel,
        category,
        metrics,
        sevenDayTrend,
        trendTitle,
        clinicalMeaning,
        recommendations,
        conditions,
        strengths,
        geneMarkers,
      ];
}
