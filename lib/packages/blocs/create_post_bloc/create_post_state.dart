part of 'create_post_bloc.dart';

sealed class CreatePostState extends Equatable {
  const CreatePostState();
  
  @override
  List<Object> get props => [];
}

final class CreatePostInitial extends CreatePostState {}

class CreatePostLoading extends CreatePostState { }

class CreatePostFailure extends CreatePostState { }

class CreatePostSucess extends CreatePostState {
  final Post post;

  CreatePostSucess(this.post);
 }

