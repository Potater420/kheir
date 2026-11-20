import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/utils/results.dart';
import '../../../domain/entities/app_user.dart';
import '../../../domain/usecases/register_user.dart';
import '../../../domain/usecases/request_registration_code.dart';
import '../register/register_draft.dart';

part 'verify_code_state.dart';

/// Step 2 of registering: sends the emailed code and creates the account.
/// It can also ask the server to send a new code.
class VerifyCodeCubit extends Cubit<VerifyCodeState> {
  VerifyCodeCubit({
    required this.draft,
    required this._registerUser,
    required this._requestCode,
  }) : super(const VerifyCodeState());

  final RegisterDraft draft;
  final RegisterUser _registerUser;
  final RequestRegistrationCode _requestCode;

  Future<void> submit(String code) async {
    if (state.isBusy) return;
    emit(const VerifyCodeState(status: VerifyCodeStatus.submitting));

    final result = await _registerUser(
      fullName: draft.fullName,
      email: draft.email,
      phone: draft.phone,
      password: draft.password,
      code: code,
    );
    if (isClosed) return;

    switch (result) {
      case Success(:final value):
        emit(VerifyCodeState(status: VerifyCodeStatus.success, user: value));
      case Err(:final failure):
        emit(VerifyCodeState(status: VerifyCodeStatus.failure, failure: failure));
    }
  }

  Future<void> resend() async {
    if (state.isBusy) return;
    emit(const VerifyCodeState(status: VerifyCodeStatus.resending));

    final result = await _requestCode(email: draft.email, phone: draft.phone);
    if (isClosed) return;

    switch (result) {
      case Success():
        emit(const VerifyCodeState(status: VerifyCodeStatus.resent));
      case Err(:final failure):
        emit(VerifyCodeState(status: VerifyCodeStatus.failure, failure: failure));
    }
  }
}