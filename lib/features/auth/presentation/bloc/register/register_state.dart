part of 'register_cubit.dart';

enum RegisterStatus { initial, submitting, success, failure }

class RegisterState extends Equatable {
  const RegisterState({
    this.status = RegisterStatus.initial,
    this.user,
    this.failure,
  });

  final RegisterStatus status;
  final AppUser? user;
  final Failure? failure;

  bool get isSubmitting => status == RegisterStatus.submitting;

  @override
  List<Object?> get props => [status, user, failure];
}
