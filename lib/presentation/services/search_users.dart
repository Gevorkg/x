import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_x/packages/blocs/follow_bloc/follow_bloc.dart';
import 'package:flutter_x/packages/blocs/get_post_bloc/get_post_bloc.dart';
import 'package:flutter_x/packages/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:flutter_x/packages/post_repository/post_firebase_repos.dart';
import 'package:flutter_x/packages/user_repository/firebase_user_repos.dart';
import 'package:flutter_x/presentation/components/TextField.dart';
import 'package:flutter_x/presentation/components/TextStyle.dart';
import 'package:flutter_x/presentation/pages/profile/users_profile_page.dart';

import '../../packages/blocs/auth_bloc/auth_bloc.dart';
import '../../packages/blocs/user_search_bloc/user_search_bloc.dart';
import '../../packages/blocs/user_search_bloc/user_search_event.dart';
import '../../packages/blocs/user_search_bloc/user_search_state.dart';

class SearchUsersScreen extends StatefulWidget {
  const SearchUsersScreen({super.key});

  @override
  State<SearchUsersScreen> createState() => _SearchUsersScreenState();
}

class _SearchUsersScreenState extends State<SearchUsersScreen> {
  final TextEditingController _searchUsers = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchField(
              controller: _searchUsers,
              hintText: 'Search by name or nickname',
              onChanged: (query) {
                context.read<UserSearchBloc>().add(SearchUsersEvent(query));
              },
            ),
          ),
          Expanded(
            child: BlocBuilder<UserSearchBloc, UserSearchState>(
              builder: (context, state) {
                if (state is UsersLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is UsersLoaded) {
                  return ListView.builder(
                    itemCount: state.users.length,
                    itemBuilder: (context, index) {
                      final user = state.users[index];
                      return InkWell(
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
                                              ..add(GetPostsByUserId(user.id)),
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
                                              ,
                                            child: Container(),
                                          )
                                        ],
                                        child: UsersProfilePage(
                                            selectedUser: user),
                                      )));
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                user.picture != null && user.picture!.isNotEmpty
                                    ? NetworkImage(user.picture!)
                                    : null,
                            child: user.picture == null || user.picture!.isEmpty
                                ? Text(user.name[0].toUpperCase())
                                : null,
                          ),
                          title: MyTxtStlName(text: user.name),
                          subtitle: MyTxtStlTime(text: '@${user.nickname.toLowerCase()}'),
                        ),
                      );
                    },
                  );
                } else if (state is UsersError) {
                  return Center(child: Text(state.message));
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
