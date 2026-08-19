import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/recommendations_repository.dart';
import '../../domain/entities/protocol_item.dart';

// Events
abstract class RecommendationsEvent extends Equatable {
  const RecommendationsEvent();
  @override
  List<Object?> get props => [];
}

class LoadRecommendationsEvent extends RecommendationsEvent {}

class ToggleProtocolEvent extends RecommendationsEvent {
  final String protocolId;
  const ToggleProtocolEvent(this.protocolId);
  @override
  List<Object?> get props => [protocolId];
}

// States
abstract class RecommendationsState extends Equatable {
  const RecommendationsState();
  @override
  List<Object?> get props => [];
}

class RecommendationsInitial extends RecommendationsState {}
class RecommendationsLoading extends RecommendationsState {}

class RecommendationsLoaded extends RecommendationsState {
  final List<ProtocolItem> protocols;

  const RecommendationsLoaded(this.protocols);

  int get completedCount => protocols.where((p) => p.isCompleted).length;
  double get completionPercentage =>
      protocols.isEmpty ? 0.0 : (completedCount / protocols.length);

  @override
  List<Object?> get props => [protocols];
}

class RecommendationsError extends RecommendationsState {
  final String message;
  const RecommendationsError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLoC
class RecommendationsBloc
    extends Bloc<RecommendationsEvent, RecommendationsState> {
  final RecommendationsRepository repository;

  RecommendationsBloc({required this.repository})
      : super(RecommendationsInitial()) {
    on<LoadRecommendationsEvent>(_onLoadRecommendations);
    on<ToggleProtocolEvent>(_onToggleProtocol);
  }

  Future<void> _onLoadRecommendations(
    LoadRecommendationsEvent event,
    Emitter<RecommendationsState> emit,
  ) async {
    emit(RecommendationsLoading());
    try {
      final protocols = await repository.getProtocols();
      emit(RecommendationsLoaded(protocols));
    } catch (e) {
      emit(RecommendationsError(e.toString()));
    }
  }

  void _onToggleProtocol(
    ToggleProtocolEvent event,
    Emitter<RecommendationsState> emit,
  ) {
    if (state is RecommendationsLoaded) {
      final current = state as RecommendationsLoaded;
      final updated = current.protocols.map((p) {
        if (p.id == event.protocolId) {
          return p.copyWith(isCompleted: !p.isCompleted);
        }
        return p;
      }).toList();
      emit(RecommendationsLoaded(updated));
    }
  }
}
