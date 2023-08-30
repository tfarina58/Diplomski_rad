import 'package:latlong2/latlong.dart';
import 'package:diplomski_rad/interfaces/preferences/user-preferences.dart';

abstract class User {
  abstract String id;
  abstract String email;
  abstract String phone;
  abstract UserPreferences? preferences;
}

class Admin extends User {
  @override
  String id;
  @override
  String email;
  @override
  String phone;
  @override
  UserPreferences? preferences = UserPreferences(); //TODO: somehow remove?

  String firstname;

  Admin({
    this.id = "",
    this.firstname = "",
    this.email = "",
    this.phone = "",
    this.preferences,
  });

  factory Admin.getUser() {
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

abstract class Customer extends User {
  @override
  abstract String id;
  @override
  abstract String email;
  @override
  abstract String phone;
  @override
  abstract UserPreferences? preferences;

  abstract String avatarImage;
  abstract String backgroundImage;
  abstract String street;
  abstract String zip;
  abstract String city;
  abstract String country;
  abstract LatLng coordinates;
  abstract String bio;
  abstract bool blocked;
  abstract bool banned;
}

class Company extends Customer {
  @override
  String avatarImage;
  @override
  String backgroundImage;
  @override
  String street;
  @override
  String zip;
  @override
  String city;
  @override
  String country;
  @override
  LatLng coordinates;
  @override
  String bio;
  @override
  String email;
  @override
  String phone;
  @override
  String id;
  @override
  bool blocked;
  @override
  bool banned;
  @override
  UserPreferences? preferences = UserPreferences(); //TODO: somehow remove ?

  String ownerFirstname;
  String ownerLastname;
  String companyName;

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
    this.blocked = false,
    this.banned = false,
  });

  static List<Company> getAllUsers() {
    List<Company> users = [];
    users.add(Company.getUser1());
    users.add(Company.getUser2());
    users.add(Company.getUser3());
    users.add(Company.getUser4());
    users.add(Company.getUser5());
    users.add(Company.getUser6());
    users.add(Company.getUser7());
    users.add(Company.getUser8());
    users.add(Company.getUser9());
    users.add(Company.getUser10());
    users.add(Company.getUser11());
    users.add(Company.getUser12());
    users.add(Company.getUser1());
    users.add(Company.getUser2());
    users.add(Company.getUser3());
    users.add(Company.getUser4());
    users.add(Company.getUser5());
    users.add(Company.getUser6());
    users.add(Company.getUser7());
    users.add(Company.getUser8());
    users.add(Company.getUser9());
    users.add(Company.getUser10());
    users.add(Company.getUser11());
    users.add(Company.getUser12());
    users.add(Company.getUser1());
    users.add(Company.getUser2());
    users.add(Company.getUser3());
    users.add(Company.getUser4());
    users.add(Company.getUser5());
    users.add(Company.getUser6());
    users.add(Company.getUser7());
    users.add(Company.getUser8());
    users.add(Company.getUser9());
    users.add(Company.getUser10());
    users.add(Company.getUser11());
    users.add(Company.getUser12());
    return users;
  }

