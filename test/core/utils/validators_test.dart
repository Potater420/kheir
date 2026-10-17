import 'package:flutter_test/flutter_test.dart';
import 'package:kheir/core/utils/validators.dart';

void main() {
  group('Validators.email', () {
    test('rejects empty and blank input', () {
      expect(Validators.email(null), ValidationError.emailRequired);
      expect(Validators.email('   '), ValidationError.emailRequired);
    });

    test('rejects malformed addresses', () {
      expect(Validators.email('sara'), ValidationError.emailInvalid);
      expect(Validators.email('sara@'), ValidationError.emailInvalid);
      expect(Validators.email('sara@mail'), ValidationError.emailInvalid);
    });

    test('accepts a valid address, ignoring surrounding spaces', () {
      expect(Validators.email('sara.ahmed@email.com'), isNull);
      expect(Validators.email('  sara@email.com  '), isNull);
    });
  });

  group('Validators.passwordStrong', () {
    test('rejects empty input', () {
      expect(Validators.passwordStrong(''), ValidationError.passwordRequired);
    });

    test('rejects passwords missing a rule', () {
      expect(Validators.passwordStrong('Ab1!'), ValidationError.passwordWeak);
      expect(
        Validators.passwordStrong('abcdefg1!'),
        ValidationError.passwordWeak,
      );
      expect(
        Validators.passwordStrong('Abcdefgh!'),
        ValidationError.passwordWeak,
      );
      expect(
        Validators.passwordStrong('Abcdefg12'),
        ValidationError.passwordWeak,
      );
    });

    test('accepts a strong password', () {
      expect(Validators.passwordStrong('Kheir#2026'), isNull);
    });
  });

  group('Validators (other fields)', () {
    test('login password is only required', () {
      expect(Validators.passwordRequired(''), ValidationError.passwordRequired);
      expect(Validators.passwordRequired('x'), isNull);
    });

    test('full name must not be blank', () {
      expect(Validators.fullName(' '), ValidationError.nameRequired);
      expect(Validators.fullName('Sara Ahmed'), isNull);
    });

    test('confirm password must match', () {
      expect(
        Validators.confirmPassword('Kheir#2026', 'Kheir#2027'),
        ValidationError.passwordMismatch,
      );
      expect(Validators.confirmPassword('Kheir#2026', 'Kheir#2026'), isNull);
    });

    test('terms must be accepted', () {
      expect(
        Validators.termsAccepted(accepted: false),
        ValidationError.termsRequired,
      );
      expect(Validators.termsAccepted(accepted: true), isNull);
    });
  });
}