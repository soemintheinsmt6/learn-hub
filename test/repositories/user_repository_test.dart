import 'package:flutter_test/flutter_test.dart';
import 'package:learn_hub/features/user/domain/entities/user.dart';
import 'package:learn_hub/features/user/data/repositories/user_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

import '../mock_api.dart';

void main() {
  group('UserRepositoryImpl', () {
    late MockApiService api;
    late UserRepositoryImpl repository;

    setUp(() {
      api = MockApiService();
      repository = UserRepositoryImpl(api);
    });

    test('fetchUsers returns list of User from api response', () async {
      final json = [
        {
          'id': 1,
          'name': 'Alice',
          'company': 'Acme',
          'username': 'alice',
          'email': 'alice@example.com',
          'address': '123 Street',
          'zip': '12345',
          'state': 'CA',
          'country': 'USA',
          'phone': '1234567890',
          'photo': null,
        },
      ];

      when(() => api.get('users')).thenAnswer((_) async => json);

      final users = await repository.fetchUsers();

      expect(users, isA<List<User>>());
      expect(users.length, 1);
      expect(users.first.name, 'Alice');
      expect(users.first.company, 'Acme');
      verify(() => api.get('users')).called(1);
    });

    test('fetchUsers returns empty list when api returns empty list', () async {
      when(() => api.get('users')).thenAnswer((_) async => []);

      final users = await repository.fetchUsers();

      expect(users, isA<List<User>>());
      expect(users, isEmpty);
      verify(() => api.get('users')).called(1);
    });

    test('fetchUsers throws when api.get throws', () async {
      when(() => api.get('users')).thenThrow(Exception('network error'));

      expect(
        () => repository.fetchUsers(),
        throwsA(isA<Exception>()),
      );
      verify(() => api.get('users')).called(1);
    });

    test('fetchUserById returns a single User from api response', () async {
      final json = {
        'id': 1,
        'name': 'Emily Johnson',
        'company': 'ABC Corporation',
        'username': 'emily_johnson',
        'email': 'emily.johnson@abccorporation.com',
        'address': '123 Main St',
        'zip': '12345',
        'state': 'California',
        'country': 'USA',
        'phone': '+1-555-123-4567',
        'photo':
            'https://cdn.pixabay.com/photo/2012/04/13/21/07/user-33638_1280.png',
      };

      when(() => api.get('users/1')).thenAnswer((_) async => json);

      final user = await repository.fetchUserById(1);

      expect(user, isA<User>());
      expect(user.name, 'Emily Johnson');
      expect(user.email, 'emily.johnson@abccorporation.com');
      verify(() => api.get('users/1')).called(1);
    });

    test('fetchUserById throws when api.get throws', () async {
      when(() => api.get('users/1')).thenThrow(Exception('not found'));

      expect(
        () => repository.fetchUserById(1),
        throwsA(isA<Exception>()),
      );
      verify(() => api.get('users/1')).called(1);
    });
  });
}
