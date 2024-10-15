import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_x/packages/user_repository/user_repos.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserRepository userRepository;
  late final StreamSubscription<User?> _userSubscription;

  AuthBloc({required UserRepository myUserRepository})
      : userRepository = myUserRepository,
        super(AuthState.uknown()) {
    _userSubscription = userRepository.user.listen((authUser) {
      add(AuthUserChanged(authUser));
    });
    on<AuthUserChanged>((event, emit) {
      try {
        if (event.user != null) {
          emit(AuthState.authenticated(event.user!));
        } else {
          emit(const AuthState.unauthenticated());
        }
      } catch (e) {}
    });

    @override
    Future<void> close() {
      _userSubscription.cancel();
      return super.close();
    }
  }
}
