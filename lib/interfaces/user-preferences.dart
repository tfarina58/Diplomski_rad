class UserPreferences {
  String temperature;
  String dateFormat;
  String language;
  int usersPerPage;
  int estatesPerPage;
  // FontSize fontSize;

  UserPreferences({
    this.temperature = "C",
    this.dateFormat = "yyyy-MM-dd",
    this.language = "en",
    this.usersPerPage = 10,
    this.estatesPerPage = 5,
    // this.fontSize = FontSize.medium,
  });

  // Kelvin to Fahrenheit
  static double K2F(double k) {
    return (k - 273.15) * 1.8 + 32;
  }

  // Kelvin to Celsius
  static double K2C(double k) {
    return k - 272.15;
  }
}
