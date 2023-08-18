import 'package:flutter/material.dart';
import 'package:diplomski_rad/auth/login/login.dart';
import 'package:diplomski_rad/other/pallete.dart';
import 'package:flutter/foundation.dart';

Future main() async {
  debugDefaultTargetPlatformOverride =
      TargetPlatform.windows; // TODO: set for multiple desktop OS
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
