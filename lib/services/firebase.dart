import 'package:diplomski_rad/interfaces/estate.dart';
import 'package:diplomski_rad/interfaces/category.dart' as localCategory;
import 'package:diplomski_rad/interfaces/user.dart' as localUser;
import 'package:diplomski_rad/interfaces/element.dart' as localElement;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:diplomski_rad/interfaces/user.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';


class FirebaseStorageService {
  var storage = FirebaseStorage.instance.ref();

  void setStorageInstace(String? instance) {
    if (instance == null || instance.isEmpty) return;
    storage = FirebaseStorage.instance.ref(instance);
  }

  // TODO: comment
  Future<void> uploadImageForCustomer(Customer customer, String name, Uint8List bytes, bool isAvatarImage) async {
    try {
      final Reference folder = storage.child("${customer.id}/$name");
      await folder.putData(bytes).whenComplete(() async {
        String url = await folder.getDownloadURL();

        Map<String, dynamic> updateObject = {
          (isAvatarImage ? "avatarImage" : "backgroundImage"): url
        };

        bool success = await UserRepository.updateUser(customer.id, updateObject);
        // TODO: give feedback
      });
    } catch (err) {

    }
  }

  // TODO: comment
  Future<void> uploadImageForEstate(Estate estate, String name, Uint8List bytes) async {
    try {
      final Reference folder = storage.child("${estate.id}/$name");
      await folder.putData(bytes).whenComplete(() async {
        String url = await folder.getDownloadURL();

        Map<String, dynamic> updateObject = {"image": url};

        bool success = await EstateRepository.updateEstate(estate.id, updateObject);
        // TODO: give feedback
      });
    } catch (err) {
      return;
    }
  }

  // TODO: comment
  Future<void> uploadImageForCategory(localCategory.Category category, String name, Uint8List bytes) async {
    try {
      final Reference folder = storage.child("${category.id}/$name");
      await folder.putData(bytes).whenComplete(() async {
        String url = await folder.getDownloadURL();

        Map<String, dynamic> updateObject = {"image": url};

        bool success = await CategoryRepository.updateCategory(category.id, updateObject);
        // TODO: give feedback
      });
    } catch (err) {
      return;
    }
  }

  Future<void> uploadBackgroundForElement(String elementId, String name, Uint8List bytes) async {
    try {
      final Reference folder = storage.child("$elementId/$name");
      await folder.putData(bytes).whenComplete(() async {
        String url = await folder.getDownloadURL();

        Map<String, dynamic> updateObject = {"background": url};

        bool success = await ElementRepository.updateElement(elementId, updateObject);
        // TODO: give feedback
      });
    } catch (err) {
      return;
    }
  }

  Future<void> uploadNewImagesForElement(String elementId, String toUploadName, Uint8List? toUploadBytes, List<String> images) async {
    if (toUploadBytes == null) return;

    try {
      final Reference folder = storage.child("$elementId/$toUploadName");
      await folder.putData(toUploadBytes).whenComplete(() async {
        String url = await folder.getDownloadURL();

        images.add(url);

        Map<String, dynamic> updateObject = {"images": images};

        bool success = await ElementRepository.updateElement(elementId, updateObject);
        // TODO: give feedback
      });
    } catch (err) {
      return;
    }
  }


  // TODO: comment
  Future<void> deleteImageForCustomer(String id, String url, bool isAvatarImage) async {
    String name = extractFileName(url);
    Map<String, dynamic> updateObject = {
      (isAvatarImage ? "avatarImage" : "backgroundImage"): ""
    };

    try {
      bool success = await UserRepository.updateUser(id, updateObject);
      if (success) {
        final Reference folder = storage.child("$id/$name");
        await folder.delete();
        // TODO: give feedback
      }
    } catch (err) {
      return;
    }
  }

  // TODO: comment
  Future<void> deleteImageForEstate(String estateId, {String url = ""}) async {
    if (url.isEmpty) {
        final estates = FirebaseFirestore.instance.collection("estates");
        url = (await estates.doc(estateId).get()).get("image");
    }

    String name = extractFileName(url);
    Map<String, dynamic> updateObject = {
      "image": ""
    };

    try {
      bool success = await EstateRepository.updateEstate(estateId, updateObject);
      if (success) {
        final Reference folder = storage.child("$estateId/$name");
        await folder.delete();
        // TODO: give feedback
      }
    } catch (err) {
      return;
    }
  }

