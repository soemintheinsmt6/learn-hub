import 'package:flutter_test/flutter_test.dart';
import 'package:learn_hub/features/company/domain/entities/company.dart';

void main() {
  group('Company', () {
    final json = {
      'id': 1,
      'name': 'ABC Corporation',
      'address': '123 Main St',
      'zip': '12345',
      'country': 'USA',
      'employeeCount': 500,
      'industry': 'Technology',
      'marketCap': 1000000,
      'domain': 'abc.com',
      'logo': 'https://example.com/logo.png',
      'ceoName': 'John Smith',
    };

    test('fromJson creates Company with correct fields', () {
      final company = Company.fromJson(json);

      expect(company.id, 1);
      expect(company.name, 'ABC Corporation');
      expect(company.address, '123 Main St');
      expect(company.zip, '12345');
      expect(company.country, 'USA');
      expect(company.employeeCount, 500);
      expect(company.industry, 'Technology');
      expect(company.marketCap, 1000000);
      expect(company.domain, 'abc.com');
      expect(company.logo, 'https://example.com/logo.png');
      expect(company.ceoName, 'John Smith');
    });

    test('toJson returns correct map', () {
      final company = Company.fromJson(json);
      final result = company.toJson();

      expect(result, json);
    });

    test('fromJson and toJson are symmetric', () {
      final company = Company.fromJson(json);
      final roundTripped = Company.fromJson(company.toJson());

      expect(roundTripped.id, company.id);
      expect(roundTripped.name, company.name);
      expect(roundTripped.address, company.address);
      expect(roundTripped.zip, company.zip);
      expect(roundTripped.country, company.country);
      expect(roundTripped.employeeCount, company.employeeCount);
      expect(roundTripped.industry, company.industry);
      expect(roundTripped.marketCap, company.marketCap);
      expect(roundTripped.domain, company.domain);
      expect(roundTripped.logo, company.logo);
      expect(roundTripped.ceoName, company.ceoName);
    });

    test('fullAddress combines address, zip, and country', () {
      final company = Company.fromJson(json);

      expect(company.fullAddress, '123 Main St, 12345, USA');
    });

    test('placeHolder has default empty/zero values', () {
      final placeholder = Company.placeHolder;

      expect(placeholder.id, 0);
      expect(placeholder.name, '');
      expect(placeholder.address, '');
      expect(placeholder.zip, '');
      expect(placeholder.country, '');
      expect(placeholder.employeeCount, 0);
      expect(placeholder.industry, '');
      expect(placeholder.marketCap, 0);
      expect(placeholder.domain, '');
      expect(placeholder.logo, '');
      expect(placeholder.ceoName, '');
    });
  });
}
