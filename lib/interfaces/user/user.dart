abstract class User {}

class Company extends User {
  String id;
  String ownerFirstname;
  String ownerLastname;
  String companyName;
  String email;
  List<String> images;
  String street;
  String zip;
  String city;
  String country;
  String phone;
  String password;
  String bio;

  Company({
    this.id = "",
    this.ownerFirstname = "",
    this.ownerLastname = "",
    this.companyName = "",
    this.email = "",
    this.images = const <String>[],
    this.street = "",
    this.zip = "",
    this.city = "",
    this.country = "",
    this.phone = "",
    this.password = "",
    this.bio = "",
  });
}

class Individual extends User {
  String id;
  String firstname;
  String lastname;
  String birthday;
  String email;
  List<String> images;
  String street;
  String zip;
  String city;
  String country;
  String phone;
  String password;
  String bio;

  Individual({
    this.id = "",
    this.firstname = "",
    this.lastname = "",
    this.birthday = "",
    this.email = "",
    this.images = const <String>[],
    this.street = "",
    this.zip = "",
    this.city = "",
    this.country = "",
    this.phone = "",
    this.password = "",
    this.bio = "",
  });
}

class Admin extends User {
  String id;
  String firstname;
  String email;
  String phone;
  String password;

  Admin({
    this.id = "",
    this.firstname = "",
    this.email = "",
    this.phone = "",
    this.password = "",
  });
}
