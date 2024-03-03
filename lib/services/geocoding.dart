import 'package:latlong2/latlong.dart';
import 'package:geocode/geocode.dart';

class Geocoding {
  String address = "";
  String zip = "";
  String city = "";
  String country = "";
  LatLng? coordinates;

  static Future<LatLng?> geocode(String street, String city, String zip, String country) async {
    GeoCode geoCode = GeoCode(apiKey: "224309012182512741305x66964");
    try {
      Coordinates coordinates = await geoCode.forwardGeocoding(address: "$street, $city, $country $zip");

      if (coordinates.latitude == null || coordinates.longitude == null) {
        return null;
      } else {
        return LatLng(coordinates.latitude!, coordinates.longitude!);
      }
    } catch (e) {
      return null;
    }
  }
}
