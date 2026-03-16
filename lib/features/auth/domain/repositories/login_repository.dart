abstract class LoginRepository {
  Future<Map<String, dynamic>> login(String userName, String password);
}
