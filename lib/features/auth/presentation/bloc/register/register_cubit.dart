import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/utils/results.dart';
import '../../../domain/usecases/request_registration_code.dart';
import 'register_draft.dart';

part 'register_state.dart';

/// Step 1 of registering: asks the server to email a verification code.
class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this._requestCode) : super(const RegisterState());

  final RequestRegistrationCode _requestCode;

  Future<void> submit({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    if (state.isSubmitting) return;
    emit(const RegisterState(status: RegisterStatus.submitting));

    final result = await _requestCode(email: email, phone: phone);
    if (isClosed) return;

    switch (result) {
      case Success():
        emit(
          RegisterState(
            status: RegisterStatus.codeSent,
            draft: RegisterDraft(
              fullName: fullName.trim(),
              email: email.trim(),
              phone: phone.trim(),
              password: password,
            ),
          ),
        );
      case Err(:final failure):
        emit(RegisterState(status: RegisterStatus.failure, failure: failure));
    }
  }
}