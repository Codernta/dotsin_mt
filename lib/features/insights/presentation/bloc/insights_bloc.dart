import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/insights_repository.dart';
import '../../domain/entities/insight_item.dart';

enum InsightsMode { phenotype, genotype }

// Events
abstract class InsightsEvent extends Equatable {
  const InsightsEvent();
  @override
  List<Object?> get props => [];
}

class LoadInsightsEvent extends InsightsEvent {}

class SwitchInsightsModeEvent extends InsightsEvent {
  final InsightsMode mode;
  const SwitchInsightsModeEvent(this.mode);

  @override
  List<Object?> get props => [mode];
}

// States
abstract class InsightsState extends Equatable {
  const InsightsState();
  @override
  List<Object?> get props => [];
}

class InsightsInitial extends InsightsState {}
class InsightsLoading extends InsightsState {}

class InsightsLoaded extends InsightsState {
  final InsightsMode mode;
  final GenotypeData genotype;
  final PhenotypeData phenotype;

  const InsightsLoaded({
    this.mode = InsightsMode.genotype,
    required this.genotype,
    required this.phenotype,
  });

  List<InsightItem> get strengths => phenotype.strengths;
  List<InsightItem> get improvements => phenotype.improvements;

  InsightsLoaded copyWith({
    InsightsMode? mode,
    GenotypeData? genotype,
    PhenotypeData? phenotype,
  }) {
    return InsightsLoaded(
      mode: mode ?? this.mode,
      genotype: genotype ?? this.genotype,
      phenotype: phenotype ?? this.phenotype,
    );
  }

  @override
  List<Object?> get props => [mode, genotype, phenotype];
}

class InsightsError extends InsightsState {
  final String message;
  const InsightsError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLoC
class InsightsBloc extends Bloc<InsightsEvent, InsightsState> {
  final InsightsRepository repository;

  InsightsBloc({required this.repository}) : super(InsightsInitial()) {
    on<LoadInsightsEvent>(_onLoadInsights);
    on<SwitchInsightsModeEvent>(_onSwitchMode);
  }

  Future<void> _onLoadInsights(
    LoadInsightsEvent event,
    Emitter<InsightsState> emit,
  ) async {
    emit(InsightsLoading());
    try {
      final genotype = await repository.getGenotypeData();
      final phenotype = await repository.getPhenotypeData();
      emit(InsightsLoaded(
        mode: InsightsMode.genotype,
        genotype: genotype,
        phenotype: phenotype,
      ));
    } catch (e) {
      emit(InsightsError(e.toString()));
    }
  }

  void _onSwitchMode(
    SwitchInsightsModeEvent event,
    Emitter<InsightsState> emit,
  ) {
    if (state is InsightsLoaded) {
      final currentState = state as InsightsLoaded;
      emit(currentState.copyWith(mode: event.mode));
    }
  }
}
