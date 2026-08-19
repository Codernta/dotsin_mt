import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/organ_detail_repository.dart';
import '../../domain/entities/organ_detail.dart';

// Events
abstract class OrganDetailEvent extends Equatable {
  const OrganDetailEvent();
  @override
  List<Object?> get props => [];
}

class LoadOrganDetailEvent extends OrganDetailEvent {
  final String organId;
  const LoadOrganDetailEvent(this.organId);
  @override
  List<Object?> get props => [organId];
}

// States
abstract class OrganDetailState extends Equatable {
  const OrganDetailState();
  @override
  List<Object?> get props => [];
}

class OrganDetailInitial extends OrganDetailState {}
class OrganDetailLoading extends OrganDetailState {}

class OrganDetailLoaded extends OrganDetailState {
  final OrganDetailData detail;
  const OrganDetailLoaded(this.detail);
  @override
  List<Object?> get props => [detail];
}

class OrganDetailError extends OrganDetailState {
  final String message;
  const OrganDetailError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLoC
class OrganDetailBloc extends Bloc<OrganDetailEvent, OrganDetailState> {
  final OrganDetailRepository repository;

  OrganDetailBloc({required this.repository}) : super(OrganDetailInitial()) {
    on<LoadOrganDetailEvent>(_onLoadOrganDetail);
  }

  Future<void> _onLoadOrganDetail(
    LoadOrganDetailEvent event,
    Emitter<OrganDetailState> emit,
  ) async {
    emit(OrganDetailLoading());
    try {
      final detail = await repository.getOrganDetail(event.organId);
      emit(OrganDetailLoaded(detail));
    } catch (e) {
      emit(OrganDetailError(e.toString()));
    }
  }
}
