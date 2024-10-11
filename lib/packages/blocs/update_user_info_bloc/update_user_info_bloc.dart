import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_x/packages/user_repository/user_repos.dart';

part 'update_user_info_event.dart';
part 'update_user_info_state.dart';

class UpdateUserInfoBloc extends Bloc<UpdateUserInfoEvent, UpdateUserInfoState> {
  final UserRepository _userRepository;
  UpdateUserInfoBloc({ required UserRepository userRepository}) : _userRepository = userRepository, super(UpdateUserInfoInitial()) {
    on<UploadPicture>((event, emit) async {
      emit(UploadPictureLoading());
      try {
        String userImage = await _userRepository.uploadAvatarPicture(event.file, event.userId);
        emit(UploadPPSuccess(userImage));
      } catch (e) {
        emit(UploadPictureFailure());
      }
    });
    on<UploadBackgroundPicture>((event, emit) async { 
      try {
        String userBackgroundImage = await _userRepository.uploadBackgroundPicture(event.file, event.userId);
        emit(UploadBackgroundPictureSuccess(userBackgroundImage));
      } catch (e) {
        
      }
    });
  }
}
