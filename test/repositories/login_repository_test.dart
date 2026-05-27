import 'package:flutter_test/flutter_test.dart';
import 'package:learn_hub/core/network/api_endpoint.dart';
import 'package:learn_hub/features/auth/data/repositories/login_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

import '../mock_api.dart';

void main() {
  group('LoginRepositoryImpl', () {
    late MockApiClient api;
    late LoginRepositoryImpl repository;

    setUp(() {
      api = MockApiClient();
      repository = LoginRepositoryImpl(api);
    });

    test('login delegates to ApiClient.post with correct payload', () async {
      const userName = 'john';
      const password = 'secret';
      final response = {'token': 'abc'};

      when(
        () => api.post(
          ApiEndpoint.login,
          body: any(named: 'body'),
          isRequiredToken: false,
        ),
      ).thenAnswer((_) async => response);

      final result = await repository.login(userName, password);

      expect(result, response);
      verify(
        () => api.post(
          ApiEndpoint.login,
          body: {'user_name': userName, 'password': password},
          isRequiredToken: false,
        ),
      ).called(1);
    });

    test('login propagates exception when ApiClient.post throws', () async {
      const userName = 'john';
      const password = 'secret';

      when(
        () => api.post(
          ApiEndpoint.login,
          body: any(named: 'body'),
          isRequiredToken: false,
        ),
      ).thenThrow(Exception('network error'));

      expect(
        () => repository.login(userName, password),
        throwsA(isA<Exception>()),
      );
      verify(
        () => api.post(
          ApiEndpoint.login,
          body: any(named: 'body'),
          isRequiredToken: false,
        ),
      ).called(1);
    });
  });
}
