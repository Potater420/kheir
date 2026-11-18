import 'package:dio/dio.dart';

import '../error/failure.dart';

/// Converts a Dio error into a [Failure]. [onUnauthorized] decides what a
/// 401 means: wrong password on login, an expired session everywhere else.
Failure failureFromDio(DioException error, {Failure? onUnauthorized}) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.connectionError:
      return const NetworkFailure();
    default:
      break;
  }

  final status = error.response?.statusCode;
  if (status == null) return const UnknownFailure();
  if (status == 401) return onUnauthorized ?? const SessionExpiredFailure();
  if (status == 403) return const ForbiddenFailure();
  if (status == 422) return ValidationFailure(_firstValidationMessage(error));
  if (status == 429) return const TooManyRequestsFailure();
  if (status >= 500) return const ServerFailure();
  return const UnknownFailure();
}

/// The API sends { errors: { field: ["message", ...] } }. Take the first.
String _firstValidationMessage(DioException error) {
  final body = error.response?.data;
  if (body is Map<String, dynamic>) {
    final errors = body['errors'];
    if (errors is Map<String, dynamic>) {
      for (final messages in errors.values) {
        if (messages is List && messages.isNotEmpty) {
          return messages.first.toString();
        }
      }
    }
    final message = body['message'];
    if (message is String && message != 'validation_error') return message;
  }
  return '';
}