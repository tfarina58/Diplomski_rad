import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';

class Category {
  String id;
  String estateId;
  Map<String, String> title;
  String image;

  // Used to save locally and display an image before saving on Firebase
  String? tmpImageName;
  Uint8List? tmpImageBytes;

  Category({
    this.id = "",
    this.estateId = "",
    this.title = const {},
    this.image = "",
  }) : super();

  static Category? toCategory(Map<String, dynamic>? category) {
    if (category == null) return null;

    Category newCategory = Category();
    newCategory.id = category['id'] ?? "";
    newCategory.estateId = category['estateId'] ?? "";

    Map<String, String> title = {
      "en": category['title']['en'] ?? "",
      "de": category['title']['de'] ?? "",
      "hr": category['title']['hr'] ?? "",
    };
    newCategory.title = title;

    newCategory.image = category['image'] ?? "";

    return newCategory;
  }

  static Map<String, dynamic>? toJSON(Category? category) {
    if (category == null) return null;

    return {
      "estateId": category.estateId,
      "title": category.title,
      "image": category.image,
    };
  }

  static String asString(Category? category) {
    if (category == null) return "";
    return "id: ${category.id}\nestateId: ${category.estateId}\ntitle: ${category.title}\nimage: ${category.image}\n";
  }

  static List<Category> setupCategoriesFromFirebaseDocuments(List<QueryDocumentSnapshot<Map<String, dynamic>>>? document) {
    if (document == null) return [];

      Category? currentCategory;
      List<Category> categories = [];

      document.map((DocumentSnapshot doc) {
        Map<String, dynamic>? categoryMap = doc.data() as Map<String, dynamic>?;
        if (categoryMap == null) return;

        categoryMap['id'] = doc.id;
        currentCategory = Category.toCategory(categoryMap);
        if (currentCategory == null) return;

        categories.add(currentCategory!);
      }).toList();

      return categories;
  }
}
