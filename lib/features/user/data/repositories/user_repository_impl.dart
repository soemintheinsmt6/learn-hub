import 'package:learn_hub/core/error/api_exception.dart';
import 'package:learn_hub/core/network/api_endpoint.dart';
import 'package:learn_hub/core/network/api_client.dart';
import 'package:learn_hub/features/user/domain/entities/user.dart';
import 'package:learn_hub/features/user/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final ApiClient api;

  UserRepositoryImpl(this.api);

  @override
  Future<List<User>> fetchUsers() async {
    try {
      final response = await api.get(ApiEndpoint.users);

      final users = (response as List).map((e) => User.fromJson(e)).toList();

      return users;
    } on TypeError catch (e) {
      throw ApiException('Unexpected users response structure: $e');
    }
  }

  @override
  Future<User> fetchUserById(int id) async {
    try {
      final response = await api.get(ApiEndpoint.userById(id));

      return User.fromJson(response as Map<String, dynamic>);
    } on TypeError catch (e) {
      throw ApiException('Unexpected user response structure: $e');
    }
  }
}
