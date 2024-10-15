// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'create_comment_bloc.dart';

abstract class CreateCommentEvent extends Equatable {
  const CreateCommentEvent();

  @override
  List<Object> get props => [];
}

class CreateComment extends CreateCommentEvent {
  final Comment comment;
  final String? imageFile;

  CreateComment(this.comment, {this.imageFile});
}

class DeleteComment extends CreateCommentEvent {
  final String commentId;
  final String userId;

  DeleteComment(this.commentId, this.userId);

  @override
  List<Object> get props => [commentId, userId];
}
