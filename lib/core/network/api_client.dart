import 'dart:ui';

import 'package:dio/dio.dart';

import '../config/app_config.dart';
import '../storage/token_storage.dart';
import 'session_events.dart';
import 'token_refresher.dart';

/// The app's two HTTP clients.
///  - [plain]: no token handling. For login, refresh and logout.
///  - [authed]: adds the bearer token, refreshes it ahead of time or after a
///    401, and retries the request once. Every other feature uses this one.
class ApiClient {
  ApiClient({required TokenStorage storage, required SessionEvents events}) {
    plain = Dio(_options())..interceptors.add(_languageInterceptor());
    refresher = TokenRefresher(dio: plain, storage: storage, events: events);
    authed = Dio(_options());
    authed.interceptors
      ..add(_languageInterceptor())
      ..add(
        AuthInterceptor(dio: authed, storage: storage, refresher: refresher),
      );
  }

  late final Dio plain;
  late final Dio authed;
  late final TokenRefresher refresher;

  static BaseOptions _options() => BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 20),
        contentType: Headers.jsonContentType,
        headers: {'Accept': 'application/json'},
      );

  /// Before sign-in the API picks its message language from this header.
  static Interceptor _languageInterceptor() {
    return InterceptorsWrapper(
      onRequest: (options, handler) {
        final code = PlatformDispatcher.instance.locale.languageCode;
        options.headers['lang'] = code == 'ar' ? 'ar' : 'en';
        handler.next(options);
      },
    );
  }
}

class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required this._dio,
    required this._storage,
    required this._refresher,
  });

  final Dio _dio;
  final TokenStorage _storage;
  final TokenRefresher _refresher;

  static const _retriedKey = 'auth_retried';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    var tokens = await _storage.readTokens();
    if (tokens != null && tokens.accessNeedsRefresh) {
      await _refresher.refresh();
      tokens = await _storage.readTokens();
    }
    if (tokens != null) {
      options.headers['Authorization'] = 'Bearer ${tokens.accessToken}';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final request = err.requestOptions;
    if (err.response?.statusCode != 401 || request.extra[_retriedKey] == true) {
      handler.next(err);
      return;
    }

    final sent = request.headers['Authorization'] as String?;
    final result = await _refresher.refresh(
      staleAccessToken: sent?.replaceFirst('Bearer ', ''),
    );
    final tokens = await _storage.readTokens();
    if (result != RefreshResult.success || tokens == null) {
      handler.next(err);
      return;
    }

    request.extra[_retriedKey] = true;
    request.headers['Authorization'] = 'Bearer ${tokens.accessToken}';
    try {
      handler.resolve(await _dio.fetch<Object?>(request));
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }
}