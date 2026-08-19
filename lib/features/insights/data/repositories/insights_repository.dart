import '../../domain/entities/insight_item.dart';

abstract class InsightsRepository {
  Future<List<InsightItem>> getInsights();
  Future<GenotypeData> getGenotypeData();
  Future<PhenotypeData> getPhenotypeData();
}

class InsightsRepositoryImpl implements InsightsRepository {
  @override
  Future<List<InsightItem>> getInsights() async {
    final phenotype = await getPhenotypeData();
    return [...phenotype.strengths, ...phenotype.improvements];
  }

  @override
  Future<GenotypeData> getGenotypeData() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return const GenotypeData(
      overallScore: 82,
      status: 'Optimized',
      summary: 'Your genetic markers indicate a highly adaptive physical profile with superior mitochondrial recovery kinetics.',
      pillars: [
        GeneticPillarItem(
          title: 'Cardiovascular',
          status: 'Average Risk',
          description: 'Standard baseline vascular elasticity and lipid clearance rate.',
          iconName: 'favorite',
          colorHex: '#4EDEA3',
        ),
        GeneticPillarItem(
          title: 'Metabolic',
          status: 'High Efficacy',
          description: 'Fast glucose clearance and rapid ATP recycling in muscle cells.',
          iconName: 'bolt',
          colorHex: '#6BD8CB',
        ),
        GeneticPillarItem(
          title: 'Nutrition',
          status: 'Watch Sensitivities',
          description: 'Lactose sensitivity & moderate caffeine clearance polymorphism.',
          iconName: 'restaurant',
          colorHex: '#F59E0B',
        ),
        GeneticPillarItem(
          title: 'Fitness',
          status: 'Endurance Dominant',
          description: 'Type I slow-twitch muscle fiber density favored for sustained stamina.',
          iconName: 'fitness_center',
          colorHex: '#ADC6FF',
        ),
      ],
      geneMarkers: [
        GeneMarkerDetail(
          geneKey: 'SLC6A4',
          geneName: 'SLC6A4',
          subtitle: 'Serotonin Transporter Gene (5-HTTLPR)',
          score: 66,
          efficiencyStatus: 'Moderate Efficiency (66%)',
          description:
              'Your SLC6A4 genotype score of 66% indicates moderate efficiency in serotonin transport. This gene plays a vital role in regulating synaptic serotonin levels, influencing mood, emotional regulation, and neural resilience under physical fatigue.',
          clinicalImpact:
              'The s/l heterozygous variant is associated with heightened neuroplastic response to mindfulness, natural sunlight, and aerobic endurance training.',
          recommendations: [
            'Incorporate 15 minutes of morning daylight exposure (10,000 lux) within 30 minutes of waking.',
            'Support tryptophan-to-serotonin synthesis with dietary Vitamin B6, Magnesium, and Zinc.',
            'Engage in rhythmic breathing or meditation post-workout to support serotonin reuptake stability.',
          ],
          impactedSystems: ['Autonomic Nervous System', 'Mood Regulation', 'Circadian Architecture'],
        ),
        GeneMarkerDetail(
          geneKey: 'DRD4',
          geneName: 'DRD4',
          subtitle: 'Dopamine Receptor D4',
          score: 88,
          efficiencyStatus: 'High Sensitivity (88%)',
          description:
              'DRD4 receptor density polymorphism indicates high novelty-seeking and elevated dopamine receptor sensitivity. Physical exertion triggers a sharp focus response with elevated neurotrophin release.',
          clinicalImpact:
              'Allows rapid skill acquisition during complex athletic tasks and fast cognitive acceleration in competitive scenarios.',
          recommendations: [
            'Structure workouts with varied interval modalities to prevent dopamine receptor habituation.',
            'Utilize cold water immersion (2-3 mins at 10°C) for sustained 250% baseline dopamine elevation.',
          ],
          impactedSystems: ['Cognitive Drive', 'Motor Learning', 'Reward Pathways'],
        ),
        GeneMarkerDetail(
          geneKey: 'COMT',
          geneName: 'COMT',
          subtitle: 'Catechol-O-Methyltransferase (Val158Met)',
          score: 78,
          efficiencyStatus: 'Balanced Clearance (78%)',
          description:
              'The Val/Met heterozygous profile provides a balanced degradation rate of prefrontal dopamine and epinephrine—giving you strong baseline focus without excessive stress vulnerability.',
          clinicalImpact:
              'Demonstrates high mental resilience and task maintenance during intense biometric training thresholds.',
          recommendations: [
            'Limit late afternoon caffeine consumption to avoid prolonged catecholamine clearance delays.',
            'Supplement with methylated folate (L-methylfolate) to optimize S-adenosylmethionine (SAMe) cycles.',
          ],
          impactedSystems: ['Prefrontal Cortex', 'Stress Tolerance', 'Executive Function'],
        ),
      ],
      geneticStrengths: [
        'Muscle Recovery: Enhanced post-workout tissue repair and satellite cell activation.',
        'Aerobic Adaptability: Rapid capillary bed expansion in response to Zone 2 cardiovascular stimuli.',
        'Antioxidant Synthesis: High endogenous glutathione peroxidase baseline activity.',
      ],
    );
  }

  @override
  Future<PhenotypeData> getPhenotypeData() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return const PhenotypeData(
      overallScore: 84,
      status: 'High Vitality',
      summary: 'Phenotypic telemetry shows strong physiological adaptation with minor muscular strain in recovery.',
      conditions: [
        PhenotypeConditionItem(
          title: 'Left Neck & Trapezius',
          status: 'Recovery Phase',
          note: 'Slight myofascial tightness noted after resistance training; mobility improving.',
          score: 76,
          iconName: 'accessibility_new',
        ),
        PhenotypeConditionItem(
          title: 'Respiratory Respiration',
          status: 'Improving',
          note: 'Recovery phase with better oxygen supply and diaphragmatic expansion.',
          score: 82,
          iconName: 'air',
        ),
        PhenotypeConditionItem(
          title: 'Knee Joint Alignment',
          status: 'Optimal',
          note: 'Synovial fluid balance and patellar tracking within ideal load thresholds.',
          score: 91,
          iconName: 'directions_walk',
        ),
      ],
      physicalActivityPhases: [
        ExertionPhaseItem(
          phaseName: 'Warm Up Phase',
          dopamineLevel: '+25%',
          heartRate: '105 bpm',
          description: 'Neuromuscular activation and gradual catecholamine priming.',
        ),
        ExertionPhaseItem(
          phaseName: 'Peak Activity',
          dopamineLevel: '+140%',
          heartRate: '162 bpm',
          description: 'High endorphin surge with optimal stroke volume recruitment.',
        ),
        ExertionPhaseItem(
          phaseName: 'Recovery Phase',
          dopamineLevel: 'Baseline +35%',
          heartRate: '82 bpm',
          description: 'Vagal nerve activation and sustained cognitive clarity.',
        ),
      ],
      mentzerMetric: MentzerMetricData(
        title: 'Mentzer Index',
        value: 36.7,
        unit: 'mcg/dL',
        status: 'Optimal Status',
        interpretation:
            'The Mentzer Index evaluates microcytic cellular morphology. Your current value of 36.7 confirms robust red cell volume and ruled-out hemoglobinopathy traits.',
        ranges: [
          ClinicalRangeItem(label: 'Very Low', rangeText: '< 4.46 mcg/dL', isCurrentRange: false, colorHex: '#BA1A1A'),
          ClinicalRangeItem(label: 'Low', rangeText: '4.46 - 6.46 mcg/dL', isCurrentRange: false, colorHex: '#F59E0B'),
          ClinicalRangeItem(label: 'Moderate', rangeText: '6.46 - 8.46 mcg/dL', isCurrentRange: false, colorHex: '#6BD8CB'),
          ClinicalRangeItem(label: 'Optimal', rangeText: '8.46 - 38.0 mcg/dL', isCurrentRange: true, colorHex: '#4EDEA3'),
          ClinicalRangeItem(label: 'High', rangeText: '38.0 - 45.0 mcg/dL', isCurrentRange: false, colorHex: '#F59E0B'),
          ClinicalRangeItem(label: 'Very High', rangeText: '> 45.0 mcg/dL', isCurrentRange: false, colorHex: '#BA1A1A'),
        ],
        impactedParameters: [
          'LDL Cholesterol Particle Density',
          'Mean Corpuscular Volume (MCV)',
          'Erythrocyte Sedimentation Equilibrium',
          'Cellular Membrane Fluidity',
        ],
      ),
      strengths: [
        InsightItem(
          id: 'str-1',
          title: 'Superior Parasympathetic Tone',
          description: 'Resting HRV at 58ms is 22% higher than your age baseline, indicating rapid physical recovery.',
          tag: 'Cardiovascular',
          type: InsightType.strength,
          iconName: 'favorite',
          actionLabel: 'View Recovery Stats',
        ),
        InsightItem(
          id: 'str-2',
          title: 'High Mitochondrial Efficiency',
          description: 'Metabolic lactate threshold during aerobic exercise shows robust mitochondrial density.',
          tag: 'Metabolism',
          type: InsightType.strength,
          iconName: 'battery_charging_full',
          actionLabel: 'Inspect Metrics',
        ),
      ],
      improvements: [
        InsightItem(
          id: 'imp-1',
          title: 'Nocturnal SpO2 Stability',
          description: 'Occasional dips below 94% SpO2 detected during early REM sleep cycles.',
          tag: 'Respiratory',
          type: InsightType.improvement,
          iconName: 'air',
          actionLabel: 'Start Breath Protocol',
        ),
        InsightItem(
          id: 'imp-2',
          title: 'Late Afternoon Circadian Drift',
          description: 'Blue light exposure after 9:30 PM is delaying melatonin onset by ~40 minutes.',
          tag: 'Circadian',
          type: InsightType.improvement,
          iconName: 'bedtime',
          actionLabel: 'Enable Sleep Shield',
        ),
      ],
    );
  }
}
