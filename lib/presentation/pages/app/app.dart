import 'package:flutter/widgets.dart';
import 'package:flutter_x/packages/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter_x/presentation/pages/app/app_view.dart';
import 'package:flutter_x/packages/user_repository/user_repos.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class App extends StatelessWidget {
  final UserRepository userRepository;
  const App(this.userRepository, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(myUserRepository: userRepository),
        ),
      ],
      child: const MyAppView(),
    );
  }
}
