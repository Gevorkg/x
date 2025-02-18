import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_x/packages/user_repository/models/user_model.dart';
import 'package:flutter_x/packages/user_repository/user_repos.dart';

part 'sign_up_event.dart';
part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final UserRepository _userRepository;
  SignUpBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(SignUpInitial()) {
    on<SignUpRequired>((event, emit)async {
      emit(SignUpProcess());
      try {
        MyUser user = await _userRepository.signUp(event.user, event.password);
        await _userRepository.setUserData(user);
        emit(SignUpSuccess());
      } catch (e) {
        log(e.toString() as num);
        emit(SignUpFailure());
        
      }
    });
  }
}
