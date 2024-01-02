import 'package:latlong2/latlong.dart';
import 'package:diplomski_rad/interfaces/presentation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Estate {
  String id;
  String ownerId;
  String name;
  String image;
  String street;
  String zip;
  String city;
  String country;
  LatLng? coordinates;
  String phone;
  String description;
  List<Slide> slides;

  Estate({
    this.id = "",
    this.ownerId = "",
    this.name = "",
    this.image = "",
    this.street = "",
    this.zip = "",
    this.city = "",
    this.country = "",
    this.coordinates,
    this.phone = "",
    this.description = "",
    this.slides = const [],
  }) : super(); // : preferences = EstatePreferences();

  static Estate? toEstate(Map<String, dynamic>? estate) {
    if (estate == null) return null;

    Estate newEstate = Estate();
    newEstate.id = estate['id'] ?? "";
    newEstate.ownerId = estate['ownerId'] ?? "";
    newEstate.image = estate['image'] ?? "";
    if (estate['coordinates'] != null) {
      newEstate.coordinates = LatLng(
          (estate['coordinates'] as GeoPoint).latitude,
          (estate['coordinates'] as GeoPoint).longitude);
    }
    newEstate.street = estate['street'] ?? "";
    newEstate.zip = estate['zip'] ?? "";
    newEstate.city = estate['city'] ?? "";
    newEstate.country = estate['country'] ?? "";
    newEstate.phone = estate['phone'] ?? "";
    newEstate.description = estate['description'] ?? "";
    newEstate.name = estate['name'] ?? "";
    newEstate.phone = estate['phone'] ?? "";

    newEstate.slides = [];
    if (estate['slides'].length == 0) {
      newEstate.slides.add(
        Slide(
          title: "",
          subtitle: "",
          description: "",
          image: "",
          template: 0,
        ),
      );
    } else {
      for (int i = 0; i < estate['slides'].length; ++i) {
        newEstate.slides.add(
          Slide(
            title: estate['slides'][i]['title'],
            subtitle: estate['slides'][i]['subtitle'],
            description: estate['slides'][i]['description'],
            image: estate['slides'][i]['image'],
            template: estate['slides'][i]['template'],
          ),
        );
      }
    }

    return newEstate;
  }

  static Map<String, dynamic>? toJSON(Estate? estate) {
    if (estate == null) return null;

    dynamic slides = [];
    for (int i = 0; i < estate.slides.length; ++i) {
      slides.add({
        'title': estate.slides[i].title,
        'subtitle': estate.slides[i].subtitle,
        'description': estate.slides[i].description,
        'image': estate.slides[i].image,
        'template': estate.slides[i].template,
      });
    }

    return {
      "name": estate.name,
      "street": estate.street,
      "zip": estate.zip,
      "city": estate.city,
      "country": estate.country,
      "coordinates": estate.coordinates != null
          ? GeoPoint(
              estate.coordinates!.latitude, estate.coordinates!.longitude)
          : null,
      "phone": estate.phone,
      "slides": slides,
    };
  }

  static String asString(Estate estate) {
    String slides = "";
    for (int i = 0; i < estate.slides.length; ++i) {
      slides +=
          "presentation $i: {\n\ttitle: ${estate.slides[i].title}\n\tsubtitle: ${estate.slides[i].subtitle}\n\tdescription: ${estate.slides[i].description}\n\timage: ${estate.slides[i].image}\n\ttemplate: ${estate.slides[i].template}\n}\n";
    }
    return "id: ${estate.id}\nownerId: ${estate.ownerId}\nlatitude: ${estate.coordinates?.latitude}\nlongitude: ${estate.coordinates?.longitude}\nstreet: ${estate.street}\nzip: ${estate.zip}\ncity: ${estate.city}\ncountry: ${estate.country}\nphone: ${estate.phone}\ndescription: ${estate.description}\n$slides";
  }
}
