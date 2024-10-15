import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_x/presentation/pages/home/messages.dart';
import '../../../packages/blocs/auth_bloc/auth_bloc.dart';
import '../../../packages/blocs/get_post_bloc/get_post_bloc.dart';
import '../../../packages/blocs/my_user_bloc/my_user_bloc.dart';
import '../../../packages/blocs/user_search_bloc/user_search_bloc.dart';
import '../../../packages/post_repository/post_firebase_repos.dart';
import '../../../packages/user_repository/firebase_user_repos.dart';
import '../../services/Drawer.dart';
import '../../widgets/app_bar_widget.dart';
import '../home/home_screen.dart';
import '../../services/search_users.dart';
import '../../services/notifications.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const SearchUsersScreen(),
    const NotificationsScreen(),
    const MessagesScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyUserBloc, MyUserState>(
      builder: (context, state) {
        if (state.status == MyUserStatus.success) {
          final currentUser = state.user!;
          return Scaffold(
            drawer: const DrawerWidget(),
            appBar: MyAppBar(currentUser: currentUser),
            body: Center(
              child: _selectedIndex == 1
                  ? MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (context) =>
                              UserSearchBloc(FirebaseUserRepository()),
                        ),
                        BlocProvider(
                          create: (context) => MyUserBloc(
                            myUserRepository:
                                context.read<AuthBloc>().userRepository,
                          )..add(GetMyUser(
                              myUserId:
                                  context.read<AuthBloc>().state.user!.uid,
                            )),
                        ),
                        BlocProvider(
                          create: (context) => GetPostBloc(
                            postRepository: PostFirebaseRepository(),
                          ),
                        ),
                      ],
                      child: const SearchUsersScreen(),
                    )
                  : _widgetOptions[_selectedIndex],
            ),
            bottomNavigationBar: SizedBox(
              height: 65,
              child: BottomAppBar(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.home,
                        size: _selectedIndex == 0 ? 32 : 30,
                        color: _selectedIndex == 0 ? Colors.black : Colors.grey,
                      ),
                      onPressed: () => _onItemTapped(0),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.search,
                        size: _selectedIndex == 1 ? 32 : 30,
                        color: _selectedIndex == 1 ? Colors.black : Colors.grey,
                      ),
                      onPressed: () => _onItemTapped(1),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.notifications,
                        size: _selectedIndex == 2 ? 32 : 30,
                        color: _selectedIndex == 2 ? Colors.black : Colors.grey,
                      ),
                      onPressed: () => _onItemTapped(2),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.chat,
                        size: _selectedIndex == 3 ? 32 : 30,
                        color: _selectedIndex == 3 ? Colors.black : Colors.grey,
                      ),
                      onPressed: () => _onItemTapped(3),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
