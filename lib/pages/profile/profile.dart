import 'dart:typed_data';

import 'package:diplomski_rad/services/language.dart';
import 'package:diplomski_rad/widgets/dropzone_widget.dart';
import 'package:diplomski_rad/widgets/image_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:diplomski_rad/components/header.dart';
import 'package:diplomski_rad/interfaces/user/user.dart';
import 'package:diplomski_rad/other/pallete.dart';
import 'package:diplomski_rad/widgets/gradient_button.dart';
import 'package:diplomski_rad/widgets/string_field.dart';
import 'package:diplomski_rad/widgets/calendar_field.dart';
import 'package:diplomski_rad/widgets/dropdown_field.dart';
import 'package:diplomski_rad/services/firebase.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  Map<String, dynamic> headerValues = <String, dynamic>{};
  String userId;
  User? user;
  LanguageService? lang;

  ProfilePage({Key? key, this.userId = ""}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    if (widget.lang == null || widget.userId.isEmpty) {
      return const SizedBox();
    }

    return Scaffold(
      appBar: HeaderComponent(
        currentPage: 'ProfilePage',
        lang: widget.lang!,
        headerValues: widget.headerValues,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: widget.userId.isNotEmpty
            ? StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.userId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(
                      color: PalleteCommon.gradient2,
                      semanticsLabel: widget.lang!.dictionary["loading"],
                      backgroundColor: PalleteCommon.backgroundColor,
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final document = snapshot.data;
                    if (document == null) {
                      return Text('Error: ${snapshot.error}');
                    }

                    Map<String, dynamic>? userMap = document.data();
                    if (userMap == null) {
                      return Text('Error: ${snapshot.error}');
                    }

                    userMap["id"] = document.id;
                    User? tmp = User.toUser(userMap);

                    if (tmp == null) {
                      return const Text("Error while converting data!");
                    }
                    widget.user = tmp;

                    return Column(
                      children: [
                        ImagesDisplay(
                          user: widget.user!,
                          lang: widget.lang!,
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(width * 0.2, 0, 0, 0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  widget.user!.email,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22),
                                ),
                              ),
                              const Expanded(flex: 3, child: SizedBox()),
                              Expanded(
                                flex: 2,
                                child: GradientButton(
                                  buttonText:
                                      widget.lang!.dictionary["save_changes"]!,
                                  callback: () {
                                    saveChanges(width, height);
                                  },
                                  colors: PalleteSuccess.getGradients(),
                                ),
                              ),
                              const Expanded(flex: 1, child: SizedBox()),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: width,
                          height: height * 0.1,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Center(
                                child: Text(
                                  widget.lang!
                                      .dictionary["personal_information"]!,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  widget.lang!.dictionary["your_address"]!,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  widget.lang!.dictionary["preferences"]!,
                                  style: const TextStyle(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
              )
            : Padding(
                padding: EdgeInsets.fromLTRB(0, height * 0.42, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: PalleteCommon.gradient2,
                      semanticsLabel: widget.lang!.dictionary["loading"],
                      backgroundColor: PalleteCommon.backgroundColor,
                    ),
                    SizedBox(height: height * 0.03),
                    Center(
                      child: Text(widget
                          .lang!.dictionary["obtaining_user_information"]!),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? tmpUserId = prefs.getString("userId");
      String? tmpTypeOfUser = prefs.getString("typeOfUser");
      String? tmpAvatarImage = prefs.getString("avatarImage");
      String? tmpLanguage = prefs.getString("language");

      if (tmpUserId == null || tmpUserId.isEmpty) return;
      if (tmpTypeOfUser == null || tmpTypeOfUser.isEmpty) return;
      if (tmpLanguage == null || tmpLanguage.isEmpty) return;

      LanguageService tmpLang = LanguageService.getInstance(tmpLanguage);

      setState(() {
        widget.headerValues["userId"] = tmpUserId;
        widget.headerValues["typeOfUser"] = tmpTypeOfUser;
        widget.headerValues["avatarImage"] = tmpAvatarImage ?? "";
        widget.userId = widget.userId.isNotEmpty ? widget.userId : tmpUserId;
        widget.lang = tmpLang;
      });
    });
  }

  Widget get11() {
    if (widget.user is Individual) {
      return StringField(
        presetText: (widget.user as Individual).firstname,
        labelText: widget.lang!.dictionary["firstname"]!,
        callback: (String value) =>
            (widget.user as Individual).firstname = value,
      );
    } else if (widget.user is Company) {
      return StringField(
        presetText: (widget.user as Company).ownerFirstname,
        labelText: widget.lang!.dictionary["owner_firstname"]!,
        callback: (String value) =>
            (widget.user as Company).ownerFirstname = value,
      );
    } else if (widget.user is Admin) {
      return StringField(
        presetText: (widget.user as Admin).firstname,
        labelText: widget.lang!.dictionary["firstname"]!,
        callback: (String value) => (widget.user as Admin).firstname = value,
      );
    }
    return const SizedBox();
  }

  Widget get21() {
    if (widget.user is Individual) {
      return StringField(
        presetText: (widget.user as Individual).lastname,
        labelText: widget.lang!.dictionary["lastname"]!,
        callback: (String value) =>
            (widget.user as Individual).lastname = value,
      );
    } else if (widget.user is Company) {
      return StringField(
        presetText: (widget.user as Company).ownerLastname,
        labelText: widget.lang!.dictionary["owner_lastname"]!,
        callback: (String value) =>
            (widget.user as Company).ownerLastname = value,
      );
    }
    return const SizedBox();
  }

  Widget get31() {
    if (widget.user is Individual) {
      return CalendarField(
        dateFormat: widget.user!.preferences.dateFormat,
        selectedDate: (widget.user as Individual).birthday,
        labelText: widget.lang!.dictionary["date_of_birth"]!,
        callback: (DateTime value) =>
            (widget.user as Individual).birthday = value,
      );
    } else if (widget.user is Company) {
      return StringField(
        presetText: (widget.user as Company).companyName,
        labelText: widget.lang!.dictionary["company_name"]!,
        callback: (String value) =>
            (widget.user as Company).companyName = value,
      );
    }
    return const SizedBox();
  }

  Widget get41() {
    return StringField(
      presetText: widget.user!.phone,
      labelText: widget.lang!.dictionary["phone_number"]!,
      callback: (String value) => widget.user!.phone = value,
    );
  }

  Widget get12() {
    if (widget.user is Customer) {
      return StringField(
        presetText: (widget.user as Customer).street,
        labelText: widget.lang!.dictionary["street"]!,
        callback: (String value) => (widget.user as Customer).street = value,
      );
    }
    return const SizedBox();
  }

  Widget get22() {
    if (widget.user is Customer) {
      return StringField(
        presetText: (widget.user as Customer).zip,
        labelText: widget.lang!.dictionary["zip"]!,
        callback: (String value) => (widget.user as Customer).zip = value,
      );
    }
    return const SizedBox();
  }

  Widget get32() {
    if (widget.user is Customer) {
      return StringField(
        presetText: (widget.user as Customer).city,
        labelText: widget.lang!.dictionary["city"]!,
        callback: (String value) => (widget.user as Customer).city = value,
      );
    }
    return const SizedBox();
  }

  Widget get42() {
    if (widget.user is Customer) {
      return StringField(
        presetText: (widget.user as Customer).country,
        labelText: widget.lang!.dictionary["country"]!,
        callback: (String value) => (widget.user as Customer).country = value,
      );
    }
    return const SizedBox();
  }

  Widget get13() {
    return DropdownField(
      labelText: widget.lang!.dictionary["distance_units"]!,
      choices: [
        widget.lang!.dictionary["km"],
        widget.lang!.dictionary["mi"],
      ],
      selected: widget.user!.preferences.distance == "mi"
          ? widget.lang!.dictionary["mi"]
          : widget.lang!.dictionary["km"],
      callback: (String value) {
        if (value == widget.lang!.dictionary["mi"]) {
          widget.user!.preferences.distance = "mi";
        } else {
          widget.user!.preferences.distance = "km";
        }
      },
    );
  }

  Widget get23() {
    return DropdownField(
      choices: const ["°C", "°F"],
      labelText: widget.lang!.dictionary["temperature_units"]!,
      selected: widget.user!.preferences.temperature == "F" ? "°F" : "°C",
      callback: (String value) {
        if (value == "°F") {
          widget.user!.preferences.temperature = "F";
        } else {
          widget.user!.preferences.temperature = "C";
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
      labelText: widget.lang!.dictionary["date_formats"]!,
      selected: getDateFormatExample(),
      callback: (String value) async {
        if (value == "24.07.2021.") {
          widget.user!.preferences.dateFormat = "dd.MM.yyyy.";
        } else if (value == "24.7.21.") {
          widget.user!.preferences.dateFormat = "d.M.yy.";
        } else if (value == "24. Jul, 2021.") {
          widget.user!.preferences.dateFormat = "dd. MMM, yyyy.";
        } else if (value == "07/24/2021") {
          widget.user!.preferences.dateFormat = "MM/dd/yyyy";
        } else if (value == "7/24/21") {
          widget.user!.preferences.dateFormat = "M/d/yy";
        } else {
          widget.user!.preferences.dateFormat = "yyyy-MM-dd";
        }
      },
    );
  }

  Widget get43() {
    return DropdownField(
      choices: [
        widget.lang!.dictionary["en"],
        widget.lang!.dictionary["de"],
      ],
      labelText: widget.lang!.dictionary["language"]!,
      selected: widget.user!.preferences.language == "de"
          ? widget.lang!.dictionary["de"]
          : widget.lang!.dictionary["en"],
      callback: (String value) async {
        if (value == widget.lang!.dictionary["de"]) {
          widget.user!.preferences.language = "de";
        } else {
          widget.user!.preferences.language = "en";
        }
      },
    );
  }

  String getDateFormatExample() {
    if (widget.user!.preferences.dateFormat == "dd.MM.yyyy.") {
      return "24.07.2021.";
    } else if (widget.user!.preferences.dateFormat == "d.M.yy.") {
      return "24.7.21.";
    } else if (widget.user!.preferences.dateFormat == "dd. MMM, yyyy.") {
      return "24. Jul, 2021.";
    } else if (widget.user!.preferences.dateFormat == "MM/dd/yyyy") {
      return "07/24/2021";
    } else if (widget.user!.preferences.dateFormat == "M/d/yy") {
      return "7/24/21";
    } else {
      return "2021-07-24";
    }
  }

  Future<void> saveChanges(double width, double height) async {
    Map<String, dynamic>? userMap = User.toJSON(widget.user);

    if (userMap == null) return;

    bool res = await UserRepository.updateUser(userMap);
    if (res) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("language", widget.user!.preferences.language);
      await prefs.setString(
        "avatarImage",
        widget.user is Customer ? (widget.user as Customer).avatarImage : "",
      );

      LanguageService tmpLang =
          LanguageService.getInstance(widget.user!.preferences.language);

      setState(() {
        widget.lang = tmpLang;
      });

      final snackBar = SnackBar(
        content: Text(widget.lang!.dictionary["account_successfully_updated"]!),
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
          label: widget.lang!.dictionary["dismiss"]!,
          onPressed: () {},
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    final snackBar = SnackBar(
      backgroundColor: PalleteCommon.gradient2,
      content: Text(widget.lang!.dictionary["error_while_updating_user"]!),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
        bottom: height * 0.85,
        left: width * 0.8,
        right: width * 0.02,
        top: height * 0.02,
      ),
      closeIconColor: PalleteCommon.gradient2,
      action: SnackBarAction(
        label: widget.lang!.dictionary["dismiss"]!,
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

enum UserChoice { profilePicture, backgroundPicture }

class ImagesDisplay extends StatefulWidget {
  User user;
  LanguageService lang;
  UserChoice choice = UserChoice.profilePicture;
  String droppedFileName = "";
  Uint8List? droppedFileBytes;

  ImagesDisplay({
    Key? key,
    required this.user,
    required this.lang,
  }) : super(key: key);

  @override
  State<ImagesDisplay> createState() => _ImagesDisplayState();
}

class _ImagesDisplayState extends State<ImagesDisplay> {
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
                        showImagesDialog(context),
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
                              image: widget.user is Customer &&
                                      (widget.user as Customer)
                                          .avatarImage
                                          .isNotEmpty
                                  ? Image.network(
                                      (widget.user as Customer).avatarImage,
                                    ).image
                                  : Image.asset('images/default_user.png')
                                      .image,
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

  Widget backgroundImage(BuildContext context, User user) {
    if (user is Admin ||
        widget.user is Customer &&
            (widget.user as Customer).backgroundImage.isEmpty) {
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
            image:
                Image.network((widget.user as Customer).backgroundImage).image,
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

  Widget showImagesDialog(BuildContext context) {
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
                        widget.choice = UserChoice.profilePicture;
                      }),
                      widget.lang.dictionary["profile_image"]!,
                    ),
                    optionButton(
                      width,
                      height,
                      () => setState(() {
                        widget.choice = UserChoice.backgroundPicture;
                      }),
                      widget.lang.dictionary["background_image"]!,
                    ),
                  ],
                ),
                SizedBox(height: height * 0.05),
                // Body features
                if (widget.choice == UserChoice.profilePicture)
                  if (widget.droppedFileBytes == null)
                    DropzoneWidget(
                      lang: widget.lang,
                      onDroppedFile: (Map<String, dynamic>? file) {
                        if (file == null) return;

                        setState(() {
                          widget.droppedFileName = file['name'];
                          widget.droppedFileBytes = file['bytes'];
                        });
                      },
                    )
                  /*ImagePickerWidget(
                      onDroppedFile: (File? file) {
                        setState(() {
                          widget.droppedFile = file;
                        });
                      },
                    )*/
                  else
                    Row(
                      children: [
                        Container(
                          width: width * 0.5,
                          height: height * 0.5,
                          margin: const EdgeInsets.all(8.0),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          // child: Image.network(widget.droppedFile!.path),
                          child: Image.memory(widget.droppedFileBytes!),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            optionSaveImage(width, height),
                            SizedBox(height: height * 0.08),
                            optionDiscardImage(width, height),
                            SizedBox(height: height * 0.08),
                            optionCancel(width, height),
                          ],
                        ),
                      ],
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

  Widget optionSaveImage(double width, double height) {
    return ElevatedButton(
      style: ButtonStyle(
        minimumSize: MaterialStatePropertyAll(
          Size(width * 0.25, height * 0.08),
        ),
        maximumSize: MaterialStatePropertyAll(
          Size(width * 0.25, height * 0.4),
        ),
        backgroundColor: const MaterialStatePropertyAll(
          Color.fromARGB(125, 85, 85, 85),
        ),
      ),
      onPressed: () async {
        if (widget.droppedFileBytes == null) return;
        FirebaseStorageService storage = FirebaseStorageService();
        storage.uploadFile(
            widget.user.id, widget.droppedFileName, widget.droppedFileBytes!);
        Navigator.pop(context);
      },
      child: Text(widget.lang.dictionary["save_image"]!),
    );
  }

  Widget optionDiscardImage(double width, double height) {
    return ElevatedButton(
      style: ButtonStyle(
        minimumSize: MaterialStatePropertyAll(
          Size(width * 0.25, height * 0.08),
        ),
        maximumSize: MaterialStatePropertyAll(
          Size(width * 0.25, height * 0.4),
        ),
        backgroundColor: const MaterialStatePropertyAll(
          Color.fromARGB(125, 85, 85, 85),
        ),
      ),
      onPressed: () {
        setState(() {
          widget.droppedFileBytes = null;
          widget.droppedFileName = '';
        });
      },
      child: Text(widget.lang.dictionary["discard_image"]!),
    );
  }

  Widget optionCancel(double width, double height) {
    return ElevatedButton(
      style: ButtonStyle(
        minimumSize: MaterialStatePropertyAll(
          Size(width * 0.25, height * 0.08),
        ),
        maximumSize: MaterialStatePropertyAll(
          Size(width * 0.25, height * 0.4),
        ),
        backgroundColor: const MaterialStatePropertyAll(
          Color.fromARGB(125, 85, 85, 85),
        ),
      ),
      onPressed: () {
        setState(() {
          widget.droppedFileBytes = null;
          widget.droppedFileName = '';
        });
        Navigator.pop(context);
      },
      child: Text(widget.lang.dictionary["cancel"]!),
    );
  }
}
