import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/sensors/sensor_service.dart';

// Events
abstract class SensorsEvent extends Equatable {
  const SensorsEvent();
  @override
  List<Object?> get props => [];
}

class StartSensorStreamEvent extends SensorsEvent {}

class UpdateSensorDataEvent extends SensorsEvent {
  final SensorData data;
  const UpdateSensorDataEvent(this.data);
  @override
  List<Object?> get props => [data];
}

// States
abstract class SensorsState extends Equatable {
  const SensorsState();
  @override
  List<Object?> get props => [];
}

class SensorsInitial extends SensorsState {}

class SensorsActive extends SensorsState {
  final SensorData data;
  const SensorsActive(this.data);
  @override
  List<Object?> get props => [data];
}

// BLoC
class SensorsBloc extends Bloc<SensorsEvent, SensorsState> {
  final SensorService sensorService;
  StreamSubscription<SensorData>? _subscription;

  SensorsBloc({required this.sensorService}) : super(SensorsInitial()) {
    on<StartSensorStreamEvent>(_onStartSensorStream);
    on<UpdateSensorDataEvent>(_onUpdateSensorData);
  }

  void _onStartSensorStream(
    StartSensorStreamEvent event,
    Emitter<SensorsState> emit,
  ) {
    sensorService.initialize();
    emit(SensorsActive(sensorService.currentData));

    _subscription?.cancel();
    _subscription = sensorService.sensorStream.listen((data) {
      add(UpdateSensorDataEvent(data));
    });
  }

  void _onUpdateSensorData(
    UpdateSensorDataEvent event,
    Emitter<SensorsState> emit,
  ) {
    emit(SensorsActive(event.data));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
