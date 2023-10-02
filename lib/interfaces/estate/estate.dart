import 'package:latlong2/latlong.dart';
import 'package:diplomski_rad/interfaces/preferences/estate-preferences.dart';
import 'package:diplomski_rad/services/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Estate {
  String id;
  String ownerId;
  String name;
  List<String> images;
  String street;
  String zip;
  String city;
  String country;
  LatLng? coordinates;
  String phone;
  int templateCount;
  String description;
  EstatePreferences preferences;

  Estate({
    this.id = "",
    this.ownerId = "",
    this.name = "",
    this.images = const [],
    this.street = "",
    this.zip = "",
    this.city = "",
    this.country = "",
    this.coordinates,
    this.phone = "",
    this.templateCount = -1,
    this.description = "",
  }) : preferences = EstatePreferences();

  static List<String>? convertArray(List<dynamic>? images) {
    if (images == null || images.isEmpty /*|| id == null || id.isEmpty*/) {
      return null;
    }

    List<String>? res = [];
    /*FirebaseStorageService storage = FirebaseStorageService();

    for (dynamic element in images) {
      String url = await storage.downloadFile(id, element.toString());
      res.add(url);
    }*/

    for (dynamic element in images) {
      res.add(element.toString());
    }

    return res;
  }

  static Estate? toEstate(Map<String, dynamic>? estate) {
    if (estate == null) return null;

    Estate newEstate = Estate();
    newEstate.id = estate['id'] ?? "";
    newEstate.ownerId = estate['ownerId'] ?? "";
    newEstate.images = convertArray(estate['images']) ?? [];
    newEstate.templateCount = estate['templateCount'] ?? -1;
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
      designatedParkingSpots: estate['designatedParkingSpots'] ?? 0,
      outletType: estate['outletType'] ?? "",
      houseOrientation: estate['houseOrientation'] ?? "",
      acceptingPaymentCards: estate['acceptingPaymentCards'] ?? false,
      wifi: estate['wifi'] ?? false,
      pool: estate['pool'] ?? false,
      kitchen: estate['kitchen'] ?? false,
      washingMachine: estate['washingMachine'] ?? false,
      dryingMachine: estate['dryingMachine'] ?? false,
    );

    return newEstate;
  }

  static Map<String, dynamic>? toJSON(Estate? estate) {
    if (estate == null) return null;

    return {
      "id": estate.id,
      // "avatarImage": avatarImage,
      // "backgroundImage": backgroundImage,
      "ownerId": estate.ownerId,
      "name": estate.name,
      "street": estate.street,
      "zip": estate.zip,
      "city": estate.city,
      "country": estate.country,
      "coordinates": estate.coordinates,
      "phone": estate.phone,
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
      // "password": password,
    };
  }

  String asString(Estate estate) {
    return "id: ${estate.id}\nownerId: ${estate.ownerId}\nlatitude: ${estate.coordinates?.latitude}\nlongitude: ${estate.coordinates?.longitude}\nstreet: ${estate.street}\nzip: ${estate.zip}\ncity: ${estate.city}\ncountry: ${estate.country}\nphone: ${estate.phone}\ndescription: ${estate.description}\npetsAllowed: ${estate.preferences.petsAllowed}\nsmokingAllowed: ${estate.preferences.smokingAllowed}\nairConditioning: ${estate.preferences.airConditioning}\nhandicapAccessible: ${estate.preferences.handicapAccessible}\ndesignatedParkingSpots: ${estate.preferences.designatedParkingSpots}\nhouseOrientation: ${estate.preferences.houseOrientation}\nacceptingPaymentCards: ${estate.preferences.acceptingPaymentCards}\nwifi: ${estate.preferences.wifi}\npool: ${estate.preferences.pool}\nkitchen: ${estate.preferences.kitchen}\nwashingMachine: ${estate.preferences.washingMachine}\ndryingMachine: ${estate.preferences.dryingMachine}\n";

    // res.images = user['images'] ?? "";
    // res.templateCount = user['templateCount'] ?? "";
  }
}
