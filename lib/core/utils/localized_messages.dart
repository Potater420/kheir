import '../error/failure.dart';
import '../l10n/generated/app_localizations.dart';
import 'validators.dart';

/// Turns a [ValidationError] into the text shown under a form field.
String validationMessage(AppLocalizations l10n, ValidationError error) {
  return switch (error) {
    ValidationError.emailRequired => l10n.validationEmailRequired,
    ValidationError.emailInvalid => l10n.validationEmailInvalid,
    ValidationError.passwordRequired => l10n.validationPasswordRequired,
    ValidationError.passwordWeak => l10n.validationPasswordWeak,
    ValidationError.nameRequired => l10n.validationNameRequired,
    ValidationError.passwordMismatch => l10n.validationPasswordMismatch,
    ValidationError.termsRequired => l10n.validationTermsRequired,
    ValidationError.phoneInvalid => l10n.validationPhoneInvalid,
  };
}

/// Turns a [Failure] from the data layer into a message for the person.
String failureMessage(AppLocalizations l10n, Failure failure) {
  return switch (failure) {
    InvalidCredentialsFailure() => l10n.errorInvalidCredentials,
    EmailAlreadyInUseFailure() => l10n.errorEmailInUse,
    NetworkFailure() => l10n.errorNetwork,
    UnknownFailure() => l10n.errorUnknown,
  };
}
