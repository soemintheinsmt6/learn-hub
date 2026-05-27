import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learn_hub/features/user/domain/entities/user.dart';
import 'package:learn_hub/features/user/domain/repositories/user_repository.dart';
import 'package:learn_hub/features/user/presentation/bloc/user_bloc/user_bloc.dart';
import 'package:learn_hub/features/user/presentation/bloc/user_bloc/user_event.dart';
import 'package:learn_hub/features/user/presentation/bloc/user_bloc/user_state.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  group('UserBloc', () {
    late MockUserRepository repository;

    setUp(() {
      repository = MockUserRepository();
    });

    final users = [
      User(
        id: 1,
        name: 'Alice',
        company: 'Acme',
        username: 'alice',
        email: 'alice@example.com',
        address: '123 Street',
        zip: '12345',
        state: 'CA',
        country: 'USA',
        phone: '1234567890',
        photo: null,
      ),
    ];

    blocTest<UserBloc, UserState>(
      'emits [loading, loaded] when fetchUsers succeeds',
      build: () {
        when(() => repository.fetchUsers()).thenAnswer((_) async => users);
        return UserBloc(repository);
      },
      act: (bloc) => bloc.add(LoadUser()),
      expect: () => [
        const UserState(isLoading: true, users: [], error: null),
        UserState(isLoading: false, users: users, error: null),
      ],
      verify: (_) => verify(() => repository.fetchUsers()).called(1),
    );

    blocTest<UserBloc, UserState>(
      'emits [loading, error] when fetchUsers throws',
      build: () {
        when(
          () => repository.fetchUsers(),
        ).thenThrow(Exception('network error'));
        return UserBloc(repository);
      },
      act: (bloc) => bloc.add(LoadUser()),
      expect: () => [
        const UserState(isLoading: true, users: [], error: null),
        const UserState(
          isLoading: false,
          users: [],
          error: 'Exception: network error',
        ),
      ],
    );
  });
}
