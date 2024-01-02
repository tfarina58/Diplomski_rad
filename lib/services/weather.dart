import 'package:http/http.dart' as http;
import 'dart:convert';

class OpenWeatherMap {
  static String key = "60a327a5990e24e4c309de648bd01fbe";

  static Future<Map<String, dynamic>?> getWeather(dynamic coordinates) async {
    String url =
        "https://api.openweathermap.org/data/2.5/weather?lat=${coordinates.latitude}&lon=${coordinates.longitude}&appid=$key";

    final response = await http.post(
      Uri.parse(url),
    );

    if (response.statusCode ~/ 100 == 2) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      return null;
    }
  }
}
