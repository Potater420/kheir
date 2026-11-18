import '../error/failure.dart';
import '../l10n/generated/app_localizations.dart';
import 'validators.dart';

/// Turns a [ValidationError] into the text shown under a form field.
String validationMessage(AppLocalizations l10n, ValidationError error) {
  return switch (error) {
    ValidationError.emailRequired => l10n.validationEmailRequired,
    ValidationError.emailInvalid => l10n.validationEmailInvalid,
    ValidationError.identifierRequired => l10n.validationIdentifierRequired,
    ValidationError.identifierInvalid => l10n.validationIdentifierInvalid,
    ValidationError.passwordRequired => l10n.validationPasswordRequired,
    ValidationError.passwordTooShort => l10n.validationPasswordTooShort,
    ValidationError.passwordWeak => l10n.validationPasswordWeak,
    ValidationError.nameRequired => l10n.validationNameRequired,
    ValidationError.passwordMismatch => l10n.validationPasswordMismatch,
    ValidationError.termsRequired => l10n.validationTermsRequired,
  };
}

/// Turns a [Failure] from the data layer into a message for the person.
String failureMessage(AppLocalizations l10n, Failure failure) {
  return switch (failure) {
    InvalidCredentialsFailure() => l10n.errorInvalidCredentials,
    EmailAlreadyInUseFailure() => l10n.errorEmailInUse,
    NetworkFailure() => l10n.errorNetwork,
    SessionExpiredFailure() => l10n.errorSessionExpired,
    ForbiddenFailure() => l10n.errorForbidden,
    TooManyRequestsFailure() => l10n.errorTooManyRequests,
    ServerFailure() => l10n.errorServer,
    ValidationFailure(:final message) =>
      message.isEmpty ? l10n.errorUnknown : message,
    UnknownFailure() => l10n.errorUnknown,
  };
}