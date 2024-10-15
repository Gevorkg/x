part of 'follow_bloc.dart';

abstract class FollowEvent extends Equatable {
  const FollowEvent();

  @override
  List<Object> get props => [];
}

class FollowUser extends FollowEvent {
  
  final String currentUserId;
  final String targetUserId;

  FollowUser(this.currentUserId, this.targetUserId);
}

class CheckFollowStatus extends FollowEvent {
  final String currentUserId;
  final String targetUserId;

  CheckFollowStatus(this.currentUserId, this.targetUserId);
}

class GetFollowers extends FollowEvent {
  final String userId;

  GetFollowers({required this.userId});
}

class GetFollowing extends FollowEvent {
  final String userId;

  GetFollowing({required this.userId});
}