import 'package:flutter_test/flutter_test.dart';
import 'package:learn_hub/core/network/api_endpoint.dart';
import 'package:learn_hub/features/company/domain/entities/company.dart';
import 'package:learn_hub/features/company/data/repositories/company_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

import '../mock_api.dart';

void main() {
  group('CompanyRepositoryImpl', () {
    late MockApiService api;
    late CompanyRepositoryImpl repository;

    setUp(() {
      api = MockApiService();
      repository = CompanyRepositoryImpl(api);
    });

    test('fetchCompanies returns list of Company from api response', () async {
      final json = [
        {
          'id': 1,
          'name': 'ABC Corporation',
          'address': '1 Infinite Loop',
          'zip': '95014',
          'country': 'USA',
          'employeeCount': 500,
          'industry': 'Technology',
          'marketCap': 1000000,
          'domain': 'abc.com',
          'logo': 'logo.png',
          'ceoName': 'John Smith',
        },
      ];

      when(() => api.get(ApiEndpoint.companies)).thenAnswer((_) async => json);

      final companies = await repository.fetchCompanies();

      expect(companies, isA<List<Company>>());
      expect(companies.length, 1);
      expect(companies.first.name, 'ABC Corporation');
      expect(companies.first.ceoName, 'John Smith');
      verify(() => api.get(ApiEndpoint.companies)).called(1);
    });

    test('fetchCompanies returns empty list when api returns empty list',
        () async {
      when(() => api.get(ApiEndpoint.companies)).thenAnswer((_) async => []);

      final companies = await repository.fetchCompanies();

      expect(companies, isA<List<Company>>());
      expect(companies, isEmpty);
      verify(() => api.get(ApiEndpoint.companies)).called(1);
    });

    test('fetchCompanies throws when api.get throws', () async {
      when(() => api.get(ApiEndpoint.companies)).thenThrow(Exception('network error'));

      expect(
        () => repository.fetchCompanies(),
        throwsA(isA<Exception>()),
      );
      verify(() => api.get(ApiEndpoint.companies)).called(1);
    });

    test('fetchCompanyById returns a single Company from api response',
        () async {
      final json = {
        'id': 1,
        'name': 'ABC Corporation',
        'address': '123 Main St',
        'zip': '12345',
        'country': 'USA',
        'employeeCount': 2,
        'industry': 'Technology',
        'marketCap': 1000000000,
        'domain': 'abccorp.com',
        'logo': 'https://example.com/logo1.png',
        'ceoName': 'Maritza Feeney',
      };

      when(() => api.get(ApiEndpoint.companyById(1))).thenAnswer((_) async => json);

      final company = await repository.fetchCompanyById(1);

      expect(company, isA<Company>());
      expect(company.name, 'ABC Corporation');
      expect(company.ceoName, 'Maritza Feeney');
      verify(() => api.get(ApiEndpoint.companyById(1))).called(1);
    });

    test('fetchCompanyById throws when api.get throws', () async {
      when(() => api.get(ApiEndpoint.companyById(1))).thenThrow(Exception('not found'));

      expect(
        () => repository.fetchCompanyById(1),
        throwsA(isA<Exception>()),
      );
      verify(() => api.get(ApiEndpoint.companyById(1))).called(1);
    });
  });
}
