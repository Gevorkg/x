import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_x/packages/user_repository/user_repos.dart';

import '../../user_repository/models/user_model.dart';

part 'follow_event.dart';
part 'follow_state.dart';

class FollowBloc extends Bloc<FollowEvent, FollowState> {
  final UserRepository _userRepository;

  FollowBloc({ required UserRepository userRepository}) : _userRepository = userRepository,  super(FollowInitial()) {
    on<FollowUser>((event, emit) async {
      await _userRepository.toggleSubscription(
          event.currentUserId, event.targetUserId);
      emit(FollowSuccess());
    });

    on<GetFollowers>((event, emit) async {
      emit(GetFollowersLoading());
      try {
        List<MyUser> followers = await _userRepository.getFollowers(event.userId);
        emit(GetFollowersSuccess(followers));
      } catch (e) {
        emit(FollowFailure(e.toString()));
      }
    });

    // Handle GetFollowing event
    on<GetFollowing>((event, emit) async {
      emit(GetFollowingLoading());
      try {
        List<MyUser> following = await _userRepository.getFollowing(event.userId);
        emit(GetFollowingSuccess(following));
      } catch (e) {
        emit(FollowFailure(e.toString()));
      }
    });
  }
  }

