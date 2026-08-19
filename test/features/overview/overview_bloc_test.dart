import 'package:dots_in/features/overview/data/repositories/health_overview_repository.dart';
import 'package:dots_in/features/overview/presentation/bloc/overview_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('OverviewBloc Tests', () {
    late HealthOverviewRepository repository;
    late OverviewBloc bloc;

    setUp(() {
      repository = HealthOverviewRepositoryImpl();
      bloc = OverviewBloc(repository: repository);
    });

    tearDown(() {
      bloc.close();
    });

    test('Initial state is OverviewInitial', () {
      expect(bloc.state, isA<OverviewInitial>());
    });

    test('LoadOverviewEvent emits [OverviewLoading, OverviewLoaded]', () async {
      bloc.add(LoadOverviewEvent());

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<OverviewLoading>(),
          isA<OverviewLoaded>().having(
            (state) => state.data.overallScore,
            'overallScore',
            82,
          ),
        ]),
      );
    });
  });
}
