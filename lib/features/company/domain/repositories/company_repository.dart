import 'package:learn_hub/features/company/domain/entities/company.dart';

abstract class CompanyRepository {
  Future<List<Company>> fetchCompanies();
  Future<Company> fetchCompanyById(int id);
}
