import 'package:dots_in/features/insights/data/repositories/insights_repository.dart';
import 'package:dots_in/features/insights/presentation/bloc/insights_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('InsightsBloc Tests', () {
    late InsightsRepository repository;
    late InsightsBloc bloc;

    setUp(() {
      repository = InsightsRepositoryImpl();
      bloc = InsightsBloc(repository: repository);
    });

    tearDown(() {
      bloc.close();
    });

    test('Initial state is InsightsInitial', () {
      expect(bloc.state, isA<InsightsInitial>());
    });

    test('LoadInsightsEvent splits items into strengths and improvements', () async {
      bloc.add(LoadInsightsEvent());

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<InsightsLoading>(),
          isA<InsightsLoaded>().having(
            (s) => s.strengths.length,
            'strengths count',
            3,
          ).having(
            (s) => s.improvements.length,
            'improvements count',
            3,
          ),
        ]),
      );
    });
  });
}
