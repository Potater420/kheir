import '../models/user_model.dart';

/// Talks to the auth backend. Implementations throw a FailureException
/// (never an SDK exception) so the repository stays backend-agnostic.
abstract interface class AuthRemoteDataSource {
  Future<UserModel?> getCurrentUser();

  Future<UserModel> login({
    required String email,
    required String password,
  });

  Future<UserModel> register({
    required String fullName,
    required String email,
    required String password,
    String? phone,
  });

  Future<void> logout();
}