  factory Company.getUser1() {
    return Company(
      id: "23f376ec08b0b6f43108f61bfaa96cd168f3dac4e5e5c02185a107ad9cffc5d1",
      ownerFirstname: "Toni",
      ownerLastname: "Farina",
      companyName: "Toni company",
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
        dateFormat: "dd.MM.yyyy.",
      ),
    );
  }

  factory Company.getUser2() {
    return Company(
      id: "23f376ec08b0b6f43108f61bfaa96cd168f3dac4e5e5c02185a107ad9cffc5d1",
      ownerFirstname: "Edmund",
      ownerLastname: "Myers",
      companyName: "Edmund company",
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
        dateFormat: "d/M/yy",
      ),
    );
  }

  factory Company.getUser3() {
    return Company(
      id: "23f376ec08b0b6f43108f61bfaa96cd168f3dac4e5e5c02185a107ad9cffc5d1",
      ownerFirstname: "Jana",
      ownerLastname: "Horn",
      companyName: "Jana company",
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
        dateFormat: "MM/dd/yyyy",
      ),
    );
  }

  factory Company.getUser4() {
    return Company(
      id: "23f376ec08b0b6f43108f61bfaa96cd168f3dac4e5e5c02185a107ad9cffc5d1",
      ownerFirstname: "Montgomery",
      ownerLastname: "Munoz",
      companyName: "Montgomery company",
      email: "montmunoz@hotmail.com",
      avatarImage: "images/chick.jpg",
      backgroundImage: "images/background.jpg",
      street: "Kandlerova 3",
      zip: "52440",
      city: "Poreč",
      country: "Croatia",
      coordinates: const LatLng(45.276392, 13.708525),
      phone: "+385981127453",
      bio: "A little about myself...",
      preferences: UserPreferences(
        distance: Length.miles,
        temperature: Temperature.fahrenheit,
        dateFormat: "MM/dd/yyyy",
      ),
    );
  }

  factory Company.getUser5() {
    return Company(
      id: "23f376ec08b0b6f43108f61bfaa96cd168f3dac4e5e5c02185a107ad9cffc5d1",
      ownerFirstname: "Aled",
      ownerLastname: "Sanders",
      companyName: "Aled company",
      email: "aled.sanders44@hotmail.com",
      avatarImage: "images/chick.jpg",
      backgroundImage: "images/background.jpg",
      street: "Kandlerova 5",
      zip: "52440",
      city: "Poreč",
      country: "Croatia",
      coordinates: const LatLng(45.276392, 13.708525),
      phone: "+38595467531",
      bio: "A little about myself...",
      preferences: UserPreferences(
        distance: Length.miles,
        temperature: Temperature.fahrenheit,
        dateFormat: "MM/dd/yyyy",
      ),
    );
  }

  factory Company.getUser6() {
    return Company(
      id: "23f376ec08b0b6f43108f61bfaa96cd168f3dac4e5e5c02185a107ad9cffc5d1",
      ownerFirstname: "Herbert",
      ownerLastname: "Beck",
      companyName: "Herbert company",
      email: "herbyb@hotmail.com",
      avatarImage: "images/chick.jpg",
      backgroundImage: "images/background.jpg",
      street: "Kandlerova 5",
      zip: "52440",
      city: "Poreč",
      country: "Croatia",
      coordinates: const LatLng(45.276392, 13.708525),
      phone: "+385916487263",
      bio: "A little about myself...",
      preferences: UserPreferences(
        distance: Length.miles,
        temperature: Temperature.fahrenheit,
        dateFormat: "MM/dd/yyyy",
      ),
    );
  }

  factory Company.getUser7() {
    return Company(
      id: "23f376ec08b0b6f43108f61bfaa96cd168f3dac4e5e5c02185a107ad9cffc5d1",
      ownerFirstname: "Luqman",
      ownerLastname: "Sanchez",
      companyName: "Luqman company",
      email: "lu.sa@hotmail.com",
      avatarImage: "images/chick.jpg",
      backgroundImage: "images/background.jpg",
      street: "Rovinjska 7",
      zip: "52450",
      city: "Vrsar",
      country: "Croatia",
      coordinates: const LatLng(45.276392, 13.708525),
      phone: "+38598761207",
      bio: "A little about myself...",
      preferences: UserPreferences(
        distance: Length.miles,
        temperature: Temperature.fahrenheit,
        dateFormat: "MM/dd/yyyy",
      ),
    );
  }

  factory Company.getUser8() {
    return Company(
      id: "23f376ec08b0b6f43108f61bfaa96cd168f3dac4e5e5c02185a107ad9cffc5d1",
      ownerFirstname: "Isabelle",
      ownerLastname: "Faulkner",
      companyName: "Isabelle company",
      email: "faulkner.isabelle777@gmail.com",
      avatarImage: "images/chick.jpg",
      backgroundImage: "images/background.jpg",
      street: "Dalmatinska 1",
      zip: "52450",
      city: "Vrsar",
      country: "Croatia",
      coordinates: const LatLng(45.276392, 13.708525),
      phone: "+385912031697",
      bio: "A little about myself...",
      preferences: UserPreferences(
        distance: Length.miles,
        temperature: Temperature.fahrenheit,
        dateFormat: "MM/dd/yyyy",
      ),
    );
  }

  factory Company.getUser9() {
    return Company(
      id: "23f376ec08b0b6f43108f61bfaa96cd168f3dac4e5e5c02185a107ad9cffc5d1",
      ownerFirstname: "Whitney",
      ownerLastname: "Strong",
      companyName: "Whitney company",
      email: "strongwhitney420@gmail.com",
      avatarImage: "images/chick.jpg",
      backgroundImage: "images/background.jpg",
      street: "Ulica Antuna Cerovca Tonića 1",
      zip: "52420",
      city: "Buzet",
      country: "Croatia",
      coordinates: const LatLng(45.276392, 13.708525),
      phone: "+385991710366",
      bio: "A little about myself...",
      preferences: UserPreferences(
        distance: Length.miles,
        temperature: Temperature.fahrenheit,
        dateFormat: "MM/dd/yyyy",
      ),
    );
  }

  factory Company.getUser10() {
    return Company(
      id: "23f376ec08b0b6f43108f61bfaa96cd168f3dac4e5e5c02185a107ad9cffc5d1",
      ownerFirstname: "Emily",
      ownerLastname: "Cherry",
      companyName: "Emily company",
      email: "mrs.cherry47@gmail.com",
      avatarImage: "images/chick.jpg",
      backgroundImage: "images/background.jpg",
      street: "Kaldir 2",
      zip: "52424",
      city: "Motovun",
      country: "Croatia",
      coordinates: const LatLng(45.276392, 13.708525),
      phone: "+385991710366",
      bio: "A little about myself...",
      preferences: UserPreferences(
        distance: Length.miles,
        temperature: Temperature.fahrenheit,
        dateFormat: "MM/dd/yyyy",
      ),
    );
  }

  factory Company.getUser11() {
    return Company(
      id: "23f376ec08b0b6f43108f61bfaa96cd168f3dac4e5e5c02185a107ad9cffc5d1",
      ownerFirstname: "Umar",
      ownerLastname: "Wyatt",
      companyName: "Umar company",
      email: "umar.wyatt571@outlook.com",
      avatarImage: "images/chick.jpg",
      backgroundImage: "images/background.jpg",
      street: "9. rujna 2",
      zip: "52341",
      city: "Žminj",
      country: "Croatia",
      coordinates: const LatLng(45.276392, 13.708525),
      phone: "+385924692304",
      bio: "A little about myself...",
      preferences: UserPreferences(
        distance: Length.miles,
        temperature: Temperature.fahrenheit,
        dateFormat: "MM/dd/yyyy",
      ),
    );
  }

  factory Company.getUser12() {
    return Company(
      id: "23f376ec08b0b6f43108f61bfaa96cd168f3dac4e5e5c02185a107ad9cffc5d1",
      ownerFirstname: "Dana",
      ownerLastname: "Romero",
      companyName: "Dana company",
      email: "alfa.romero@outlook.com",
      avatarImage: "images/chick.jpg",
      backgroundImage: "images/background.jpg",
      street: "Lukovica 17",
      zip: "52341",
      city: "Žminj",
      country: "Croatia",
      coordinates: const LatLng(45.276392, 13.708525),
      phone: "+385991710366",
      bio: "A little about myself...",
      preferences: UserPreferences(
        distance: Length.miles,
        temperature: Temperature.fahrenheit,
        dateFormat: "MM/dd/yyyy",
      ),
    );
  }
}

