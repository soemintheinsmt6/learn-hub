import 'package:learn_hub/core/network/api_endpoint.dart';
import 'package:learn_hub/core/network/api_client.dart';
import 'package:learn_hub/features/auth/domain/repositories/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final ApiClient api;

  LoginRepositoryImpl(this.api);

  @override
  Future<Map<String, dynamic>> login(String userName, String password) {
    return api.post(
      ApiEndpoint.login,
      body: {"user_name": userName, "password": password},
      isRequiredToken: false,
    );
  }
}
