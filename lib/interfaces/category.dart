import 'dart:typed_data';

class Category {
  String id;
  String estateId;
  String title;
  String image;
  int? position;
  String elementsType; // img, min

  // Used to save locally and display an image before saving on Firebase
  String? tmpImageName;
  Uint8List? tmpImageBytes;

  Category({
    this.id = "",
    this.estateId = "",
    this.title = "",
    this.image = "",
    this.position,
    this.elementsType = "",
  }) : super();

  static Category? toCategory(Map<String, dynamic>? category) {
    if (category == null) return null;

    Category newCategory = Category();
    newCategory.id = category['id'] ?? "";
    newCategory.estateId = category['estateId'] ?? "";
    newCategory.title = category['title'] ?? "";
    newCategory.image = category['image'] ?? "";
    newCategory.position = category['position'];
    newCategory.elementsType = category['elementsType'] ?? "img";

    return newCategory;
  }

  static Map<String, dynamic>? toJSON(Category? category) {
    if (category == null) return null;

    return {
      "id": category.id,
      "estateId": category.estateId,
      "title": category.title,
      "image": category.image,
      "position": category.position,
      "elementsType": category.elementsType,
    };
  }

  static String asString(Category? category) {
    if (category == null) return "";
    return "id: ${category.id}\nestateId: ${category.estateId}\ntitle: ${category.title}\nimage: ${category.image}\nposition: ${category.position}\nelementsType: ${category.elementsType}\n";
  }
}
