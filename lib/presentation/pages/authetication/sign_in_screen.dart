// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_x/packages/blocs/sign_In_bloc/sign_in_bloc.dart';
import 'package:flutter_x/presentation/components/TextButton.dart';
import 'package:flutter_x/presentation/components/TextField.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool signInRequired = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInBloc, SignInState>(
      listener: (context, state) {
        if (state is SignInSucess) {
          setState(() {
            signInRequired = false;
          });
        } else if (state is SignInProcess) {
          setState(() {
            signInRequired = true;
          });
        } else if (state is SignInFailure) {
          setState(() {
            signInRequired = false;
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
          !signInRequired ?
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 50,
              child: MyTextButtonAuth(
                text: 'Sign in',
                onPressed: () {
                  context.read<SignInBloc>().add(SignInRequired(
                        _emailController.text,
                        _passwordController.text,
                      ));
                },
              ),
            )
            : const CircularProgressIndicator()
        ],
      ),
    );
  }
}
