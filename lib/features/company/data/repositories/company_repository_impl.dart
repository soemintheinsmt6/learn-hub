import 'package:learn_hub/features/company/domain/entities/company.dart';
import 'package:learn_hub/core/network/api_service.dart';
import 'package:learn_hub/features/company/domain/repositories/company_repository.dart';

class CompanyRepositoryImpl implements CompanyRepository {
  final ApiService api;

  CompanyRepositoryImpl(this.api);

  @override
  Future<List<Company>> fetchCompanies() async {
    final response = await api.get('companies');

    final companies =
        (response as List).map((e) => Company.fromJson(e)).toList();

    return companies;
  }

  @override
  Future<Company> fetchCompanyById(int id) async {
    final response = await api.get('companies/$id');

    return Company.fromJson(response as Map<String, dynamic>);
  }
}
