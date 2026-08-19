import 'package:dots_in/features/recommendations/data/repositories/recommendations_repository.dart';
import 'package:dots_in/features/recommendations/presentation/bloc/recommendations_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('RecommendationsBloc Tests', () {
    late RecommendationsRepository repository;
    late RecommendationsBloc bloc;

    setUp(() {
      repository = RecommendationsRepositoryImpl();
      bloc = RecommendationsBloc(repository: repository);
    });

    tearDown(() {
      bloc.close();
    });

    test('Initial state is RecommendationsInitial', () {
      expect(bloc.state, isA<RecommendationsInitial>());
    });

    test('LoadRecommendationsEvent loads bio-protocols', () async {
      bloc.add(LoadRecommendationsEvent());

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<RecommendationsLoading>(),
          isA<RecommendationsLoaded>().having(
            (s) => s.protocols.length,
            'protocols count',
            6,
          ),
        ]),
      );
    });

    test('ToggleProtocolEvent toggles completed state of a protocol', () async {
      bloc.add(LoadRecommendationsEvent());
      await Future.delayed(const Duration(milliseconds: 150));

      final state = bloc.state as RecommendationsLoaded;
      final target = state.protocols.firstWhere((p) => p.id == 'p2');
      final originalCompleted = target.isCompleted;

      bloc.add(ToggleProtocolEvent(target.id));

      await expectLater(
        bloc.stream,
        emits(
          isA<RecommendationsLoaded>().having(
            (s) => s.protocols.firstWhere((p) => p.id == 'p2').isCompleted,
            'toggled state',
            !originalCompleted,
          ),
        ),
      );
    });
  });
}
