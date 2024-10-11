import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_x/packages/post_repository/models/post_model.dart';
import 'package:flutter_x/packages/user_repository/models/user_model.dart';
import 'package:flutter_x/packages/post_repository/post_repos.dart';

part 'get_post_event.dart';
part 'get_post_state.dart';

class GetPostBloc extends Bloc<GetPostEvent, GetPostState> {
  final PostRepository _postRepository;
  StreamSubscription<List<Post>>? _postSubscription;

  GetPostBloc({required PostRepository postRepository})
      : _postRepository = postRepository,
        super(GetPostInitial()) {
    
    // Обработчик события получения всех постов
    on<GetPosts>((event, emit) async {
      emit(GetPostLoading());
      try {
        // Подписка на стрим постов
        _postSubscription?.cancel(); // отменяем предыдущую подписку, если есть
        _postSubscription = _postRepository.getPost().listen(
          (posts) {
            add(PostsUpdated(posts));
          },
        );
      } catch (e) {
        emit(GetPostError(e.toString()));
      }
    });

    // Обработчик события получения постов по userId
    on<GetPostsByUserId>((event, emit) async {
      emit(GetPostLoading());
      try {
        List<Post> usersPosts = await _postRepository.getPostByUserId(event.userId);
        emit(GetPostSuccess(usersPosts));
      } catch (e) {
        emit(GetPostError(e.toString()));
      }
    });

    // Обработчик лайка поста
   on<LikePostEvent>((event, emit) async {
  try {
    // Лайк/дизлайк поста
    await _postRepository.likePost(event.postId, event.user);
    // Мы больше не перезагружаем посты здесь. Они автоматически обновятся через стрим.
  } catch (e) {
    emit(GetPostError(e.toString()));
  }
});



on<PostsUpdated>((event, emit) {
      emit(GetPostSuccess(event.posts));  // Обрабатываем обновленные посты
    });
  }

  @override
  Future<void> close() {
    _postSubscription?.cancel(); // Отменяем подписку при закрытии блока
    return super.close();
  }
}