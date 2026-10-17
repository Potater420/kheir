import '../../../../core/utils/results.dart';
import '../repositories/auth_repository.dart';

class LogoutUser {
  const LogoutUser(this._repository);

  final AuthRepository _repository;

  Future<Result<void>> call() => _repository.logout();
}
