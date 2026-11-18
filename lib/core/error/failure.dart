/// App-level errors. Data sources convert SDK exceptions into these,
/// so nothing above the data layer ever sees a Firebase or Dio type.
/// The UI maps each type to a localized message from the ARB files.
sealed class Failure {
  const Failure(this.code);

  final String code;
}

class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure() : super('invalid_credentials');
}

class EmailAlreadyInUseFailure extends Failure {
  const EmailAlreadyInUseFailure() : super('email_in_use');
}

class NetworkFailure extends Failure {
  const NetworkFailure() : super('network');
}

/// The saved login is no longer accepted by the server.
class SessionExpiredFailure extends Failure {
  const SessionExpiredFailure() : super('session_expired');
}

class ForbiddenFailure extends Failure {
  const ForbiddenFailure() : super('forbidden');
}

class TooManyRequestsFailure extends Failure {
  const TooManyRequestsFailure() : super('too_many_requests');
}

class ServerFailure extends Failure {
  const ServerFailure() : super('server');
}

/// The server rejected the input. [message] is its first field error,
/// already translated by the API. Empty when none was given.
class ValidationFailure extends Failure {
  const ValidationFailure(this.message) : super('validation');

  final String message;
}

class UnknownFailure extends Failure {
  const UnknownFailure() : super('unknown');
}