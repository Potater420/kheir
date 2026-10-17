import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/utils/results.dart';
import '../../../domain/entities/app_user.dart';
import '../../../domain/usecases/register_user.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit(this._registerUser) : super(const RegisterState());

  final RegisterUser _registerUser;

  Future<void> submit({
    required String fullName,
    required String email,
    required String password,
    String? phone,
  }) async {
    if (state.isSubmitting) return;
    emit(const RegisterState(status: RegisterStatus.submitting));

    final result = await _registerUser(
      fullName: fullName,
      email: email,
      password: password,
      phone: phone,
    );
    if (isClosed) return;

    switch (result) {
      case Success(:final value):
        emit(RegisterState(status: RegisterStatus.success, user: value));
      case Err(:final failure):
        emit(RegisterState(status: RegisterStatus.failure, failure: failure));
    }
  }
}
