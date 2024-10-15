import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_x/packages/blocs/create_comment_bloc/create_comment_bloc.dart';
import 'package:flutter_x/packages/blocs/get_comment_bloc/get_comment_bloc.dart';
import 'package:flutter_x/packages/blocs/get_post_bloc/get_post_bloc.dart';
import 'package:flutter_x/packages/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:flutter_x/packages/blocs/update_user_info_bloc/update_user_info_bloc.dart';
import 'package:flutter_x/presentation/components/TextStyle.dart';
import 'package:flutter_x/presentation/pages/home/comment_screen.dart';
import 'package:flutter_x/packages/comment_repository/comment_firebase_repos.dart';
import 'package:flutter_x/packages/post_repository/post_firebase_repos.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../packages/user_repository/firebase_user_repos.dart';

class ForYouScreen extends StatefulWidget {
  const ForYouScreen({super.key});

  @override
  State<ForYouScreen> createState() => _ForYouScreenState();
}

class _ForYouScreenState extends State<ForYouScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateUserInfoBloc, UpdateUserInfoState>(
      listener: (context, state) {
        if (state is UploadPPSuccess) {
          setState(() {
            context.read<MyUserBloc>().state.user!.picture = state.userImage;
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<GetPostBloc, GetPostState>(
          builder: (context, state) {
            if (state is GetPostSuccess) {
              return ListView.builder(
                padding: const EdgeInsets.only(bottom: 150, top: 5),
                shrinkWrap: true,
                itemCount: state.posts.length,
                itemBuilder: (context, int i) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 3),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 65,
                              height: 65,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: NetworkImage(
                                      state.posts[i].myUser.picture!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 7),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        MyTxtStlName(
                                          text: state.posts[i].myUser.name,
                                        ),
                                        const SizedBox(width: 5),
                                        MyTxtStlTime(
                                          text:
                                              '@${state.posts[i].myUser.nickname.toLowerCase()}',
                                        ),
                                        const SizedBox(width: 5),
                                        MyTxtStlTime(
                                          text:
                                              '· ${timeago.format(state.posts[i].createdAt)}',
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    MyTxtStlContent(text: state.posts[i].post),
                                    if (state.posts[i].postImage != null &&
                                        state.posts[i].postImage!.isNotEmpty)
                                      Column(
                                        children: [
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                            height: 200,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: NetworkImage(
                                                      state.posts[i].postImage!,
                                                    )),
                                                color: Colors.grey,
                                                border: Border.all(
                                                  color: Colors.grey
                                                      .withOpacity(0.3),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                          ),
                                        ],
                                      ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        GestureDetector(
                                            onTap: () {
                                              final myUser = context
                                                  .read<MyUserBloc>()
                                                  .state
                                                  .user!;

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute<void>(
                                                  builder:
                                                      (BuildContext context) =>
                                                          MultiBlocProvider(
                                                    providers: [
                                                      BlocProvider(
                                                        create: (context) =>
                                                            GetPostBloc(
                                                          postRepository:
                                                              PostFirebaseRepository(),
                                                        ),
                                                      ),
                                                      BlocProvider(
                                                        create: (context) =>
                                                            CreateCommentBloc(
                                                          commentRepos:
                                                              CommentFirebaseRepos(),
                                                        ),
                                                      ),
                                                      BlocProvider(
                                                        create: (context) =>
                                                            GetCommentBloc(
                                                                CommentFirebaseRepos())
                                                              ..add(GetComment(
                                                                  postId: state
                                                                      .posts[i]
                                                                      .postId)),
                                                      ),
                                                      BlocProvider(
                                                          create: (context) => MyUserBloc(
                                                              myUserRepository:
                                                                  FirebaseUserRepository())
                                                            ..add(GetMyUser(
                                                                myUserId: myUser
                                                                    .id))),
                                                    ],
                                                    child: CommentScreen(
                                                      myUser: myUser,
                                                      post: state.posts[i],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.comment,
                                                  color: Colors.grey,
                                                  size: 19,
                                                ),
                                                const SizedBox(width: 5),
                                                state.posts[i].commentCount == 0
                                                    ? const Padding(
                                                      padding: EdgeInsets.only(left: 8),
                                                      child: Text(
                                                          '',
                                                          style: TextStyle(
                                                            color: Colors.grey,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                    )
                                                    : Text(
                                                        state.posts[i]
                                                            .commentCount
                                                            .toString(),
                                                        style: const TextStyle(
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 16,
                                                        ),
                                                      )
                                              ],
                                            )),
                                        const SizedBox(width: 15),
                                        GestureDetector(
                                          onTap: () {
                                            final myUser = context
                                                .read<MyUserBloc>()
                                                .state
                                                .user;

                                            if (myUser != null) {
                                              context.read<GetPostBloc>().add(
                                                    LikePostEvent(
                                                        state.posts[i].postId,
                                                        myUser),
                                                  );
                                            }
                                          },
                                          child: BlocBuilder<MyUserBloc,
                                              MyUserState>(
                                            builder: (context, myUserState) {
                                              final myUser = myUserState.user;

                                              return Icon(
                                                state.posts[i].likedBy.contains(
                                                        myUser?.nickname)
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                color: state.posts[i].likedBy
                                                        .contains(
                                                            myUser?.nickname)
                                                    ? Colors.red
                                                    : Colors.grey,
                                                size: 20,
                                              );
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(state.posts[i].likes.toString(),
                                            style: const TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 16)),
                                      ],
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
                    ],
                  );
                },
              );
            } else if (state is GetPostLoading) {
              return const CircularProgressIndicator();
            } else {
              return const Center(child: Text('Something went wrong'));
            }
          },
        ),
      ),
    );
  }
}
