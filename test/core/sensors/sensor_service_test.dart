import 'package:dots_in/core/sensors/sensor_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SensorService & SensorData Tests', () {
    test('Initial SensorData has sensible physiological defaults', () {
      final initial = SensorData.initial();
      expect(initial.liveBpm, 68);
      expect(initial.liveHrv, 58);
      expect(initial.liveSpo2, 98);
      expect(initial.activityState, 'Stationary');
      expect(initial.todaySteps, greaterThanOrEqualTo(0));
    });

    test('SensorData copyWith updates fields immutably', () {
      final initial = SensorData.initial();
      final updated = initial.copyWith(
        liveBpm: 75,
        activityState: 'Walking',
        todaySteps: 7000,
      );

      expect(updated.liveBpm, 75);
      expect(updated.activityState, 'Walking');
      expect(updated.todaySteps, 7000);
      expect(initial.liveBpm, 68); // original remains intact
    });
  });
}