    // TODO: comment
  Future<void> deleteImageForCategory(String categoryId, {String url = ""}) async {
    if (url.isEmpty) {
        final categories = FirebaseFirestore.instance.collection("categories");
        url = (await categories.doc(categoryId).get()).get("image");
    }

    String name = extractFileName(url);
    Map<String, dynamic> updateObject = {
      "image": ""
    };

    try {
      bool success = await CategoryRepository.updateCategory(categoryId, updateObject);
      if (success) {
        final Reference folder = storage.child("$categoryId/$name");
        await folder.delete();
        // TODO: give feedback
      }
    } catch (err) {
      return;
    }
  }

  // TODO: comment
  Future<void> deleteImagesForElement(String elementId, List<String> images, int index) async {
    String name = extractFileName(images[index]);

    images = [...images.sublist(0, index), ...images.sublist(index + 1, images.length)];

    try {
      bool success = await ElementRepository.updateElement(elementId, {"images": images});
      if (success) {
        final Reference folder = storage.child("$elementId/$name");
        await folder.delete();
        // TODO: give feedback
      }
    } catch (err) {
      return;
    }
  }

  Future<void> deleteAllImagesForElement(String elementId) async {
    final elements = FirebaseFirestore.instance.collection("elements");

    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await elements.doc(elementId).get();
      Map<String, dynamic>? map = snapshot.data();
      if (map == null) return;

      List<dynamic> images = map["images"];
      Reference storedImage;

      for (int i = 0; i < images.length; ++i) {
        storedImage = storage.child("$elementId/${extractFileName(images[i])}");
        await storedImage.delete();
      }

      bool success = await ElementRepository.updateElement(elementId, {"images": []});
      // TODO: feedback
    } catch (err) {
      return;
    }
  }

    // TODO: comment
  Future<void> deleteBackgroundForElement(String elementId, {String url = ""}) async {
    try {
      if (url.isEmpty) {
        final elements = FirebaseFirestore.instance.collection("elements");
        url = (await elements.doc(elementId).get()).get("background");
      }

      String name = extractFileName(url);

      bool success = await ElementRepository.updateElement(elementId, {"background": ""});
      if (success) {
        final Reference folder = storage.child("$elementId/$name");
        await folder.delete();
        // TODO: give feedback
      }
    } catch (err) {
      return;
    }
  }

    // TODO: comment
  Future<String> downloadImage(String id, String name) async {
    try {
      final Reference folder = storage.child(id);
      final Reference fileRef = folder.child(name);
      String url = await fileRef.getDownloadURL();
      return url;
    } catch (err) {
      return "";
    }
  }

  String extractFileName(String url) {
    String substring = url.substring(url.indexOf('%2F', 98) + 3, url.indexOf('?', 98));
    return substring;
  } 
}

// TODO: comment
class UserRepository {
  static final users = FirebaseFirestore.instance.collection("users");
  static final estates = FirebaseFirestore.instance.collection("estates");
  
  // TODO: comment
  static Future<localUser.User?> createCustomer(Map<String, dynamic> userMap) async {
    try {
      QuerySnapshot<Map<String, dynamic>> res = await users.where("email", isEqualTo: userMap["email"]).get();

      if (res.docs.isEmpty) {
        DocumentSnapshot<Map<String, dynamic>> docSnapshot = await (await users.add(userMap)).get();
        Map<String, dynamic>? res = docSnapshot.data();

        res?["id"] = docSnapshot.id;

        if (res != null) return localUser.User.toUser(res);
      }
      
      return null;
    } catch (err) {
      return null;
    }
  }

  // TODO: comment
  static Future<Map<String, dynamic>?> readUserWithId(String? id) async {
    if (id == null || id.isEmpty) return null;

    try {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot = await users.doc(id).get();
      Map<String, dynamic>? userMap = docSnapshot.data();
      if (userMap == null) return null;

      userMap["id"] = docSnapshot.id;
      return userMap;
    } catch (err) {
        return null;
    }
  }

