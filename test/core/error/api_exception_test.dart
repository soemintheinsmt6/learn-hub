import 'package:flutter_test/flutter_test.dart';
import 'package:learn_hub/core/error/api_exception.dart';

void main() {
  group('ApiException', () {
    test('stores message correctly', () {
      final exception = ApiException('Something went wrong');

      expect(exception.message, 'Something went wrong');
    });

    test('toString returns the message', () {
      final exception = ApiException('Network error');

      expect(exception.toString(), 'Network error');
    });

    test('implements Exception', () {
      final exception = ApiException('error');

      expect(exception, isA<Exception>());
    });

    test('can be thrown and caught', () {
      expect(
        () => throw ApiException('test error'),
        throwsA(isA<ApiException>()),
      );
    });

    test('caught exception preserves message', () {
      try {
        throw ApiException('preserved message');
      } on ApiException catch (e) {
        expect(e.message, 'preserved message');
        return;
      }
    });
  });
}
