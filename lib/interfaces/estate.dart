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
  String description;
  List<Map<String, dynamic>> guests;
  List<List<dynamic>> variables;

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
    this.description = "",
    this.guests = const [],
    this.variables = const [],
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
    newEstate.description = estate['description'] ?? "";

    Map<String, String> name = {
      "en": estate['name']['en'] ?? "",
      "de": estate['name']['de'] ?? "",
      "hr": estate['name']['hr'] ?? "",
    };
    newEstate.name = name;
    
    newEstate.phone = estate['phone'] ?? "";
    newEstate.guests = toGuestTable(estate['guests']);
    newEstate.variables = toVariableTable(estate['variables']);
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
      "description": estate.description,
      "phone": estate.phone,
      "guests": estate.guests,
      "variables": toVariableJSON(estate.variables),
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

  static List<List<dynamic>> toVariableTable(Map<String, dynamic>? JSONVariables) {
    if (JSONVariables == null) return [];

    List<List<dynamic>> newVariables = [];

    JSONVariables.forEach((String key, dynamic value) {
      List<dynamic> row = [key, value[0] as String, (value[1] as Timestamp).toDate()];
      newVariables = [...newVariables, row];
    });

    return newVariables;
  }

  static Map<String, dynamic> toVariableJSON(List<List<dynamic>>? variablesTable) {
    if (variablesTable == null) return {};

    Map<String, dynamic> output = {};

    for (int i = 0; i < variablesTable.length; ++i) {
      Timestamp from = Timestamp.fromDate(variablesTable[i][2] as DateTime);

      DateTime now = DateTime.now();
      if ((variablesTable[i][0] as String).isEmpty || (variablesTable[i][1] as String).isEmpty || from.millisecondsSinceEpoch < now.millisecondsSinceEpoch) {
        continue;
      }

      output[variablesTable[i][0] as String] = [variablesTable[i][1] as String, from];
    }

    return output;
  }

  static List<dynamic> newVariableRow() {
    DateTime now = DateTime.now();
    return ["", "", DateTime(now.year, now.month, now.day)];
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
    return "id: ${estate.id}\nownerId: ${estate.ownerId}\nlatitude: ${estate.coordinates?.latitude}\nlongitude: ${estate.coordinates?.longitude}\nstreet: ${estate.street}\nzip: ${estate.zip}\ncity: ${estate.city}\ncountry: ${estate.country}\nphone: ${estate.phone}\ndescription: ${estate.description}\n";
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
