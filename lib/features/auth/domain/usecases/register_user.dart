import '../../../../core/utils/results.dart';
import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class RegisterUser {
  const RegisterUser(this._repository);

  final AuthRepository _repository;

  Future<Result<AppUser>> call({
    required String fullName,
    required String email,
    required String password,
    String? phone,
  }) {
    return _repository.register(
      fullName: fullName,
      email: email,
      password: password,
      phone: phone,
    );
  }
}
