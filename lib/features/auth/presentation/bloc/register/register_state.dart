part of 'register_cubit.dart';

enum RegisterStatus { initial, submitting, codeSent, failure }

class RegisterState extends Equatable {
  const RegisterState({
    this.status = RegisterStatus.initial,
    this.draft,
    this.failure,
  });

  final RegisterStatus status;
  final RegisterDraft? draft;
  final Failure? failure;

  bool get isSubmitting => status == RegisterStatus.submitting;

  @override
  List<Object?> get props => [status, draft, failure];
}