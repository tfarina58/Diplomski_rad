import 'package:diplomski_rad/interfaces/preferences/user-preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:diplomski_rad/components/header.dart';
import 'package:diplomski_rad/interfaces/user/user.dart';
import 'package:diplomski_rad/other/pallete.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:flutter/foundation.dart';
import 'package:diplomski_rad/widgets/gradient_button.dart';
import 'package:diplomski_rad/widgets/string_field.dart';
import 'package:diplomski_rad/widgets/calendar_field.dart';
import 'package:diplomski_rad/widgets/maps.dart';
import 'package:diplomski_rad/widgets/dropdown_field.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'package:diplomski_rad/services/firebase.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  User user = Individual.getUser1();

  LatLng coordinates = const LatLng(0, 0);

  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: HeaderComponent(currentPage: 'ProfilePage'),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('email', isEqualTo: widget.user.email)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(
                color: PalleteCommon.gradient2,
                semanticsLabel: "Loading",
                backgroundColor: PalleteCommon.backgroundColor,
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final document = snapshot.data?.docs;

              if (document == null) return Text('Error: ${snapshot.error}');

              document.map((DocumentSnapshot doc) {
                Map<String, dynamic>? tmpMap =
                    doc.data() as Map<String, dynamic>?;
                if (tmpMap == null) return;

                User? tmp = User.toUser(tmpMap);
                if (tmp == null) return;

                widget.user = tmp;
              }).toList();

              return Column(
                children: [
                  ImagesDisplay(user: widget.user),
                  Padding(
                    padding: EdgeInsets.fromLTRB(width * 0.2, 0, 0, 0),
                    child: Row(
                      children: [
                        Text(
                          widget.user.email,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                        SizedBox(width: width * 0.4),
                        GradientButton(
                          buttonText: "Save changes",
                          callback: () {
                            saveChanges(width, height);
                          },
                          colors: PalleteSuccess.getGradients(),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: width,
                    height: height * 0.1,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            "Personal information",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            "Your address",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            "Preferences",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: width,
                    height: height * 0.04,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            get11(),
                            SizedBox(height: height * 0.02),
                            get21(),
                            SizedBox(height: height * 0.02),
                            get31(),
                            SizedBox(height: height * 0.02),
                            get41(),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            get12(),
                            SizedBox(height: height * 0.02),
                            get22(),
                            SizedBox(height: height * 0.02),
                            get32(),
                            SizedBox(height: height * 0.02),
                            get42(),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            get13(),
                            SizedBox(height: height * 0.02),
                            get23(),
                            SizedBox(height: height * 0.02),
                            get33(),
                            SizedBox(height: height * 0.02),
                            get43(),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * 0.1),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget get11() {
    if (widget.user is Individual) {
      return StringField(
        presetText: (widget.user as Individual).firstname,
        labelText: 'First name',
        callback: (String value) =>
            (widget.user as Individual).firstname = value,
      );
    } else if (widget.user is Company) {
      return StringField(
        presetText: (widget.user as Company).ownerFirstname,
        labelText: 'Owner\'s first name',
        callback: (String value) =>
            (widget.user as Company).ownerFirstname = value,
      );
    } else if (widget.user is Admin) {
      return StringField(
        presetText: (widget.user as Admin).firstname,
        labelText: 'First name',
        callback: (String value) => (widget.user as Admin).firstname = value,
      );
    }
    return const SizedBox();
  }

  Widget get21() {
    if (widget.user is Individual) {
      return StringField(
        presetText: (widget.user as Individual).lastname,
        labelText: 'Last name',
        callback: (String value) =>
            (widget.user as Individual).lastname = value,
      );
    } else if (widget.user is Company) {
      return StringField(
        presetText: (widget.user as Company).ownerLastname,
        labelText: 'Owner\'s last name',
        callback: (String value) =>
            (widget.user as Company).ownerLastname = value,
      );
    }
    return const SizedBox();
  }

  Widget get31() {
    if (widget.user is Individual) {
      return CalendarField(
        selectedDate: (widget.user as Individual).birthday.isNotEmpty
            ? DateTime.parse((widget.user as Individual).birthday)
            : DateTime.now(),
        labelText: 'Date of birth',
        callback: (String value) =>
            (widget.user as Individual).birthday = value,
      );
    } else if (widget.user is Company) {
      return StringField(
        presetText: (widget.user as Company).companyName,
        labelText: 'Company\'s name',
        callback: (String value) =>
            (widget.user as Company).companyName = value,
      );
    }
    return const SizedBox();
  }

  Widget get41() {
    return StringField(
      presetText: widget.user.phone,
      labelText: 'Phone number',
      callback: (String value) => widget.user.phone = value,
    );
  }

  Widget get12() {
    if (widget.user is Customer) {
      return StringField(
        presetText: (widget.user as Customer).street,
        labelText: 'Street',
        callback: (String value) => (widget.user as Customer).street = value,
      );
    }
    return const SizedBox();
  }

  Widget get22() {
    if (widget.user is Customer) {
      return StringField(
        presetText: (widget.user as Customer).zip,
        labelText: 'Zip',
        callback: (String value) => (widget.user as Customer).zip = value,
      );
    }
    return const SizedBox();
  }

  Widget get32() {
    if (widget.user is Customer) {
      return StringField(
        presetText: (widget.user as Customer).city,
        labelText: 'City',
        callback: (String value) => (widget.user as Customer).city = value,
      );
    }
    return const SizedBox();
  }

  Widget get42() {
    if (widget.user is Customer) {
      return StringField(
        presetText: (widget.user as Customer).country,
        labelText: 'Country',
        callback: (String value) => (widget.user as Customer).country = value,
      );
    }
    return const SizedBox();
  }

  Widget get13() {
    return DropdownField(
      labelText: 'Distance units',
      choices: const ["Kilometers", "Miles"],
      selected: widget.user.preferences?.distance == Length.miles
          ? "Miles"
          : "Kilometers",
      callback: (String value) {
        widget.user.preferences ??= UserPreferences();
        if (value == "Miles") {
          widget.user.preferences!.distance = Length.miles;
        } else {
          widget.user.preferences!.distance = Length.kilometers;
        }
      },
    );
  }

  Widget get23() {
    return DropdownField(
      choices: const ["°C", "°F"],
      labelText: 'Temperature units',
      selected: widget.user.preferences?.temperature == Temperature.fahrenheit
          ? "°F"
          : "°C",
      callback: (String value) {
        widget.user.preferences ??= UserPreferences();
        if (value == "°F") {
          widget.user.preferences!.temperature = Temperature.fahrenheit;
        } else {
          widget.user.preferences!.temperature = Temperature.celsius;
        }
      },
    );
  }

  Widget get33() {
    return DropdownField(
      choices: const [
        "24.07.2021.",
        "24.7.21.",
        "24. Jul, 2021.",
        "07/24/2021",
        "7/24/21",
        "2021-07-24",
      ],
      labelText: 'Date format',
      selected: getDateFormatExample(),
      callback: (String value) {
        widget.user.preferences ??= UserPreferences();
        if (value == "24.07.2021.") {
          widget.user.preferences!.dateFormat = "dd.MM.yyyy.";
        } else if (value == "24.7.21.") {
          widget.user.preferences!.dateFormat = "d.M.yy.";
        } else if (value == "24. Jul, 2021.") {
          widget.user.preferences!.dateFormat = "dd. MMM, yyyy.";
        } else if (value == "07/24/2021") {
          widget.user.preferences!.dateFormat = "MM/dd/yyyy";
        } else if (value == "7/24/21") {
          widget.user.preferences!.dateFormat = "M/d/yy";
        } else {
          widget.user.preferences!.dateFormat = "yyyy-MM-dd";
        }
      },
    );
  }

  Widget get43() {
    return DropdownField(
      choices: const ["English", "German"],
      labelText: 'Language',
      selected: widget.user.preferences?.language == Language.german
          ? "German"
          : "English",
      callback: (String value) {
        widget.user.preferences ??= UserPreferences();
        if (value == "German") {
          widget.user.preferences!.language = Language.german;
        } else {
          widget.user.preferences!.language = Language.english;
        }
      },
    );
  }

  String getDateFormatExample() {
    if (widget.user.preferences?.dateFormat == null) return "2021-07-24";

    if (widget.user.preferences!.dateFormat == "dd.MM.yyyy.") {
      return "24.07.2021.";
    } else if (widget.user.preferences!.dateFormat == "d.M.yy.") {
      return "24.7.21.";
    } else if (widget.user.preferences!.dateFormat == "dd. MMM, yyyy.") {
      return "24. Jul, 2021.";
    } else if (widget.user.preferences!.dateFormat == "MM/dd/yyyy") {
      return "07/24/2021";
    } else if (widget.user.preferences!.dateFormat == "M/d/yy") {
      return "7/24/21";
    } else {
      return "2021-07-24";
    }
  }

  Future<void> saveChanges(double width, double height) async {
    Map<String, dynamic>? userMap = User.toJSON(widget.user);

    if (userMap == null) return;

    bool res = await UserRepository.updateUser(userMap);
    if (!res) {
      final snackBar = SnackBar(
        backgroundColor: PalleteCommon.gradient2,
        content: const Text(
            'There was an error while creating your account. Please try again (later)...'),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: height * 0.85,
          left: width * 0.8,
          right: width * 0.02,
          top: height * 0.02,
        ),
        closeIconColor: PalleteCommon.gradient2,
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    final snackBar = SnackBar(
      content: const Text('Your account has successfully been created!'),
      backgroundColor: (Colors.white),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
        bottom: height * 0.85,
        left: width * 0.8,
        right: width * 0.02,
        top: height * 0.02,
      ),
      closeIconColor: PalleteCommon.gradient2,
      action: SnackBarAction(
        label: 'Dismiss',
        onPressed: () {},
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  dynamic getValue(int index) {
    switch (index) {
      case 0:
        if (widget.user is Individual) {
          return (widget.user as Individual).firstname;
        } else if (widget.user is Company) {
          return (widget.user as Company).ownerFirstname;
        } else {
          return (widget.user as Admin).firstname;
        }
      case 1:
        if (widget.user is Individual) {
          return (widget.user as Individual).lastname;
        } else if (widget.user is Company) {
          return (widget.user as Company).ownerLastname;
        } else {
          return null;
        }
      case 2:
        if (widget.user is Individual) {
          return (widget.user as Individual).birthday;
        } else if (widget.user is Company) {
          return (widget.user as Company).companyName;
        } else {
          return null;
        }
      case 3:
        if (widget.user is Individual) {
          return (widget.user as Individual).phone;
        } else if (widget.user is Company) {
          return (widget.user as Company).phone;
        } else {
          return (widget.user as Admin).phone;
        }
      case 4:
        if (widget.user is Individual) {
          return (widget.user as Individual).street;
        } else if (widget.user is Company) {
          return (widget.user as Company).street;
        } else {
          return null;
        }

      case 5:
        if (widget.user is Individual) {
          return (widget.user as Individual).zip;
        } else if (widget.user is Company) {
          return (widget.user as Company).zip;
        } else {
          return null;
        }
      case 6:
        if (widget.user is Individual) {
          return (widget.user as Individual).city;
        } else if (widget.user is Company) {
          return (widget.user as Company).city;
        } else {
          return null;
        }
      case 7:
        if (widget.user is Individual) {
          return (widget.user as Individual).country;
        } else if (widget.user is Company) {
          return (widget.user as Company).country;
        } else {
          return null;
        }
      case 8:
        if (widget.user is Individual &&
            (widget.user as Individual).preferences != null) {
          return (widget.user as Individual).preferences!.distance;
        } else if (widget.user is Company &&
            (widget.user as Company).preferences != null) {
          return (widget.user as Company).preferences!.distance;
        } else {
          return null;
        }
      case 9:
        if (widget.user is Individual &&
            (widget.user as Individual).preferences != null) {
          return (widget.user as Individual).preferences!.temperature;
        } else if (widget.user is Company &&
            (widget.user as Company).preferences != null) {
          return (widget.user as Company).preferences!.temperature;
        } else {
          return null;
        }
      case 10:
        if (widget.user is Individual &&
            (widget.user as Individual).preferences != null) {
          return (widget.user as Individual).preferences!.dateFormat;
        } else if (widget.user is Company &&
            (widget.user as Company).preferences != null) {
          return (widget.user as Company).preferences!.dateFormat;
        } else {
          return null;
        }
    }
  }

  @override
  void initState() {
    super.initState();

    /*WidgetsBinding.instance.addPostFrameCallback((_) async {
      List<Location> locations =
          await locationFromAddress("Gronausestraat 710, Enschede");
      widget.coordinates =
          LatLng(locations[0].latitude, locations[0].longitude);
      print(widget.coordinates);
    });*/
  }

  @override
  void dispose() {
    super.dispose();
  }

  void emptyFunction() {}
}

enum UserChoice { editImage, changeImage }

class ImagesDisplay extends StatefulWidget {
  User user;
  UserChoice choice = UserChoice.editImage;

  ImagesDisplay({Key? key, required this.user}) : super(key: key);

  @override
  State<ImagesDisplay> createState() => _ImagesDisplayState();
}

class _ImagesDisplayState extends State<ImagesDisplay> {
  late DropzoneViewController dvController;
  bool isHovering = false;
  Uint8List? selectedImage;
  Uint8List? profileImage;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      constraints: BoxConstraints(
        maxHeight: height * 0.6,
        minHeight: height * 0.3,
        maxWidth: width,
        minWidth: width,
      ),
      child: Stack(
        children: [
          backgroundImage(context, widget.user),
          Padding(
            padding: EdgeInsets.fromLTRB(width * 0.12, 0, 0, 0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        showImageOptions(context),
                  ),
                  child: SizedBox(
                    width: 150,
                    height: 150,
                    child: Stack(
                      children: [
                        // User's image
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: getAvatarImage(),
                            ),
                          ),
                        ),
                        // Camera icon
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor:
                                Theme.of(context).scaffoldBackgroundColor,
                            child: Container(
                              margin: const EdgeInsets.all(8.0),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.camera_alt),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ImageProvider<Object> getAvatarImage() {
    if (profileImage != null) {
      return Image.memory(profileImage!).image;
    } else if (widget.user is Individual &&
        (widget.user as Individual).avatarImage.isNotEmpty) {
      return Image.asset((widget.user as Individual).avatarImage).image;
    } else if (widget.user is Company &&
        (widget.user as Company).avatarImage.isNotEmpty) {
      return Image.asset((widget.user as Individual).avatarImage).image;
    } else {
      return Image.asset('images/chick.jpg').image;
    }
  }

  Widget backgroundImage(BuildContext context, User user) {
    if (user is Admin) {
      return Container(
        margin: const EdgeInsets.only(bottom: 50),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Color(0xff0043ba), Color(0xff006df1)]),
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.only(bottom: 50),
        decoration: BoxDecoration(
          image: DecorationImage(
            scale: 0.01,
            fit: BoxFit.fitWidth,
            image: Image(
              fit: BoxFit.fitWidth,
              image: AssetImage(
                  user is Individual && user.backgroundImage.isNotEmpty
                      ? user.backgroundImage
                      : user is Company && user.backgroundImage.isNotEmpty
                          ? user.backgroundImage
                          : "images/background.jpg"),
            ).image,
          ),
        ),
      );
    }
  }

  Widget optionButton(
      double width, double height, Function onPressed, String title) {
    return SizedBox(
      width: width * 0.4,
      height: height * 0.05,
      child: ElevatedButton(
        style: const ButtonStyle(
          backgroundColor:
              MaterialStatePropertyAll(PalleteCommon.backgroundColor),
        ),
        onPressed: () => onPressed(),
        child: Text(
          title,
          style: const TextStyle(
            color: PalleteCommon.gradient2,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget showImageOptions(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Dialog(
      backgroundColor: PalleteCommon.backgroundColor,
      alignment: Alignment.center,
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Container(
            constraints: BoxConstraints(
              maxWidth: width * 0.8,
              maxHeight: height * 0.8,
              minWidth: width * 0.8,
              minHeight: height * 0.8,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                // Header options
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    optionButton(
                      width,
                      height,
                      () => setState(() {
                        widget.choice = UserChoice.editImage;
                      }),
                      "Edit image",
                    ),
                    optionButton(
                      width,
                      height,
                      () => setState(() {
                        widget.choice = UserChoice.changeImage;
                      }),
                      "Change image",
                    ),
                  ],
                ),
                // Body features
                if (widget.choice == UserChoice.editImage)
                  Container(
                    padding: const EdgeInsets.fromLTRB(150, 50, 150, 50),
                    child: InkWell(
                      onTap: () {},
                      onHover: (value) {
                        setState(() {
                          isHovering = value;
                        });
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(6)),
                              border: Border(
                                left: BorderSide(
                                    color: isHovering
                                        ? PalleteCommon.gradient2
                                        : Colors.white),
                                top: BorderSide(
                                    color: isHovering
                                        ? PalleteCommon.gradient2
                                        : Colors.white),
                                right: BorderSide(
                                    color: isHovering
                                        ? PalleteCommon.gradient2
                                        : Colors.white),
                                bottom: BorderSide(
                                    color: isHovering
                                        ? PalleteCommon.gradient2
                                        : Colors.white),
                              ),
                              color: PalleteCommon.backgroundColor,
                            ),
                            width: width * 0.7,
                            height: height * 0.6,
                            child: DropzoneView(
                              mime: const ['image/jpg', 'image/png'],
                              onDropInvalid: declineFile,
                              onDrop: acceptFile,
                              onCreated: (controller) =>
                                  dvController = controller,
                            ),
                          ),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () => showFilePicker(),
                              child: selectedImage == null
                                  ? dropOrBrowseImage()
                                  : manageSelectedImage(width, height),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  const Padding(
                    padding: EdgeInsets.fromLTRB(50, 50, 50, 50),
                    child: Center(
                      child: Text("changeImage"),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget manageSelectedImage(double width, double height) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: width * 0.5,
                minWidth: width * 0.5,
                maxHeight: height * 0.5,
                minHeight: height * 0.5,
              ),
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: Image.memory(
                    selectedImage!,
                  ).image,
                ),
              ),
              /*child: Image.memory(
                                              (await selectedImage!.readAsBytes()),
                                              fit: BoxFit.contain,
                                            ),*/
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                GradientButton(buttonText: 'Anything', callback: () {}),
                const SizedBox(
                  width: 100,
                  height: 20,
                ),
                GradientButton(
                  buttonText: 'Discard image',
                  colors: const [
                    Color.fromARGB(255, 224, 40, 0),
                    Color.fromARGB(255, 255, 91, 46),
                    Color.fromARGB(255, 179, 60, 0),
                  ],
                  callback: () {
                    setState(() {
                      selectedImage = null;
                    });
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget dropOrBrowseImage() {
    return const Column(
      children: [
        Icon(
          Icons.cloud_upload,
          size: 80,
          color: PalleteCommon.gradient2,
        ),
        Text(
          "Drop images here or browse through files",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Future<void> declineFile(dynamic event) async {
    print("Failed (declined)!");
  }

  Future<void> errorFile(dynamic event) async {
    print("Failed (error)!");
  }

  Future<void> acceptFile(dynamic event) async {
    setState(() {
      selectedImage = event;
    });

    /*final name = event.name;
    final mime = await dvController.getFileMIME(event);
    final bytes = await dvController.getFileSize(event);
    final url = await dvController.createFileUrl(event);

    print(event.runtimeType);
    print(name);
    print(mime);
    print(bytes);
    print(url);*/
  }

  Future<void> showFilePicker() async {
    /*if (kIsWeb) {
      print("kIsWeb");
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      print("iOS");
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      print("android");
    }
    if (defaultTargetPlatform == TargetPlatform.linux) {
      print("linux");
    }
    if (defaultTargetPlatform == TargetPlatform.macOS) {
      print("macOS");
    }
    if (defaultTargetPlatform == TargetPlatform.windows) {
      print("windows");
    }
    if (defaultTargetPlatform == TargetPlatform.fuchsia) {
      print("fuchsia");
    }*/

    FilePickerResult? picked = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['jpg', 'png', 'gif'],
    );

    if (picked == null || picked.files.single.bytes == null) return;
    setState(() {
      selectedImage = picked.files.single.bytes;
    });
  }
}
