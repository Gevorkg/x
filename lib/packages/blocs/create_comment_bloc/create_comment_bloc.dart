import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_x/packages/comment_repository/comment_repos.dart';

import '../../comment_repository/models/comment_model.dart';

part 'create_comment_event.dart';
part 'create_comment_state.dart';

class CreateCommentBloc extends Bloc<CreateCommentEvent, CreateCommentState> {
  CommentRepos _commentRepos;

  CreateCommentBloc({required CommentRepos commentRepos})
      : _commentRepos = commentRepos,
        super(CreateCommentInitial()) {
    on<CreateComment>((event, emit) async {
      emit(CreateCommentLoading());
      try {
        Comment comment = await _commentRepos.createComment(event.comment,
            imageFile: event.imageFile);

        emit(CreateCommentSuccess(comment));
      } catch (e) {
        log(e.toString());
      }
    });
    
    on<DeleteComment>((event, emit) async {
  try {
    await _commentRepos.deleteComment(event.commentId, event.userId);
    emit(DeleteCommentSuccess());
  } catch (e) {
    log(e.toString());
    emit(CreateCommentFailure());
  }
});
  }
}
