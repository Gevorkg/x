import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_x/packages/blocs/auth_bloc/auth_bloc.dart';
import 'package:flutter_x/packages/blocs/sign_In_bloc/sign_in_bloc.dart';
import 'package:flutter_x/packages/blocs/sign_Up_bloc/sign_up_bloc.dart';
import 'package:flutter_x/presentation/pages/authetication/sign_in_screen.dart';
import 'package:flutter_x/presentation/pages/authetication/sign_up_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Text('Welcome.',
                    style: GoogleFonts.roboto(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    )),
                const SizedBox(height: kToolbarHeight),
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
                    tabs: const [
                      Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ]),
                Expanded(
                  child: TabBarView(controller: tabController, children: [
                    BlocProvider<SignInBloc>(
                      create: (context) => SignInBloc(
                          userRepository:
                              context.read<AuthBloc>().userRepository),
                      child: const SignInScreen(),
                    ),
                    BlocProvider<SignUpBloc>(
                      create: (context) => SignUpBloc(
                          userRepository:
                              context.read<AuthBloc>().userRepository),
                      child: const SignUpScreen(),
                    ),
                  ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
