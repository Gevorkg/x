part of 'get_post_bloc.dart';

abstract class GetPostEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetPosts extends GetPostEvent {}

class GetPostsByUserId extends GetPostEvent {
  final String userId;

  GetPostsByUserId(this.userId);

  @override
  List<Object> get props => [userId];
}

class GetPostsForFollowedUsers extends GetPostEvent {
  final String currentUserId;

  GetPostsForFollowedUsers(this.currentUserId);

  @override
  List<Object> get props => [currentUserId];
}

class LikePostEvent extends GetPostEvent {
  final String postId;
  final MyUser user;

  LikePostEvent(this.postId, this.user);

  @override
  List<Object> get props => [postId, user];
}


class PostsUpdated extends GetPostEvent {
  final List<Post> posts;

  PostsUpdated(this.posts);

  @override
  List<Object> get props => [posts];
}