part of 'verify_code_cubit.dart';

enum VerifyCodeStatus { initial, submitting, resending, resent, success, failure }

class VerifyCodeState extends Equatable {
  const VerifyCodeState({
    this.status = VerifyCodeStatus.initial,
    this.user,
    this.failure,
  });

  final VerifyCodeStatus status;
  final AppUser? user;
  final Failure? failure;

  bool get isSubmitting => status == VerifyCodeStatus.submitting;

  bool get isBusy =>
      status == VerifyCodeStatus.submitting ||
      status == VerifyCodeStatus.resending;

  @override
  List<Object?> get props => [status, user, failure];
}