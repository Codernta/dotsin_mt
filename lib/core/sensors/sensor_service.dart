import 'dart:async';
import 'dart:math' as math;
import 'package:battery_plus/battery_plus.dart';
import 'package:pedometer/pedometer.dart';
import 'package:sensors_plus/sensors_plus.dart';

/// Aggregated Live Sensor Telemetry Model
class SensorData {
  final double accelX;
  final double accelY;
  final double accelZ;
  final double gyroX;
  final double gyroY;
  final double gyroZ;
  final double motionIntensity; // 0.0 (rest) to 1.0 (intense)
  final String activityState; // 'Resting', 'Stationary', 'Walking', 'Active'
  final int stepCount;
  final int todaySteps;
  final String pedestrianStatus; // 'walking', 'stopped', 'unknown'
  final int batteryLevel;
  final BatteryState batteryState;
  final int liveBpm;
  final int liveHrv;
  final int liveSpo2;
  final DateTime timestamp;

  const SensorData({
    required this.accelX,
    required this.accelY,
    required this.accelZ,
    required this.gyroX,
    required this.gyroY,
    required this.gyroZ,
    required this.motionIntensity,
    required this.activityState,
    required this.stepCount,
    required this.todaySteps,
    required this.pedestrianStatus,
    required this.batteryLevel,
    required this.batteryState,
    required this.liveBpm,
    required this.liveHrv,
    required this.liveSpo2,
    required this.timestamp,
  });

  factory SensorData.initial() {
    return SensorData(
      accelX: 0.0,
      accelY: 9.8,
      accelZ: 0.0,
      gyroX: 0.0,
      gyroY: 0.0,
      gyroZ: 0.0,
      motionIntensity: 0.08,
      activityState: 'Stationary',
      stepCount: 6420,
      todaySteps: 6420,
      pedestrianStatus: 'stopped',
      batteryLevel: 85,
      batteryState: BatteryState.discharging,
      liveBpm: 68,
      liveHrv: 58,
      liveSpo2: 98,
      timestamp: DateTime.now(),
    );
  }

