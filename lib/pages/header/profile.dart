import 'package:diplomski_rad/services/language.dart';
import 'package:diplomski_rad/widgets/images_display_widget.dart';
import 'package:flutter/material.dart';
import 'package:diplomski_rad/widgets/header_widget.dart';
import 'package:diplomski_rad/interfaces/user.dart';
import 'package:diplomski_rad/other/pallete.dart';
import 'package:diplomski_rad/widgets/gradient_button.dart';
import 'package:diplomski_rad/widgets/string_field.dart';
import 'package:diplomski_rad/widgets/calendar_field.dart';
import 'package:diplomski_rad/widgets/dropdown_field.dart';
import 'package:diplomski_rad/services/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:diplomski_rad/services/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  Map<String, dynamic> headerValues = <String, dynamic>{};
  String userId;
  User? user;
  LanguageService? lang;
  bool enableEditing;

  ProfilePage({
    Key? key,
    this.userId = "",
    required this.enableEditing,
  }) : super(key: key);

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
                      semanticsLabel: widget.lang!.translate('loading'),
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
                          showAvatar: true,
                          enableEditing: widget.enableEditing,
                          user: widget.user!,
                          lang: widget.lang!,
                          callback: () {},
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
                                      widget.lang!.translate('save_changes'),
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
                                      .translate('personal_information'),
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
                                  widget.lang!.translate('your_address'),
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
                                  widget.lang!.translate('preferences'),
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
                      semanticsLabel: widget.lang!.translate('loading'),
                      backgroundColor: PalleteCommon.backgroundColor,
                    ),
                    SizedBox(height: height * 0.03),
                    Center(
                      child: Text(widget
                          .lang!.translate('obtaining_user_information')),
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
      SharedPreferencesService sharedPreferencesService = SharedPreferencesService(await SharedPreferences.getInstance());
      String tmpUserId = sharedPreferencesService.getUserId();
      String tmpTypeOfUser = sharedPreferencesService.getTypeOfUser();
      String tmpAvatarImage = sharedPreferencesService.getAvatarImage();
      String tmpLanguage = sharedPreferencesService.getLanguage();

      if (tmpUserId.isEmpty) return;
      if (tmpTypeOfUser.isEmpty) return;
      if (tmpLanguage.isEmpty) return;

      LanguageService tmpLang = LanguageService.getInstance(tmpLanguage);

      setState(() {
        widget.headerValues["userId"] = tmpUserId;
        widget.headerValues["typeOfUser"] = tmpTypeOfUser;
        widget.headerValues["avatarImage"] = tmpAvatarImage;
        widget.userId = widget.userId.isNotEmpty ? widget.userId : tmpUserId;
        widget.lang = tmpLang;
      });
    });
  }

  Widget get11() {
    if (widget.user is Individual) {
      return StringField(
        presetText: (widget.user as Individual).firstname,
        labelText: widget.lang!.translate('firstname'),
        callback: (String value) =>
            (widget.user as Individual).firstname = value,
      );
    } else if (widget.user is Company) {
      return StringField(
        presetText: (widget.user as Company).ownerFirstname,
        labelText: widget.lang!.translate('owner_firstname'),
        callback: (String value) =>
            (widget.user as Company).ownerFirstname = value,
      );
    } else if (widget.user is Admin) {
      return StringField(
        presetText: (widget.user as Admin).firstname,
        labelText: widget.lang!.translate('firstname'),
        callback: (String value) => (widget.user as Admin).firstname = value,
      );
    }
    return const SizedBox();
  }

  Widget get21() {
    if (widget.user is Individual) {
      return StringField(
        presetText: (widget.user as Individual).lastname,
        labelText: widget.lang!.translate('lastname'),
        callback: (String value) =>
            (widget.user as Individual).lastname = value,
      );
    } else if (widget.user is Company) {
      return StringField(
        presetText: (widget.user as Company).ownerLastname,
        labelText: widget.lang!.translate('owner_lastname'),
        callback: (String value) =>
            (widget.user as Company).ownerLastname = value,
      );
    }
    return const SizedBox();
  }

  Widget get31() {
    if (widget.user is Individual) {
      return CalendarField(
        selectingBirthday: true,
        dateFormat: widget.user!.preferences.dateFormat,
        selectedDate: (widget.user as Individual).birthday,
        labelText: widget.lang!.translate('date_of_birth'),
        callback: (DateTime value) =>
            (widget.user as Individual).birthday = value,
        lang: widget.lang!,
      );
    } else if (widget.user is Company) {
      return StringField(
        presetText: (widget.user as Company).companyName,
        labelText: widget.lang!.translate('company_name'),
        callback: (String value) =>
            (widget.user as Company).companyName = value,
      );
    }
    return const SizedBox();
  }

  Widget get41() {
    return StringField(
      presetText: widget.user!.phone,
      labelText: widget.lang!.translate('phone_number'),
      callback: (String value) => widget.user!.phone = value,
    );
  }

  Widget get12() {
    if (widget.user is Customer) {
      return StringField(
        presetText: (widget.user as Customer).street,
        labelText: widget.lang!.translate('street'),
        callback: (String value) => (widget.user as Customer).street = value,
      );
    }
    return const SizedBox();
  }

  Widget get22() {
    if (widget.user is Customer) {
      return StringField(
        presetText: (widget.user as Customer).zip,
        labelText: widget.lang!.translate('zip'),
        callback: (String value) => (widget.user as Customer).zip = value,
      );
    }
    return const SizedBox();
  }

  Widget get32() {
    if (widget.user is Customer) {
      return StringField(
        presetText: (widget.user as Customer).city,
        labelText: widget.lang!.translate('city'),
        callback: (String value) => (widget.user as Customer).city = value,
      );
    }
    return const SizedBox();
  }

  Widget get42() {
    if (widget.user is Customer) {
      return StringField(
        presetText: (widget.user as Customer).country,
        labelText: widget.lang!.translate('country'),
        callback: (String value) => (widget.user as Customer).country = value,
      );
    }
    return const SizedBox();
  }

  Widget get13() {
    return DropdownField(
      labelText: widget.lang!.translate('distance_units'),
      choices: [
        widget.lang!.translate('km'),
        widget.lang!.translate('mi'),
      ],
      selected: widget.user!.preferences.distance == "mi"
          ? widget.lang!.translate('mi')
          : widget.lang!.translate('km'),
      callback: (String value) {
        if (value == widget.lang!.translate('mi')) {
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
      labelText: widget.lang!.translate('temperature_units'),
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
      labelText: widget.lang!.translate('date_formats'),
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
        widget.lang!.translate('en'),
        widget.lang!.translate('de'),
      ],
      labelText: widget.lang!.translate('language'),
      selected: widget.user!.preferences.language == "de"
          ? widget.lang!.translate('de')
          : widget.lang!.translate('en'),
      callback: (String value) async {
        if (value == widget.lang!.translate('de')) {
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

    bool res = await UserRepository.updateUser(widget.user!.id, userMap);
    if (res) {
      SharedPreferencesService sharedPreferencesService = SharedPreferencesService(await SharedPreferences.getInstance());
      await sharedPreferencesService.setLanguage(widget.user!.preferences.language);
      await sharedPreferencesService.setAvatarImage(widget.user is Customer ? (widget.user as Customer).avatarImage : "");
      await sharedPreferencesService.setTemperaturePreference(widget.user is Customer ? (widget.user as Customer).preferences.temperature : "");

      LanguageService tmpLang = LanguageService.getInstance(widget.user!.preferences.language);

      setState(() {
        widget.lang = tmpLang;
      });

      final snackBar = SnackBar(
        content: Text(widget.lang!.translate('account_successfully_updated')),
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
          label: widget.lang!.translate('dismiss'),
          onPressed: () {},
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    final snackBar = SnackBar(
      backgroundColor: PalleteCommon.gradient2,
      content: Text(widget.lang!.translate('error_while_updating_user')),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
        bottom: height * 0.85,
        left: width * 0.8,
        right: width * 0.02,
        top: height * 0.02,
      ),
      closeIconColor: PalleteCommon.gradient2,
      action: SnackBarAction(
        label: widget.lang!.translate('dismiss'),
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
