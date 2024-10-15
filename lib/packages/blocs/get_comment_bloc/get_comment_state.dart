part of 'get_comment_bloc.dart';

abstract class GetCommentState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetCommentInitial extends GetCommentState {}

class GetCommentLoading extends GetCommentState {}

class GetCommentSuccess extends GetCommentState {
  final List<Comment> comments;

  GetCommentSuccess(this.comments);

  @override
  List<Object?> get props => [comments];
}

class GetCommentFailure extends GetCommentState {
  final String error;

  GetCommentFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class CommentLiked extends GetCommentState{}