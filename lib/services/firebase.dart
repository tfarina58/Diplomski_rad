import 'package:diplomski_rad/interfaces/estate.dart';
import 'package:diplomski_rad/interfaces/user.dart' as local;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:diplomski_rad/interfaces/user.dart';

class FirebaseStorageService {
  var storage = FirebaseStorage.instance.ref();

  void setStorageInstace(String? instance) {
    if (instance == null || instance.isEmpty) return;
    storage = FirebaseStorage.instance.ref(instance);
  }

  Future<void> uploadFile(
      dynamic object, String name, Uint8List bytes, bool choice) async {
    if (object is Estate) {
      final Reference folder = storage.child("${(object as Estate).id}/$name");
      if (kIsWeb) {
        await folder.putData(bytes).whenComplete(() async {
          String url = await folder.getDownloadURL();

          Map<String, dynamic> updateObject = {
            "images": [url]
          };
          bool success = await EstateRepository.updateEstate(
              updateObject, (object as Estate).id);
        });
      }
    } else if (object is User) {
      final Reference folder = storage.child("${(object as User).id}/$name");
      if (kIsWeb) {
        await folder.putData(bytes).whenComplete(() async {
          String url = await folder.getDownloadURL();

          Map<String, dynamic> updateObject = {
            "email": (object as User).email,
            (choice ? "avatarImage" : "backgroundImage"): url
          };
          bool success = await UserRepository.updateUser(updateObject);
        });
      }
    }
  }

  Future<String> downloadFile(String id, String name) async {
    final Reference folder = storage.child(id);
    final Reference fileRef = folder.child(name);
    String url = await fileRef.getDownloadURL();
    return url;
  }

  Future<void> deleteFile(
      User user, String name, Uint8List bytes, bool choice) async {
    final Reference folder = storage.child("${user.id}/$name");
    if (kIsWeb) {
      final TaskSnapshot uploadTask =
          await folder.putData(bytes).whenComplete(() async {
        String url = await folder.getDownloadURL();

        Map<String, dynamic> updateObject = {
          "email": user.email,
          (choice ? "avatarImage" : "backgroundImage"): url
        };
        bool success = await UserRepository.updateUser(updateObject);
      });
    }
  }
}

class GoogleAuthService {
  static final firebase.FirebaseAuth firebaseAuth =
      firebase.FirebaseAuth.instance;
  static final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId:
          "236389351601-0q6kgflcvpferc94od95bk5o79385q8m.apps.googleusercontent.com",
      scopes: []);

  /*Firebase.User? userFromFirebase(Firebase.UserCredential? credentials) {
    if (credentials == null) return null;
credentials.user.

    return  Firebase.User(uid: credentials.user!.uid);
  }*/

  /*Stream<Firebase.User> get onAuthStateChanged {
    return firebaseAuth.
  }*/

  // Future<Firebase.User?> signInWithGoogle() async {
  static Future<firebase.User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser =
          await googleSignIn.signInSilently();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final firebase.AuthCredential credential =
          firebase.GoogleAuthProvider.credential(
              accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      final firebase.UserCredential authResult =
          await firebaseAuth.signInWithCredential(credential);

      return authResult.user;
    } catch (err) {
      return null;
    }
    // return userFromFirebase(authResult);
  }

  static Future<void> signOut() async {
    return firebaseAuth.signOut();
  }

  static Future<firebase.User?> currentUser() async {
    final firebase.User? user = firebaseAuth.currentUser;
    // return userFromFirebase(user);
    return user;
  }
}

class UserRepository {
  static final users = FirebaseFirestore.instance.collection("users");

  static Future<local.User?> createCustomer(
      Map<String, dynamic> userMap) async {
    // TODO: email comparation should be done on the backend
    QuerySnapshot<Map<String, dynamic>> res =
        await users.where("email", isEqualTo: userMap["email"]).get();

    if (res.docs.isEmpty) {
      try {
        Map<String, dynamic>? res =
            (await (await users.add(userMap)).get()).data();

        if (res != null) return local.User.toUser(res);
        return null;
      } catch (err) {
        return null;
      }
    }
  }

