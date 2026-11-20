/// Reasons a form field can be invalid. The UI maps each one to a
/// localized message (validationEmailRequired, and so on, in the ARB files).
enum ValidationError {
  emailRequired,
  emailInvalid,
  identifierRequired,
  identifierInvalid,
  passwordRequired,
  passwordTooShort,
  passwordWeak,
  nameRequired,
  passwordMismatch,
  termsRequired,
  phoneInvalid,
}

/// Pure validation rules. Each returns null when the value is valid.
abstract final class Validators {
  static final RegExp _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  static final RegExp _phonePattern = RegExp(r'^\+?\d{8,15}$');

  /// Register: the phone is optional, but if given it must look like a number.
  static ValidationError? phoneOptional(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;
    final digits = text.replaceAll(RegExp(r'[\s-]'), '');
    return _phonePattern.hasMatch(digits) ? null : ValidationError.phoneInvalid;
  }

  /// Register: the phone is required.
  static ValidationError? phoneRequired(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return ValidationError.phoneInvalid;
    return phoneOptional(text);
  }

  static ValidationError? email(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return ValidationError.emailRequired;
    if (!_emailPattern.hasMatch(text)) return ValidationError.emailInvalid;
    return null;
  }

  /// Login: an email address or a phone number (8 to 15 digits, optional +).
  static ValidationError? emailOrPhone(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return ValidationError.identifierRequired;
    if (text.contains('@')) {
      return _emailPattern.hasMatch(text)
          ? null
          : ValidationError.identifierInvalid;
    }
    final digits = text.replaceAll(RegExp(r'[\s-]'), '');
    return _phonePattern.hasMatch(digits)
        ? null
        : ValidationError.identifierInvalid;
  }

  /// Login: the API needs at least 8 characters.
  static ValidationError? passwordMinLength(String? value) {
    if (value == null || value.isEmpty) return ValidationError.passwordRequired;
    if (value.length < 8) return ValidationError.passwordTooShort;
    return null;
  }

  /// Only checks that something was entered.
  static ValidationError? passwordRequired(String? value) {
    if (value == null || value.isEmpty) return ValidationError.passwordRequired;
    return null;
  }

  /// Register: 8+ characters, an uppercase letter, a number and a symbol.
  static ValidationError? passwordStrong(String? value) {
    if (value == null || value.isEmpty) return ValidationError.passwordRequired;
    final strong =
        value.length >= 8 &&
        value.contains(RegExp('[A-Z]')) &&
        value.contains(RegExp(r'\d')) &&
        value.contains(RegExp('[^A-Za-z0-9]'));
    return strong ? null : ValidationError.passwordWeak;
  }

  static ValidationError? fullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return ValidationError.nameRequired;
    }
    return null;
  }

  static ValidationError? confirmPassword(String? password, String? confirm) {
    if (confirm != password) return ValidationError.passwordMismatch;
    return null;
  }

  static ValidationError? termsAccepted({required bool accepted}) {
    return accepted ? null : ValidationError.termsRequired;
  }
}
