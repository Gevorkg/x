

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_x/presentation/pages/app.dart';
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
  runApp(App(FirebaseUserRepository()));
}
