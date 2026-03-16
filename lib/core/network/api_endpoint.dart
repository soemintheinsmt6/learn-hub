class ApiEndpoint {
  ApiEndpoint._();

  static const String login = 'login';
  static const String users = 'users';
  static const String companies = 'companies';

  static String userById(int id) => 'users/$id';
  static String companyById(int id) => 'companies/$id';
}