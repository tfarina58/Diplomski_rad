import 'package:latlong2/latlong.dart';
import 'package:diplomski_rad/interfaces/user-preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class User {
  abstract String id;
  abstract String email;
  abstract String phone;
  abstract UserPreferences preferences;

  static List<String>? convertArray(List<dynamic>? input) {
    if (input == null || input.isEmpty) {
      return null;
    }

    List<String>? output = [];
    for (dynamic element in input) {
      output.add(element.toString());
    }

    return output;
  }

  static User? toUser(Map<String, dynamic> user) {
        if (user['typeOfUser'] == "ind") {
      Individual res = Individual();

      res.avatarImage = user['avatarImage'] ?? "";
      res.backgroundImage = user['backgroundImage'] ?? "";
      res.banned = user['banned'] ?? false;
      res.bio = user['bio'] ?? "";
      res.blocked = user['blocked'] ?? false;
      res.city = user['city'] ?? "";
      if (user['coordinates'] != null) {
        res.coordinates = LatLng((user['coordinates'] as GeoPoint).latitude,
            (user['coordinates'] as GeoPoint).longitude);
      }
      res.country = user['country'] ?? "";
      res.email = user['email'] ?? "";
      res.firstname = user['firstname'] ?? "";
      res.id = user['id'] ?? "";
      res.lastname = user['lastname'] ?? "";
      res.phone = user['phone'] ?? "";
      res.preferences = UserPreferences(
        distance: user['distance'] ?? "km",
        temperature: user['temperature'] ?? "C",
        dateFormat: user['dateFormat'] ?? "yyyy-MM-dd",
        language: user['language'] ?? "en",
      );
      Timestamp x = user['birthday'];
      res.birthday =
          DateTime.fromMillisecondsSinceEpoch(x.millisecondsSinceEpoch);
      res.street = user['street'] ?? "";
      res.zip = user['zip'] ?? "";
      res.numOfEstates = user['numOfEstates'] ?? 0;

      return res;
    } else if (user["typeOfUser"] == "com") {
      Company res = Company();

      res.avatarImage = user['avatarImage'] ?? "";
      res.backgroundImage = user['backgroundImage'] ?? "";
      res.banned = user['banned'] ?? false;
      res.bio = user['bio'] ?? "";
      res.blocked = user['blocked'] ?? false;
      res.city = user['city'] ?? "";
      if (user['coordinates'] != null) {
        res.coordinates = LatLng((user['coordinates'] as GeoPoint).latitude,
            (user['coordinates'] as GeoPoint).longitude);
      }
      res.country = user['country'] ?? "";
      res.email = user['email'] ?? "";
      res.ownerFirstname = user['ownerFirstname'] ?? "";
      res.id = user['id'] ?? "";
      res.ownerLastname = user['ownerLastname'] ?? "";
      res.phone = user['phone'] ?? "";
      res.preferences = UserPreferences(
        distance: user['distance'] ?? "km",
        temperature: user['temperature'] ?? "C",
        dateFormat: user['dateFormat'] ?? "yyyy-MM-dd",
        language: user['language'] ?? "en",
      );
      res.companyName = user['email'] ?? "";
      res.street = user['street'] ?? "";
      res.zip = user['zip'] ?? "";
      res.numOfEstates = user['numOfEstates'] ?? 0;

      return res;
    } else if (user["typeOfUser"] == "adm") {
      Admin res = Admin();
      res.id = user['id'] ?? "";
      res.firstname = user['firstname'] ?? "";
      res.email = user['email'] ?? "";
      res.phone = user['phone'] ?? "";
      res.preferences = UserPreferences(
        distance: user['distance'] ?? "km",
        temperature: user['temperature'] ?? "C",
        dateFormat: user['dateFormat'] ?? "yyyy-MM-dd",
        language: user['language'] ?? "en",
      );

      return res;
    }
    return null;
  }

  static Map<String, dynamic>? toJSON(User? user) {
    if (user == null) return null;

    if (user is Individual) {
      return {
        "email": user.email,
        // "avatarImage": avatarImage,
        // "backgroundImage": backgroundImage,
        "street": user.street,
        "zip": user.zip,
        "city": user.city,
        "country": user.country,
        "coordinates": user.coordinates != null
            ? GeoPoint(user.coordinates!.latitude, user.coordinates!.longitude)
            : null,
        "phone": user.phone,
        "bio": user.bio,
        "blocked": user.blocked,
        "banned": user.banned,
        "distance": user.preferences.distance,
        "temperature": user.preferences.temperature,
        "dateFormat": user.preferences.dateFormat,
        "language": user.preferences.language,
        // "password": password
        "firstname": user.firstname,
        "typeOfUser": "ind",
        "lastname": user.lastname,
        "birthday": Timestamp(user.birthday.millisecondsSinceEpoch ~/ 1000, 0),
        "numOfEstates": user.numOfEstates,
      };
    } else if (user is Company) {
      return {
        "email": user.email,
        // "avatarImage": user.avatarImage,
        // "backgroundImage": user.backgroundImage,
        "street": user.street,
        "zip": user.zip,
        "city": user.city,
        "country": user.country,
        "coordinates": user.coordinates != null
            ? GeoPoint(user.coordinates!.latitude, user.coordinates!.longitude)
            : null,
        "phone": user.phone,
        "bio": user.bio,
        "blocked": user.blocked,
        "banned": user.banned,
        "distance": user.preferences.distance,
        "temperature": user.preferences.temperature,
        "dateFormat": user.preferences.dateFormat,
        "language": user.preferences.language,
        "typeOfUser": "com",
        // "password": password
        "ownerFirstname": user.ownerFirstname,
        "ownerLastname": user.ownerLastname,
        "companyName": user.companyName,
        "numOfEstates": user.numOfEstates,
      };
    } else if (user is Admin) {
      return {
        "email": user.email,
        "phone": user.phone,
        "distance": user.preferences.distance,
        "temperature": user.preferences.temperature,
        "dateFormat": user.preferences.dateFormat,
        "language": user.preferences.language,
        "typeOfUser": "adm",
        // "password": password
        "firstname": user.firstname,
      };
    }
    return null;
  }
}

