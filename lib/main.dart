import 'package:flutter/material.dart';
import 'package:diplomski_rad/auth/login/login.dart';
import 'package:diplomski_rad/other/pallete.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  debugDefaultTargetPlatformOverride =
      TargetPlatform.windows; // TODO: set for multiple desktop OS

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
