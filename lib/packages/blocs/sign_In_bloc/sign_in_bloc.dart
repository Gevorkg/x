// ignore_for_file: unused_field

import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_x/packages/user_repository/user_repos.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final UserRepository _userRepository;

  SignInBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(SignInInitial()) {
    on<SignInRequired>((event, emit) async{
      emit(SignInProcess());
      try {
        await userRepository.signIn(event.email, event.password);
        emit(SignInSucess());
        
      } catch (e) {
        log(e.toString() as num);
        emit( const SignInFailure());
        
      }
    });
    on<SignOutRequired>((event, emit) async{
      await userRepository.logOut();
    },);
  }
}
