import 'package:dots_in/features/body_explore/data/repositories/organ_repository.dart';
import 'package:dots_in/features/body_explore/presentation/bloc/body_explore_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('BodyExploreBloc Tests', () {
    late OrganRepository repository;
    late BodyExploreBloc bloc;

    setUp(() {
      repository = OrganRepositoryImpl();
      bloc = BodyExploreBloc(repository: repository);
    });

    tearDown(() {
      bloc.close();
    });

    test('Initial state is BodyExploreInitial', () {
      expect(bloc.state, isA<BodyExploreInitial>());
    });

    test('LoadOrgansEvent loads organs and selects first organ by default', () async {
      bloc.add(LoadOrgansEvent());

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<BodyExploreLoading>(),
          isA<BodyExploreLoaded>().having(
            (state) => state.organs.length,
            'organs count',
            greaterThanOrEqualTo(5),
          ),
        ]),
      );
    });

    test('SelectOrganEvent changes currently active organ node', () async {
      bloc.add(LoadOrgansEvent());
      await Future.delayed(const Duration(milliseconds: 150));

      final state = bloc.state as BodyExploreLoaded;
      final lungs = state.organs.firstWhere((o) => o.id == 'lungs');

      bloc.add(SelectOrganEvent(lungs));

      await expectLater(
        bloc.stream,
        emits(
          isA<BodyExploreLoaded>().having(
            (s) => s.selectedOrgan.id,
            'selectedOrgan id',
            'lungs',
          ),
        ),
      );
    });
  });
}
