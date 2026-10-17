part of 'login_cubit.dart';

enum LoginStatus { initial, submitting, success, failure }

class LoginState extends Equatable {
  const LoginState({
    this.status = LoginStatus.initial,
    this.user,
    this.failure,
  });

  final LoginStatus status;
  final AppUser? user;
  final Failure? failure;

  bool get isSubmitting => status == LoginStatus.submitting;

  @override
  List<Object?> get props => [status, user, failure];
}
