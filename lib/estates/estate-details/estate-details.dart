import 'package:diplomski_rad/components/header.dart';
import 'package:diplomski_rad/services/firebase.dart';
import 'package:diplomski_rad/widgets/dropdown_field.dart';
import 'package:flutter/material.dart';
import 'package:diplomski_rad/widgets/string_field.dart';
import 'package:diplomski_rad/widgets/gradient_button.dart';
import 'package:diplomski_rad/interfaces/estate/estate.dart';
import 'package:diplomski_rad/estates/estate-details/manage-presentation/manage-presentation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:diplomski_rad/services/language.dart';

class EstateDetailsPage extends StatefulWidget {
  Estate estate;
  bool isNew;
  String? userId;
  LanguageService? lang;
  Map<String, dynamic> headerValues = <String, dynamic>{};

  EstateDetailsPage({Key? key, required this.estate, this.isNew = false})
      : super(key: key);

  @override
  State<EstateDetailsPage> createState() => _EstateDetailsPageState();
}

class _EstateDetailsPageState extends State<EstateDetailsPage> {
  // bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    // final double width = MediaQuery.of(context).size.width;

    print("Estate smoking: ${widget.estate.preferences}");

    if (widget.lang == null || widget.userId == null) {
      return const SizedBox();
    }

    return Scaffold(
      appBar: HeaderComponent(
        currentPage: 'EstateDetailsPage',
        lang: widget.lang!,
        headerValues: widget.headerValues,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(32.0),
          child: Row(
            children: [
              /*Expanded(
                flex: 3,
                child: MouseRegion(
                  onEnter: (event) => setState(() {
                    isHovering = true;
                  }),
                  onExit: (event) => setState(() {
                    isHovering = false;
                  }),
                  child: Stack(
                    children: [
                      //...getImages(width),
                      if (isHovering)
                        Padding(
                          // padding: EdgeInsets.fromLTRB(300, 100, 0, 100),
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ManagePresentationPage(
                                    estate: widget.estate,
                                  ),
                                ),
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.5),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(22),
                                  ),
                                ),
                                width: double.infinity,
                                height: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.manage_search,
                                      color: Colors.white,
                                    ),
                                    Text(widget.lang!
                                        .dictionary["manage_presentation"]!),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              ),*/
              Expanded(
                flex: 2,
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        widget.lang!.dictionary["general_information"]!,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      /*const SizedBox(height: 20),
                                            Text(
                        widget.lang!.dictionary["additional_information"]!,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),*/
                      const SizedBox(height: 20),
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
                      StringField(
                        labelText: widget.lang!.dictionary["phone_number"]!,
                        callback: (value) => widget.estate.phone = value,
                        presetText: widget.estate.phone,
                      ),
                      const SizedBox(height: 15),
                      StringField(
                        labelText: widget.lang!.dictionary["description"]!,
                        callback: (value) => widget.estate.description = value,
                        presetText: widget.estate.description,
                        multiline: 5,
                      ),
                      const SizedBox(height: 30),
                      widget.isNew
                          ? GradientButton(
                              buttonText:
                                  widget.lang!.dictionary["create_estate"]!,
                              callback: createEstate,
                            )
                          : GradientButton(
                              buttonText:
                                  widget.lang!.dictionary["save_changes"]!,
                              callback: saveChanges,
                            ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        widget.lang!.dictionary["additional_information"]!,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 15),
                      DropdownField(
                        labelText: widget.lang!.dictionary["allow_pets"]!,
                        callback: (String? value) {
                          if (value == null) return;
                          setState(() {
                            widget.estate.preferences.petsAllowed =
                                value == "True";
                          });
                        },
                        selected: widget.estate.preferences.petsAllowed
                            ? "True"
                            : "False",
                        choices: const ["True", "False"],
                      ),
                      const SizedBox(height: 15),
                      DropdownField(
                        labelText: widget.lang!.dictionary["allow_smoking"]!,
                        callback: (String? value) {
                          if (value == null) return;
                          setState(() {
                            widget.estate.preferences.smokingAllowed =
                                value == "True";
                          });
                        },
                        choices: const ["True", "False"],
                        selected: widget.estate.preferences.smokingAllowed
                            ? "True"
                            : "False",
                      ),
                      const SizedBox(height: 15),
                      DropdownField(
                        labelText:
                            widget.lang!.dictionary["handicap_accessible"]!,
                        callback: (String? value) {
                          if (value == null) return;
                          setState(() {
                            widget.estate.preferences.handicapAccessible =
                                value == "True";
                          });
                        },
                        choices: const ["True", "False"],
                        selected: widget.estate.preferences.handicapAccessible
                            ? "True"
                            : "False",
                      ),
                      const SizedBox(height: 15),
                      DropdownField(
                        labelText: widget.lang!.dictionary["air_conditioning"]!,
                        callback: (String? value) {
                          if (value == null) return;
                          setState(() {
                            widget.estate.preferences.airConditioning =
                                value == "True";
                          });
                        },
                        choices: const ["True", "False"],
                        selected: widget.estate.preferences.airConditioning
                            ? "True"
                            : "False",
                      ),
                      const SizedBox(height: 20),
                      DropdownField(
                        labelText: widget.lang!.dictionary["wifi"]!,
                        callback: (String? value) {
                          if (value == null) return;
                          setState(() {
                            widget.estate.preferences.wifi = value == "True";
                          });
                        },
                        choices: const ["True", "False"],
                        selected:
                            widget.estate.preferences.wifi ? "True" : "False",
                      ),
                      const SizedBox(height: 15),
                      DropdownField(
                        labelText: widget.lang!.dictionary["pool"]!,
                        callback: (String? value) {
                          if (value == null) return;
                          setState(() {
                            widget.estate.preferences.pool = value == "True";
                          });
                        },
                        choices: const ["True", "False"],
                        selected:
                            widget.estate.preferences.pool ? "True" : "False",
                      ),
                      const SizedBox(height: 15),
                      DropdownField(
                        labelText: widget.lang!.dictionary["kitchen"]!,
                        callback: (String? value) {
                          if (value == null) return;
                          setState(() {
                            widget.estate.preferences.kitchen = value == "True";
                          });
                        },
                        choices: const ["True", "False"],
                        selected: widget.estate.preferences.kitchen
                            ? "True"
                            : "False",
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        widget.lang!.dictionary["additional_information"]!,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      DropdownField(
                        labelText: widget.lang!.dictionary["washing_machine"]!,
                        callback: (String? value) {
                          if (value == null) return;
                          setState(() {
                            widget.estate.preferences.washingMachine =
                                value == "True";
                          });
                        },
                        choices: const ["True", "False"],
                        selected: widget.estate.preferences.washingMachine
                            ? "True"
                            : "False",
                      ),
                      const SizedBox(height: 15),
                      DropdownField(
                        labelText:
                            widget.lang!.dictionary["accepting_payment_cards"]!,
                        callback: (String? value) {
                          if (value == null) return;
                          setState(() {
                            widget.estate.preferences.acceptingPaymentCards =
                                value == "True";
                          });
                        },
                        choices: const ["True", "False"],
                        selected:
                            widget.estate.preferences.acceptingPaymentCards
                                ? "True"
                                : "False",
                      ),
                      const SizedBox(height: 15),
                      DropdownField(
                        labelText: widget.lang!.dictionary["drying_machine"]!,
                        callback: (String? value) {
                          if (value == null) return;
                          setState(() {
                            widget.estate.preferences.dryingMachine =
                                value == "True";
                          });
                        },
                        choices: const ["True", "False"],
                        selected: widget.estate.preferences.dryingMachine
                            ? "True"
                            : "False",
                      ),
                      const SizedBox(height: 15),
                      StringField(
                        inputType: TextInputType.number,
                        labelText: widget
                            .lang!.dictionary["designated_parking_spots"]!,
                        presetText: widget
                            .estate.preferences.designatedParkingSpots
                            .toString(),
                        callback: (int? value) {
                          if (value == null) return;

                          setState(() {
                            widget.estate.preferences.designatedParkingSpots =
                                value;
                          });
                        },
                      ),
                      const SizedBox(height: 15),
                      DropdownField(
                        labelText: widget.lang!.dictionary["outlet_type"]!,
                        choices: const [
                          "A",
                          "B",
                          "C",
                          "D",
                          "E",
                          "F",
                          "G",
                          "H",
                          "I",
                          "J",
                          "K",
                          "L",
                        ],
                        selected: widget.estate.preferences.outletType,
                        callback: (String? value) {
                          if (value == null) return;

                          setState(() {
                            widget.estate.preferences.outletType = value;
                          });
                        },
                      ),
                      const SizedBox(height: 15),
                      DropdownField(
                        labelText:
                            widget.lang!.dictionary["house_orientation"]!,
                        choices: const [
                          "N",
                          "NE",
                          "E",
                          "SE",
                          "S",
                          "SW",
                          "W",
                          "NW",
                        ],
                        selected: widget.estate.preferences.houseOrientation,
                        callback: (String? value) {
                          if (value == null) return;

                          setState(() {
                            widget.estate.preferences.houseOrientation = value;
                          });
                        },
                      ),
                      const SizedBox(height: 30),
                      GradientButton(
                        buttonText:
                            widget.lang!.dictionary["edit_presentation"]!,
                        callback: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ManagePresentationPage(
                              estate: widget.estate,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
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

      print(tmpUserId);
      print(tmpLang);
      print(tmpUserId);
      print(tmpTypeOfUser);
      print(tmpAvatarImage);

      setState(() {
        widget.userId = tmpUserId;
        widget.lang = tmpLang;
        widget.headerValues["userId"] = tmpUserId;
        widget.headerValues["typeOfUser"] = tmpTypeOfUser;
        widget.headerValues["userImage"] = tmpAvatarImage ?? "";
      });
    });
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

  void createEstate() async {
    if (!checkMandatoryData()) return;

    Map<String, dynamic>? estateMap = Estate.toJSON(widget.estate);
    if (estateMap == null) return null;

    Estate? res = await EstateRepository.createEstate(estateMap);
    if (res == null) return;

    // TODO: process data
  }

  void saveChanges() async {
    if (!checkMandatoryData()) return;

    Map<String, dynamic>? estateMap = Estate.toJSON(widget.estate);
    if (estateMap == null) return null;

    bool res = await EstateRepository.updateEstate(estateMap);

    // TODO: process data
  }
}
