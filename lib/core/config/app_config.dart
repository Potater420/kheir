/// Build-time settings. Override the server with
/// `--dart-define=API_BASE_URL=https://staging.example.com/api/v1`.
abstract final class AppConfig {
  /// Digits in the email verification code. Postman's example is 4 digits and
  /// the Figma OTP screen shows 6. Change this one number to match the server.
  static const int otpLength = 4;
  static const int otpResendSeconds = 60;
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://wecare.manfazy.com/api/v1',
  );

  /// The API requires a push token at login. Real FCM arrives in Phase 4.
  static const String pushTokenPlaceholder = 'placeholder-push-token';
}
