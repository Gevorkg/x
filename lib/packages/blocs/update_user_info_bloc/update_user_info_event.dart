part of 'update_user_info_bloc.dart';

abstract class UpdateUserInfoEvent extends Equatable {
  const UpdateUserInfoEvent();

  @override
  List<Object> get props => [];
}

class UpdateUserInfo extends UpdateUserInfoEvent {
  final String userId;
  final String? name;
  final String? bio;

  const UpdateUserInfo({
    required this.userId,
    this.name,
    this.bio,
  });
}

class UploadPicture extends UpdateUserInfoEvent {
  final String file;
  final String userId;

  const UploadPicture(this.file, this.userId);

  @override
  List<Object> get props => [file, userId];
}

class UploadBackgroundPicture extends UpdateUserInfoEvent {
  final String file;
  final String userId;

  const UploadBackgroundPicture(this.file, this.userId);

  @override
  List<Object> get props => [file, userId];
}
