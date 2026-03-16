import 'package:learn_hub/features/user/domain/entities/user.dart';
import 'package:learn_hub/core/network/api_service.dart';
import 'package:learn_hub/features/user/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final ApiService api;

  UserRepositoryImpl(this.api);

  @override
  Future<List<User>> fetchUsers() async {
    final response = await api.get('users');

    final users = (response as List).map((e) => User.fromJson(e)).toList();

    return users;
  }

  @override
  Future<User> fetchUserById(int id) async {
    final response = await api.get('users/$id');

    return User.fromJson(response as Map<String, dynamic>);
  }
}
