import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learn_hub/features/company/presentation/bloc/company_details_bloc/company_details_bloc.dart';
import 'package:learn_hub/features/company/presentation/bloc/company_details_bloc/company_details_event.dart';
import 'package:learn_hub/features/company/presentation/bloc/company_details_bloc/company_details_state.dart';
import 'package:learn_hub/features/company/domain/entities/company.dart';
import 'package:learn_hub/features/company/domain/repositories/company_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockCompanyRepository extends Mock implements CompanyRepository {}

void main() {
  group('CompanyDetailsBloc', () {
    late MockCompanyRepository repository;

    setUp(() {
      repository = MockCompanyRepository();
    });

    final company = Company(
      id: 1,
      name: 'ABC Corporation',
      address: '123 Main St',
      zip: '12345',
      country: 'USA',
      employeeCount: 2,
      industry: 'Technology',
      marketCap: 1000000000,
      domain: 'abccorp.com',
      logo: 'https://example.com/logo1.png',
      ceoName: 'Maritza Feeney',
    );

    test('initial state is not loading and has no company', () {
      final bloc = CompanyDetailsBloc(repository);

      expect(
        bloc.state,
        const CompanyDetailsState(isLoading: false, company: null, error: null),
      );
    });

    blocTest<CompanyDetailsBloc, CompanyDetailsState>(
      'emits [loading, loaded] when fetchCompanyById succeeds',
      build: () {
        when(
          () => repository.fetchCompanyById(1),
        ).thenAnswer((_) async => company);
        return CompanyDetailsBloc(repository);
      },
      act: (bloc) => bloc.add(LoadCompanyDetails(1)),
      expect: () => [
        const CompanyDetailsState(isLoading: true, company: null, error: null),
        CompanyDetailsState(isLoading: false, company: company, error: null),
      ],
      verify: (_) => verify(() => repository.fetchCompanyById(1)).called(1),
    );

    blocTest<CompanyDetailsBloc, CompanyDetailsState>(
      'emits [loading, error] when fetchCompanyById throws',
      build: () {
        when(
          () => repository.fetchCompanyById(1),
        ).thenThrow(Exception('network error'));
        return CompanyDetailsBloc(repository);
      },
      act: (bloc) => bloc.add(LoadCompanyDetails(1)),
      expect: () => const [
        CompanyDetailsState(isLoading: true, company: null, error: null),
        CompanyDetailsState(
          isLoading: false,
          company: null,
          error: 'Exception: network error',
        ),
      ],
    );
  });
}
