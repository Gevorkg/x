import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_x/packages/blocs/follow_bloc/follow_bloc.dart';
import 'package:flutter_x/packages/blocs/message_bloc/message_bloc.dart';
import 'package:flutter_x/packages/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:flutter_x/packages/chat_repository/firebase_chat_repos.dart';

import 'package:flutter_x/presentation/components/TextButton.dart';
import 'package:flutter_x/presentation/components/TextStyle.dart';
import 'package:flutter_x/presentation/pages/home/chat_screen.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../packages/blocs/auth_bloc/auth_bloc.dart';
import '../../../packages/blocs/get_post_bloc/get_post_bloc.dart';
import '../../../packages/post_repository/post_firebase_repos.dart';
import '../../../packages/user_repository/firebase_user_repos.dart';
import '../../../packages/user_repository/models/user_model.dart';
import 'profile_followers.dart';
import 'profile_following.dart';
import 'profile_posts.dart';

class UsersProfilePage extends StatefulWidget {
  final MyUser selectedUser;
  const UsersProfilePage({super.key, required this.selectedUser});

  @override
  State<UsersProfilePage> createState() => _UsersProfilePageState();
}

class _UsersProfilePageState extends State<UsersProfilePage>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      initialIndex: 0,
      length: 3,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    final targetUser = widget.selectedUser;

    return BlocBuilder<MyUserBloc, MyUserState>(
      builder: (context, state) {
        MyUser? currentUser;
        if (state.status == MyUserStatus.success) {
          currentUser = state.user;
          context
              .read<FollowBloc>()
              .add(CheckFollowStatus(currentUser!.id, targetUser.id));
        }

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            title: MyTxtStlName(text: targetUser.name),
          ),
          body: Column(
            children: [
              Column(
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          image: targetUser.backgroundPicture != null &&
                                  targetUser.backgroundPicture!.isNotEmpty
                              ? DecorationImage(
                                  image: NetworkImage(
                                      targetUser.backgroundPicture!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: targetUser.backgroundPicture == null ||
                                targetUser.backgroundPicture!.isEmpty
                            ? const Center(child: SizedBox())
                            : null,
                      ),
                      Positioned(
                        top: 100,
                        left: 16,
                        child: CircleAvatar(
                          radius: 45,
                          backgroundColor: Colors.grey,
                          backgroundImage: targetUser.picture != null &&
                                  targetUser.picture!.isNotEmpty
                              ? NetworkImage(targetUser.picture!)
                              : null,
                          child: targetUser.picture == null ||
                                  targetUser.picture!.isEmpty
                              ? const Center(child: Icon(Icons.person))
                              : null,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 50, left: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyTxtStlName(text: targetUser.name),
                            const SizedBox(height: 2),
                            MyTxtStlContent(
                              text: '@${targetUser.nickname}',
                            ),
                            const SizedBox(height: 10),
                            MyTxtStlContent(text: targetUser.bio ?? ''),
                          ],
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, right: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MultiBlocProvider(
                                      providers: [
                                        BlocProvider(
                                          create: (context) => MessageBloc(
                                            chatRepository:
                                                FirebaseChatRepository(),
                                          )..add(
                                              LoadMessages(
                                                  state.user!.id, targetUser.id),
                                            ),
                                        ),
                                        BlocProvider(
                                          create: (context) => MyUserBloc(
                                            myUserRepository: context
                                                .read<AuthBloc>()
                                                .userRepository,
                                          )..add(GetMyUser(
                                              myUserId: currentUser!.id)),
                                        ),
                                      ],
                                      child: ChatScreen(
                                          sender: state.user!,
                                          receiver: targetUser),
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.email, size: 30),
                            ),
                            const SizedBox(width: 5,),
                            BlocBuilder<FollowBloc, FollowState>(
                              builder: (context, state) {
                                bool isFollowing = (state is FollowSuccess)
                                    ? state.isFollowing
                                    : false;
                        
                                return MyTextButtonSubscribe(
                                  onPressed: () {
                                    if (currentUser != null) {
                                      context.read<FollowBloc>().add(FollowUser(
                                          currentUser.id, targetUser.id));
                                    }
                                  },
                                  text: isFollowing ? 'Unfollow' : 'Follow',
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 10),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              TabBar(
                controller: tabController,
                unselectedLabelColor: Colors.grey,
                labelColor: Colors.black,
                labelStyle: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
                indicatorColor: Colors.blue,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: [
                  Expanded(
                    child: Tab(
                      child: BlocBuilder<GetPostBloc, GetPostState>(
                        builder: (context, postState) {
                          if (postState is GetPostSuccess) {
                            return Text('${postState.posts.length} posts');
                          } else if (postState is GetPostLoading) {
                            return const CircularProgressIndicator();
                          } else {
                            return const Text('0 posts');
                          }
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(targetUser.followers.isNotEmpty
                              ? targetUser.followers.length.toString()
                              : '0'),
                          const SizedBox(width: 5),
                          const Text('followers'),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Tab(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(targetUser.following.isNotEmpty
                              ? targetUser.following.length.toString()
                              : '0'),
                          const SizedBox(width: 5),
                          const Text('following'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(controller: tabController, children: [
                  BlocProvider(
                    create: (context) =>
                        GetPostBloc(postRepository: PostFirebaseRepository())
                          ..add(GetPostsByUserId(targetUser.id)),
                    child: const ProfilePosts(),
                  ),
                  MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) => MyUserBloc(
                          myUserRepository:
                              context.read<AuthBloc>().userRepository,
                        )..add(GetMyUser(
                            myUserId:
                                context.read<AuthBloc>().state.user!.uid)),
                      ),
                      BlocProvider(
                        create: (context) => FollowBloc(
                          userRepository: FirebaseUserRepository(),
                        )..add(GetFollowers(userId: targetUser.id)),
                      ),
                    ],
                    child: const ProfileFollowers(),
                  ),
                  MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) => MyUserBloc(
                          myUserRepository:
                              context.read<AuthBloc>().userRepository,
                        )..add(GetMyUser(
                            myUserId:
                                context.read<AuthBloc>().state.user!.uid)),
                      ),
                      BlocProvider(
                        create: (context) => FollowBloc(
                          userRepository: FirebaseUserRepository(),
                        )..add(GetFollowing(userId: targetUser.id)),
                      ),
                    ],
                    child: const ProfileFollowing(),
                  ),
                ]),
              )
            ],
          ),
        );
      },
    );
  }
}
