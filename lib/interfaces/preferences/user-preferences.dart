enum Length { kilometers, miles }

enum Temperature { celsius, fahrenheit }

enum Language { english, german }

// enum FontSize { small, medium, large }

class UserPreferences {
  Length distance;
  Temperature temperature;
  String dateFormat;
  Language language;
  int usersPerPage;
  int estatesPerPage;
  // FontSize fontSize;

  UserPreferences({
    this.distance = Length.kilometers,
    this.temperature = Temperature.celsius,
    this.dateFormat = "yyyy-MM-dd",
    this.language = Language.english,
    this.usersPerPage = 10,
    this.estatesPerPage = 5,
    // this.fontSize = FontSize.medium,
  });

  String asString(dynamic arg) {
    if (arg is Length) {
      if (arg == Length.miles) {
        return "mi";
      } else {
        return "km";
      }
    } else if (arg is Temperature) {
      if (arg == Temperature.fahrenheit) {
        return "F";
      } else {
        return "C";
      }
    } else if (arg is Language) {
      if (arg == Language.german) {
        return "de";
      } else {
        return "en";
      }
    } else if (arg is String) {
      return arg;
    } else {
      return "";
    }
  }

  static Length toLength(String length) {
    switch (length) {
      case "km":
        return Length.kilometers;
      case "mi":
        return Length.miles;
      default:
        return Length.kilometers;
    }
  }

  static Temperature toTemperature(String temperature) {
    switch (temperature) {
      case "C":
        return Temperature.celsius;
      case "F":
        return Temperature.fahrenheit;
      default:
        return Temperature.celsius;
    }
  }

  static Language toLanguage(String language) {
    switch (language) {
      case "en":
        return Language.english;
      case "de":
        return Language.german;
      default:
        return Language.english;
    }
  }
}