class Admin extends User {
  @override
  String id;
  @override
  String email;
  @override
  String phone;
  @override
  UserPreferences preferences; //TODO: somehow remove?

  String firstname;

  Admin({
    this.id = "",
    this.firstname = "",
    this.email = "",
    this.phone = "",
  }) : preferences = UserPreferences();
}

abstract class Customer extends User {
  @override
  abstract String id;
  @override
  abstract String email;
  @override
  abstract String phone;
  @override
  abstract UserPreferences preferences;

  abstract String avatarImage;
  abstract String backgroundImage;
  abstract String street;
  abstract String zip;
  abstract String city;
  abstract String country;
  abstract LatLng? coordinates;
  abstract String bio;
  abstract bool blocked;
  abstract bool banned;
  abstract int numOfEstates;
}

class Company extends Customer {
  @override
  String avatarImage;
  @override
  String backgroundImage;
  @override
  String street;
  @override
  String zip;
  @override
  String city;
  @override
  String country;
  @override
  LatLng? coordinates;
  @override
  String bio;
  @override
  String email;
  @override
  String phone;
  @override
  String id;
  @override
  bool blocked;
  @override
  bool banned;
  @override
  int numOfEstates;
  @override
  UserPreferences preferences; //TODO: somehow remove ?

  String ownerFirstname;
  String ownerLastname;
  String companyName;

  Company({
    this.id = "",
    this.ownerFirstname = "",
    this.ownerLastname = "",
    this.companyName = "",
    this.email = "",
    this.avatarImage = "",
    this.backgroundImage = "",
    this.street = "",
    this.zip = "",
    this.city = "",
    this.country = "",
    this.coordinates,
    this.phone = "",
    this.bio = "",
    this.blocked = false,
    this.banned = false,
    this.numOfEstates = 0,
  }) : preferences = UserPreferences();
}

class Individual extends Customer {
  @override
  String id;
  @override
  String email;
  @override
  String avatarImage;
  @override
  String backgroundImage;
  @override
  String street;
  @override
  String zip;
  @override
  String city;
  @override
  String country;
  @override
  LatLng? coordinates;
  @override
  String phone;
  @override
  String bio;
  @override
  bool blocked;
  @override
  bool banned;
  @override
  int numOfEstates;
  @override
  UserPreferences preferences; //TODO: somehow remove ?

  String firstname;
  String lastname;
  DateTime birthday;

  Individual({
    this.id = "",
    this.firstname = "",
    this.lastname = "",
    this.email = "",
    this.avatarImage = "",
    this.backgroundImage = "",
    this.street = "",
    this.zip = "",
    this.city = "",
    this.country = "",
    this.coordinates,
    this.phone = "",
    this.bio = "",
    this.blocked = false,
    this.banned = false,
    this.numOfEstates = 0,
  })  : preferences = UserPreferences(),
        birthday = DateTime.now();
}
