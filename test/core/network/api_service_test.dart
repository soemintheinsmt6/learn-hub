import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:learn_hub/core/error/api_exception.dart';
import 'package:learn_hub/core/network/api_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  group('ApiService', () {
    late ApiService apiService;
    late MockFlutterSecureStorage mockStorage;

    setUpAll(() {
      dotenv.loadFromString(envString: 'BASE_URL=http://localhost:3000');
    });

    setUp(() {
      mockStorage = MockFlutterSecureStorage();
      apiService = ApiService();
      apiService.storage = mockStorage;
    });

    group('handleResponse', () {
      test('returns decoded data for 200 status', () {
        final response = http.Response(
          jsonEncode({'key': 'value'}),
          200,
        );

        final result = apiService.handleResponse(response, 'test');

        expect(result, {'key': 'value'});
      });

      test('returns decoded data for 201 status', () {
        final response = http.Response(
          jsonEncode({'created': true}),
          201,
        );

        final result = apiService.handleResponse(response, 'test');

        expect(result, {'created': true});
      });

      test('returns decoded list for 200 status', () {
        final response = http.Response(
          jsonEncode([
            {'id': 1},
            {'id': 2},
          ]),
          200,
        );

        final result = apiService.handleResponse(response, 'test');

        expect(result, isList);
        expect(result.length, 2);
      });

      test('throws ApiException for 400 status with message', () {
        final response = http.Response(
          jsonEncode({'message': 'Bad request'}),
          400,
        );

        expect(
          () => apiService.handleResponse(response, 'test'),
          throwsA(
            isA<ApiException>()
                .having((e) => e.message, 'message', 'Bad request'),
          ),
        );
      });

      test('throws ApiException for 401 status', () {
        final response = http.Response(
          jsonEncode({'message': 'Unauthorized'}),
          401,
        );

        expect(
          () => apiService.handleResponse(response, 'auth'),
          throwsA(isA<ApiException>()),
        );
      });

      test('throws ApiException for 500 status with fallback message', () {
        final response = http.Response(
          jsonEncode({}),
          500,
        );

        expect(
          () => apiService.handleResponse(response, 'users'),
          throwsA(
            isA<ApiException>().having(
              (e) => e.message,
              'message',
              'Failed to request users: status code: 500',
            ),
          ),
        );
      });

      test('throws ApiException for 404 status', () {
        final response = http.Response(
          jsonEncode({'message': 'Not found'}),
          404,
        );

        expect(
          () => apiService.handleResponse(response, 'users/99'),
          throwsA(
            isA<ApiException>()
                .having((e) => e.message, 'message', 'Not found'),
          ),
        );
      });
    });

    group('getHeaders', () {
      test('returns base headers when token not required', () async {
        final headers = await apiService.getHeaders(false);

        expect(headers['Content-Type'], 'application/json');
        expect(headers['Accept'], 'application/json');
        expect(headers.containsKey('Authorization'), false);
      });

      test('includes Authorization when token is available', () async {
        when(() => mockStorage.read(key: 'token'))
            .thenAnswer((_) async => 'my-token');

        final headers = await apiService.getHeaders(true);

        expect(headers['Authorization'], 'Bearer my-token');
        expect(headers['Content-Type'], 'application/json');
      });

      test('omits Authorization when token is null', () async {
        when(() => mockStorage.read(key: 'token'))
            .thenAnswer((_) async => null);

        final headers = await apiService.getHeaders(true);

        expect(headers.containsKey('Authorization'), false);
      });
    });
  });
}
