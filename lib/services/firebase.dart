import 'package:firebase_core/firebase_core.dart';

class FirebaseService {
  FirebaseOptions? options = const FirebaseOptions(
      apiKey: "AIzaSyCr1DO0mTiEk3G7G31ir462s61f9kiZqEQ",
      appId: "1:236389351601:web:24956e1c461447b056a290",
      messagingSenderId: "236389351601",
      projectId: "diplomski-rad-8bdb2");

  Future<FirebaseApp>? app;

  FirebaseService() {}
}
