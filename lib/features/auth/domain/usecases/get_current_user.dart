import '../../../../core/utils/results.dart';
import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class GetCurrentUser {
  const GetCurrentUser(this._repository);

  final AuthRepository _repository;

  Future<Result<AppUser?>> call() => _repository.getCurrentUser();
}
