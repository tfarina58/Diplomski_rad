import 'package:latlong2/latlong.dart';
import 'package:diplomski_rad/interfaces/preferences/user-preferences.dart';

abstract class User {}

class Company extends User {
  String ownerFirstname;
  String ownerLastname;
  String companyName;
  String avatarImage;
  String backgroundImage;
  String street;
  String zip;
  String city;
  String country;
  LatLng coordinates;
  String bio;
  String email;
  String phone;
  String id;
  UserPreferences? preferences = UserPreferences(); //TODO: somehow remove ?

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
    this.coordinates = const LatLng(0, 0),
    this.phone = "",
    this.bio = "",
    this.preferences,
  });

  factory Company.getUser1() {
    return Company(
      id: "23f376ec08b0b6f43108f61bfaa96cd168f3dac4e5e5c02185a107ad9cffc5d1",
      ownerFirstname: "Toni",
      ownerLastname: "Farina",
      companyName: "1998-03-12",
      email: "tfarina58@gmail.com",
      avatarImage: "images/chick.jpg",
      backgroundImage: "images/background.jpg",
      street: "Farini 10A",
      zip: "52463",
      city: "Višnjan",
      country: "Croatia",
      coordinates: const LatLng(45.276392, 13.708525),
      phone: "+385994716110",
      bio: "A little about myself...",
      preferences: UserPreferences(
          distance: Length.miles,
          temperature: Temperature.fahrenheit,
          dateFormat: "dd.MM.yyyy."),
    );
  }

  factory Company.getUser2() {
    return Company(
      id: "23f376ec08b0b6f43108f61bfaa96cd168f3dac4e5e5c02185a107ad9cffc5d1",
      ownerFirstname: "Nevio",
      ownerLastname: "Žiković",
      companyName: "1998-03-12",
      email: "nevio.zikovic@gmail.com",
      avatarImage: "images/chick.jpg",
      backgroundImage: "images/background.jpg",
      street: "Markovac 17",
      zip: "52463",
      city: "Višnjan",
      country: "Croatia",
      coordinates: const LatLng(45.276392, 13.708525),
      phone: "+38591436201",
      bio: "A little about myself...",
      preferences: UserPreferences(
          distance: Length.miles,
          temperature: Temperature.fahrenheit,
          dateFormat: "d/M/yy"),
    );
  }

  factory Company.getUser3() {
    return Company(
      id: "23f376ec08b0b6f43108f61bfaa96cd168f3dac4e5e5c02185a107ad9cffc5d1",
      ownerFirstname: "Klaudia",
      ownerLastname: "Mofardin",
      companyName: "1978-02-02",
      email: "kmofardin@hotmail.com",
      avatarImage: "images/chick.jpg",
      backgroundImage: "images/background.jpg",
      street: "Mofardini 11",
      zip: "52404",
      city: "Tinjan",
      country: "Croatia",
      coordinates: const LatLng(45.276392, 13.708525),
      phone: "+385984239920",
      bio: "A little about myself...",
      preferences: UserPreferences(
          distance: Length.miles,
          temperature: Temperature.fahrenheit,
          dateFormat: "MM/dd/yyyy"),
    );
  }
}

class Individual extends User {
  String id;
  String firstname;
  String lastname;
  String birthday;
  String email;
  String avatarImage;
  String backgroundImage;
  String street;
  String zip;
  String city;
  String country;
  LatLng coordinates;
  String phone;
  String bio;
  UserPreferences? preferences = UserPreferences(); //TODO: somehow remove ?

  Individual({
    this.id = "",
    this.firstname = "",
    this.lastname = "",
    this.birthday = "",
    this.email = "",
    this.avatarImage = "",
    this.backgroundImage = "",
    this.street = "",
    this.zip = "",
    this.city = "",
    this.country = "",
    this.coordinates = const LatLng(0, 0),
    this.phone = "",
    this.bio = "",
    this.preferences,
  });

  factory Individual.getUser1() {
    return Individual(
      id: "23f376ec08b0b6f43108f61bfaa96cd168f3dac4e5e5c02185a107ad9cffc5d1",
      firstname: "Toni",
      lastname: "Farina",
      birthday: "1998-03-12",
      email: "tfarina58@gmail.com",
      avatarImage: "images/chick.jpg",
      backgroundImage: "images/background.jpg",
      street: "Farini 10A",
      zip: "52463",
      city: "Višnjan",
      country: "Croatia",
      coordinates: const LatLng(45.276392, 13.708525),
      phone: "+385994716110",
      bio: "A little about myself...",
      preferences: UserPreferences(
          distance: Length.miles,
          temperature: Temperature.fahrenheit,
          dateFormat: "dd.MM.yyyy."),
    );
  }

  factory Individual.getUser2() {
    return Individual(
      id: "23f376ec08b0b6f43108f61bfaa96cd168f3dac4e5e5c02185a107ad9cffc5d1",
      firstname: "Edmund",
      lastname: "Myers",
      birthday: "1998-03-12",
      email: "emyers11@gmail.com",
      avatarImage: "images/chick.jpg",
      backgroundImage: "images/background.jpg",
      street: "Markovac 17",
      zip: "52463",
      city: "Višnjan",
      country: "Croatia",
      coordinates: const LatLng(45.276392, 13.708525),
      phone: "+38591436201",
      bio: "A little about myself...",
      preferences: UserPreferences(
          distance: Length.miles,
          temperature: Temperature.fahrenheit,
          dateFormat: "d/M/yy"),
    );
  }

  factory Individual.getUser3() {
    return Individual(
      id: "23f376ec08b0b6f43108f61bfaa96cd168f3dac4e5e5c02185a107ad9cffc5d1",
      firstname: "Jana",
      lastname: "Horn",
      birthday: "1978-02-02",
      email: "jana.horn@hotmail.com",
      avatarImage: "images/chick.jpg",
      backgroundImage: "images/background.jpg",
      street: "Mofardini 11",
      zip: "52404",
      city: "Tinjan",
      country: "Croatia",
      coordinates: const LatLng(45.276392, 13.708525),
      phone: "+385984239920",
      bio: "A little about myself...",
      preferences: UserPreferences(
          distance: Length.miles,
          temperature: Temperature.fahrenheit,
          dateFormat: "MM/dd/yyyy"),
    );
  }
}

class Admin extends User {
  String id;
  String firstname;
  String email;
  String phone;
  UserPreferences? preferences = UserPreferences(); //TODO: somehow remove ?

  Admin({
    this.id = "",
    this.firstname = "",
    this.email = "",
    this.phone = "",
    this.preferences,
  });

  factory Admin.getUser2() {
    return Admin(
      id: "23f376ec08b0b6f43108f61bfaa96cd168f3dac4e5e5c02185a107ad9cffc5d1",
      firstname: "Toni",
      email: "tfarina58@gmail.com",
      phone: "+385994716110",
      preferences: UserPreferences(
          distance: Length.miles,
          temperature: Temperature.fahrenheit,
          dateFormat: "MM/dd/yyyy"),
    );
  }
}
