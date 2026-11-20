import 'package:equatable/equatable.dart';

/// What the person typed on the register form. It is carried to the
/// verification screen, which finishes the registration with the code.
class RegisterDraft extends Equatable {
  const RegisterDraft({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
  });

  final String fullName;
  final String email;
  final String phone;
  final String password;

  @override
  List<Object?> get props => [fullName, email, phone, password];
}