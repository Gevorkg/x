import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_x/packages/user_repository/user_repos.dart';

import '../../user_repository/models/user_model.dart';

part 'follow_event.dart';
part 'follow_state.dart';

class FollowBloc extends Bloc<FollowEvent, FollowState> {
  final UserRepository _userRepository;

  FollowBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(FollowInitial()) {
    on<FollowUser>((event, emit) async {
      emit(FollowLoading());
      try {
        bool isCurrentlyFollowing = await _userRepository.isFollowing(
            event.currentUserId, event.targetUserId);

        if (isCurrentlyFollowing) {
          await _userRepository.unfollowUser(
              event.currentUserId, event.targetUserId);
        } else {
          await _userRepository.followUser(
              event.currentUserId, event.targetUserId);
        }

        bool isFollowing = await _userRepository.isFollowing(
            event.currentUserId, event.targetUserId);
        emit(FollowSuccess(isFollowing));
      } catch (e) {
        emit(FollowFailure(e.toString()));
      }
    });

    on<CheckFollowStatus>((event, emit) async {
      emit(FollowLoading());
      try {
        bool isFollowing = await _userRepository.isFollowing(
            event.currentUserId, event.targetUserId);
        emit(FollowSuccess(isFollowing));
      } catch (e) {
        emit(FollowFailure(e.toString()));
      }
    });

    on<GetFollowers>((event, emit) async {
      emit(GetFollowersLoading());
      try {
        List<MyUser> followers =
            await _userRepository.getFollowers(event.userId);
        emit(GetFollowersSuccess(followers));
      } catch (e) {
        emit(FollowFailure(e.toString()));
      }
    });

    on<GetFollowing>((event, emit) async {
      emit(GetFollowingLoading());
      try {
        List<MyUser> following =
            await _userRepository.getFollowing(event.userId);
        emit(GetFollowingSuccess(following));
      } catch (e) {
        emit(FollowFailure(e.toString()));
      }
    });
  }
}
