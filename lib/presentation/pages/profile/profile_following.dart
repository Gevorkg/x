import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../packages/blocs/auth_bloc/auth_bloc.dart';
import '../../../packages/blocs/follow_bloc/follow_bloc.dart';
import '../../../packages/blocs/get_post_bloc/get_post_bloc.dart';
import '../../../packages/blocs/my_user_bloc/my_user_bloc.dart';
import '../../../packages/post_repository/post_firebase_repos.dart';
import '../../../packages/user_repository/firebase_user_repos.dart';
import '../../components/TextStyle.dart';
import '../users_profile_page.dart';

class ProfileFollowing extends StatefulWidget {
  const ProfileFollowing({super.key});

  @override
  State<ProfileFollowing> createState() => _ProfileFollowingState();
}

class _ProfileFollowingState extends State<ProfileFollowing> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.white,
      body: BlocBuilder<FollowBloc, FollowState>(
        builder: (context, state) {
          if (state is FollowLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetFollowingSuccess) {
            return ListView.builder(
              itemCount: state.following.length,
              itemBuilder: (context, index) {
                final following = state.following[index];
                return Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: InkWell(
                    onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MultiBlocProvider(
                                        providers: [
                                          BlocProvider(
                                            create: (context) => GetPostBloc(
                                                postRepository:
                                                    PostFirebaseRepository())
                                              ..add(GetPostsByUserId(following.id)),
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
                                            create: (context) => FollowBloc(
                                                userRepository:
                                                    FirebaseUserRepository())
                                              ..add(FollowUser(
                                                  context
                                                          .read<AuthBloc>()
                                                          .state
                                                          .user!
                                                          .uid, following.id)),
                                           
                                          )
                                        ],
                                        child: UsersProfilePage(
                                            selectedUser: following),
                                      )));
                        },
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            following.picture != null && following.picture!.isNotEmpty
                                ? NetworkImage(following.picture!)
                                : null,
                        child: following.picture == null || following.picture!.isEmpty
                            ? Text(following.name[0].toUpperCase())
                            : null,
                      ),
                      title: MyTxtStlName(text: following.name),
                      subtitle: MyTxtStlTime(text: '@${following.nickname}'),
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