import '../../domain/entities/organ_detail.dart';

abstract class OrganDetailRepository {
  Future<OrganDetailData> getOrganDetail(String organId);
}

class OrganDetailRepositoryImpl implements OrganDetailRepository {
  @override
  Future<OrganDetailData> getOrganDetail(String organId) async {
    await Future.delayed(const Duration(milliseconds: 120));

    switch (organId.toLowerCase()) {
      case 'heart':
        return const OrganDetailData(
          id: 'heart',
          title: 'Heart Health',
          overallScore: 86,
          statusLabel: 'Good Status',
          category: 'Cardiovascular System',
          trendTitle: 'Resting Heart Rate (7-Day)',
          clinicalMeaning:
              'Your cardiovascular biomarkers show strong parasympathetic recovery. Heart Rate Variability (HRV) at 58ms demonstrates excellent autonomic nervous system balance and cardiovascular reserve.',
          metrics: [
            BiometricMetric(
              title: 'Resting HR',
              value: '64',
              unit: 'bpm',
              status: 'Optimal range',
              changeText: '↓ 2% this week',
              isOptimal: true,
              iconName: 'favorite',
            ),
            BiometricMetric(
              title: 'HRV',
              value: '58',
              unit: 'ms',
              status: 'Stable',
              changeText: 'Baseline aligned',
              isOptimal: true,
              iconName: 'monitor_heart',
            ),
            BiometricMetric(
              title: 'Blood Pressure',
              value: '118/76',
              unit: 'mmHg',
              status: 'Normal',
              changeText: 'Target achieved',
              isOptimal: true,
              iconName: 'bloodtype',
            ),
            BiometricMetric(
              title: 'VO2 Max',
              value: '46',
              unit: 'mL/kg',
              status: 'High',
              changeText: 'Top 20% tier',
              isOptimal: true,
              iconName: 'air',
            ),
          ],
          sevenDayTrend: [
            TrendDataPoint(dayLabel: 'Mon', value: 66),
            TrendDataPoint(dayLabel: 'Tue', value: 65),
            TrendDataPoint(dayLabel: 'Wed', value: 67),
            TrendDataPoint(dayLabel: 'Thu', value: 64),
            TrendDataPoint(dayLabel: 'Fri', value: 63),
            TrendDataPoint(dayLabel: 'Sat', value: 64),
            TrendDataPoint(dayLabel: 'Sun', value: 64),
          ],
          conditions: [
            ClinicalConditionItem(
              title: 'Cardiac Rhythm Stability',
              status: 'Optimal',
              note: 'Sinus rhythm consistent without premature ventricular contractions.',
              isWarning: false,
            ),
            ClinicalConditionItem(
              title: 'Myocardial Recovery',
              status: 'Mild Note',
              note: 'Recovery phase noted following high-intensity aerobic interval session.',
              isWarning: false,
            ),
          ],
          recommendations: [
            'Maintain a heart-friendly diet rich in polyphenol antioxidants, whole grains, and omega-3s.',
            'Keep sodium intake balanced to sustain optimal 118/76 mmHg baseline vascular tone.',
            'Incorporate 25 minutes of Zone 2 endurance cardio 3-4x per week to elevate cardiac stroke volume.',
            'Practice 5 minutes of resonant breathwork before sleep to maximize nocturnal HRV recovery.',
          ],
          strengths: [
            StrengthBiomarkerItem(name: 'HCV Antibody', value: '0.05 S/CO', status: 'Negative / Optimal'),
            StrengthBiomarkerItem(name: 'hs-CRP (Inflammation)', value: '0.8 mg/L', status: 'Low Risk'),
            StrengthBiomarkerItem(name: 'Troponin I', value: '< 0.01 ng/mL', status: 'Normal / Healthy'),
          ],
          geneMarkers: ['APOE-e3', 'KIF6', 'NOS3', 'ADRB2'],
        );

      case 'lungs':
        return const OrganDetailData(
          id: 'lungs',
          title: 'Lung Health',
          overallScore: 74,
          statusLabel: 'Needs Attention',
          category: 'Respiratory System',
          trendTitle: 'Oxygen Saturation & Resp Rate (7-Day)',
          clinicalMeaning:
              'Oxygen saturation dips to 94% during sleep transition periods. Resting respiratory rate is normal at 14 breaths/min, but inspiratory capacity indicates opportunity for respiratory muscle training.',
          metrics: [
            BiometricMetric(
              title: 'Resp. Rate',
              value: '14',
              unit: 'br/min',
              status: 'Optimal',
              changeText: 'Target range',
              isOptimal: true,
              iconName: 'air',
            ),
            BiometricMetric(
              title: 'SpO2',
              value: '94',
              unit: '%',
              status: 'Slightly Low',
              changeText: 'Watch trend',
              isOptimal: false,
              iconName: 'bloodtype',
            ),
            BiometricMetric(
              title: 'Capacity',
              value: '4.2',
              unit: 'L',
              status: 'Stable',
              changeText: 'Vital Capacity',
              isOptimal: true,
              iconName: 'pulmonology',
            ),
            BiometricMetric(
              title: 'VO2 Max',
              value: '38',
              unit: 'mL/kg',
              status: 'Moderate',
              changeText: 'Trending Up',
              isOptimal: true,
              iconName: 'directions_run',
            ),
          ],
          sevenDayTrend: [
            TrendDataPoint(dayLabel: 'Mon', value: 96),
            TrendDataPoint(dayLabel: 'Tue', value: 95),
            TrendDataPoint(dayLabel: 'Wed', value: 94),
            TrendDataPoint(dayLabel: 'Thu', value: 94),
            TrendDataPoint(dayLabel: 'Fri', value: 95),
            TrendDataPoint(dayLabel: 'Sat', value: 94),
            TrendDataPoint(dayLabel: 'Sun', value: 95),
          ],
          conditions: [
            ClinicalConditionItem(
              title: 'Airway Resistance',
              status: 'Moderate',
              note: 'Mild bronchial constriction during cold mornings or dry air exposure.',
              isWarning: true,
            ),
            ClinicalConditionItem(
              title: 'Oxygenation Index',
              status: 'Monitoring',
              note: 'Slight nocturnal SpO2 variability; consider nasal breathing strips.',
              isWarning: false,
            ),
          ],
          recommendations: [
            'Practice Box Breathing (4s Inhale, 4s Hold, 4s Exhale, 4s Hold) twice daily.',
            'Avoid indoor particulate pollutants and maintain room humidity between 45-55%.',
            'Perform inspiratory muscle training (IMT) using resistance breath devices 5 mins/day.',
            'Support alveolar elasticity with antioxidant-rich dietary intake (Vitamin C, NAC, Quercetin).',
          ],
          strengths: [
            StrengthBiomarkerItem(name: 'FEV1/FVC Ratio', value: '82%', status: 'Normal / Healthy'),
            StrengthBiomarkerItem(name: 'Peak Expiratory Flow', value: '520 L/min', status: 'Good'),
          ],
          geneMarkers: ['SERPINA1', 'ADAM33', 'TGFB1'],
        );

      case 'liver':
        return const OrganDetailData(
          id: 'liver',
          title: 'Liver Health',
          overallScore: 92,
          statusLabel: 'Optimal',
          category: 'Hepatic & Metabolic System',
          trendTitle: 'Enzyme Activity Index (7-Day)',
          clinicalMeaning:
              'Hepatic enzyme markers (ALT: 18 U/L, AST: 22 U/L) and total bilirubin are in optimal clinical ranges. Phase I and Phase II detoxification pathways are operating within the top 5% demographic percentile.',
          metrics: [
            BiometricMetric(
              title: 'ALT',
              value: '18',
              unit: 'U/L',
              status: 'Normal (7-55)',
              changeText: 'Optimal',
              isOptimal: true,
              iconName: 'check_circle',
            ),
            BiometricMetric(
              title: 'AST',
              value: '22',
              unit: 'U/L',
              status: 'Normal (8-48)',
              changeText: 'Optimal',
              isOptimal: true,
              iconName: 'check_circle',
            ),
            BiometricMetric(
              title: 'Bilirubin',
              value: '0.6',
              unit: 'mg/dL',
              status: 'Normal (0.2-1.2)',
              changeText: '↓ 0.2 improved',
              isOptimal: true,
              iconName: 'trending_down',
            ),
            BiometricMetric(
              title: 'Albumin',
              value: '4.6',
              unit: 'g/dL',
              status: 'Optimal (3.5-5.0)',
              changeText: 'Peak protein synthesis',
              isOptimal: true,
              iconName: 'shield',
            ),
          ],
          sevenDayTrend: [
            TrendDataPoint(dayLabel: 'Mon', value: 90),
            TrendDataPoint(dayLabel: 'Tue', value: 91),
            TrendDataPoint(dayLabel: 'Wed', value: 92),
            TrendDataPoint(dayLabel: 'Thu', value: 92),
            TrendDataPoint(dayLabel: 'Fri', value: 93),
            TrendDataPoint(dayLabel: 'Sat', value: 92),
            TrendDataPoint(dayLabel: 'Sun', value: 92),
          ],
          conditions: [
            ClinicalConditionItem(
              title: 'Cellular Regeneration',
              status: 'High',
              note: 'Enzyme levels indicate excellent hepatocyte regeneration rates post-exercise.',
              isWarning: false,
            ),
            ClinicalConditionItem(
              title: 'Detoxification Efficiency',
              status: 'Optimal',
              note: 'Phase I & II conjugation kinetics well-supported by glutathione levels.',
              isWarning: false,
            ),
          ],
          recommendations: [
            'Maintain cruciferous vegetable intake (broccoli sprouts, arugula) for sulforaphane support.',
            'Continue 14-hour intermittent fasting window to promote hepatic autophagy.',
            'Keep hydration high (3L daily) to facilitate renal and biliary toxin clearance.',
          ],
          strengths: [
            StrengthBiomarkerItem(name: 'Glutathione Status', value: 'High', status: 'Optimal Anti-oxidant'),
            StrengthBiomarkerItem(name: 'GGT Marker', value: '14 U/L', status: 'Excellent'),
          ],
          geneMarkers: ['CYP1A2', 'GSTM1', 'GSTT1', 'PNPLA3'],
        );

      case 'blood':
        return const OrganDetailData(
          id: 'blood',
          title: 'Blood Health & Hematology',
          overallScore: 91,
          statusLabel: 'Optimal Status',
          category: 'Hematologic System',
          trendTitle: 'Hematocrit & Oxygen Delivery (7-Day)',
          clinicalMeaning:
              'Red blood cell indices and iron stores are in ideal equilibrium. Hemoglobin at 15.2 g/dL provides maximum aerobic transport capacity with no signs of microcytic or macrocytic anomalies.',
          metrics: [
            BiometricMetric(
              title: 'Hemoglobin',
              value: '15.2',
              unit: 'g/dL',
              status: 'Normal (13.8-17.2)',
              changeText: 'Target range',
              isOptimal: true,
              iconName: 'bloodtype',
            ),
            BiometricMetric(
              title: 'Ferritin',
              value: '142',
              unit: 'ng/mL',
              status: 'Optimal (30-400)',
              changeText: 'Well-stored iron',
              isOptimal: true,
              iconName: 'shield',
            ),
            BiometricMetric(
              title: 'RBC Count',
              value: '5.1',
              unit: 'x10⁶/µL',
              status: 'Healthy',
              changeText: 'Optimal density',
              isOptimal: true,
              iconName: 'bubble_chart',
            ),
            BiometricMetric(
              title: 'Platelets',
              value: '245',
              unit: 'x10³/µL',
              status: 'Normal',
              changeText: 'Optimal coagulation',
              isOptimal: true,
              iconName: 'check_circle',
            ),
          ],
          sevenDayTrend: [
            TrendDataPoint(dayLabel: 'Mon', value: 90),
            TrendDataPoint(dayLabel: 'Tue', value: 91),
            TrendDataPoint(dayLabel: 'Wed', value: 91),
            TrendDataPoint(dayLabel: 'Thu', value: 92),
            TrendDataPoint(dayLabel: 'Fri', value: 91),
            TrendDataPoint(dayLabel: 'Sat', value: 91),
            TrendDataPoint(dayLabel: 'Sun', value: 91),
          ],
          conditions: [
            ClinicalConditionItem(
              title: 'Oxygen Transport Efficiency',
              status: 'Optimal',
              note: 'High hematocrit-to-viscosity ratio ensures fluid systemic perfusion.',
              isWarning: false,
            ),
            ClinicalConditionItem(
              title: 'Mentzer Index Score',
              status: 'Optimal (12.8)',
              note: 'Mentzer calculation (MCV/RBC) confirms zero alpha/beta thalassemia trait indicators.',
              isWarning: false,
            ),
          ],
          recommendations: [
            'Maintain copper and Vitamin B12 intake for sustained erythropoiesis.',
            'Stay well-hydrated during endurance workouts to prevent blood hyperviscosity.',
          ],
          strengths: [
            StrengthBiomarkerItem(name: 'Serum Iron', value: '98 µg/dL', status: 'Optimal'),
            StrengthBiomarkerItem(name: 'Total Iron Binding (TIBC)', value: '310 µg/dL', status: 'Normal'),
          ],
          geneMarkers: ['HFE', 'HBB', 'HBA1', 'TMPRSS6'],
        );

      default:
        return OrganDetailData(
          id: organId,
          title: '${organId[0].toUpperCase()}${organId.substring(1)} Health',
          overallScore: 88,
          statusLabel: 'Good Status',
          category: 'Biological System',
          trendTitle: 'Biometric Trend (7-Day)',
          clinicalMeaning:
              'Biomarkers for this system indicate steady homeostasis and healthy physiological response.',
          metrics: const [
            BiometricMetric(
              title: 'Efficiency',
              value: '88',
              unit: '%',
              status: 'Good',
              changeText: '+1% this week',
              isOptimal: true,
              iconName: 'check_circle',
            ),
            BiometricMetric(
              title: 'Biomarker Index',
              value: '1.05',
              unit: '',
              status: 'Optimal',
              changeText: 'Stable',
              isOptimal: true,
              iconName: 'biotech',
            ),
          ],
          sevenDayTrend: const [
            TrendDataPoint(dayLabel: 'Mon', value: 85),
            TrendDataPoint(dayLabel: 'Tue', value: 86),
            TrendDataPoint(dayLabel: 'Wed', value: 87),
            TrendDataPoint(dayLabel: 'Thu', value: 88),
            TrendDataPoint(dayLabel: 'Fri', value: 88),
            TrendDataPoint(dayLabel: 'Sat', value: 89),
            TrendDataPoint(dayLabel: 'Sun', value: 88),
          ],
          conditions: const [],
          recommendations: const [
            'Follow healthy lifestyle guidelines and regular hydration.',
          ],
          strengths: const [],
          geneMarkers: const [],
        );
    }
  }
}
