import 'package:flutter/material.dart';

import '../coordinates/coordinates.dart';

class HeaderPages {
  String typeOfUser;

  HeaderPages({
    this.typeOfUser = "",
  });
}

class IndividualEstate {
  final String id;
  final String individualId;
  String name;
  List<String> images;
  String street;
  String zip;
  String city;
  String country;
  Coordinates? coordinates;
  String phone;
  int templates;
  String description;

  IndividualEstate({
    this.id = "",
    this.individualId = "",
    this.name = "",
    this.images = const <String>[],
    this.street = "",
    this.zip = "",
    this.city = "",
    this.country = "",
    this.coordinates,
    this.phone = "",
    this.templates = -1,
    this.description = "",
  });
}
