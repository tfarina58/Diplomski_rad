import 'package:latlong2/latlong.dart';
import 'package:diplomski_rad/interfaces/preferences/estate-preferences.dart';

abstract class Estate {
  abstract final String id;
  abstract final String ownerId;
  abstract String name;
  abstract List<String> images;
  abstract String street;
  abstract String zip;
  abstract String city;
  abstract String country;
  abstract LatLng? coordinates;
  abstract String phone;
  abstract int templateCount;
  abstract String description;
  abstract EstatePreferences? preferences;
}

class CompanyEstate extends Estate {
  @override
  final String ownerId;

  @override
  final String id;
  @override
  String name;
  @override
  List<String> images;
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
  int templateCount;
  @override
  String description;
  @override
  EstatePreferences? preferences = EstatePreferences();

  CompanyEstate({
    this.id = "",
    this.ownerId = "",
    this.name = "",
    this.images = const <String>[],
    this.street = "",
    this.zip = "",
    this.city = "",
    this.country = "",
    this.coordinates,
    this.phone = "",
    this.templateCount = -1,
    this.description = "",
    this.preferences,
  });

  factory CompanyEstate.getEstate1() {
    return CompanyEstate(
      id: "23f376ec08b0b6f43108f61bfaa96cd168f3dac4e5e5c02185a107ad9cffc5d1",
      ownerId:
          "23f376ec08b0b6f43108f61bfaa96cd168f3dac4e5e5c02185a107ad9cffc5d1",
      name: "Villa Rovinj",
      images: ["images/test.png", "images/rovinj2.jpg"],
      street: "Ulica Luje Adamovića 2",
      zip: "52210",
      city: "Rovinj",
      country: "Croatia",
      coordinates: const LatLng(45.07739, 13.64329),
      phone: "+385 99 471 6110",
      description: "Villa Rovinj description",
      templateCount: -1,
      preferences: EstatePreferences(),
    );
  }

  factory CompanyEstate.getEstate2() {
    return CompanyEstate(
      id: "c4ca4238a0b923820dcc509a6f75849b",
      ownerId: "c81e728d9d4c2f636f067f89cc14862c",
      name: "Aphrodite's rock",
      images: ["images/test3.jpg"],
      street: "Pissouri 221A",
      zip: "3221",
      city: "Pissouri",
      country: "Cyprus",
      coordinates: const LatLng(34.664776, 32.627872),
      phone: "+357 11 529 4490",
      description: "Aphrodite's rock description",
      templateCount: -1,
      preferences: EstatePreferences(),
    );
  }

  factory CompanyEstate.getEstate3() {
    return CompanyEstate(
      id: "c4ca4238a0b923820dcc509a6f75849b",
      ownerId: "c81e728d9d4c2f636f067f89cc14862c",
      name: "Sea apartments",
      images: ["images/test2.jpg"],
      zip: "47712",
      city: "Vaitāpē",
      country: "Bora Bora, French Polynesia",
      coordinates: const LatLng(-16.499701, -151.770538),
      phone: "+47 86 000 1000",
      description: "Sea apartments description",
      templateCount: -1,
      preferences: EstatePreferences(),
    );
  }
}

class IndividualEstate extends Estate {
  @override
  final String ownerId;
  @override
  final String id;
  @override
  String name;
  @override
  List<String> images;
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
  int templateCount;
  @override
  String description;
  @override
  EstatePreferences? preferences;

  IndividualEstate({
    this.id = "",
    this.ownerId = "",
    this.name = "",
    this.images = const <String>[],
    this.street = "",
    this.zip = "",
    this.city = "",
    this.country = "",
    this.coordinates,
    this.phone = "",
    this.templateCount = -1,
    this.description = "",
    this.preferences,
  });

  factory IndividualEstate.getEstate1() {
    return IndividualEstate(
      id: "23f376ec08b0b6f43108f61bfaa96cd168f3dac4e5e5c02185a107ad9cffc5d1",
      ownerId:
          "23f376ec08b0b6f43108f61bfaa96cd168f3dac4e5e5c02185a107ad9cffc5d1",
      name: "Villa Rovinj",
      images: ["images/test.png", "images/rovinj2.jpg"],
      street: "Ulica Luje Adamovića 2",
      zip: "52210",
      city: "Rovinj",
      country: "Croatia",
      coordinates: const LatLng(45.07739, 13.64329),
      phone: "+385 99 471 6110",
      description: "Villa Rovinj description",
      templateCount: -1,
      preferences: EstatePreferences(),
    );
  }

  factory IndividualEstate.getEstate2() {
    return IndividualEstate(
      id: "c4ca4238a0b923820dcc509a6f75849b",
      ownerId: "c81e728d9d4c2f636f067f89cc14862c",
      name: "Aphrodite's rock",
      images: ["images/test3.jpg"],
      street: "Pissouri 221A",
      zip: "3221",
      city: "Pissouri",
      country: "Cyprus",
      coordinates: const LatLng(44.80251084712432, 13.910140726102172),
      phone: "+357 11 529 4490",
      description: "Aphrodite's rock description",
      templateCount: -1,
      preferences: EstatePreferences(),
    );
  }

  factory IndividualEstate.getEstate3() {
    return IndividualEstate(
      id: "c4ca4238a0b923820dcc509a6f75849b",
      ownerId: "c81e728d9d4c2f636f067f89cc14862c",
      name: "Sea apartments",
      images: ["images/test2.jpg"],
      zip: "47712",
      city: "Vaitāpē",
      country: "Bora Bora, French Polynesia",
      coordinates: const LatLng(46.07739, 14.64329),
      phone: "+47 86 000 1000",
      description: "Sea apartments description",
      templateCount: -1,
      preferences: EstatePreferences(),
    );
  }
}
