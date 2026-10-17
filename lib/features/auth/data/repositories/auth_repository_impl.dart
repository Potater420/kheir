import '../../../../core/error/failure_exception.dart';
import '../../../../core/utils/results.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._remote);

  final AuthRemoteDataSource _remote;

  @override
  Future<Result<AppUser?>> getCurrentUser() {
    return _guard<AppUser?>(_remote.getCurrentUser);
  }

  @override
  Future<Result<AppUser>> login({
    required String email,
    required String password,
  }) {
    return _guard<AppUser>(
      () => _remote.login(email: email, password: password),
    );
  }

  @override
  Future<Result<AppUser>> register({
    required String fullName,
    required String email,
    required String password,
    String? phone,
  }) {
    return _guard<AppUser>(
      () => _remote.register(
        fullName: fullName,
        email: email,
        password: password,
        phone: phone,
      ),
    );
  }

  @override
  Future<Result<void>> logout() {
    return _guard<void>(() async {
      await _remote.logout();
    });
  }

  Future<Result<T>> _guard<T>(Future<T> Function() action) async {
    try {
      return Success(await action());
    } on FailureException catch (error) {
      return Err(error.failure);
    }
  }
}
