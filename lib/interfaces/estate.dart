import 'package:latlong2/latlong.dart';
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
  int categoryRows;
  int categoryColumns;
  String categoryHeader;
  List<List<dynamic>> variables;

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
    this.categoryRows = 1,
    this.categoryColumns = 3,
    this.categoryHeader = "",
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
    newEstate.name = estate['name'] ?? "";
    newEstate.phone = estate['phone'] ?? "";
    newEstate.categoryRows = estate['categoryRows'] ?? 1;
    newEstate.categoryColumns = estate['categoryColumns'] ?? 3;
    newEstate.categoryHeader = "";
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
      "categoryRows": estate.categoryRows,
      "categoryColumns": estate.categoryColumns,
      "categoryHeader": estate.categoryHeader,
      "variables": toVariableJSON(estate.variables),
    };
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

  static String asString(Estate? estate) {
    if (estate == null) return "";
    return "id: ${estate.id}\nownerId: ${estate.ownerId}\nlatitude: ${estate.coordinates?.latitude}\nlongitude: ${estate.coordinates?.longitude}\nstreet: ${estate.street}\nzip: ${estate.zip}\ncity: ${estate.city}\ncountry: ${estate.country}\nphone: ${estate.phone}\ndescription: ${estate.description}\n";
  }
}
