import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_x/presentation/pages/home/following_screen.dart';
import 'package:flutter_x/presentation/pages/home/for_you_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../packages/blocs/auth_bloc/auth_bloc.dart';
import '../../../packages/blocs/create_post_bloc/create_post_bloc.dart';
import '../../../packages/blocs/get_post_bloc/get_post_bloc.dart';
import '../../../packages/blocs/my_user_bloc/my_user_bloc.dart';
import '../../../packages/blocs/sign_In_bloc/sign_in_bloc.dart';
import '../../../packages/blocs/update_user_info_bloc/update_user_info_bloc.dart';
import '../../../packages/post_repository/post_firebase_repos.dart';
import '../../services/post_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
  }

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
      child: BlocBuilder<MyUserBloc, MyUserState>(
        builder: (context, state) {
          if (state.status == MyUserStatus.success) {
            final currentUser = state.user!;
            return Scaffold(
              backgroundColor: Colors.white,
              floatingActionButton: FloatingActionButton(
                backgroundColor: Colors.blue,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => BlocProvider(
                        create: (context) => CreatePostBloc(
                          postRepository: PostFirebaseRepository(),
                        ),
                        child: PostScreen(currentUser),
                      ),
                    ),
                  );
                },
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
              
              body: Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    unselectedLabelColor: Colors.grey,
                    labelColor: Colors.black,
                    labelStyle: GoogleFonts.roboto(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                    indicatorColor: Colors.blue,
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: const [
                      Tab(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text('For you')],
                        ),
                      ),
                      Tab(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text('Following')],
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        MultiBlocProvider(
                          providers: [
                            BlocProvider(
                              create: (context) => SignInBloc(
                                userRepository:
                                    context.read<AuthBloc>().userRepository,
                              ),
                            ),
                            BlocProvider(
                              create: (context) => UpdateUserInfoBloc(
                                  userRepository:
                                      context.read<AuthBloc>().userRepository),
                            ),
                            BlocProvider(
                                create: (context) => MyUserBloc(
                                      myUserRepository: context
                                          .read<AuthBloc>()
                                          .userRepository,
                                    )..add(GetMyUser(
                                        myUserId: context
                                            .read<AuthBloc>()
                                            .state
                                            .user!
                                            .uid))),
                            BlocProvider(
                                create: (context) => GetPostBloc(
                                    postRepository: PostFirebaseRepository())
                                  ..add(GetPosts())),
                          ],
                          child: const ForYouScreen(),
                        ),
                        MultiBlocProvider(
                          providers: [
                            BlocProvider(
                              create: (context) => UpdateUserInfoBloc(
                                  userRepository:
                                      context.read<AuthBloc>().userRepository),
                            ),
                            BlocProvider(
                                create: (context) => MyUserBloc(
                                      myUserRepository: context
                                          .read<AuthBloc>()
                                          .userRepository,
                                    )..add(GetMyUser(
                                        myUserId: context
                                            .read<AuthBloc>()
                                            .state
                                            .user!
                                            .uid))),
                            BlocProvider(
                              create: (context) => GetPostBloc(
                                  postRepository: PostFirebaseRepository())
                                ..add(GetPostsForFollowedUsers(currentUser.id)),
                              child: Container(),
                            ),
                          ],
                          child: const FollowingScreen(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
    );
  }
}
