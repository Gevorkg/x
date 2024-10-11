import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_x/packages/comment_repository/comment_repos.dart';
import '../../comment_repository/models/comment_model.dart';

part 'get_comment_event.dart';
part 'get_comment_state.dart';

class GetCommentBloc extends Bloc<GetCommentEvent, GetCommentState> {
  final CommentRepos _commentRepos;
  StreamSubscription<List<Comment>>? _commentsSubscription;

  GetCommentBloc(this._commentRepos) : super(GetCommentInitial()) {
    on<GetComment>((event, emit) async {
      // Emit loading state
      emit(GetCommentLoading());
      // log('Начата загрузка комментариев для поста: ${event.postId}');

      // Cancel previous subscription if it exists
      await _commentsSubscription?.cancel();

      // Subscribe to the comments stream
      try {
        _commentsSubscription = _commentRepos.getCommentsStream(event.postId).listen(
          (comments) {
            // log('Полученные комментарии: ${comments.length}');
            // log('комментарии: $comments ');

            // Emit success state here
            emit(GetCommentSuccess(comments));
          },
          onError: (error) {
            // log('Ошибка при получении комментариев: $error');
            emit(GetCommentFailure(error.toString()));
          },
        );

        // Не забудьте ожидать завершение подписки
        await _commentsSubscription!.asFuture(); // ждём завершения
      } catch (error) {
        // log('Ошибка при подписке на поток комментариев: $error');
        emit(GetCommentFailure(error.toString()));
      }
    });
  }

  @override
  Future<void> close() {
    // Ensure subscription is canceled
    _commentsSubscription?.cancel();
    return super.close();
  }
}