  // TODO: Front-end shouldn't check if there are more docs with the same email
  // TODO: comment
  static Future<User?> loginUser(String email, String password) async {
    if (password.length < 8) return null;

    password = sha256.convert(utf8.encode(password)).toString();

    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await users
          .where("email", isEqualTo: email)
          .where("password", isEqualTo: password)
          .where("blocked", isEqualTo: false)
          .where("banned", isEqualTo: false)
          .get();

      if (querySnapshot.docs.length == 1) {
        Map<String, dynamic> userMap = querySnapshot.docs[0].data();
        userMap["id"] = querySnapshot.docs[0].id;

        User? user = User.toUser(userMap);
        if (user == null) return null;

        return user;
      }
    } catch (err) {
      return null;
    }
    return null;
  }

  // TODO: comment
  static Future<bool> updateUser(String id, Map<String, dynamic> JSONCustomer) async {
    bool success = false;

    try {
      await users.doc(id).update(JSONCustomer);
      success = true;
    } catch (err) {
      success = false;
    }
    return success;
  }

  // TODO: comment
  static Future<bool> deleteUser(String userId, String password) async {
    if (password.length < 8) return false;

    try {
      DocumentSnapshot<Map<String, dynamic>> res = await users.doc(userId).get();
      Map<String, dynamic>? userMap = res.data();
      if (userMap == null) return false;

      if (userMap["password"] != null && userMap["password"] == password) {
        List<QueryDocumentSnapshot<Map<String, dynamic>>> documents = (await estates.where("ownerId", isEqualTo: userId).get()).docs;

        for (int i = 0; i < documents.length; ++i) {
          await EstateRepository.deleteEstate(documents[i].id);
        }

        await users.doc(userId).delete();
        return true;
      }

      return false;
    } catch (err) {
      return false;
    }
  }

  static Future<void> getNumOfEstates(String userId) async {
    try {
      int numOfEstates = (await estates.where("ownerId", isEqualTo: userId).get()).docs.length;
      await users.doc(userId).update({"numOfEstates": numOfEstates});
    } catch (err) {}
  }

  // TODO: comment
  static Future<bool> blockUser(String id, bool wantedState) async {
    if (id.isEmpty) return false;

    try {
      DocumentSnapshot<Map<String, dynamic>> res = await users.doc(id).get();

      if (res["blocked"] == wantedState) {
        return true;
      } else {
        await users.doc(id).update({"blocked": wantedState});
        return true;
      }
    } catch (err) {
      return false;
    }
  }

  // TODO: comment
  static Future<bool?> banUser(Customer? customer) async {
    if (customer == null) return false;

    try {
      FirebaseStorageService fss = FirebaseStorageService();
      fss.deleteImageForCustomer(customer.id, customer.avatarImage, true);
      fss.deleteImageForCustomer(customer.id, customer.backgroundImage, false);
    } catch (err) {
      print(err);
    }

    try {
      QuerySnapshot<Map<String, dynamic>> res = await estates.where("ownerId", isEqualTo: customer.id).get();

      for (int i = 0; i < res.docs.length; ++i) {
        EstateRepository.deleteEstate(res.docs[i].id);
      }
    } catch (err) {
      print(err);
    }

    try {
      DocumentSnapshot<Map<String, dynamic>> res = await users.doc(customer.id).get();

      if (res["banned"] == true) {
        return null;
      } else if (res["banned"] == false) {
        await users.doc(customer.id).set({
          "banned": true,
          "blocked": true,
          "coordinates": null,
          "email": res["email"],
          "typeOfUser": res["typeOfUser"],
        });
        return true;
      }
    } catch (err) {
      return false;
    }
  }

  static Future<bool> checkPasswordMatching(String userId, String oldPassword) async {
    DocumentSnapshot<Map<String, dynamic>> docSnapshot = await users.doc(userId).get();
    Map<String, dynamic>? res = docSnapshot.data();
    if (res == null) return false;

    return res['password'] == oldPassword;
  }
}

