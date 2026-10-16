/// App-level errors. Data sources convert SDK exceptions into these,
/// so nothing above the data layer ever sees a Firebase or Dio type.
/// The UI maps [code] to a localized message from the ARB files.
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

class UnknownFailure extends Failure {
  const UnknownFailure() : super('unknown');
}