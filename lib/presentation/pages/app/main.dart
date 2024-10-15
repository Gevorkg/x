import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_x/presentation/pages/app/app.dart';
import 'package:flutter_x/packages/user_repository/firebase_user_repos.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: 'AIzaSyD3C93mhzi38HZk51pLZoj4HlNELTjTSGQ',
    appId: "1:555128633980:android:9149fbbff424e34f77e7f9",
    messagingSenderId: "555128633980",
    projectId: "twitterclone-c246b",
    storageBucket: "twitterclone-c246b.appspot.com",
  ));

  final notifications = FirebaseMessaging.instance;
  notifications.getToken().then((token) => log(token ?? ''));
  NotificationSettings settings = await notifications.requestPermission(
  alert: true,
  announcement: false,
  badge: true,
  carPlay: false,
  criticalAlert: false,
  provisional: false,
  sound: true,
);

print('User granted permission: ${settings.authorizationStatus}');

  runApp(App(FirebaseUserRepository()));
}
