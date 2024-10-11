part of 'get_comment_bloc.dart';

abstract class GetCommentEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetComment extends GetCommentEvent {
  final String postId;

  GetComment({ required this.postId});

  @override
  List<Object?> get props => [postId];
}