class Individual extends Customer {
  @override
  String id;
  @override
  String email;
  @override
  String avatarImage;
  @override
  String backgroundImage;
  @override
  String street;
  @override
  String zip;
  @override
  String city;
  @override
  String country;
  @override
  LatLng coordinates;
  @override
  String phone;
  @override
  String bio;
  @override
  bool blocked;
  @override
  bool banned;
  @override
  UserPreferences? preferences = UserPreferences(); //TODO: somehow remove ?

  String firstname;
  String lastname;
  String birthday;

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
    this.blocked = false,
    this.banned = false,
  });

  static List<Individual> getAllCustomers() {
    List<Individual> users = [];
    users.add(Individual.getUser1());
    users.add(Individual.getUser2());
    users.add(Individual.getUser3());
    users.add(Individual.getUser4());
    users.add(Individual.getUser5());
    users.add(Individual.getUser6());
    users.add(Individual.getUser7());
    users.add(Individual.getUser8());
    users.add(Individual.getUser9());
    users.add(Individual.getUser10());
    users.add(Individual.getUser11());
    users.add(Individual.getUser12());
    users.add(Individual.getUser1());
    users.add(Individual.getUser2());
    users.add(Individual.getUser3());
    users.add(Individual.getUser4());
    users.add(Individual.getUser5());
    users.add(Individual.getUser6());
    users.add(Individual.getUser7());
    users.add(Individual.getUser8());
    users.add(Individual.getUser9());
    users.add(Individual.getUser10());
    users.add(Individual.getUser11());
    users.add(Individual.getUser12());
    users.add(Individual.getUser1());
    users.add(Individual.getUser2());
    users.add(Individual.getUser3());
    users.add(Individual.getUser4());
    users.add(Individual.getUser5());
    users.add(Individual.getUser6());
    users.add(Individual.getUser7());
    users.add(Individual.getUser8());
    users.add(Individual.getUser9());
    users.add(Individual.getUser10());
    users.add(Individual.getUser11());
    users.add(Individual.getUser12());
    return users;
  }

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
        dateFormat: "dd.MM.yyyy.",
      ),
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
        dateFormat: "d/M/yy",
      ),
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
        dateFormat: "MM/dd/yyyy",
      ),
    );
  }

  factory Individual.getUser4() {
    return Individual(
      id: "23f376ec08b0b6f43108f61bfaa96cd168f3dac4e5e5c02185a107ad9cffc5d1",
      firstname: "Montgomery",
      lastname: "Munoz",
      birthday: "1961-03-02",
      email: "montmunoz@hotmail.com",
      avatarImage: "images/chick.jpg",
      backgroundImage: "images/background.jpg",
      street: "Kandlerova 3",
      zip: "52440",
      city: "Poreč",
      country: "Croatia",
      coordinates: const LatLng(45.276392, 13.708525),
      phone: "+385981127453",
      bio: "A little about myself...",
      preferences: UserPreferences(
        distance: Length.miles,
        temperature: Temperature.fahrenheit,
        dateFormat: "MM/dd/yyyy",
      ),
    );
  }

  factory Individual.getUser5() {
    return Individual(
      id: "23f376ec08b0b6f43108f61bfaa96cd168f3dac4e5e5c02185a107ad9cffc5d1",
      firstname: "Aled",
      lastname: "Sanders",
      birthday: "1988-08-01",
      email: "aled.sanders44@hotmail.com",
      avatarImage: "images/chick.jpg",
      backgroundImage: "images/background.jpg",
      street: "Kandlerova 5",
      zip: "52440",
      city: "Poreč",
      country: "Croatia",
      coordinates: const LatLng(45.276392, 13.708525),
      phone: "+38595467531",
      bio: "A little about myself...",
      preferences: UserPreferences(
        distance: Length.miles,
        temperature: Temperature.fahrenheit,
        dateFormat: "MM/dd/yyyy",
      ),
    );
  }

  factory Individual.getUser6() {
    return Individual(
      id: "23f376ec08b0b6f43108f61bfaa96cd168f3dac4e5e5c02185a107ad9cffc5d1",
      firstname: "Herbert",
      lastname: "Beck",
      birthday: "1981-11-20",
      email: "herbyb@hotmail.com",
      avatarImage: "images/chick.jpg",
      backgroundImage: "images/background.jpg",
      street: "Kandlerova 5",
      zip: "52440",
      city: "Poreč",
      country: "Croatia",
      coordinates: const LatLng(45.276392, 13.708525),
      phone: "+385916487263",
      bio: "A little about myself...",
      preferences: UserPreferences(
        distance: Length.miles,
        temperature: Temperature.fahrenheit,
        dateFormat: "MM/dd/yyyy",
      ),
    );
  }

  factory Individual.getUser7() {
    return Individual(
      id: "23f376ec08b0b6f43108f61bfaa96cd168f3dac4e5e5c02185a107ad9cffc5d1",
      firstname: "Luqman",
      lastname: "Sanchez",
      birthday: "1981-03-27",
      email: "lu.sa@hotmail.com",
      avatarImage: "images/chick.jpg",
      backgroundImage: "images/background.jpg",
      street: "Rovinjska 7",
      zip: "52450",
      city: "Vrsar",
      country: "Croatia",
      coordinates: const LatLng(45.276392, 13.708525),
      phone: "+38598761207",
      bio: "A little about myself...",
      preferences: UserPreferences(
        distance: Length.miles,
        temperature: Temperature.fahrenheit,
        dateFormat: "MM/dd/yyyy",
      ),
    );
  }

  factory Individual.getUser8() {
    return Individual(
      id: "23f376ec08b0b6f43108f61bfaa96cd168f3dac4e5e5c02185a107ad9cffc5d1",
      firstname: "Isabelle",
      lastname: "Faulkner",
      birthday: "1981-09-19",
      email: "faulkner.isabelle777@gmail.com",
      avatarImage: "images/chick.jpg",
      backgroundImage: "images/background.jpg",
      street: "Dalmatinska 1",
      zip: "52450",
      city: "Vrsar",
      country: "Croatia",
      coordinates: const LatLng(45.276392, 13.708525),
      phone: "+385912031697",
      bio: "A little about myself...",
      preferences: UserPreferences(
        distance: Length.miles,
        temperature: Temperature.fahrenheit,
        dateFormat: "MM/dd/yyyy",
      ),
    );
  }

  factory Individual.getUser9() {
    return Individual(
      id: "23f376ec08b0b6f43108f61bfaa96cd168f3dac4e5e5c02185a107ad9cffc5d1",
      firstname: "Whitney",
      lastname: "Strong",
      birthday: "1945-08-06",
      email: "strongwhitney420@gmail.com",
      avatarImage: "images/chick.jpg",
      backgroundImage: "images/background.jpg",
      street: "Ulica Antuna Cerovca Tonića 1",
      zip: "52420",
      city: "Buzet",
      country: "Croatia",
      coordinates: const LatLng(45.276392, 13.708525),
      phone: "+385991710366",
      bio: "A little about myself...",
      preferences: UserPreferences(
        distance: Length.miles,
        temperature: Temperature.fahrenheit,
        dateFormat: "MM/dd/yyyy",
      ),
    );
  }

  factory Individual.getUser10() {
    return Individual(
      id: "23f376ec08b0b6f43108f61bfaa96cd168f3dac4e5e5c02185a107ad9cffc5d1",
      firstname: "Emily",
      lastname: "Cherry",
      birthday: "1999-10-07",
      email: "mrs.cherry47@gmail.com",
      avatarImage: "images/chick.jpg",
      backgroundImage: "images/background.jpg",
      street: "Kaldir 2",
      zip: "52424",
      city: "Motovun",
      country: "Croatia",
      coordinates: const LatLng(45.276392, 13.708525),
      phone: "+385991710366",
      bio: "A little about myself...",
      preferences: UserPreferences(
        distance: Length.miles,
        temperature: Temperature.fahrenheit,
        dateFormat: "MM/dd/yyyy",
      ),
    );
  }

  factory Individual.getUser11() {
    return Individual(
      id: "23f376ec08b0b6f43108f61bfaa96cd168f3dac4e5e5c02185a107ad9cffc5d1",
      firstname: "Umar",
      lastname: "Wyatt",
      birthday: "1989-08-14",
      email: "umar.wyatt571@outlook.com",
      avatarImage: "images/chick.jpg",
      backgroundImage: "images/background.jpg",
      street: "9. rujna 2",
      zip: "52341",
      city: "Žminj",
      country: "Croatia",
      coordinates: const LatLng(45.276392, 13.708525),
      phone: "+385924692304",
      bio: "A little about myself...",
      preferences: UserPreferences(
        distance: Length.miles,
        temperature: Temperature.fahrenheit,
        dateFormat: "MM/dd/yyyy",
      ),
    );
  }

  factory Individual.getUser12() {
    return Individual(
      id: "23f376ec08b0b6f43108f61bfaa96cd168f3dac4e5e5c02185a107ad9cffc5d1",
      firstname: "Dana",
      lastname: "Romero",
      birthday: "1999-12-26",
      email: "alfa.romero@outlook.com",
      avatarImage: "images/chick.jpg",
      backgroundImage: "images/background.jpg",
      street: "Lukovica 17",
      zip: "52341",
      city: "Žminj",
      country: "Croatia",
      coordinates: const LatLng(45.276392, 13.708525),
      phone: "+385991710366",
      bio: "A little about myself...",
      preferences: UserPreferences(
        distance: Length.miles,
        temperature: Temperature.fahrenheit,
        dateFormat: "MM/dd/yyyy",
      ),
    );
  }
}
