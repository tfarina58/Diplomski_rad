import 'dart:typed_data';

class Element {
  String id;
  String categoryId;
  String background;
  Map<String, String> title;
  Map<String, String> description;
  List<String> images;
  List<Map<String, dynamic>> links;

  // Used to save locally and display an image before saving on Firebase
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

    Element newElement = Element();
    newElement.id = JSONElement['id'] ?? "";
    newElement.categoryId = JSONElement['categoryId'] ?? "";
    newElement.background = JSONElement['background'] as String? ?? "";

    if (JSONElement['title'] != null) {
      JSONElement['title'].forEach((String key, dynamic value) {
        newElement.title[key] = value;
      });
    } else {
      newElement.title = {
        "en": "",
        "de": "",
        "hr": "",
      };
    }

    if (JSONElement['description'] != null) {
      JSONElement['description'].forEach((String key, dynamic value) {
        newElement.description[key] =  value;
      });
    } else {
      newElement.description = {
        "en": "",
        "de": "",
        "hr": "",
      };
    }

    newElement.images = [];
    if (JSONElement['images'] != null) {
      for (int i = 0; i < (JSONElement['images'] as List).length; ++i) {
        newElement.images.add(JSONElement['images'][i]);
      }
    }

    newElement.links = [];
    if (JSONElement['links'] != null) {
      for (int i = 0; i < (JSONElement['links'] as List).length; ++i) {
        Map<String, dynamic> currentLink = {
          "url": "",
          "title": {
            "en": "",
            "de": "",
            "hr": "",
          }
        };
        
        currentLink['url'] = JSONElement['links'][i]['url'] as String;

        currentLink['title'] = {};
        JSONElement['links'][i]['title'].forEach((String key, dynamic value) {
          currentLink['title'][key] = value;
        });
        newElement.links.add(currentLink);
      }
    }

    while (newElement.links.length < 3) {
      newElement.links.add(Map.from({
        "url": "",
        "title": {
          "en": "",
          "de": "",
          "hr": "",
        }
      }));
    }

    return newElement;
  }

  static Map<String, dynamic>? toJSON(Element? card) {
    if (card == null) return null;

    return {
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
