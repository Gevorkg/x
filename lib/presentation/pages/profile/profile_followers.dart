import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_x/packages/blocs/follow_bloc/follow_bloc.dart';

import '../../../packages/blocs/auth_bloc/auth_bloc.dart';
import '../../../packages/blocs/get_post_bloc/get_post_bloc.dart';
import '../../../packages/blocs/my_user_bloc/my_user_bloc.dart';
import '../../../packages/blocs/update_user_info_bloc/update_user_info_bloc.dart';
import '../../../packages/post_repository/post_firebase_repos.dart';
import '../../../packages/user_repository/firebase_user_repos.dart';
import '../../components/TextStyle.dart';
import 'users_profile_page.dart';
import 'my_profile_screen.dart';

class ProfileFollowers extends StatefulWidget {
  const ProfileFollowers({super.key});

  @override
  State<ProfileFollowers> createState() => _ProfileFollowersState();
}

class _ProfileFollowersState extends State<ProfileFollowers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<FollowBloc, FollowState>(
        builder: (context, state) {
          if (state is FollowLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetFollowersSuccess) {
            return ListView.builder(
              itemCount: state.followers.length,
              itemBuilder: (context, index) {
                final follower = state.followers[index];
                return Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: InkWell(
                    onTap: () {
                      final currentUserId =
                          context.read<AuthBloc>().state.user!.uid;
                      if (follower.id == currentUserId) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MultiBlocProvider(
                              providers: [
                                BlocProvider(
                                  create: (context) => GetPostBloc(
                                    postRepository: PostFirebaseRepository(),
                                  )..add(GetPostsByUserId(currentUserId)),
                                ),
                                BlocProvider(
                                  create: (context) => MyUserBloc(
                                    myUserRepository:
                                        context.read<AuthBloc>().userRepository,
                                  )..add(GetMyUser(myUserId: currentUserId)),
                                ),
                                BlocProvider(
                                  create: (context) => UpdateUserInfoBloc(
                                      userRepository: context
                                          .read<AuthBloc>()
                                          .userRepository),
                                ),
                              ],
                              child: const MyProfileScreen(),
                            ),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MultiBlocProvider(
                              providers: [
                                BlocProvider(
                                  create: (context) => GetPostBloc(
                                    postRepository: PostFirebaseRepository(),
                                  )..add(GetPostsByUserId(follower.id)),
                                ),
                                BlocProvider(
                                  create: (context) => MyUserBloc(
                                    myUserRepository:
                                        context.read<AuthBloc>().userRepository,
                                  )..add(GetMyUser(myUserId: currentUserId)),
                                ),
                                BlocProvider(
                                    create: (context) => FollowBloc(
                                          userRepository:
                                              FirebaseUserRepository(),
                                        )),
                              ],
                              child: UsersProfilePage(
                                  selectedUser:
                                      follower), 
                            ),
                          ),
                        );
                      }
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: follower.picture != null &&
                                follower.picture!.isNotEmpty
                            ? NetworkImage(follower.picture!)
                            : null,
                        child: follower.picture == null ||
                                follower.picture!.isEmpty
                            ? Text(follower.name[0].toUpperCase())
                            : null,
                      ),
                      title: MyTxtStlName(text: follower.name),
                      subtitle: MyTxtStlTime(text: '@${follower.nickname}'),
                    ),
                  ),
                );
              },
            );
          } else if (state is FollowFailure) {
            return Center(child: Text('Error: ${state.error}'));
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
