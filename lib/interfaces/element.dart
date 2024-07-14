import 'dart:typed_data';

class Element {
  String id;
  String categoryId;
  String background;
  Map<String, String> title;
  Map<String, String> description;
  List<String> images;
  List<Map<String, dynamic>> links;

  List<String?> tmpDescriptionImageNames = [null];
  List<Uint8List?> tmpDescriptionImageBytes  = [null];
  List<String?> deletedImages = [];

  String? tmpBackgroundName;
  Uint8List? tmpBackgroundBytes;

  String? tmpColor;
  
  Element({
    this.id = "",
    this.categoryId = "",
    this.background = "",
    this.images = const [],
    this.links = const [],
  }) : title = {
      "en": "",
      "de": "",
      "hr": "",
    }, description = {
      "en": "",
      "de": "",
      "hr": "",
    };

  static Element? toElement(Map<String, dynamic>? JSONElement) {
    if (JSONElement == null) return null;

    Element newcard = Element();
    newcard.id = JSONElement['id'] ?? "";
    newcard.categoryId = JSONElement['categoryId'] ?? "";
    newcard.background = JSONElement['background'] as String? ?? "";

    JSONElement['title'].forEach((String key, dynamic value) {
      newcard.title[key] =  value;
    });

    JSONElement['description'].forEach((String key, dynamic value) {
      newcard.description[key] =  value;
    });

    newcard.links = [];
    for (int i = 0; i < (JSONElement['links'] as List).length; ++i) {
      Map<String, dynamic> currentLink = {};
      currentLink['url'] = JSONElement['links'][i]['url'] as String;

      currentLink['title'] = {};
      JSONElement['links'][i]['title'].forEach((String key, dynamic value) {
        currentLink['title'][key] = value;
      });

      newcard.links.add(currentLink);
    }

    return newcard;
  }

  static Map<String, dynamic>? toJSON(Element? card) {
    if (card == null) return null;

    return {
      "id": card.id,
      "categoryId": card.categoryId,
      "title": card.title,
      "links": card.links,
      "background": card.background,
      "description": card.description,
    };
  }

  static String asString(Element? card) {
    if (card == null) return "";
    return "id: ${card.id}\ncategoryId: ${card.categoryId}\ntitle: ${card.title}\nbackground: ${card.background}\ndescription: ${card.description}\n";
    // TODO: add links
  }
}
