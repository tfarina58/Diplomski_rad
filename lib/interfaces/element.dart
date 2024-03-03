import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:typed_data';

class Element {
  String id;
  String categoryId;
  String background;
  Map<String, String> title;
  Map<String, dynamic> links;
  Map<String, dynamic> description;

  String? tmpDescriptionImageName;
  Uint8List? tmpDescriptionImageBytes;

  String? tmpBackgroundName;
  Uint8List? tmpBackgroundBytes;

  String? tmpColor;
  
  Element({
    this.id = "",
    this.categoryId = "",
    this.background = "",
  }) : title = {
      "alignment": "top-left", // top-left, top-center, top-right (when expanded)
      "text": "",
    }, links = {
      "url": ["", "", ""],
      "text": ["", "", ""],
    }, description = {
      "text": "",
      "images": [] // opposite side of description.alignment
    };

  static Element? toElement(Map<String, dynamic>? card) {
    if (card == null) return null;

    Element newcard = Element();
    newcard.id = card['id'] ?? "";
    newcard.categoryId = card['categoryId'] ?? "";
    newcard.background = card['background'] as String? ?? "";

    card['title'].forEach((String key, dynamic value) {
      newcard.title[key] =  value;
    });

    card['links'].forEach((String key, dynamic value) {
      newcard.links[key] =  value;
    });

    while (newcard.links['url'].length < 3) {
      (newcard.links['url'] as List).add('');
    }

    while (newcard.links['text'].length < 3) {
      (newcard.links['text'] as List).add('');
    }

    card['description'].forEach((String key, dynamic value) {
      newcard.description[key] =  value;
    });

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
