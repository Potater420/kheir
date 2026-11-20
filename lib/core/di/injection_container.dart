import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/datasources/laravel_auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_current_user.dart';
import '../../features/auth/domain/usecases/login_user.dart';
import '../../features/auth/domain/usecases/logout_user.dart';
import '../../features/auth/domain/usecases/register_user.dart';
import '../../features/auth/domain/usecases/request_registration_code.dart';
import '../network/api_client.dart';
import '../network/session_events.dart';
import '../storage/token_storage.dart';

/// The app's service locator. Features register their classes here,
/// which is the one place that decides which implementation is used.
final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  _registerCore();
  _registerAuth();
}

void _registerCore() {
  sl
    ..registerLazySingleton<FlutterSecureStorage>(FlutterSecureStorage.new)
    ..registerLazySingleton<TokenStorage>(() => TokenStorage(sl()))
    ..registerLazySingleton<SessionEvents>(SessionEvents.new)
    ..registerLazySingleton<ApiClient>(
      () => ApiClient(storage: sl(), events: sl()),
    );
}

void _registerAuth() {
  sl
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => LaravelAuthRemoteDataSource(api: sl(), storage: sl()),
    )
    ..registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()))
    ..registerLazySingleton(() => GetCurrentUser(sl()))
    ..registerLazySingleton(() => LoginUser(sl()))
    ..registerLazySingleton(() => LogoutUser(sl()))
    ..registerLazySingleton(() => RegisterUser(sl()))
    ..registerLazySingleton(() => RequestRegistrationCode(sl()));
}