// TODO: comment
class EstateRepository {
  static final estates = FirebaseFirestore.instance.collection("estates");
  static final categories = FirebaseFirestore.instance.collection("categories");
  static final elements = FirebaseFirestore.instance.collection("elements");

  // TODO: comment
  static Future<Estate?> createEstate(Map<String, dynamic> estateMap) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot = await (await estates.add(estateMap)).get();
      Map<String, dynamic>? res = docSnapshot.data();
      if (res == null) return null;

      res["id"] = docSnapshot.id;
      return Estate.toEstate(res);
    } catch (err) {
      return null;
    }
  }

  // TODO: comment
  static Future<bool> updateEstate(String estateId, Map<String, dynamic> estateMap) async {
    bool success = false;

    try {
      await estates.doc(estateId).update(estateMap);
      success = true;
    } catch (err) {
      success = false;
    }
    return success;
  }

  // TODO: comment
  static Future<bool> deleteEstate(String estateId) async {
    bool success = false;

    try {
      List<QueryDocumentSnapshot<Map<String, dynamic>>> documents = (await categories.where("estateId", isEqualTo: estateId).get()).docs;

      for (int i = 0; i < documents.length; ++i) {
        await CategoryRepository.deleteCategory(documents[i].id);
      }

      FirebaseStorageService service = FirebaseStorageService();
      service.deleteImageForEstate(estateId);

      await estates.doc(estateId).delete();
      success = true;
    } catch (err) {
      success = false;
    }
    return success;
  }
}

// TODO: comment
class CategoryRepository {
  static final categories = FirebaseFirestore.instance.collection("categories");
  static final elements = FirebaseFirestore.instance.collection("elements");

  // TODO: comment
  static Future<localCategory.Category?> createCategory(Map<String, dynamic> categoryMap) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot = await (await categories.add(categoryMap)).get();
      Map<String, dynamic>? res = docSnapshot.data();
      if (res == null) return null;

      res["id"] = docSnapshot.id;
      return localCategory.Category.toCategory(res);
    } catch (err) {
      return null;
    }
  }

  // TODO: comment
  static Future<bool> updateCategory(String categoryId, Map<String, dynamic> categoryMap) async {
    bool success = false;

    try {
      await categories.doc(categoryId).update(categoryMap);
      success = true;
    } catch (err) {
      success = false;
    }
    return success;
  }

  // TODO: comment
  static Future<bool> deleteCategory(String categoryId) async {
    bool success = false;

    try {
      List<QueryDocumentSnapshot<Map<String, dynamic>>> documents = (await elements.where("categoryId", isEqualTo: categoryId).get()).docs;

      for (int i = 0; i < documents.length; ++i) {
        await ElementRepository.deleteElement(documents[i].id);
      }

      FirebaseStorageService service = FirebaseStorageService();
      service.deleteImageForCategory(categoryId);

      await categories.doc(categoryId).delete();
      success = true;
    } catch (err) {
      success = false;
    }
    return success;
  }
}

class ElementRepository {
  static final elements = FirebaseFirestore.instance.collection("elements");

  // TODO: comment
  static Future<localElement.Element?> createElement(Map<String, dynamic> elementMap) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot = await (await elements.add(elementMap)).get();
      Map<String, dynamic>? res = docSnapshot.data();
      if (res == null) return null;

      res["id"] = docSnapshot.id;
      return localElement.Element.toElement(res);
    } catch (err) {
      return null;
    }
  }

  // TODO: comment
  static Future<bool> updateElement(String elementId, Map<String, dynamic> elementMap) async {
    bool success = false;

    try {
      await elements.doc(elementId).update(elementMap);
      success = true;
    } catch (err) {
      success = false;
    }
    return success;
  }

  // TODO: comment
  static Future<bool> deleteElement(String elementId) async {
    bool success = false;

    FirebaseStorageService storage = FirebaseStorageService();
    storage.deleteAllImagesForElement(elementId);
    storage.deleteBackgroundForElement(elementId);

    try {
      await elements.doc(elementId).delete();
      success = true;
    } catch (err) {
      success = false;
    }
    return success;
  }
}