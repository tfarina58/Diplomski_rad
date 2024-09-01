import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';

class Element {
  String id;
  String categoryId;
  String background;
  Map<String, String> title;
  Map<String, String> description;
  List<String> images;
  List<Map<String, dynamic>> links;
  int template;
  String entryFee;
  int minimalAge;
  List<Map<String, dynamic>> workingHours;

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
    this.template = 3,
    this.entryFee = "",
    this.minimalAge = 0,
    this.workingHours = const [],
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
    newElement.template = JSONElement['template'] as int? ?? 3;
    newElement.entryFee = JSONElement['entryFee'] as String? ?? "";
    newElement.minimalAge = JSONElement['minimalAge'] as int? ?? 0;

    newElement.title = {
      "en": "",
      "de": "",
      "hr": "",
    };

    if (JSONElement['title'] != null) {
      JSONElement['title'].forEach((String key, dynamic value) {
        newElement.title[key] = value;
      });
    }

    newElement.description = {
      "en": "",
      "de": "",
      "hr": "",
    };
    if (JSONElement['description'] != null) {
      JSONElement['description'].forEach((String key, dynamic value) {
        newElement.description[key] =  value;
      });
    }

    newElement.images = [];
    if (JSONElement['images'] != null) {
      for (int i = 0; i < (JSONElement['images'] as List).length; ++i) {
        newElement.images.add(JSONElement['images'][i]);
      }
    }

    newElement.workingHours = [
      {"from": 0, "to": 0}, 
      {"from": 0, "to": 0}, 
      {"from": 0, "to": 0}, 
      {"from": 0, "to": 0}, 
      {"from": 0, "to": 0}, 
      {"from": 0, "to": 0}, 
      {"from": 0, "to": 0}, 
    ];
    if (JSONElement['workingHours'] != null) {
      for (int i = 0; i < (JSONElement['workingHours'] as List).length; ++i) {
        newElement.workingHours[i] = (JSONElement['workingHours'][i] as Map<String, dynamic>);
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

    List<Map<String, dynamic>> workingHours = [];

    int counter = 0;
    for (int i = 0; i < 7; ++i) {
      if (card.workingHours[i]["from"] == 0 && card.workingHours[i]["to"] == 0) {
        counter++;
      }
    }

    Map<String, dynamic> tmp = {};
    if ((card.links[0]['title']['en'] as String).isEmpty && (card.links[0]['title']['de'] as String).isEmpty && (card.links[0]['title']['hr'] as String).isEmpty && (card.links[0]['url'] as String).isEmpty) {
      if ((card.links[1]['title']['en'] as String).isNotEmpty && (card.links[1]['title']['de'] as String).isNotEmpty && (card.links[1]['title']['hr'] as String).isNotEmpty && (card.links[1]['url'] as String).isNotEmpty) {
        tmp = card.links[1];
        card.links[1] = card.links[0];
        card.links[0] = tmp;
      } else if ((card.links[2]['title']['en'] as String).isNotEmpty && (card.links[2]['title']['de'] as String).isNotEmpty && (card.links[2]['title']['hr'] as String).isNotEmpty && (card.links[2]['url'] as String).isNotEmpty) {
        tmp = card.links[2];
        card.links[2] = card.links[0];
        card.links[0] = tmp;
      }
    }

    if ((card.links[1]['title']['en'] as String).isEmpty && (card.links[1]['title']['de'] as String).isEmpty && (card.links[1]['title']['hr'] as String).isEmpty && (card.links[1]['url'] as String).isEmpty) {
      if ((card.links[2]['title']['en'] as String).isNotEmpty && (card.links[2]['title']['de'] as String).isNotEmpty && (card.links[2]['title']['hr'] as String).isNotEmpty && (card.links[2]['url'] as String).isNotEmpty) {
        tmp = card.links[1];
        card.links[1] = card.links[2];
        card.links[2] = tmp;
      }
    }

    if (counter != 7) workingHours = card.workingHours;

    return {
      "categoryId": card.categoryId,
      "title": card.title,
      "links": card.links,
      "background": card.background,
      "description": card.description,
      "template": card.template,
      "entryFee": card.entryFee,
      "minimalAge": card.minimalAge,
      "workingHours": workingHours
    };
  }

  static String asString(Element? card) {
    if (card == null) return "";
    return "id: ${card.id}\ncategoryId: ${card.categoryId}\ntitle: ${card.title}\nbackground: ${card.background}\ndescription: ${card.description}\n";
    // TODO: add links
  }

  static List<Element> setupElementsFromFirebaseDocuments(List<QueryDocumentSnapshot<Map<String, dynamic>>>? document) {
    if (document == null) return [];
      
    Element? element;
    List<Element> elements = [];

    document.map((DocumentSnapshot doc) {
      Map<String, dynamic>? tmpMap = doc.data() as Map<String, dynamic>?;
      if (tmpMap == null) return;

      tmpMap['id'] = doc.id;
      element = Element.toElement(tmpMap);
      if (element == null) return;

      elements.add(element!);
    }).toList();

    return elements;
  }
}
