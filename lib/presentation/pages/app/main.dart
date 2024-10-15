import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_x/presentation/pages/app/app.dart';
import 'package:flutter_x/packages/user_repository/firebase_user_repos.dart';

Future<void> main() async {  
 WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(App(FirebaseUserRepository()));
}
