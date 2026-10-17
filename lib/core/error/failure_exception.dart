import 'failure.dart';

/// Thrown by data sources after converting an SDK error into a [Failure].
/// Repositories catch it and return the failure inside an [Err].
class FailureException implements Exception {
  const FailureException(this.failure);

  final Failure failure;
}
