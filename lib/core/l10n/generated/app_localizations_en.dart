// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Kheir';

  @override
  String get appTagline => 'Together for each other';

  @override
  String get splashFooter => 'Smart donation and volunteering platform';

  @override
  String get loginTitle => 'Welcome back';

  @override
  String get loginHeading => 'Your good continues with us';

  @override
  String get loginSubtitle =>
      'Sign in to follow your donations and nearby ways to help.';

  @override
  String get loginButton => 'Log in';

  @override
  String get forgotPassword => 'Forgot your password?';

  @override
  String get privacyNotice =>
      'Your data is encrypted and protected. Your privacy comes first.';

  @override
  String get noAccountPrompt => 'New here?';

  @override
  String get createAccountAction => 'Create an account';

  @override
  String get registerTitle => 'New account, new impact';

  @override
  String get registerSubtitle => 'One simple step brings us together for good';

  @override
  String get registerButton => 'Create account';

  @override
  String get passwordRequirements =>
      'At least 8 characters, an uppercase letter, a number and a symbol';

  @override
  String get termsConsent => 'I agree to the Terms of Use and Privacy Policy';

  @override
  String get haveAccountPrompt => 'Already have an account?';

  @override
  String get loginAction => 'Log in';

  @override
  String get fullNameLabel => 'Full name';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get confirmPasswordLabel => 'Confirm password';

  @override
  String get validationEmailRequired => 'Enter your email';

  @override
  String get validationEmailInvalid => 'Enter a valid email address';

  @override
  String get validationPasswordRequired => 'Enter your password';

  @override
  String get validationPasswordWeak =>
      'Password must be at least 8 characters with an uppercase letter, a number and a symbol';

  @override
  String get validationNameRequired => 'Enter your full name';

  @override
  String get validationPasswordMismatch => 'Passwords do not match';

  @override
  String get validationTermsRequired =>
      'You need to accept the terms to continue';

  @override
  String get errorInvalidCredentials => 'Incorrect email or password.';

  @override
  String get errorEmailInUse => 'This email is already registered.';

  @override
  String get errorNetwork =>
      'No internet connection. Check your network and try again.';

  @override
  String get errorUnknown => 'Something went wrong. Please try again.';
}
