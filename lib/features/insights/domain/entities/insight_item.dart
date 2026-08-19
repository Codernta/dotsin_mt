import 'package:equatable/equatable.dart';

enum InsightType { strength, improvement }

class InsightItem extends Equatable {
  final String id;
  final String title;
  final String description;
  final String tag;
  final InsightType type;
  final String iconName;
  final String actionLabel;

  const InsightItem({
    required this.id,
    required this.title,
    required this.description,
    required this.tag,
    required this.type,
    required this.iconName,
    required this.actionLabel,
  });

  @override
  List<Object?> get props => [id, title, description, tag, type, iconName, actionLabel];
}

class GeneticPillarItem extends Equatable {
  final String title;
  final String status;
  final String description;
  final String iconName;
  final String colorHex;

  const GeneticPillarItem({
    required this.title,
    required this.status,
    required this.description,
    required this.iconName,
    required this.colorHex,
  });

  @override
  List<Object?> get props => [title, status, description, iconName, colorHex];
}

class GeneMarkerDetail extends Equatable {
  final String geneKey;
  final String geneName;
  final String subtitle;
  final int score;
  final String efficiencyStatus;
  final String description;
  final String clinicalImpact;
  final List<String> recommendations;
  final List<String> impactedSystems;

  const GeneMarkerDetail({
    required this.geneKey,
    required this.geneName,
    required this.subtitle,
    required this.score,
    required this.efficiencyStatus,
    required this.description,
    required this.clinicalImpact,
    required this.recommendations,
    required this.impactedSystems,
  });

  @override
  List<Object?> get props => [
        geneKey,
        geneName,
        subtitle,
        score,
        efficiencyStatus,
        description,
        clinicalImpact,
        recommendations,
        impactedSystems,
      ];
}

class PhenotypeConditionItem extends Equatable {
  final String title;
  final String status;
  final String note;
  final int score;
  final String iconName;

  const PhenotypeConditionItem({
    required this.title,
    required this.status,
    required this.note,
    required this.score,
    required this.iconName,
  });

  @override
  List<Object?> get props => [title, status, note, score, iconName];
}

class ExertionPhaseItem extends Equatable {
  final String phaseName;
  final String dopamineLevel;
  final String heartRate;
  final String description;

  const ExertionPhaseItem({
    required this.phaseName,
    required this.dopamineLevel,
    required this.heartRate,
    required this.description,
  });

  @override
  List<Object?> get props => [phaseName, dopamineLevel, heartRate, description];
}

class ClinicalRangeItem extends Equatable {
  final String label;
  final String rangeText;
  final bool isCurrentRange;
  final String colorHex;

  const ClinicalRangeItem({
    required this.label,
    required this.rangeText,
    required this.isCurrentRange,
    required this.colorHex,
  });

  @override
  List<Object?> get props => [label, rangeText, isCurrentRange, colorHex];
}

class MentzerMetricData extends Equatable {
  final String title;
  final double value;
  final String unit;
  final String status;
  final String interpretation;
  final List<ClinicalRangeItem> ranges;
  final List<String> impactedParameters;

  const MentzerMetricData({
    required this.title,
    required this.value,
    required this.unit,
    required this.status,
    required this.interpretation,
    required this.ranges,
    required this.impactedParameters,
  });

  @override
  List<Object?> get props => [
        title,
        value,
        unit,
        status,
        interpretation,
        ranges,
        impactedParameters,
      ];
}

class GenotypeData extends Equatable {
  final int overallScore;
  final String status;
  final String summary;
  final List<GeneticPillarItem> pillars;
  final List<GeneMarkerDetail> geneMarkers;
  final List<String> geneticStrengths;

  const GenotypeData({
    required this.overallScore,
    required this.status,
    required this.summary,
    required this.pillars,
    required this.geneMarkers,
    required this.geneticStrengths,
  });

  @override
  List<Object?> get props => [
        overallScore,
        status,
        summary,
        pillars,
        geneMarkers,
        geneticStrengths,
      ];
}

class PhenotypeData extends Equatable {
  final int overallScore;
  final String status;
  final String summary;
  final List<PhenotypeConditionItem> conditions;
  final List<ExertionPhaseItem> physicalActivityPhases;
  final MentzerMetricData mentzerMetric;
  final List<InsightItem> strengths;
  final List<InsightItem> improvements;

  const PhenotypeData({
    required this.overallScore,
    required this.status,
    required this.summary,
    required this.conditions,
    required this.physicalActivityPhases,
    required this.mentzerMetric,
    required this.strengths,
    required this.improvements,
  });

  @override
  List<Object?> get props => [
        overallScore,
        status,
        summary,
        conditions,
        physicalActivityPhases,
        mentzerMetric,
        strengths,
        improvements,
      ];
}
