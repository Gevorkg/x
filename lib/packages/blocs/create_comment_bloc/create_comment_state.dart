part of 'create_comment_bloc.dart';

sealed class CreateCommentState extends Equatable {
  const CreateCommentState();
  
  @override
  List<Object> get props => [];
}

final class CreateCommentInitial extends CreateCommentState {}

class CreateCommentFailure extends CreateCommentState {}

class CreateCommentLoading extends CreateCommentState {}

class CreateCommentSuccess extends CreateCommentState {
  final Comment comment;
  

  CreateCommentSuccess(this.comment);
}

class DeleteCommentSuccess extends CreateCommentState {}