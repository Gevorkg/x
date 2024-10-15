import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_x/packages/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter_x/packages/blocs/get_post_bloc/get_post_bloc.dart';
import 'package:flutter_x/packages/blocs/my_user_bloc/my_user_bloc.dart';
import 'package:flutter_x/packages/blocs/sign_In_bloc/sign_in_bloc.dart';
import 'package:flutter_x/packages/blocs/update_user_info_bloc/update_user_info_bloc.dart';
import 'package:flutter_x/presentation/pages/authetication/auth_screen.dart';
import 'package:flutter_x/packages/post_repository/post_firebase_repos.dart';
import 'package:flutter_x/presentation/pages/app/main_screen.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GG',
      home: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state.status == AuthStatus.authenticated) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => SignInBloc(
                    userRepository: context.read<AuthBloc>().userRepository,
                  ),
                ),
                BlocProvider(
                  create: (context) => UpdateUserInfoBloc(
                      userRepository: context.read<AuthBloc>().userRepository),
                ),
                BlocProvider(
                    create: (context) => MyUserBloc(
                          myUserRepository:
                              context.read<AuthBloc>().userRepository,
                        )..add(GetMyUser(
                            myUserId:
                                context.read<AuthBloc>().state.user!.uid))),
                BlocProvider(
                    create: (context) =>
                        GetPostBloc(postRepository: PostFirebaseRepository())
                          ..add(GetPosts())),
                
              ],
              child: const MainScreen(),
            );
          } else if (state.status == AuthStatus.unauthenticated) {
            return const AuthScreen();
          } else { 
            return const AuthScreen();
          }
        },
      ),
    );
  }
}
