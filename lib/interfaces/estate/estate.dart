import 'package:latlong2/latlong.dart';
import 'package:diplomski_rad/interfaces/preferences/estate-preferences.dart';
import 'package:diplomski_rad/interfaces/presentation/presentation.dart';
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
  EstatePreferences preferences;
  List<Slide> presentation;

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
    this.presentation = const [],
  }) : preferences = EstatePreferences();

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
    newEstate.preferences = EstatePreferences(
      petsAllowed: estate['petsAllowed'] ?? false,
      smokingAllowed: estate['smokingAllowed'] ?? false,
      airConditioning: estate['airConditioning'] ?? false,
      handicapAccessible: estate['handicapAccessible'] ?? false,
      designatedParkingSpots: estate['designatedParkingSpots'] ?? '0',
      outletType: estate['outletType'] ?? "",
      houseOrientation: estate['houseOrientation'] ?? "",
      acceptingPaymentCards: estate['acceptingPaymentCards'] ?? false,
      wifi: estate['wifi'] ?? false,
      pool: estate['pool'] ?? false,
      kitchen: estate['kitchen'] ?? false,
      washingMachine: estate['washingMachine'] ?? false,
      dryingMachine: estate['dryingMachine'] ?? false,
    );
    newEstate.presentation = [];
    if (estate['presentation'].isEmpty) {
      newEstate.presentation.add(
        Slide(
          title: "",
          subtitle: "",
          description: "",
          image: "",
          template: 0,
        ),
      );
    } else {
      for (int i = 0; i < estate['presentation'].length; ++i) {
        newEstate.presentation.add(
          Slide(
            title: estate['presentation'][i]['title'],
            subtitle: estate['presentation'][i]['subtitle'],
            description: estate['presentation'][i]['description'],
            image: estate['presentation'][i]['image'],
            template: estate['presentation'][i]['template'],
          ),
        );
      }
    }

    return newEstate;
  }

  static Map<String, dynamic>? toJSON(Estate? estate) {
    if (estate == null) return null;

    dynamic presentation = [];
    for (int i = 0; i < estate.presentation.length; ++i) {
      presentation.add({
        'title': estate.presentation[i].title,
        'subtitle': estate.presentation[i].subtitle,
        'description': estate.presentation[i].description,
        'image': estate.presentation[i].image,
        'template': estate.presentation[i].template,
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
      "presentation": presentation,
      "acceptingPaymentCards": estate.preferences.acceptingPaymentCards,
      "airConditioning": estate.preferences.airConditioning,
      "designatedParkingSpots": estate.preferences.designatedParkingSpots,
      "dryingMachine": estate.preferences.dryingMachine,
      "handicapAccessible": estate.preferences.handicapAccessible,
      "houseOrientation": estate.preferences.houseOrientation,
      "kitchen": estate.preferences.kitchen,
      "outletType": estate.preferences.outletType,
      "petsAllowed": estate.preferences.petsAllowed,
      "pool": estate.preferences.pool,
      "smokingAllowed": estate.preferences.smokingAllowed,
      "washingMachine": estate.preferences.washingMachine,
      "wifi": estate.preferences.wifi,
    };
  }

  static String asString(Estate estate) {
    String presentation = "";
    for (int i = 0; i < estate.presentation.length; ++i) {
      presentation +=
          "presentation $i: {\n\ttitle: ${estate.presentation[i].title}\n\tsubtitle: ${estate.presentation[i].subtitle}\n\tdescription: ${estate.presentation[i].description}\n\timage: ${estate.presentation[i].image}\n\ttemplate: ${estate.presentation[i].template}\n}\n";
    }
    return "id: ${estate.id}\nownerId: ${estate.ownerId}\nlatitude: ${estate.coordinates?.latitude}\nlongitude: ${estate.coordinates?.longitude}\nstreet: ${estate.street}\nzip: ${estate.zip}\ncity: ${estate.city}\ncountry: ${estate.country}\nphone: ${estate.phone}\ndescription: ${estate.description}\n$presentation";
  }
}
