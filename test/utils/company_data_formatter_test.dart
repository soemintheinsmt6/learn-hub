import 'package:flutter_test/flutter_test.dart';
import 'package:learn_hub/core/utils/company_data_formatter.dart';

void main() {
  group('formatEmployees', () {
    test('returns exact count when below 1000', () {
      expect(formatEmployees(0), '0');
      expect(formatEmployees(5), '5');
      expect(formatEmployees(999), '999');
    });

    test('formats thousands with comma and plus suffix', () {
      expect(formatEmployees(1000), '1,000+');
      expect(formatEmployees(1500), '2,000+');
      expect(formatEmployees(25000), '25,000+');
    });
  });

  group('formatMarketCap', () {
    test('formats values below 1M as plain dollars', () {
      expect(formatMarketCap(0), '\$0');
      expect(formatMarketCap(500000), '\$500000');
    });

    test('formats values between 1M and 1B as millions', () {
      expect(formatMarketCap(1000000), '\$1.0M');
      expect(formatMarketCap(2500000), '\$2.5M');
      expect(formatMarketCap(125000000), '\$125.0M');
    });

    test('formats values from 1B and above as billions', () {
      expect(formatMarketCap(1000000000), '\$1.0B');
      expect(formatMarketCap(2500000000), '\$2.5B');
    });
  });
}
