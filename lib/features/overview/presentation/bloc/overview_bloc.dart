import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/health_overview_repository.dart';
import '../../domain/entities/health_overview.dart';

// Events
abstract class OverviewEvent extends Equatable {
  const OverviewEvent();
  @override
  List<Object?> get props => [];
}

class LoadOverviewEvent extends OverviewEvent {}
class RefreshOverviewEvent extends OverviewEvent {}

// States
abstract class OverviewState extends Equatable {
  const OverviewState();
  @override
  List<Object?> get props => [];
}

class OverviewInitial extends OverviewState {}
class OverviewLoading extends OverviewState {}

class OverviewLoaded extends OverviewState {
  final HealthOverviewData data;
  const OverviewLoaded(this.data);
  @override
  List<Object?> get props => [data];
}

class OverviewError extends OverviewState {
  final String message;
  const OverviewError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLoC
class OverviewBloc extends Bloc<OverviewEvent, OverviewState> {
  final HealthOverviewRepository repository;

  OverviewBloc({required this.repository}) : super(OverviewInitial()) {
    on<LoadOverviewEvent>(_onLoadOverview);
    on<RefreshOverviewEvent>(_onRefreshOverview);
  }

  Future<void> _onLoadOverview(
    LoadOverviewEvent event,
    Emitter<OverviewState> emit,
  ) async {
    emit(OverviewLoading());
    try {
      final data = await repository.getHealthOverview();
      emit(OverviewLoaded(data));
    } catch (e) {
      emit(OverviewError(e.toString()));
    }
  }

  Future<void> _onRefreshOverview(
    RefreshOverviewEvent event,
    Emitter<OverviewState> emit,
  ) async {
    try {
      final data = await repository.getHealthOverview();
      emit(OverviewLoaded(data));
    } catch (e) {
      emit(OverviewError(e.toString()));
    }
  }
}
