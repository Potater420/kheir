part of 'auth_session_cubit.dart';

enum AuthSessionStatus { unknown, authenticated, unauthenticated }

class AuthSessionState extends Equatable {
  const AuthSessionState({
    this.status = AuthSessionStatus.unknown,
    this.user,
  });

  final AuthSessionStatus status;
  final AppUser? user;

  @override
  List<Object?> get props => [status, user];
}
