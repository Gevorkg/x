part of 'sign_in_bloc.dart';

abstract class SignInState extends Equatable {
  const SignInState();
  
  @override
  List<Object> get props => [];
}

final class SignInInitial extends SignInState {}

class SignInSucess extends SignInState{}

class SignInFailure extends SignInState{
  final String? message;

  const SignInFailure({this.message});
}

class SignInProcess extends SignInState{}


