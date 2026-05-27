import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learn_hub/features/user/domain/entities/user.dart';
import 'package:learn_hub/features/user/domain/repositories/user_repository.dart';
import 'package:learn_hub/features/user/presentation/bloc/profile_bloc/profile_bloc.dart';
import 'package:learn_hub/features/user/presentation/bloc/profile_bloc/profile_event.dart';
import 'package:learn_hub/features/user/presentation/bloc/profile_bloc/profile_state.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  group('ProfileBloc', () {
    late MockUserRepository repository;

    setUp(() {
      repository = MockUserRepository();
    });

    final user = User(
      id: 1,
      name: 'Emily Johnson',
      company: 'ABC Corporation',
      username: 'emily_johnson',
      email: 'emily.johnson@abccorporation.com',
      address: '123 Main St',
      zip: '12345',
      state: 'California',
      country: 'USA',
      phone: '+1-555-123-4567',
      photo:
          'https://cdn.pixabay.com/photo/2012/04/13/21/07/user-33638_1280.png',
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits [loading, loaded] when fetchUserById succeeds',
      build: () {
        when(() => repository.fetchUserById(1)).thenAnswer((_) async => user);
        return ProfileBloc(repository);
      },
      act: (bloc) => bloc.add(LoadProfile(1)),
      expect: () => [
        const ProfileState(isLoading: true, user: null, error: null),
        ProfileState(isLoading: false, user: user, error: null),
      ],
      verify: (_) => verify(() => repository.fetchUserById(1)).called(1),
    );

    blocTest<ProfileBloc, ProfileState>(
      'emits [loading, error] when fetchUserById throws',
      build: () {
        when(
          () => repository.fetchUserById(1),
        ).thenThrow(Exception('network error'));
        return ProfileBloc(repository);
      },
      act: (bloc) => bloc.add(LoadProfile(1)),
      expect: () => const [
        ProfileState(isLoading: true, user: null, error: null),
        ProfileState(
          isLoading: false,
          user: null,
          error: 'Exception: network error',
        ),
      ],
    );
  });
}
