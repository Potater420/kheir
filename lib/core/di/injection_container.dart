import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/datasources/firebase_auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/get_current_user.dart';
import '../../features/auth/domain/usecases/login_user.dart';
import '../../features/auth/domain/usecases/logout_user.dart';
import '../../features/auth/domain/usecases/register_user.dart';

/// The app's service locator. Features register their classes here,
/// which is the one place that decides which implementation is used
/// (for example Firebase now, the Laravel API later).
final GetIt sl = GetIt.instance;

Future<void> initDependencies() async {
  _registerAuth();
}

void _registerAuth() {
  sl
    // To move to the API, register a different AuthRemoteDataSource here.
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => FirebaseAuthRemoteDataSource(
        auth: FirebaseAuth.instance,
        firestore: FirebaseFirestore.instance,
      ),
    )
    ..registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()))
    ..registerLazySingleton(() => GetCurrentUser(sl()))
    ..registerLazySingleton(() => LoginUser(sl()))
    ..registerLazySingleton(() => LogoutUser(sl()))
    ..registerLazySingleton(() => RegisterUser(sl()));
}
