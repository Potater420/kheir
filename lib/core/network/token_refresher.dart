import 'package:dio/dio.dart';

import '../storage/token_storage.dart';
import 'api_response.dart';
import 'auth_tokens.dart';
import 'session_events.dart';

enum RefreshResult {
  success,

  /// The server refused the refresh token. The session is over.
  rejected,

  /// No answer (offline, server down). The session may still be valid.
  networkError,
}

/// Swaps the refresh token for a new token pair. Only one refresh runs at a
/// time: callers that arrive meanwhile wait for the same result.
class TokenRefresher {
  TokenRefresher({
    required this._dio,
    required this._storage,
    required this._events,
  });

  /// A Dio without the auth interceptor, so refreshing can't trigger itself.
  final Dio _dio;
  final TokenStorage _storage;
  final SessionEvents _events;

  Future<RefreshResult>? _running;

  /// [staleAccessToken] is the token that just failed. If the stored token
  /// is already a newer one, another request refreshed in the meantime.
  Future<RefreshResult> refresh({String? staleAccessToken}) {
    return _running ??= _refresh(staleAccessToken).whenComplete(
      () => _running = null,
    );
  }

  Future<RefreshResult> _refresh(String? staleAccessToken) async {
    final tokens = await _storage.readTokens();
    if (tokens == null) return RefreshResult.rejected;
    if (staleAccessToken != null && tokens.accessToken != staleAccessToken) {
      return RefreshResult.success;
    }
    if (tokens.refreshExpired) return _reject();

    try {
      final response = await _dio.post<Object?>(
        '/public/refresh',
        options: Options(
          headers: {'Authorization': 'Bearer ${tokens.refreshToken}'},
        ),
      );
      await _storage.saveTokens(
        AuthTokens.fromJson(responseData(response.data)),
      );
      return RefreshResult.success;
    } on DioException catch (error) {
      final status = error.response?.statusCode;
      if (status == 401 || status == 403 || status == 422) return _reject();
      return RefreshResult.networkError;
    } on FormatException {
      return RefreshResult.networkError;
    }
  }

  Future<RefreshResult> _reject() async {
    await _storage.clearSession();
    _events.notifyExpired();
    return RefreshResult.rejected;
  }
}