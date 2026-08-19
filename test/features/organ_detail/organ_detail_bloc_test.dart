import 'package:dots_in/features/organ_detail/data/repositories/organ_detail_repository.dart';
import 'package:dots_in/features/organ_detail/presentation/bloc/organ_detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('OrganDetailBloc Tests', () {
    late OrganDetailRepository repository;
    late OrganDetailBloc bloc;

    setUp(() {
      repository = OrganDetailRepositoryImpl();
      bloc = OrganDetailBloc(repository: repository);
    });

    tearDown(() {
      bloc.close();
    });

    test('Initial state is OrganDetailInitial', () {
      expect(bloc.state, isA<OrganDetailInitial>());
    });

    test('LoadOrganDetailEvent loads heart diagnostic data', () async {
      bloc.add(const LoadOrganDetailEvent('heart'));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<OrganDetailLoading>(),
          isA<OrganDetailLoaded>().having(
            (s) => s.detail.overallScore,
            'heart score',
            86,
          ),
        ]),
      );
    });

    test('LoadOrganDetailEvent loads lungs diagnostic data', () async {
      bloc.add(const LoadOrganDetailEvent('lungs'));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          isA<OrganDetailLoading>(),
          isA<OrganDetailLoaded>().having(
            (s) => s.detail.overallScore,
            'lungs score',
            74,
          ),
        ]),
      );
    });
  });
}