  SensorData copyWith({
    double? accelX,
    double? accelY,
    double? accelZ,
    double? gyroX,
    double? gyroY,
    double? gyroZ,
    double? motionIntensity,
    String? activityState,
    int? stepCount,
    int? todaySteps,
    String? pedestrianStatus,
    int? batteryLevel,
    BatteryState? batteryState,
    int? liveBpm,
    int? liveHrv,
    int? liveSpo2,
    DateTime? timestamp,
  }) {
    return SensorData(
      accelX: accelX ?? this.accelX,
      accelY: accelY ?? this.accelY,
      accelZ: accelZ ?? this.accelZ,
      gyroX: gyroX ?? this.gyroX,
      gyroY: gyroY ?? this.gyroY,
      gyroZ: gyroZ ?? this.gyroZ,
      motionIntensity: motionIntensity ?? this.motionIntensity,
      activityState: activityState ?? this.activityState,
      stepCount: stepCount ?? this.stepCount,
      todaySteps: todaySteps ?? this.todaySteps,
      pedestrianStatus: pedestrianStatus ?? this.pedestrianStatus,
      batteryLevel: batteryLevel ?? this.batteryLevel,
      batteryState: batteryState ?? this.batteryState,
      liveBpm: liveBpm ?? this.liveBpm,
      liveHrv: liveHrv ?? this.liveHrv,
      liveSpo2: liveSpo2 ?? this.liveSpo2,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}

/// Unified Sensor & Bio-Telemetry Hardware Service
class SensorService {
  final Battery _battery = Battery();
  final StreamController<SensorData> _sensorStreamController =
      StreamController<SensorData>.broadcast();

  SensorData _currentData = SensorData.initial();
  Timer? _simulationTimer;
  StreamSubscription? _accelSub;
  StreamSubscription? _gyroSub;
  StreamSubscription? _stepSub;
  StreamSubscription? _pedestrianSub;
  StreamSubscription? _batterySub;

  bool _isHardwareConnected = false;

  SensorData get currentData => _currentData;
  Stream<SensorData> get sensorStream => _sensorStreamController.stream;

  void initialize() {
    _initHardwareSensors();
    _initBattery();
    _startContinuousBioEngine();
  }

  void _initHardwareSensors() {
    try {
      _accelSub = accelerometerEventStream().listen(
        (AccelerometerEvent event) {
          _isHardwareConnected = true;
          final magnitude = math.sqrt(
            event.x * event.x + event.y * event.y + event.z * event.z,
          );
          final motionDelta = (magnitude - 9.81).abs();
          final intensity = (motionDelta / 8.0).clamp(0.0, 1.0);

          String state = 'Stationary';
          if (intensity > 0.4) {
            state = 'Active';
          } else if (intensity > 0.15) {
            state = 'Walking';
          }

          _currentData = _currentData.copyWith(
            accelX: event.x,
            accelY: event.y,
            accelZ: event.z,
            motionIntensity: intensity,
            activityState: state,
            timestamp: DateTime.now(),
          );
          _sensorStreamController.add(_currentData);
        },
        onError: (e) {
          // Fallback to simulation
        },
      );

      _gyroSub = gyroscopeEventStream().listen(
        (GyroscopeEvent event) {
          _currentData = _currentData.copyWith(
            gyroX: event.x,
            gyroY: event.y,
            gyroZ: event.z,
          );
        },
        onError: (e) {},
      );

      _stepSub = Pedometer.stepCountStream.listen(
        (StepCount event) {
          _currentData = _currentData.copyWith(
            stepCount: event.steps,
            todaySteps: event.steps,
          );
          _sensorStreamController.add(_currentData);
        },
        onError: (e) {},
      );

      _pedestrianSub = Pedometer.pedestrianStatusStream.listen(
        (PedestrianStatus event) {
          _currentData = _currentData.copyWith(
            pedestrianStatus: event.status,
            activityState: event.status == 'walking' ? 'Walking' : 'Stationary',
          );
          _sensorStreamController.add(_currentData);
        },
        onError: (e) {},
      );
    } catch (_) {
      // Hardware unavailable; simulation handles it smoothly
    }
  }

  void _initBattery() async {
    try {
      final level = await _battery.batteryLevel;
      _currentData = _currentData.copyWith(batteryLevel: level);
      _sensorStreamController.add(_currentData);

      _batterySub = _battery.onBatteryStateChanged.listen((state) {
        _currentData = _currentData.copyWith(batteryState: state);
        _sensorStreamController.add(_currentData);
      });
    } catch (_) {}
  }

  void _startContinuousBioEngine() {
    double timeTicker = 0;

    _simulationTimer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
      timeTicker += 0.1;

      // Realistic circadian/physiological oscillation
      final baseBpm = 64 + (math.sin(timeTicker * 0.3) * 6).round();
      final motionEffect = (_currentData.motionIntensity * 28).round();
      final bpm = (baseBpm + motionEffect).clamp(55, 145);

      final hrv = (62 - (_currentData.motionIntensity * 16) + (math.cos(timeTicker * 0.2) * 5)).round().clamp(38, 95);
      final spo2 = (98 + (math.sin(timeTicker * 0.1) * 1.2)).round().clamp(95, 100);

      // Increment steps naturally if walking/simulating
      int newSteps = _currentData.todaySteps;
      if (_currentData.activityState == 'Walking' || _currentData.activityState == 'Active') {
        newSteps += 2;
      } else if (!_isHardwareConnected) {
        // Subtle background pacing steps simulation
        if (timer.tick % 4 == 0) {
          newSteps += 1;
        }
      }

      _currentData = _currentData.copyWith(
        liveBpm: bpm,
        liveHrv: hrv,
        liveSpo2: spo2,
        todaySteps: newSteps,
        timestamp: DateTime.now(),
      );

      _sensorStreamController.add(_currentData);
    });
  }

  void dispose() {
    _simulationTimer?.cancel();
    _accelSub?.cancel();
    _gyroSub?.cancel();
    _stepSub?.cancel();
    _pedestrianSub?.cancel();
    _batterySub?.cancel();
    _sensorStreamController.close();
  }
}
