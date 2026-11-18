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

  Future<Result<AppUser>> register({
    required String fullName,
    required String email,
    required String password,
    String? phone,
  });

  Future<Result<void>> logout();
}