import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_x/packages/comment_repository/comment_repos.dart';
import '../../comment_repository/models/comment_model.dart';
import '../../user_repository/models/user_model.dart';

part 'get_comment_event.dart';
part 'get_comment_state.dart';

class GetCommentBloc extends Bloc<GetCommentEvent, GetCommentState> {
  final CommentRepos _commentRepos;
  StreamSubscription<List<Comment>>? _commentsSubscription;

  GetCommentBloc(this._commentRepos) : super(GetCommentInitial()) {
    on<GetComment>((event, emit) async {
      emit(GetCommentLoading());

      await _commentsSubscription?.cancel();

      try {
        _commentsSubscription =
            _commentRepos.getCommentsStream(event.postId).listen(
          (comments) {
            emit(GetCommentSuccess(comments));
          },
          onError: (error) {
            emit(GetCommentFailure(error.toString()));
          },
        );

        await _commentsSubscription!.asFuture();
      } catch (error) {
        emit(GetCommentFailure(error.toString()));
      }
    });

    on<LikeCommentEvent>((event, emit) async {
      try {
        await _commentRepos.likeComment(event.postId, event.user);
      } catch (e) {
        emit(GetCommentFailure(e.toString()));
      }
    });

    
  }

  @override
  Future<void> close() {
    _commentsSubscription?.cancel();
    return super.close();
  }
}
