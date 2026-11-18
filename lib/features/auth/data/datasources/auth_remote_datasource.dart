import '../models/user_model.dart';

/// Talks to the auth backend. Implementations throw a FailureException
/// (never an SDK exception) so the repository stays backend-agnostic.
abstract interface class AuthRemoteDataSource {
  Future<UserModel?> getCurrentUser();

  /// [identifier] is an email address or a phone number.
  Future<UserModel> login({
    required String identifier,
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