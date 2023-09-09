import 'package:diplomski_rad/interfaces/estate/estate.dart';
import 'package:diplomski_rad/interfaces/user/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/*abstract class SessionRes {
  bool? success; // If request sending and response obtaining was successful
  bool? session; // Is the session still active or not
}*/

class UserRepository {
  static final users = FirebaseFirestore.instance.collection("users");

  static Future<User?> createCustomer(Map<String, dynamic> userMap) async {
    // TODO: email comparation should be done on the backend
    QuerySnapshot<Map<String, dynamic>> res =
        await users.where("email", isEqualTo: userMap["email"]).get();

    if (res.docs.isEmpty) {
      try {
        Map<String, dynamic>? res =
            (await (await users.add(userMap)).get()).data();

        if (res != null) return User.toUser(res);
        return null;
      } catch (err) {
        print('Error updating document: $err');
        return null;
      }
    }
  }

  static Future<User?> readUser(String email, String password) async {
    // TODO: Front-end shouldn't check if there are more docs with the same email
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await users.where("email", isEqualTo: email).get();

    if (querySnapshot.docs.length == 1) {
      Map<String, dynamic> userMap = querySnapshot.docs[0].data();
      return User.toUser(userMap);
    }
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
        print('Error updating document: $err');
        success = false;
      }
      return success;
    }
    return false;
  }

  static Future<bool> deleteUser(
      Map<String, dynamic> userMap, String password) async {
    // TODO: email and PASSWORD comparation should be done on the backend
    QuerySnapshot<Map<String, dynamic>> res =
        await users.where("email", isEqualTo: userMap["email"]).get();

    if (res.docs.length == 1 && password == res.docs[0]["password"]) {
      bool success;

      try {
        await users.doc(res.docs[0].id).delete();
        success = true;
      } catch (err) {
        print('Error updating document: $err');
        success = false;
      }
      return success;
    }
    return false;
  }
}

class EstateRepository {
  static final users = FirebaseFirestore.instance.collection("estates");

  static Future<User?> createEstate(Map<String, dynamic> estateMap) async {
    // TODO: email comparation should be done on the backend
    QuerySnapshot<Map<String, dynamic>> res =
        await users.where("email", isEqualTo: estateMap["email"]).get();

    if (res.docs.isEmpty) {
      try {
        Map<String, dynamic>? res =
            (await (await users.add(estateMap)).get()).data();

        if (res != null) return User.toUser(res);
        return null;
      } catch (err) {
        print('Error updating document: $err');
        return null;
      }
    }
  }

  /*static Future<User?> readEstate(String email, String password) async {
    // TODO: Front-end shouldn't check if there are more docs with the same email
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await users.where("email", isEqualTo: email).get();

    if (querySnapshot.docs.length == 1) {
      Map<String, dynamic> userMap = querySnapshot.docs[0].data();
      return User.toUser(userMap);
    }
  }*/

  static Future<bool> updateEstate(Map<String, dynamic> estateMap) async {
    // TODO: email comparation should be done on the backend
    QuerySnapshot<Map<String, dynamic>> res =
        await users.where("email", isEqualTo: estateMap["email"]).get();

    if (res.docs.length == 1) {
      bool success;

      try {
        await users.doc(res.docs[0].id).update(estateMap);
        success = true;
      } catch (err) {
        print('Error updating document: $err');
        success = false;
      }
      return success;
    }
    return false;
  }

  static Future<bool> deleteEstate(Map<String, dynamic> estateMap) async {
    // TODO: email comparation should be done on the backend
    QuerySnapshot<Map<String, dynamic>> res =
        await users.where("email", isEqualTo: estateMap["email"]).get();

    if (res.docs.length == 1) {
      bool success;

      try {
        await users.doc(res.docs[0].id).delete();
        success = true;
      } catch (err) {
        print('Error updating document: $err');
        success = false;
      }
      return success;
    }
    return false;
  }
}
