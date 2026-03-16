import 'package:flutter_test/flutter_test.dart';
import 'package:learn_hub/features/onboarding/domain/entities/on_board.dart';

void main() {
  group('OnBoard', () {
    test('list contains five items', () {
      expect(OnBoard.list.length, 5);
    });

    test('each item has non-empty image, title, and desc', () {
      for (final item in OnBoard.list) {
        expect(item.image, isNotEmpty);
        expect(item.title, isNotEmpty);
        expect(item.desc, isNotEmpty);
      }
    });
  });
}

