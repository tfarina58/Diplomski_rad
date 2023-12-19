import 'dart:html';

import 'package:diplomski_rad/components/header.dart';
import 'package:diplomski_rad/services/firebase.dart';
import 'package:diplomski_rad/widgets/dropdown_field.dart';
import 'package:flutter/material.dart';
import 'package:diplomski_rad/widgets/string_field.dart';
import 'package:diplomski_rad/widgets/gradient_button.dart';
import 'package:diplomski_rad/interfaces/estate/estate.dart';
import 'package:diplomski_rad/interfaces/user/user.dart';
import 'package:diplomski_rad/pages/estates/estate-details/manage-presentation/manage-presentation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:diplomski_rad/services/language.dart';
import 'package:diplomski_rad/other/pallete.dart';
import 'package:diplomski_rad/widgets/images_display_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EstateDetailsPage extends StatefulWidget {
  String? userId;
  Estate estate;
  bool isNew;
  LanguageService? lang;
  Map<String, dynamic> headerValues = <String, dynamic>{};

  EstateDetailsPage({
    Key? key,
    required this.estate,
    this.isNew = false,
  }) : super(key: key);

  @override
  State<EstateDetailsPage> createState() => _EstateDetailsPageState();
}

class _EstateDetailsPageState extends State<EstateDetailsPage> {
  // bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    if (widget.lang == null || widget.userId == null) {
      return const SizedBox();
    }

    print(widget.estate.id);
    return Scaffold(
      appBar: HeaderComponent(
        currentPage: 'EstateDetailsPage',
        lang: widget.lang!,
        headerValues: widget.headerValues,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: widget.estate.id.isEmpty
            ? displayBody(width, height)
            : StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('estates')
                    .doc(widget.estate.id)
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
                    final estateMap = snapshot.data?.data();
                    if (estateMap == null)
                      return Text('Error: ${snapshot.error}');
                    estateMap['id'] = snapshot.data!.id;

                    Estate? estate = Estate.toEstate(estateMap);
                    if (estate == null) {
                      return const Text('Error: Can\'t proccess data!');
                    }

                    widget.estate = estate;
                    return displayBody(width, height);
                  }
                },
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
        widget.userId = tmpUserId;
        widget.lang = tmpLang;
        widget.headerValues["userId"] = tmpUserId;
        widget.headerValues["typeOfUser"] = tmpTypeOfUser;
        widget.headerValues["avatarImage"] = tmpAvatarImage ?? "";
      });
    });
  }

  Widget displayBody(double width, double height) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ImagesDisplay(
                estate: widget.estate,
                lang: widget.lang!,
                showAvatar: false,
                enableEditing: !widget.isNew),
            SizedBox(
              width: width,
              height: height * 0.1,
            ),
            ...generalInformation(height),
            SizedBox(
              width: width,
              height: height * 0.08,
            ),
            ...additionalInformation(height),
            SizedBox(
              height: height * 0.08,
            ),
            optionButtons(width, height),
            const SizedBox(
              height: 65,
            ),
          ],
        ),
      ),
    );
  }

  Widget optionButtons(double width, double height) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Expanded(child: SizedBox()),
        Expanded(
          flex: 3,
          child: widget.isNew
              ? GradientButton(
                  buttonText: widget.lang!.dictionary["create_estate"]!,
                  callback: createEstate,
                )
              : GradientButton(
                  buttonText: widget.lang!.dictionary["save_changes"]!,
                  callback: updateEstate,
                ),
        ),
        const Expanded(
          flex: 2,
          child: SizedBox(),
        ),
        Expanded(
          flex: 3,
          child: GradientButton(
            buttonText: widget.lang!.dictionary["edit_presentation"]!,
            callback: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ManagePresentationPage(
                  estate: widget.estate,
                ),
              ),
            ),
          ),
        ),
        if (!widget.isNew)
          const Expanded(
            flex: 2,
            child: SizedBox(),
          ),
        if (!widget.isNew)
          Expanded(
            flex: 3,
            child: GradientButton(
              buttonText: widget.lang!.dictionary["delete_estate"]!,
              callback: () => showDialog(
                context: context,
                builder: (BuildContext context) =>
                    showDeleteAlert(width, height),
              ),
            ),
          ),
        const Expanded(child: SizedBox()),
      ],
    );
  }

  List<Widget> generalInformation(double height) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Text(
                widget.lang!.dictionary["general_information"]!,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const Expanded(
            flex: 2,
            child: SizedBox(),
          ),
        ],
      ),
      SizedBox(
        height: height * 0.04,
      ),
      Row(
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  StringField(
                    labelText: widget.lang!.dictionary["name"]!,
                    callback: (value) => widget.estate.name = value,
                    presetText: widget.estate.name,
                  ),
                  const SizedBox(height: 15),
                  StringField(
                    labelText: widget.lang!.dictionary["street"]!,
                    callback: (value) => widget.estate.street = value,
                    presetText: widget.estate.street,
                  ),
                  const SizedBox(height: 15),
                  StringField(
                    labelText: widget.lang!.dictionary["zip"]!,
                    callback: (value) => widget.estate.zip = value,
                    presetText: widget.estate.zip,
                  ),
                  const SizedBox(height: 15),
                  /*const SizedBox(height: 30),
                              widget.isNew
                                  ? GradientButton(
                                      buttonText: widget
                                          .lang!.dictionary["create_estate"]!,
                                      callback: createEstate,
                                    )
                                  : GradientButton(
                                      buttonText: widget
                                          .lang!.dictionary["save_changes"]!,
                                      callback: saveChanges,
                                    ),*/
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Column(
                children: [
                  StringField(
                    labelText: widget.lang!.dictionary["phone_number"]!,
                    callback: (value) => widget.estate.phone = value,
                    presetText: widget.estate.phone,
                  ),
                  const SizedBox(height: 15),
                  StringField(
                    labelText: widget.lang!.dictionary["city"]!,
                    callback: (value) => widget.estate.city = value,
                    presetText: widget.estate.city,
                  ),
                  const SizedBox(height: 15),
                  StringField(
                    labelText: widget.lang!.dictionary["country"]!,
                    callback: (value) => widget.estate.country = value,
                    presetText: widget.estate.country,
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ],
      )
    ];
  }

  List<Widget> additionalInformation(double height) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Text(
                widget.lang!.dictionary["additional_information"]!,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const Expanded(
            flex: 2,
            child: SizedBox(),
          ),
        ],
      ),
      SizedBox(
        height: height * 0.04,
      ),
      Row(
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  StringField(
                    labelText: widget.lang!.dictionary["name"]!,
                    callback: (value) => widget.estate.name = value,
                    presetText: widget.estate.name,
                  ),
                  const SizedBox(height: 15),
                  StringField(
                    labelText: widget.lang!.dictionary["street"]!,
                    callback: (value) => widget.estate.street = value,
                    presetText: widget.estate.street,
                  ),
                  const SizedBox(height: 15),
                  StringField(
                    labelText: widget.lang!.dictionary["zip"]!,
                    callback: (value) => widget.estate.zip = value,
                    presetText: widget.estate.zip,
                  ),
                  const SizedBox(height: 15),
                  /*const SizedBox(height: 30),
                              widget.isNew
                                  ? GradientButton(
                                      buttonText: widget
                                          .lang!.dictionary["create_estate"]!,
                                      callback: createEstate,
                                    )
                                  : GradientButton(
                                      buttonText: widget
                                          .lang!.dictionary["save_changes"]!,
                                      callback: saveChanges,
                                    ),*/
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Column(
                children: [
                  StringField(
                    labelText: widget.lang!.dictionary["phone_number"]!,
                    callback: (value) => widget.estate.phone = value,
                    presetText: widget.estate.phone,
                  ),
                  const SizedBox(height: 15),
                  StringField(
                    labelText: widget.lang!.dictionary["city"]!,
                    callback: (value) => widget.estate.city = value,
                    presetText: widget.estate.city,
                  ),
                  const SizedBox(height: 15),
                  StringField(
                    labelText: widget.lang!.dictionary["country"]!,
                    callback: (value) => widget.estate.country = value,
                    presetText: widget.estate.country,
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ],
      )
    ];
  }

  Widget backgroundImageDisplay(BuildContext context) {
    if (widget.estate.images.isEmpty || widget.estate.images[0].isEmpty) {
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
            image: Image.network(widget.estate.images[0]).image,
          ),
        ),
      );
    }
  }

  Widget cameraIconDisplay(bool avatarImage) {
    if (avatarImage) {
      return Positioned(
        bottom: 0,
        right: 0,
        child: CircleAvatar(
          radius: 20,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          child: Container(
            margin: const EdgeInsets.all(8.0),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.camera_alt),
          ),
        ),
      );
    } else {
      return Positioned(
        bottom: 60,
        right: 15,
        child: CircleAvatar(
          radius: 20,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          child: Container(
            margin: const EdgeInsets.all(8.0),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.camera_alt),
          ),
        ),
      );
    }
  }

  List<Widget> getImages(double width) {
    List<Widget> res = [];

    if (widget.estate.images.isNotEmpty) {
      for (int i = 0; i < widget.estate.images.length && i < 3; ++i) {
        res.add(
          Padding(
            padding: EdgeInsets.fromLTRB(
                i * 100 + 100, 300 - i * 100, 300 - i * 100, i * 100 + 100),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(16),
              ),
              child: Hero(
                tag: widget.estate.images[widget.estate.images.length > 3
                    ? 2 - i
                    : widget.estate.images.length - 1 - i],
                child: Image(
                  width: width,
                  height: width * 0.5625,
                  image: NetworkImage(
                    widget.estate.images[widget.estate.images.length > 3
                        ? 2 - i
                        : widget.estate.images.length - 1 - i],
                  ),
                ),
              ),
            ),
          ),
        );
      }
      return res;
    }

    for (int i = 0; i < widget.estate.images.length && i < 3; ++i) {
      res.add(
        Padding(
          padding: EdgeInsets.fromLTRB(
              i * 100 + 100, 300 - i * 100, 300 - i * 100, i * 100 + 100),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(16),
            ),
            child: Hero(
              tag: widget.estate.images[widget.estate.images.length > 3
                  ? 2 - i
                  : widget.estate.images.length - 1 - i],
              child: Image(
                width: width,
                height: width * 0.5625,
                image: AssetImage(
                  widget.estate.images[widget.estate.images.length > 3
                      ? 2 - i
                      : widget.estate.images.length - 1 - i],
                ),
              ),
            ),
          ),
        ),
      );
    }
    return res;
  }

  bool checkMandatoryData() {
    return widget.estate.street.isNotEmpty &&
        widget.estate.zip.isNotEmpty &&
        widget.estate.city.isNotEmpty &&
        widget.estate.country.isNotEmpty &&
        widget.estate.name.isNotEmpty;
  }

  void createEstate(/*double width, double height*/) async {
    if (!checkMandatoryData()) return;

    Map<String, dynamic>? estateMap = Estate.toJSON(widget.estate);
    if (estateMap == null) return;

    estateMap["ownerId"] = widget.userId;

    Estate? res = await EstateRepository.createEstate(estateMap);
    if (res == null) {}

    setState(() {
      widget.estate = res!;
      widget.isNew = false;
    });

    // TODO: process data
  }

  void updateEstate(/*double width, double height*/) async {
    if (!checkMandatoryData()) return;

    Map<String, dynamic>? estateMap = Estate.toJSON(widget.estate);
    if (estateMap == null) return null;

    bool res = await EstateRepository.updateEstate(estateMap, widget.estate.id);

    /*if (!res) {
      final snackBar = SnackBar(
        content: const Text(
            'There was an error while updating your estate. Please try again (later)...'),
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

    final snackBar = SnackBar(
      content: const Text('Your estate has been updated successfully!'),
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
    ScaffoldMessenger.of(context).showSnackBar(snackBar);*/

    // TODO: process data
  }

  void deleteEstate(/*double width, double height*/) async {
    if (widget.estate.id.isEmpty) return;

    bool res = await EstateRepository.deleteEstate(widget.estate.id);

    if (res) {
      Navigator.pop(context);
      Navigator.pop(context);
    }

    /*if (!res) {
      final snackBar = SnackBar(
        content: const Text(
            'There was an error while updating your estate. Please try again (later)...'),
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

    final snackBar = SnackBar(
      content: const Text('Your estate has been updated successfully!'),
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
    ScaffoldMessenger.of(context).showSnackBar(snackBar);*/

    // TODO: process data
  }

  Widget showDeleteAlert(double width, double height) {
    return Dialog(
      insetPadding: EdgeInsets.fromLTRB(
        width * 0.28,
        height * 0.3,
        width * 0.28,
        height * 0.3,
      ),
      backgroundColor: PalleteCommon.backgroundColor,
      alignment: Alignment.center,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Expanded(flex: 2, child: SizedBox()),
            Expanded(
              flex: 2,
              child: Text(
                widget.lang!.dictionary["delete_estate_warning_message"]!,
                style: const TextStyle(
                  fontSize: 18,
                  color: PalleteCommon.gradient2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Expanded(flex: 2, child: SizedBox()),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Expanded(
                    flex: 2,
                    child: SizedBox(),
                  ),
                  Expanded(
                    flex: 3,
                    child: GradientButton(
                      colors: PalleteDanger.getGradients(),
                      buttonText: widget.lang!.dictionary["delete_estate"]!,
                      callback: () => deleteEstate(),
                    ),
                  ),
                  const Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),
                  Expanded(
                    flex: 3,
                    child: GradientButton(
                      buttonText: widget.lang!.dictionary["cancel"]!,
                      callback: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const Expanded(
                    flex: 2,
                    child: SizedBox(),
                  ),
                ],
              ),
            ),
            const Expanded(flex: 1, child: SizedBox()),
          ],
        ),
      ),
    );
  }
}
