import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/organ_repository.dart';
import '../../domain/entities/organ_node.dart';

// Events
abstract class BodyExploreEvent extends Equatable {
  const BodyExploreEvent();
  @override
  List<Object?> get props => [];
}

class LoadOrgansEvent extends BodyExploreEvent {}

class SelectOrganEvent extends BodyExploreEvent {
  final OrganNode organ;
  const SelectOrganEvent(this.organ);
  @override
  List<Object?> get props => [organ];
}

class DeselectOrganEvent extends BodyExploreEvent {}

// States
abstract class BodyExploreState extends Equatable {
  const BodyExploreState();
  @override
  List<Object?> get props => [];
}

class BodyExploreInitial extends BodyExploreState {}
class BodyExploreLoading extends BodyExploreState {}

class BodyExploreLoaded extends BodyExploreState {
  final List<OrganNode> organs;
  final OrganNode selectedOrgan;

  const BodyExploreLoaded({
    required this.organs,
    required this.selectedOrgan,
  });

  BodyExploreLoaded copyWith({
    List<OrganNode>? organs,
    OrganNode? selectedOrgan,
  }) {
    return BodyExploreLoaded(
      organs: organs ?? this.organs,
      selectedOrgan: selectedOrgan ?? this.selectedOrgan,
    );
  }

  @override
  List<Object?> get props => [organs, selectedOrgan];
}

class BodyExploreError extends BodyExploreState {
  final String message;
  const BodyExploreError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLoC
class BodyExploreBloc extends Bloc<BodyExploreEvent, BodyExploreState> {
  final OrganRepository repository;

  BodyExploreBloc({required this.repository}) : super(BodyExploreInitial()) {
    on<LoadOrgansEvent>(_onLoadOrgans);
    on<SelectOrganEvent>(_onSelectOrgan);
  }

  Future<void> _onLoadOrgans(
    LoadOrgansEvent event,
    Emitter<BodyExploreState> emit,
  ) async {
    emit(BodyExploreLoading());
    try {
      final organs = await repository.getOrgans();
      final defaultSelected = organs.isNotEmpty ? organs.first : null;
      if (defaultSelected != null) {
        emit(BodyExploreLoaded(
          organs: organs,
          selectedOrgan: defaultSelected,
        ));
      }
    } catch (e) {
      emit(BodyExploreError(e.toString()));
    }
  }

  void _onSelectOrgan(
    SelectOrganEvent event,
    Emitter<BodyExploreState> emit,
  ) {
    if (state is BodyExploreLoaded) {
      final current = state as BodyExploreLoaded;
      emit(current.copyWith(selectedOrgan: event.organ));
    }
  }
}