  static Future<Map<String, dynamic>?> readUserWithId(String? id) async {
    if (id == null || id.isEmpty) return null;

    // TODO: Front-end shouldn't check if there are more docs with the same email
    DocumentSnapshot<Map<String, dynamic>> docSnapshot =
        await users.doc(id).get();
    Map<String, dynamic>? userMap = docSnapshot.data();

    if (userMap == null) return {};
    userMap["id"] = docSnapshot.id;
    return userMap;
  }

  static Future<User?> loginUser(String email, String password) async {
    if (password.length < 8) return null;
    // TODO: Front-end shouldn't check if there are more docs with the same email
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await users
        .where("email", isEqualTo: email)
        .where("password", isEqualTo: password)
        // .where("blocked", isEqualTo: false)
        // .where("banned", isEqualTo: false)
        .get();

    if (querySnapshot.docs.length == 1) {
      Map<String, dynamic> userMap = querySnapshot.docs[0].data();
      userMap["id"] = querySnapshot.docs[0].id;
      User? user = User.toUser(userMap);
      if (user == null) return null;
      return user;
    }
    return null;
  }

  static Future<bool> updateUser(Map<String, dynamic> userMap) async {
    // TODO: email comparation should be done on the backend
    QuerySnapshot<Map<String, dynamic>> res =
        await users.where("email", isEqualTo: userMap["email"]).get();

    if (res.docs.length == 1) {
      bool success;

      try {
        await users.doc(res.docs[0].id).update(userMap);
        success = true;
      } catch (err) {
        success = false;
      }
      return success;
    }
    return false;
  }

  static Future<bool> deleteUser(String userId, String password) async {
    if (password.length < 8) return false;

    // TODO: PASSWORD comparation should be done on the backend
    DocumentSnapshot<Map<String, dynamic>> res = await users.doc(userId).get();

    if (res["password"] != null && password == res["password"]) {
      bool success;

      try {
        await users.doc(userId).delete();
        success = true;
      } catch (err) {
        success = false;
      }
      return success;
    }
    return false;
  }

  static Future<Map<String, dynamic>> blockUser(
      String id, bool wantedState) async {
    if (id.isEmpty) return {"success": false};

    DocumentSnapshot<Map<String, dynamic>> res = await users.doc(id).get();

    if (res["blocked"] == wantedState) {
      return {"success": true, "value": wantedState};
    } else {
      try {
        await users.doc(id).update({"blocked": wantedState});
        return {"success": true, "value": wantedState};
      } catch (err) {
        return {"success": false};
      }
    }
  }

  static Future<Map<String, dynamic>> banUser(
      String id, bool wantedState) async {
    if (id.isEmpty) return {"success": false};

    DocumentSnapshot<Map<String, dynamic>> res = await users.doc(id).get();

    if (res["banned"] == wantedState) {
      return {"success": true, "value": wantedState};
    } else {
      try {
        await users.doc(id).update({"banned": wantedState});
        return {"success": true, "value": wantedState};
      } catch (err) {
        return {"success": false};
      }
    }
  }
}

class EstateRepository {
  static final users = FirebaseFirestore.instance.collection("users");
  static final estates = FirebaseFirestore.instance.collection("estates");

  static Future<Estate?> createEstate(Map<String, dynamic> estateMap) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await (await estates.add(estateMap)).get();
      Map<String, dynamic>? res = docSnapshot.data();

      if (res == null) return null;

      res["id"] = docSnapshot.id;
      return Estate.toEstate(res);
    } catch (err) {
      return null;
    }
  }

  /*static Future<Estate?> readEstate() async {}*/

  static Future<bool> updateEstate(
      Map<String, dynamic> estateMap, String estateId) async {
    // TODO: email comparation should be done on the backend

    bool success = false;

    try {
      await estates.doc(estateId).update(estateMap);
      success = true;
    } catch (err) {
      success = false;
    }
    return success;
  }

  static Future<bool> deleteEstate(String estateId) async {
    // TODO: email comparation should be done on the backend
    bool success;

    try {
      await estates.doc(estateId).delete();
      success = true;
    } catch (err) {
      success = false;
    }
    return success;
  }
}
