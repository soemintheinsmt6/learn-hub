import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learn_hub/features/company/domain/entities/company.dart';
import 'package:learn_hub/features/company/domain/repositories/company_repository.dart';
import 'package:learn_hub/features/company/presentation/screens/company_list.dart';
import 'package:learn_hub/features/company/presentation/widgets/company_tile.dart';
import 'package:mocktail/mocktail.dart';

class MockCompanyRepository extends Mock implements CompanyRepository {}

void main() {
  group('CompanyList widget', () {
    testWidgets('shows list of companies when loading completes', (
      tester,
    ) async {
      final repository = MockCompanyRepository();

      final companies = [
        Company(
          id: 1,
          name: 'ABC Corporation',
          address: '1 Infinite Loop',
          zip: '95014',
          country: 'USA',
          employeeCount: 500,
          industry: 'Technology',
          marketCap: 1000000,
          domain: 'abc.com',
          logo: 'logo.png',
          ceoName: 'John Smith',
        ),
      ];

      when(
        () => repository.fetchCompanies(),
      ).thenAnswer((_) async => companies);

      await tester.pumpWidget(
        MaterialApp(home: CompanyList(repository: repository)),
      );

      await tester.pumpAndSettle();

      expect(find.text('Company List'), findsOneWidget);
      expect(find.byType(CompanyTile), findsWidgets);
      expect(find.text('ABC Corporation'), findsOneWidget);
    });
  });
}
