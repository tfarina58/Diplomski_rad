import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Estate {
  String id;
  String ownerId;
  Map<String, String> name;
  String image;
  String street;
  String zip;
  String city;
  String country;
  LatLng? coordinates;
  String phone;
  List<Map<String, dynamic>> guests;

  Estate({
    this.id = "",
    this.ownerId = "",
    this.name = const {},
    this.image = "",
    this.street = "",
    this.zip = "",
    this.city = "",
    this.country = "",
    this.coordinates,
    this.phone = "",
    this.guests = const [],
  }) : super();

  static Estate? toEstate(Map<String, dynamic>? estate) {
    if (estate == null) return null;

    Estate newEstate = Estate();
    newEstate.id = estate['id'] ?? "";
    newEstate.ownerId = estate['ownerId'] ?? "";
    newEstate.image = estate['image'] ?? "";
    if (estate['coordinates'] != null) {
      newEstate.coordinates = LatLng(
        (estate['coordinates'] as GeoPoint).latitude,
        (estate['coordinates'] as GeoPoint).longitude,
      );
    }

    newEstate.street = estate['street'] ?? "";
    newEstate.zip = estate['zip'] ?? "";
    newEstate.city = estate['city'] ?? "";
    newEstate.country = estate['country'] ?? "";
    newEstate.phone = estate['phone'] ?? "";

    Map<String, String> name = {
      "en": estate['name']['en'] ?? "",
      "de": estate['name']['de'] ?? "",
      "hr": estate['name']['hr'] ?? "",
    };
    newEstate.name = name;
    
    newEstate.phone = estate['phone'] ?? "";
    newEstate.guests = toGuestTable(estate['guests']);
    return newEstate;
  }

  static Map<String, dynamic>? toJSON(Estate? estate) {
    if (estate == null) return null;

    return {
      "name": estate.name,
      "street": estate.street,
      "zip": estate.zip,
      "city": estate.city,
      "country": estate.country,
      "coordinates": estate.coordinates != null
          ? GeoPoint(estate.coordinates!.latitude, estate.coordinates!.longitude)
          : null,
      "phone": estate.phone,
      "guests": estate.guests,
    };
  }

  static List<Map<String, dynamic>> toGuestTable(List<dynamic>? JSONGuests) {
    if (JSONGuests == null) return [];

    List<Map<String, dynamic>> newGuests = [];

    for (int i = 0; i < JSONGuests.length; ++i) {
      Map<String, dynamic> guest = JSONGuests[i];
      guest['from'] = (guest['from'] as Timestamp).toDate();
      guest['to'] = (guest['to'] as Timestamp).toDate();
      newGuests = [...newGuests, guest];
    }

    return newGuests;
  }

  static Map<String, dynamic> newGuestRow() {
    DateTime now = DateTime.now();
    return {
      'from': now,
      'name': "",
      'to': now
    };
  }

  static String asString(Estate? estate) {
    if (estate == null) return "";
    return "id: ${estate.id}\nownerId: ${estate.ownerId}\nlatitude: ${estate.coordinates?.latitude}\nlongitude: ${estate.coordinates?.longitude}\nstreet: ${estate.street}\nzip: ${estate.zip}\ncity: ${estate.city}\ncountry: ${estate.country}\nphone: ${estate.phone}\n";
  }

  static List<Estate> setupEstatesFromFirebaseDocuments(List<QueryDocumentSnapshot<Map<String, dynamic>>>? document) {
    if (document == null) return [];
    
    Estate? currentEstate;
    List<Estate> estates = [];
    
    document.map((DocumentSnapshot doc) {
      Map<String, dynamic>? estateMap = doc.data() as Map<String, dynamic>?;
      if (estateMap == null) return;

      estateMap['id'] = doc.id;

      currentEstate = Estate.toEstate(estateMap);
      if (currentEstate == null) return;

      estates.add(currentEstate!);
    }).toList();

    return estates;
  }
}
