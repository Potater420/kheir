import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

import '../network/auth_tokens.dart';

/// Keeps the tokens, the cached user and the device id in the phone's
/// secure storage (Keystore on Android, Keychain on iOS).
class TokenStorage {
  const TokenStorage(this._storage);

  final FlutterSecureStorage _storage;

  static const _access = 'access_token';
  static const _refresh = 'refresh_token';
  static const _accessExpiry = 'access_expires_at';
  static const _refreshExpiry = 'refresh_expires_at';
  static const _user = 'user_json';
  static const _device = 'device_id';

  Future<AuthTokens?> readTokens() async {
    final all = await _storage.readAll();
    final access = all[_access];
    final refresh = all[_refresh];
    final accessExpiry = DateTime.tryParse(all[_accessExpiry] ?? '');
    final refreshExpiry = DateTime.tryParse(all[_refreshExpiry] ?? '');
    if (access == null ||
        refresh == null ||
        accessExpiry == null ||
        refreshExpiry == null) {
      return null;
    }
    return AuthTokens(
      accessToken: access,
      refreshToken: refresh,
      accessExpiresAt: accessExpiry,
      refreshExpiresAt: refreshExpiry,
    );
  }

  Future<void> saveTokens(AuthTokens tokens) async {
    await Future.wait([
      _storage.write(key: _access, value: tokens.accessToken),
      _storage.write(key: _refresh, value: tokens.refreshToken),
      _storage.write(
        key: _accessExpiry,
        value: tokens.accessExpiresAt.toIso8601String(),
      ),
      _storage.write(
        key: _refreshExpiry,
        value: tokens.refreshExpiresAt.toIso8601String(),
      ),
    ]);
  }

  Future<void> saveSession(AuthTokens tokens, String userJson) async {
    await saveTokens(tokens);
    await _storage.write(key: _user, value: userJson);
  }

  Future<String?> readUser() => _storage.read(key: _user);

  /// The device id (`imei` in the API). Created once and never changes,
  /// because logout must send the same value as login.
  Future<String> deviceId() async {
    final existing = await _storage.read(key: _device);
    if (existing != null) return existing;
    final created = const Uuid().v4();
    await _storage.write(key: _device, value: created);
    return created;
  }

  /// Signs out locally. The device id is kept.
  Future<void> clearSession() async {
    await Future.wait([
      _storage.delete(key: _access),
      _storage.delete(key: _refresh),
      _storage.delete(key: _accessExpiry),
      _storage.delete(key: _refreshExpiry),
      _storage.delete(key: _user),
    ]);
  }
}