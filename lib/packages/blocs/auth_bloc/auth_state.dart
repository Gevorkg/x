part of 'auth_bloc.dart';

enum AuthStatus { authenticated, unauthenticated, uknown }

class AuthState extends Equatable {
  final AuthStatus status;
  final User? user;

  const AuthState._({
    this.status = AuthStatus.uknown,
    this.user,
  });

  const AuthState.uknown() : this._();

  const AuthState.authenticated(User user)
      : this._(status: AuthStatus.authenticated, user: user);

  const AuthState.unauthenticated()
      : this._(status: AuthStatus.unauthenticated);

  @override
  List<Object?> get props => [status, user];
}
