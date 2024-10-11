import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_x/packages/blocs/follow_bloc/follow_bloc.dart';
import 'package:flutter_x/packages/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:flutter_x/presentation/components/TextButton.dart';
import 'package:flutter_x/presentation/components/TextStyle.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../packages/blocs/auth_bloc/auth_bloc.dart';
import '../../packages/blocs/get_post_bloc/get_post_bloc.dart';
import '../../packages/post_repository/post_firebase_repos.dart';
import '../../packages/user_repository/firebase_user_repos.dart';
import '../../packages/user_repository/models/user_model.dart';
import 'profile/profile_followers.dart';
import 'profile/profile_following.dart';
import 'profile/profile_posts.dart';

class UsersProfilePage extends StatefulWidget {
  final MyUser selectedUser;
  const UsersProfilePage({super.key, required this.selectedUser});

  @override
  State<UsersProfilePage> createState() => _UsersProfilePageState();
}

class _UsersProfilePageState extends State<UsersProfilePage>
    with TickerProviderStateMixin {
  bool IsFollowed = false;
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: Container(
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            image: targetUser.backgroundPicture != null &&
                                    targetUser.backgroundPicture!.isNotEmpty
                                ? DecorationImage(
                                    image: NetworkImage(
                                        targetUser.backgroundPicture!),
                                  )
                                : null,
                          ),
                          child: targetUser.backgroundPicture == null ||
                                  targetUser.backgroundPicture!.isEmpty
                              ? const Center(child: SizedBox())
                              : null,
                        ),
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
                          children: [
                            MyTxtStlName(text: targetUser.name),
                            MyTxtStlContent(
                              text: '@${targetUser.nickname}',
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MyTextButtonSubscribe(
                          onPressed: () {
                            if (currentUser != null) {
                              context.read<FollowBloc>().add(
                                  FollowUser(currentUser.id, targetUser.id));
                            }
                          },
                          text: 'Follow',
                          padding: const EdgeInsets.symmetric(horizontal: 17),
                        ),
                      )
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
                        )..add(GetFollowing(
                            userId: targetUser
                                .id)), 
                        
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
