import '../../../../core/utils/results.dart';
import '../repositories/auth_repository.dart';

class RequestRegistrationCode {
  const RequestRegistrationCode(this._repository);

  final AuthRepository _repository;

  Future<Result<void>> call({required String email, required String phone}) {
    return _repository.requestRegistrationCode(email: email, phone: phone);
  }
}