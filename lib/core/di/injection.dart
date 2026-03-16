import 'package:get_it/get_it.dart';

import 'package:learn_hub/features/company/domain/repositories/company_repository.dart';
import 'package:learn_hub/features/company/data/repositories/company_repository_impl.dart';
import 'package:learn_hub/features/auth/domain/repositories/login_repository.dart';
import 'package:learn_hub/features/auth/data/repositories/login_repository_impl.dart';
import 'package:learn_hub/features/user/domain/repositories/user_repository.dart';
import 'package:learn_hub/features/user/data/repositories/user_repository_impl.dart';
import 'package:learn_hub/core/network/api_service.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Services
  getIt.registerLazySingleton<ApiService>(() => ApiService());

  // Repositories
  getIt.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<CompanyRepository>(
    () => CompanyRepositoryImpl(getIt<ApiService>()),
  );
  getIt.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImpl(getIt<ApiService>()),
  );
}
