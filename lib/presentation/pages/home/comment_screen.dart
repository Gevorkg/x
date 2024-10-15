import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_x/packages/blocs/create_comment_bloc/create_comment_bloc.dart';
import 'package:flutter_x/packages/blocs/get_comment_bloc/get_comment_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../packages/comment_repository/models/comment_model.dart';
import '../../../packages/post_repository/models/post_model.dart';
import '../../../packages/user_repository/models/user_model.dart';
import '../../../packages/blocs/get_post_bloc/get_post_bloc.dart';
import '../../../packages/blocs/my_user_bloc/my_user_bloc.dart';
import '../../components/TextField.dart';
import '../../components/TextStyle.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentScreen extends StatefulWidget {
  final Post post;
  final MyUser myUser;

  const CommentScreen({required this.myUser, required this.post, super.key});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  late Comment comment;
  final TextEditingController _commentController = TextEditingController();
  String? imagePath;

  @override
  void initState() {
    super.initState();
    comment = Comment.empty..myUser = widget.myUser;
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        imagePath = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        title: const MyTxtStlArtic(text: 'Post'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: BlocBuilder<GetCommentBloc, GetCommentState>(
              builder: (context, state) {
                int commentCount = 0;
                if (state is GetCommentSuccess) {
                  commentCount = state.comments.length;
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image:
                                    NetworkImage(widget.post.myUser.picture!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      MyTxtStlName(
                                        text: widget.post.myUser.name,
                                      ),
                                      const SizedBox(width: 5),
                                      MyTxtStlTime(
                                        text:
                                            '@${widget.post.myUser.nickname.toLowerCase()}',
                                      ),
                                      const SizedBox(width: 5),
                                      MyTxtStlTime(
                                        text:
                                            '· ${timeago.format(widget.post.createdAt)}',
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  MyTxtStlContent(text: widget.post.post),
                                  if (widget.post.postImage != null &&
                                      widget.post.postImage!.isNotEmpty)
                                    Column(
                                      children: [
                                        const SizedBox(height: 5),
                                        Container(
                                          height: 200,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  widget.post.postImage!),
                                            ),
                                            color: Colors.grey,
                                            border: Border.all(
                                              color:
                                                  Colors.grey.withOpacity(0.3),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                        ),
                                      ],
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Row(
                                      children: [
                                        Text(
                                          DateFormat('HH:mm · dd.MM.yyyy')
                                              .format(widget.post.createdAt),
                                          style: const TextStyle(
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15),
                                        ),
                                        const Spacer(),
                                        const Icon(
                                          Icons.comment,
                                          size: 19,
                                          color: Colors.grey,
                                        ),
                                        const SizedBox(width: 5),
                                        commentCount == 0
                                            ? const Text('')
                                            : Text(
                                                commentCount.toString(),
                                                style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 16,
                                                ),
                                              ),
                                        const SizedBox(width: 10),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              if (widget.post.likedBy.contains(
                                                  widget.myUser.nickname)) {
                                                widget.post.likedBy.remove(
                                                    widget.myUser.nickname);
                                                widget.post.likes -= 1;
                                              } else {
                                                widget.post.likedBy.add(
                                                    widget.myUser.nickname);
                                                widget.post.likes += 1;
                                              }
                                            });

                                            context.read<GetPostBloc>().add(
                                                  LikePostEvent(
                                                      widget.post.postId,
                                                      widget.myUser),
                                                );
                                          },
                                          child: Icon(
                                            widget.post.likedBy.contains(
                                                    widget.myUser.nickname)
                                                ? Icons.favorite
                                                : Icons.favorite_border,
                                            color: widget.post.likedBy.contains(
                                                    widget.myUser.nickname)
                                                ? Colors.red
                                                : Colors.grey,
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(widget.post.likes.toString(),
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      thickness: 1,
                      color: Colors.grey.withOpacity(0.4),
                    ),
                    BlocBuilder<GetCommentBloc, GetCommentState>(
                      builder: (context, state) {
                        if (state is GetCommentSuccess) {
                          return ListView.builder(
                            padding: const EdgeInsets.only(bottom: 150, top: 5),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.comments.length,
                            itemBuilder: (context, int i) {
                              final currentUser =
                                  context.read<MyUserBloc>().state.user;
                              final isCurrentUserComment =
                                  state.comments[i].myUser.id ==
                                      currentUser?.id;
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                              image: NetworkImage(state
                                                  .comments[i].myUser.picture!),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    MyTxtStlName(
                                                      text: state.comments[i]
                                                          .myUser.name,
                                                    ),
                                                    const SizedBox(width: 5),
                                                    MyTxtStlTime(
                                                      text:
                                                          '@${state.comments[i].myUser.nickname.toLowerCase()}',
                                                    ),
                                                    const SizedBox(width: 5),
                                                    MyTxtStlTime(
                                                      text:
                                                          '· ${timeago.format(state.comments[i].createdAt)}',
                                                    ),
                                                    const Spacer(),
                                                    if (isCurrentUserComment)
                                                      GestureDetector(
                                                        onTap: () {
                                                          context
                                                              .read<
                                                                  CreateCommentBloc>()
                                                              .add(
                                                                DeleteComment(
                                                                  state
                                                                      .comments[
                                                                          i]
                                                                      .commentId,
                                                                  currentUser!
                                                                      .id,
                                                                ),
                                                              );
                                                        },
                                                        child: const Icon(
                                                          Icons.delete,
                                                          size: 20,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                  ],
                                                ),
                                                MyTxtStlContent(
                                                  text:
                                                      state.comments[i].comment,
                                                ),
                                                const SizedBox(height: 5),
                                                if (state.comments[i]
                                                            .commentImage !=
                                                        null &&
                                                    state
                                                        .comments[i]
                                                        .commentImage!
                                                        .isNotEmpty)
                                                  Container(
                                                    height: 200,
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: NetworkImage(
                                                            state.comments[i]
                                                                .commentImage!),
                                                      ),
                                                      color: Colors.grey,
                                                      border: Border.all(
                                                        color: Colors.grey
                                                            .withOpacity(0.3),
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    const Icon(
                                                      Icons.comment,
                                                      color: Colors.grey,
                                                      size: 19,
                                                    ),
                                                    const SizedBox(width: 5),
                                                    state.comments[i]
                                                                .commentCount ==
                                                            0
                                                        ? const Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 8),
                                                            child: Text(
                                                              '',
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.grey,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                          )
                                                        : Text(
                                                            state.comments[i]
                                                                .commentCount
                                                                .toString(),
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                    // const Spacer(),
                                                    GestureDetector(
                                                      onTap: () {
                                                        final myUser = context
                                                            .read<MyUserBloc>()
                                                            .state
                                                            .user;

                                                        if (myUser != null) {
                                                          setState(() {
                                                            if (state
                                                                .comments[i]
                                                                .likedBy
                                                                .contains(myUser
                                                                    .nickname)) {
                                                              state.comments[i]
                                                                  .likedBy
                                                                  .remove(myUser
                                                                      .nickname);
                                                              state.comments[i]
                                                                  .likes -= 1;
                                                            } else {
                                                              state.comments[i]
                                                                  .likedBy
                                                                  .add(myUser
                                                                      .nickname);
                                                              state.comments[i]
                                                                  .likes += 1;
                                                            }
                                                          });
                                                          context
                                                              .read<
                                                                  GetCommentBloc>()
                                                              .add(
                                                                LikeCommentEvent(
                                                                    state
                                                                        .comments[
                                                                            i]
                                                                        .commentId,
                                                                    myUser),
                                                              );
                                                        }
                                                      },
                                                      child: BlocBuilder<
                                                          MyUserBloc,
                                                          MyUserState>(
                                                        builder: (context,
                                                            myUserState) {
                                                          final myUser =
                                                              myUserState.user;
                                                          return Icon(
                                                            state.comments[i]
                                                                    .likedBy
                                                                    .contains(myUser
                                                                        ?.nickname)
                                                                ? Icons.favorite
                                                                : Icons
                                                                    .favorite_border,
                                                            color: state
                                                                    .comments[i]
                                                                    .likedBy
                                                                    .contains(myUser
                                                                        ?.nickname)
                                                                ? Colors.red
                                                                : Colors.grey,
                                                            size: 20,
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Text(
                                                      state.comments[i].likes
                                                          .toString(),
                                                      style: const TextStyle(
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(
                                    thickness: 0.5,
                                    color: Colors.grey.withOpacity(0.4),
                                  ),
                                ],
                              );
                            },
                          );
                        } else if (state is GetCommentLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return const Center(
                            child: Text('Something went wrong'),
                          );
                        }
                      },
                    ),
                  ],
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SearchField(
                    controller: _commentController,
                    hintText: 'Type your answer...',
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: _pickImage,
                        icon: const Icon(Icons.picture_as_pdf),
                      ),
                      if (imagePath != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Image.file(
                            File(imagePath!),
                            height: 50,
                            width: 50,
                          ),
                        ),
                      BlocListener<CreateCommentBloc, CreateCommentState>(
                        listener: (context, state) {
                          if (state is CreateCommentSuccess) {
                            FocusScope.of(context).unfocus();
                            setState(() {
                              imagePath = null; // Сбрасываем путь к изображению
                            });
                            _commentController.clear();
                          }
                        },
                        child: IconButton(
                          onPressed: () {
                            if (_commentController.text.isNotEmpty) {
                              setState(() {
                                comment.postId = widget.post.postId;
                                comment.comment = _commentController.text;
                                context.read<CreateCommentBloc>().add(
                                    CreateComment(comment,
                                        imageFile: imagePath));
                              });
                            } else {}
                          },
                          icon: const Icon(Icons.publish),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
