/// Reasons a form field can be invalid. The UI maps each one to a
/// localized message (validationEmailRequired, and so on, in the ARB files).
enum ValidationError {
  emailRequired,
  emailInvalid,
  passwordRequired,
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

  static ValidationError? email(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return ValidationError.emailRequired;
    if (!_emailPattern.hasMatch(text)) return ValidationError.emailInvalid;
    return null;
  }

  /// Login: only checks that something was entered.
  static ValidationError? passwordRequired(String? value) {
    if (value == null || value.isEmpty) return ValidationError.passwordRequired;
    return null;
  }

  /// Register: 8+ characters, an uppercase letter, a number and a symbol.
  static ValidationError? passwordStrong(String? value) {
    if (value == null || value.isEmpty) return ValidationError.passwordRequired;
    final strong = value.length >= 8 &&
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

  /// Optional field: empty is fine, otherwise 8 to 15 digits with an
  /// optional leading +. Spaces and dashes are ignored.
  static ValidationError? phoneOptional(String? value) {
    final text = value?.replaceAll(RegExp(r'[\s-]'), '') ?? '';
    if (text.isEmpty) return null;
    return _phonePattern.hasMatch(text) ? null : ValidationError.phoneInvalid;
  }

  static ValidationError? termsAccepted({required bool accepted}) {
    return accepted ? null : ValidationError.termsRequired;
  }
}