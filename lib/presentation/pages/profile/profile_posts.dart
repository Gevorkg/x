import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../packages/blocs/get_post_bloc/get_post_bloc.dart';
import '../../components/TextStyle.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class ProfilePosts extends StatefulWidget {
  const ProfilePosts({super.key});

  @override
  State<ProfilePosts> createState() => _ProfilePostsState();
}

class _ProfilePostsState extends State<ProfilePosts> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: BlocBuilder<GetPostBloc, GetPostState>(
            builder: (context, state) {
              if (state is GetPostSuccess) {
                return SingleChildScrollView(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 150, top: 10),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.posts.length,
                    itemBuilder: (context, i) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            MyTxtStlContent(
                                                text: state
                                                    .posts[i].myUser.nickname),
                                            const SizedBox(width: 10),
                                            Text(
                                              timeago.format(
                                                  state.posts[i].createdAt),
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                        MyTxtStlContent(
                                            text: state.posts[i].post),
                                        const SizedBox(height: 5),
                                        if (state.posts[i].postImage != null &&
                                            state
                                                .posts[i].postImage!.isNotEmpty)
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
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(60, 10, 0, 0),
                              child: Row(
                                children: [
                                  Text(
                                    DateFormat('HH:mm · dd.MM.yyyy')
                                        .format(state.posts[i].createdAt),
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
                                  const SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (state.posts[i].likedBy.contains(
                                            state.posts[i].myUser.nickname)) {
                                          state.posts[i].likedBy.remove(
                                              state.posts[i].myUser.nickname);
                                          state.posts[i].likes -= 1;
                                        } else {
                                          state.posts[i].likedBy.add(
                                              state.posts[i].myUser.nickname);
                                          state.posts[i].likes += 1;
                                        }
                                      });

                                      context.read<GetPostBloc>().add(
                                            LikePostEvent(state.posts[i].postId,
                                                state.posts[i].myUser),
                                          );
                                    },
                                    child: Icon(
                                      state.posts[i].likedBy.contains(
                                              state.posts[i].myUser.nickname)
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: state.posts[i].likedBy.contains(
                                              state.posts[i].myUser.nickname)
                                          ? Colors.red
                                          : Colors.grey,
                                      size: 20,
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
                            ),
                            Divider(
                              thickness: 0.5,
                              color: Colors.grey.withOpacity(0.4),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              } else if (state is GetPostLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return const Center(
                  child: Text('Error loading posts'),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
