// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_x/packages/user_repository/models/user_model.dart';
import 'package:flutter_x/packages/blocs/sign_Up_bloc/sign_up_bloc.dart';
import 'package:flutter_x/presentation/components/TextButton.dart';
import 'package:flutter_x/presentation/components/TextField.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isPasswordVisible = false;
  bool signUpRequired = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nickname = TextEditingController();
  final _name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
        if (state is SignUpProcess) {
          setState(() {
            signUpRequired = false;
          });
        } else if (state is SignUpSuccess) {
          setState(() {
            signUpRequired = true;
          });
        } else if (state is SignUpFailure) {
          setState(() {
            signUpRequired = false;
          });
        }
      },
      child: Column(
        children: [
          SizedBox(height: 20),
          SizedBox(
            child: SearchField(
              controller: _emailController,
              hintText: 'Email',
              prefixIcon: Icons.email,
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            child: SearchField(
              controller: _passwordController,
              hintText: 'Password',
              obscureText: _isPasswordVisible,
              prefixIcon: Icons.lock,
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            child: SearchField(
                controller: _name, hintText: 'Name', prefixIcon: Icons.person),
          ),
          SizedBox(height: 20),
          SizedBox(
            child: SearchField(
              controller: _nickname,
              hintText: 'Nickname',
              prefixIcon: Icons.emoji_people,
            ),
          ),
          SizedBox(height: 20),
          !signUpRequired
              ? SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 50,
                  child: MyTextButtonAuth(
                      text: 'Sign up',
                      onPressed: () {
                        MyUser myUser = MyUser.empty;
                        myUser = myUser.copyWith(
                          email: _emailController.text,
                          nickname: _nickname.text,
                          name: _name.text
                        );
                        setState(() {
                          context.read<SignUpBloc>().add(
                              SignUpRequired(myUser, _passwordController.text));
                        });
                      }),
                )
              : const CircularProgressIndicator()
        ],
      ),
    );
  }
}
