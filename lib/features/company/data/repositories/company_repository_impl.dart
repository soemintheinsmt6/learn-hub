import 'package:learn_hub/core/error/api_exception.dart';
import 'package:learn_hub/core/network/api_endpoint.dart';
import 'package:learn_hub/core/network/api_client.dart';
import 'package:learn_hub/features/company/domain/entities/company.dart';
import 'package:learn_hub/features/company/domain/repositories/company_repository.dart';

class CompanyRepositoryImpl implements CompanyRepository {
  final ApiClient api;

  CompanyRepositoryImpl(this.api);

  @override
  Future<List<Company>> fetchCompanies() async {
    try {
      final response = await api.get(ApiEndpoint.companies);

      final companies =
          (response as List).map((e) => Company.fromJson(e)).toList();

      return companies;
    } on TypeError catch (e) {
      throw ApiException('Unexpected companies response structure: $e');
    }
  }

  @override
  Future<Company> fetchCompanyById(int id) async {
    try {
      final response = await api.get(ApiEndpoint.companyById(id));

      return Company.fromJson(response as Map<String, dynamic>);
    } on TypeError catch (e) {
      throw ApiException('Unexpected company response structure: $e');
    }
  }
}
