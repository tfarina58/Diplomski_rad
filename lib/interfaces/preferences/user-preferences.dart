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
}
