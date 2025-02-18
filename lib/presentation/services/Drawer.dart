import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_x/presentation/components/TextStyle.dart';
import 'package:flutter_x/presentation/pages/profile/my_profile_screen.dart';
import '../../packages/blocs/update_user_info_bloc/update_user_info_bloc.dart';
import '../../packages/post_repository/post_firebase_repos.dart';
import '../../packages/user_repository/firebase_user_repos.dart';
import '../../packages/blocs/auth_bloc/auth_bloc.dart';
import '../../packages/blocs/get_post_bloc/get_post_bloc.dart';
import '../../packages/blocs/my_user_bloc/my_user_bloc.dart';
import '../../packages/blocs/sign_In_bloc/sign_in_bloc.dart';
import '../../packages/blocs/user_search_bloc/user_search_bloc.dart';
import '../pages/home/messages.dart';
import 'search_users.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: BlocBuilder<MyUserBloc, MyUserState>(
        builder: (context, state) {
          if (state.status == MyUserStatus.success) {
            final myUser = state.user!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UserAccountsDrawerHeader(
                  currentAccountPicture: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(myUser.picture!)))),
                  accountName: MyTxtStlName(text: myUser.name),
                  accountEmail: MyTxtStlNickname(text: '@${myUser.nickname.toLowerCase()}'),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.person, size: 26),
                  title: const MyTxtStlDrawer(text: 'Profile'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MultiBlocProvider(
                          providers: [
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
                                  ..add(GetPostsByUserId(myUser.id))),
                            BlocProvider(
                              create: (context) => UpdateUserInfoBloc(
                                  userRepository:
                                      context.read<AuthBloc>().userRepository),
                            ),
                          ],
                          child: const MyProfileScreen(),
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.search, size: 26),
                  title: const MyTxtStlDrawer(text: 'Search'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MultiBlocProvider(
                          providers: [
                            BlocProvider(
                              create: (context) =>
                                  UserSearchBloc(FirebaseUserRepository()),
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
                                  postRepository: PostFirebaseRepository()),
                            ),
                          ],
                          child: const SearchUsersScreen(),
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings, size: 26),
                  title: const MyTxtStlDrawer(text: 'Settings'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MultiBlocProvider(
                          providers: [
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
                          ],
                          child: const MessagesScreen(),
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                    leading: const Icon(Icons.exit_to_app, size: 26),
                    title: const MyTxtStlDrawer(text: 'Log out'),
                    onTap: () {
                      context.read<SignInBloc>().add(const SignOutRequired());
                    })
              ],
            );
          } else if (state.status == MyUserStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Center(child: Text('Error loading user data'));
          }
        },
      ),
    );
  }
}
