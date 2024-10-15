import 'package:equatable/equatable.dart';
import 'package:flutter_x/packages/user_repository/models/user_model.dart';

abstract class UserSearchState extends Equatable {
  const UserSearchState();

  @override
  List<Object?> get props => [];
}

class UsersInitial extends UserSearchState {}

class UsersLoading extends UserSearchState {}

class UsersLoaded extends UserSearchState {
  final List<MyUser> users;

  const UsersLoaded(this.users);

  @override
  List<Object?> get props => [users];
}

class UsersError extends UserSearchState {
  final String message;

  const UsersError(this.message);

  @override
  List<Object?> get props => [message];
}