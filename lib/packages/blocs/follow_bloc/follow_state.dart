part of 'follow_bloc.dart';

sealed class FollowState extends Equatable {
  const FollowState();
  
  @override
  List<Object> get props => [];
}

final class FollowInitial extends FollowState {}

class FollowLoading extends FollowState{}

class FollowSuccess extends FollowState{ 
final bool isFollowing; 

  FollowSuccess(this.isFollowing);

  @override
  List<Object> get props => [isFollowing];
}


class GetFollowersLoading extends FollowState{}

class GetFollowersSuccess extends FollowState {
  final List<MyUser> followers;

  GetFollowersSuccess(this.followers);

  @override
  List<Object> get props => [followers];
}

class GetFollowingLoading extends FollowState{}

class GetFollowingSuccess extends FollowState {
  final List<MyUser> following;

  GetFollowingSuccess(this.following);

  @override
  List<Object> get props => [following];
}

class FollowFailure extends FollowState {
  final String error;

  FollowFailure(this.error);

  @override
  List<Object> get props => [error];
}