import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learn_hub/features/company/domain/entities/company.dart';
import 'package:learn_hub/features/company/domain/repositories/company_repository.dart';
import 'package:learn_hub/features/company/presentation/bloc/company_bloc/company_bloc.dart';
import 'package:learn_hub/features/company/presentation/bloc/company_bloc/company_event.dart';
import 'package:learn_hub/features/company/presentation/bloc/company_bloc/company_state.dart';
import 'package:mocktail/mocktail.dart';

class MockCompanyRepository extends Mock implements CompanyRepository {}

void main() {
  group('CompanyBloc', () {
    late MockCompanyRepository repository;

    setUp(() {
      repository = MockCompanyRepository();
    });

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

    blocTest<CompanyBloc, CompanyState>(
      'emits [loading, loaded] when fetchCompanies succeeds',
      build: () {
        when(
          () => repository.fetchCompanies(),
        ).thenAnswer((_) async => companies);
        return CompanyBloc(repository);
      },
      act: (bloc) => bloc.add(LoadCompanies()),
      expect: () => [
        const CompanyState(isLoading: true, companies: [], error: null),
        CompanyState(isLoading: false, companies: companies, error: null),
      ],
      verify: (_) => verify(() => repository.fetchCompanies()).called(1),
    );

    blocTest<CompanyBloc, CompanyState>(
      'emits [loading, error] when fetchCompanies throws',
      build: () {
        when(
          () => repository.fetchCompanies(),
        ).thenThrow(Exception('network error'));
        return CompanyBloc(repository);
      },
      act: (bloc) => bloc.add(LoadCompanies()),
      expect: () => [
        const CompanyState(isLoading: true, companies: [], error: null),
        const CompanyState(
          isLoading: false,
          companies: [],
          error: 'Exception: network error',
        ),
      ],
    );
  });
}
