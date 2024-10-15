part of 'update_user_info_bloc.dart';

sealed class UpdateUserInfoState extends Equatable {
  const UpdateUserInfoState();

  @override
  List<Object> get props => [];
}

class UpdateUserInfoSuccess extends UpdateUserInfoState {}

class UpdateUserInfoFailure extends UpdateUserInfoState {}

class UpdateUserInfoInitial extends UpdateUserInfoState {}

class UploadPictureFailure extends UpdateUserInfoState {}

class UploadPictureLoading extends UpdateUserInfoState {}

class UploadPPSuccess extends UpdateUserInfoState {
  final String userImage;

  const UploadPPSuccess(this.userImage);

  @override
  List<Object> get props => [userImage];
}

class UploadBackgroundPictureSuccess extends UpdateUserInfoState {
  final String userBackgroundImage;

  UploadBackgroundPictureSuccess(this.userBackgroundImage);

  @override
  List<Object> get props => [userBackgroundImage];
}
