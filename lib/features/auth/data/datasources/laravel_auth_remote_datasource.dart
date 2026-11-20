import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/error/failure_exception.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/network/auth_tokens.dart';
import '../../../../core/network/dio_failure_mapper.dart';
import '../../../../core/network/token_refresher.dart';
import '../../../../core/storage/token_storage.dart';
import '../models/user_model.dart';
import 'auth_remote_datasource.dart';

class LaravelAuthRemoteDataSource implements AuthRemoteDataSource {
  const LaravelAuthRemoteDataSource({
    required this._api,
    required this._storage,
  });

  final ApiClient _api;
  final TokenStorage _storage;

  /// Restores the saved session. Uses the user saved at login, so the app
  /// opens even when offline. Refreshes the tokens first if they expired.
  @override
  Future<UserModel?> getCurrentUser() async {
    final tokens = await _storage.readTokens();
    final cached = await _storage.readUser();
    if (tokens == null || cached == null) return null;

    if (tokens.accessNeedsRefresh) {
      final result = await _api.refresher.refresh();
      if (result == RefreshResult.rejected) return null;
    }

    try {
      return UserModel.fromJson(asMap(jsonDecode(cached)));
    } on FormatException {
      await _storage.clearSession();
      return null;
    }
  }

  @override
  Future<UserModel> login({
    required String identifier,
    required String password,
  }) async {
    try {
      final response = await _api.plain.post<Object?>(
        '/public/login',
        data: {
          // The API accepts an email or a phone number in this field.
          'email': _normalize(identifier),
          'password': password,
          'imei': await _storage.deviceId(),
          'token': AppConfig.pushTokenPlaceholder,
          'device_type': _deviceType,
        },
      );
      final user = await _saveSession(response.data);
      return user;
    } on DioException catch (error) {
      throw FailureException(
        failureFromDio(error, onUnauthorized: const InvalidCredentialsFailure()),
      );
    } on FormatException {
      throw const FailureException(UnknownFailure());
    }
  }

  /// Checks the email and phone are free and emails a verification code.
  @override
  Future<void> requestRegistrationCode({
    required String email,
    required String phone,
  }) async {
    try {
      await _api.plain.post<Object?>(
        '/public/register/check',
        data: {'email': email.trim(), 'phone': _normalize(phone)},
      );
    } on DioException catch (error) {
      throw FailureException(failureFromDio(error));
    }
  }

  /// Creates the account. The API signs the new user in and returns tokens,
  /// exactly like login. Everyone registers as a donor for now.
  @override
  Future<UserModel> register({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String code,
  }) async {
    try {
      final response = await _api.plain.post<Object?>(
        '/public/register',
        data: {
          'full_name': fullName.trim(),
          'email': email.trim(),
          'phone': _normalize(phone),
          'password': password,
          'confirm_password': password,
          'code': code.trim(),
          'type': 'donor',
          'locale': PlatformDispatcher.instance.locale.languageCode == 'ar'
              ? 'ar'
              : 'en',
          'imei': await _storage.deviceId(),
          'token': AppConfig.pushTokenPlaceholder,
          'device_type': _deviceType,
        },
      );
      final user = await _saveSession(response.data);
      return user;
    } on DioException catch (error) {
      throw FailureException(failureFromDio(error));
    } on FormatException {
      throw const FailureException(UnknownFailure());
    }
  }

  /// Best effort: the local session is always cleared, even if the server
  /// can't be reached.
  @override
  Future<void> logout() async {
    try {
      final tokens = await _storage.readTokens();
      if (tokens != null) {
        await _api.plain.post<Object?>(
          '/public/logout',
          data: {'imei': await _storage.deviceId()},
          options: Options(
            headers: {'Authorization': 'Bearer ${tokens.accessToken}'},
          ),
        );
      }
    } on DioException {
      // Ignored on purpose.
    } finally {
      await _storage.clearSession();
    }
  }

  /// Reads tokens and user from a login or register response and saves them.
  Future<UserModel> _saveSession(Object? body) async {
    final data = responseData(body);
    final tokens = AuthTokens.fromJson(data);
    final user = UserModel.fromJson(asMap(data['data']));
    await _storage.saveSession(tokens, jsonEncode(user.toJson()));
    return user;
  }

  String get _deviceType => Platform.isIOS ? 'ios' : 'android';

  /// Phone numbers: drop spaces and dashes. Emails are left alone.
  String _normalize(String value) {
    final text = value.trim();
    return text.contains('@') ? text : text.replaceAll(RegExp(r'[\s-]'), '');
  }
}