import 'package:learn_hub/core/network/api_service.dart';
import 'package:learn_hub/features/auth/domain/repositories/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final ApiService api;

  LoginRepositoryImpl(this.api);

  @override
  Future<Map<String, dynamic>> login(String userName, String password) {
    return api.post(
      'login',
      body: {"user_name": userName, "password": password},
      isRequiredToken: false,
    );
  }
}
