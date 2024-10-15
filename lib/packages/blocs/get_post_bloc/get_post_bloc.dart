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
    on<GetPosts>((event, emit) async {
      emit(GetPostLoading());
      try {
        _postSubscription?.cancel();
        _postSubscription = _postRepository.getPost().listen(
          (posts) {
            add(PostsUpdated(posts));
          },
        );
      } catch (e) {
        emit(GetPostError(e.toString()));
      }
    });

    on<GetPostsByUserId>((event, emit) async {
      emit(GetPostLoading());
      try {
        List<Post> usersPosts =
            await _postRepository.getPostByUserId(event.userId);
        emit(GetPostSuccess(usersPosts));
      } catch (e) {
        emit(GetPostError(e.toString()));
      }
    });

    on<GetPostsForFollowedUsers>((event, emit) async {
      emit(GetPostLoading());
      try {
        _postSubscription?.cancel();
        _postSubscription =
            _postRepository.getPostByFollowing(event.currentUserId).listen(
          (posts) {
            add(PostsUpdated(posts));
          },
        );
      } catch (e) {
        emit(GetPostError(e.toString()));
      }
    });

    on<LikePostEvent>((event, emit) async {
      try {
        await _postRepository.likePost(event.postId, event.user);
      } catch (e) {
        emit(GetPostError(e.toString()));
      }
    });

    on<PostsUpdated>((event, emit) {
      emit(GetPostSuccess(event.posts));
    });
  }

  @override
  Future<void> close() {
    _postSubscription?.cancel();
    return super.close();
  }
}
