import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/results.dart';
import '../../../domain/entities/app_user.dart';
import '../../../domain/usecases/get_current_user.dart';
import '../../../domain/usecases/logout_user.dart';

part 'auth_session_state.dart';

/// Knows whether someone is signed in. Lives for the whole app, so any
/// screen can read it (the splash checks it, the home screen signs out).
class AuthSessionCubit extends Cubit<AuthSessionState> {
  AuthSessionCubit({
    required this._getCurrentUser,
    required this._logoutUser,
  }) : super(const AuthSessionState());

  final GetCurrentUser _getCurrentUser;
  final LogoutUser _logoutUser;

  /// Called once at startup (by the splash screen).
  Future<void> checkSession() async {
    final result = await _getCurrentUser();
    final user = switch (result) {
      Success(:final value) => value,
      Err() => null,
    };
    if (isClosed) return;
    emit(
      user == null
          ? const AuthSessionState(status: AuthSessionStatus.unauthenticated)
          : AuthSessionState(
              status: AuthSessionStatus.authenticated,
              user: user,
            ),
    );
  }

  void signedIn(AppUser user) {
    emit(
      AuthSessionState(status: AuthSessionStatus.authenticated, user: user),
    );
  }

  Future<void> signOut() async {
    final result = await _logoutUser();
    if (isClosed || result is! Success<void>) return;
    emit(const AuthSessionState(status: AuthSessionStatus.unauthenticated));
  }
}
