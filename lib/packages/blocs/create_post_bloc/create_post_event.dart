// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'create_post_bloc.dart';

sealed class CreatePostEvent extends Equatable {
  const CreatePostEvent();

  @override
  List<Object> get props => [];
}

class CreatePost extends CreatePostEvent {
  final Post post;
  final String? imageFile;

  CreatePost(this.post, {this.imageFile});
}
