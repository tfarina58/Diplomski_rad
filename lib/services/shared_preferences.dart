import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  SharedPreferences sharedPreferences;

  SharedPreferencesService(this.sharedPreferences);

  bool getKeepLoggedIn() {
    String? keepLoggedIn = sharedPreferences.getString("keepLoggedIn");
    if (keepLoggedIn == "true") {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> setKeepLoggedIn(bool keepLoggedIn) {
    return sharedPreferences.setString("keepLoggedIn", keepLoggedIn.toString());
  }

  String getUserId() {
    return sharedPreferences.getString("userId") ?? "";
  }

  Future<bool> setUserId(String userId) async {
    return await sharedPreferences.setString("userId", userId);
  }

  String getTypeOfUser() {
    return sharedPreferences.getString("typeOfUser") ?? "";
  }

  Future<bool> setTypeOfUser(String typeOfUser) async {
    return await sharedPreferences.setString("typeOfUser", typeOfUser);
  }

  String getAvatarImage() {
    return sharedPreferences.getString("avatarImage") ?? "";
  }

  Future<bool> setAvatarImage(String avatarImage) async {
    return await sharedPreferences.setString("avatarImage", avatarImage);
  }

  String getLanguage() {
    return sharedPreferences.getString("language") ?? "en";
  }

  Future<bool> setLanguage(String language) async {
    return await sharedPreferences.setString("language", language);
  }

  String getTemperaturePreference() {
    return sharedPreferences.getString("temperaturePreference") ?? "C";
  }

  Future<bool> setTemperaturePreference(String temperaturePreference) async {
    return await sharedPreferences.setString("temperaturePreference", temperaturePreference);
  }
}
