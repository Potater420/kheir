import '../../../../core/utils/results.dart';
import '../entities/app_user.dart';

/// What the app needs from authentication. The data layer decides how it
/// is done, so nothing here changes when the backend does.
abstract interface class AuthRepository {
  /// The signed-in user, or null inside [Success] when nobody is signed in.
  Future<Result<AppUser?>> getCurrentUser();

  /// [identifier] is an email address or a phone number.
  Future<Result<AppUser>> login({
    required String identifier,
    required String password,
  });

  /// Step 1 of registering: checks the email and phone are free and sends
  /// a verification code to the email.
  Future<Result<void>> requestRegistrationCode({
    required String email,
    required String phone,
  });

  /// Step 2: creates the account with the emailed [code] and signs in.
  Future<Result<AppUser>> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String code,
  });

  Future<Result<void>> logout();
}