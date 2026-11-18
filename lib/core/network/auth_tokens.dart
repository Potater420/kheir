/// The access/refresh token pair returned by login and refresh.
class AuthTokens {
  const AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    required this.accessExpiresAt,
    required this.refreshExpiresAt,
  });

  /// Reads the `data` object of a login or refresh response.
  factory AuthTokens.fromJson(Map<String, dynamic> data) {
    final access = data['access_token'];
    final refresh = data['refresh_token'];
    if (access is! String || access.isEmpty || refresh is! String) {
      throw const FormatException('Tokens missing from response');
    }
    final now = DateTime.now().toUtc();
    final expiresIn = (data['expires_in'] as num?)?.toInt() ?? 3600;
    return AuthTokens(
      accessToken: access,
      refreshToken: refresh,
      accessExpiresAt: DateTime.tryParse(
            data['access_token_expires_at'] as String? ?? '',
          )?.toUtc() ??
          now.add(Duration(seconds: expiresIn)),
      refreshExpiresAt: DateTime.tryParse(
            data['refresh_token_expires_at'] as String? ?? '',
          )?.toUtc() ??
          now.add(const Duration(days: 30)),
    );
  }

  final String accessToken;
  final String refreshToken;
  final DateTime accessExpiresAt;
  final DateTime refreshExpiresAt;

  /// True when the access token is expired or about to be (within a minute).
  bool get accessNeedsRefresh => DateTime.now().toUtc().isAfter(
        accessExpiresAt.subtract(const Duration(minutes: 1)),
      );

  bool get refreshExpired => DateTime.now().toUtc().isAfter(refreshExpiresAt);
}