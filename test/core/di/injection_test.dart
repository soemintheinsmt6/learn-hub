import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:learn_hub/core/di/injection.dart';
import 'package:learn_hub/core/network/api_client.dart';
import 'package:learn_hub/features/auth/domain/repositories/login_repository.dart';
import 'package:learn_hub/features/company/domain/repositories/company_repository.dart';
import 'package:learn_hub/features/user/domain/repositories/user_repository.dart';

void main() {
  group('setupDependencies', () {
    setUpAll(() {
      dotenv.loadFromString(envString: 'BASE_URL=http://localhost:3000');
    });

    setUp(() {
      GetIt.instance.reset();
      setupDependencies();
    });

    tearDown(() {
      GetIt.instance.reset();
    });

    test('registers ApiClient as lazy singleton', () {
      expect(getIt.isRegistered<ApiClient>(), true);

      final a = getIt<ApiClient>();
      final b = getIt<ApiClient>();
      expect(identical(a, b), true);
    });

    test('registers UserRepository as lazy singleton', () {
      expect(getIt.isRegistered<UserRepository>(), true);

      final a = getIt<UserRepository>();
      final b = getIt<UserRepository>();
      expect(identical(a, b), true);
    });

    test('registers CompanyRepository as lazy singleton', () {
      expect(getIt.isRegistered<CompanyRepository>(), true);

      final a = getIt<CompanyRepository>();
      final b = getIt<CompanyRepository>();
      expect(identical(a, b), true);
    });

    test('registers LoginRepository as lazy singleton', () {
      expect(getIt.isRegistered<LoginRepository>(), true);

      final a = getIt<LoginRepository>();
      final b = getIt<LoginRepository>();
      expect(identical(a, b), true);
    });
  });
}
