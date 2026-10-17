import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/utils/results.dart';
import '../../../domain/entities/app_user.dart';
import '../../../domain/usecases/login_user.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._loginUser) : super(const LoginState());

  final LoginUser _loginUser;

  Future<void> submit({
    required String email,
    required String password,
  }) async {
    if (state.isSubmitting) return;
    emit(const LoginState(status: LoginStatus.submitting));

    final result = await _loginUser(email: email, password: password);
    if (isClosed) return;

    switch (result) {
      case Success(:final value):
        emit(LoginState(status: LoginStatus.success, user: value));
      case Err(:final failure):
        emit(LoginState(status: LoginStatus.failure, failure: failure));
    }
  }
}
