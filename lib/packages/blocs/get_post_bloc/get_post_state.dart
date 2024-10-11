part of 'get_post_bloc.dart';

abstract class GetPostState extends Equatable {
  @override
  List<Object> get props => [];
}

class GetPostInitial extends GetPostState {}

class GetPostLoading extends GetPostState {}

class GetPostSuccess extends GetPostState {
  final List<Post> posts;

  GetPostSuccess(this.posts);

  @override
  List<Object> get props => [posts];
}

class GetPostError extends GetPostState {
  final String error;

  GetPostError(this.error);

  @override
  List<Object> get props => [error];
}

class PostLiked extends GetPostState {}