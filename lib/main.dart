import 'package:flutter/material.dart';
import 'package:diplomski_rad/auth/login/login.dart';
import 'package:diplomski_rad/other/pallete.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  /*debugDefaultTargetPlatformOverride =
      TargetPlatform.windows; // TODO: set for multiple desktop OS*/

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: "AIzaSyCr1DO0mTiEk3G7G31ir462s61f9kiZqEQ",
    appId: "1:236389351601:web:66c1f13569d93cc056a290",
    messagingSenderId: "236389351601",
    projectId: "diplomski-rad-8bdb2",
    storageBucket: "diplomski-rad-8bdb2.appspot.com",
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: PalleteCommon.backgroundColor,
      ),
      home: LoginPage(),
    );
  }
}
