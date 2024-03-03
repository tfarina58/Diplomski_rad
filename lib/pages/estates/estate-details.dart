import 'package:diplomski_rad/pages/estates/elements.dart';
import 'package:diplomski_rad/widgets/calendar_field.dart';
import 'package:diplomski_rad/widgets/card_widget.dart';
import 'package:diplomski_rad/widgets/header_widget.dart';
import 'package:diplomski_rad/services/firebase.dart';
import 'package:diplomski_rad/widgets/dropzone_widget.dart';
import 'package:flutter/material.dart';
import 'package:diplomski_rad/widgets/string_field.dart';
import 'package:diplomski_rad/widgets/gradient_button.dart';
import 'package:diplomski_rad/interfaces/estate.dart';
import 'package:diplomski_rad/interfaces/category.dart';
import 'package:latlong2/latlong.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:diplomski_rad/services/language.dart';
import 'package:diplomski_rad/other/pallete.dart';
import 'package:diplomski_rad/widgets/images_display_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:diplomski_rad/services/geocoding.dart';

class EstateDetailsPage extends StatefulWidget {
  String? userId;
  Estate estate;
  List<Category> categories = [];
  bool isNew;
  LanguageService? lang;
  Map<String, dynamic> headerValues = <String, dynamic>{};
  int currentPage = 0;

  EstateDetailsPage({
    Key? key,
    required this.estate,
    this.isNew = false
  }) : super(key: key);

  @override
  State<EstateDetailsPage> createState() => _EstateDetailsPageState();
}

class _EstateDetailsPageState extends State<EstateDetailsPage> {
  final controller = PageController(
    initialPage: 0,
    viewportFraction: 0.7,
  );

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    if (widget.lang == null || widget.userId == null) {
      return const SizedBox();
    }

    return Scaffold(
      appBar: HeaderComponent(
        currentPage: 'EstateDetailsPage',
        lang: widget.lang!,
        headerValues: widget.headerValues,
      ),
      body: SingleChildScrollView(scrollDirection: Axis.vertical, child: displayBody(width, height)),
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
            if (widget.isNew) estateInformation(width, height)
            else StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('estates')
                  .doc(widget.estate.id)
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
                  final document = snapshot.data;
                  Estate? tmpEstate;

                  if (document == null) return Text('Error: ${snapshot.error}');

                  Map<String, dynamic>? tmpMap = document.data();
                  if (tmpMap == null) return Text(''); // TODO

                  tmpMap['id'] = document.id;

                  tmpEstate = Estate.toEstate(tmpMap);
                  if (tmpEstate == null) return Text(''); // TODO

                  widget.estate = tmpEstate;

                  return estateInformation(width, height);
                }
              },
            ),

            if (!widget.isNew) 
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('categories')
                    .where('estateId', isEqualTo: widget.estate.id)
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
        
                    widget.categories = [];

                    Category? tmp;
                    List<Category> tmpCategories = [];
                    document.map((DocumentSnapshot doc) {
                      Map<String, dynamic>? tmpMap = doc.data() as Map<String, dynamic>?;
                      if (tmpMap == null) return;
        
                      tmpMap['id'] = doc.id;
                      tmp = Category.toCategory(tmpMap);
                      if (tmp == null) return;
        
                      tmpCategories.add(tmp!);
                    }).toList();
        
                    widget.categories = tmpCategories;

                    return showCategories(width, height);
                  }
                },
              ),
              
              if (!widget.isNew) SizedBox(height: height * 0.075),
              if (!widget.isNew) optionButtons(width, height),
              if (!widget.isNew) SizedBox(height: height * 0.05),
          ],
        ),
      ),
    );
  }

  List<Widget> showSlideVariables(double width, double height, StateSetter setState) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: Text(
                widget.lang!.dictionary["variables"]!,
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
      SizedBox(height: height * 0.015),

      for (int i = 0; i < widget.estate.variables.length; ++i)
        ...[
          Divider(
            height: height * 0.066,
            thickness: 3,
            color: PalleteCommon.gradient2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(child: SizedBox()),
              Expanded(
                child: Text(i.toString()),
              ),
              Expanded(
                flex: 4,
                child: StringField(
                  labelText: widget.lang!.dictionary["key"]!,
                  callback: (newValue) => setState(() {
                    widget.estate.variables[i][0] = newValue;
                  }),
                  presetText: widget.estate.variables[i][0],
                ),
              ),
              const Expanded(child: SizedBox()),
              Expanded(
                flex: 4,
                child: StringField(
                  labelText: widget.lang!.dictionary["value"]!,
                  callback: (newValue) => setState(() {
                    widget.estate.variables[i][1] = newValue;
                  }),
                  presetText: widget.estate.variables[i][1],
                ),
              ),
              const Expanded(child: SizedBox()),
              Expanded(
                flex: 4,
                child: CalendarField(
                  labelText: widget.lang!.dictionary["from"]!,
                  callback: (newValue) => setState(() {
                    widget.estate.variables[i][2] = newValue;
                  }),
                  selectedDate: widget.estate.variables[i][2] as DateTime,
                ),
              ),
              const Expanded(child: SizedBox()),
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        print(widget.estate.variables[i][0]);
                        widget.estate.variables.removeAt(i);
                      });
                    },
                    onHover: (value) {},
                    child: const Icon(Icons.remove),
                  ),
                ),
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
        ],

      Divider(
        height: height * 0.066,
        thickness: 3,
        color: PalleteCommon.gradient2,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Expanded(flex: 18, child: SizedBox()),
          Expanded(
            child: SizedBox(
              height: 50,	
              child: InkWell(
                onTap: () {
                  setState(() {
                    widget.estate.variables.add(Estate.newVariableRow());
                  });
                },
                onHover: (value) {},
                child: const Icon(Icons.add),
              ),
            ),
          ),
          const Expanded(child: SizedBox()),
        ],
      ),
      Divider(
        height: height * 0.066,
        thickness: 3,
        color: PalleteCommon.gradient2,
      )
    ];
  }

  Widget optionButtons(double width, double height) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (!widget.isNew) ...[
          const Expanded(flex: 2, child: SizedBox()),
          Expanded(
            flex: 3,
            child: GradientButton(
              buttonText: widget.lang!.dictionary["save_changes"]!,
              callback: updateEstateAndCategories,
            ),
          ),
          const Expanded(
            flex: 2,
            child: SizedBox(),
          ),
          Expanded(
            flex: 3,
            child: GradientButton(
              buttonText: widget.lang!.dictionary["delete_estate"]!,
              callback: () => showDialog(
                context: context,
                builder: (BuildContext context) => showDeleteAlert(width, height),
              ),
            ),
          ),
          const Expanded(flex: 2, child: SizedBox()),
        ],
        if (widget.isNew) ...[
          const Expanded(flex: 3, child: SizedBox()),
          Expanded(
            flex: 2,
            child: GradientButton(
              buttonText: widget.lang!.dictionary["create_estate"]!,
              callback: createEstate,
            ),
          ),
          const Expanded(flex: 3, child: SizedBox()),
        ],
      ],
    );
  }

  Widget showCategories(double width, double height) {
    List<Widget> res = [];
    double cardSize = width * 0.4166;

    for (int i = 0; i < widget.categories.length; ++i) {
      res.add(
        Padding(
          padding: EdgeInsets.fromLTRB(width * 0.005, 0, width * 0.005, 0),
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ElementsPage(category: widget.categories[i]),
              ),
            ),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: CardWidget(
                title: widget.categories[i].title,
                type: 'cat',
                width: cardSize,
                height: cardSize * 0.5625,
                lang: widget.lang!,
                backgroundImage: widget.categories[i].image,
                category: widget.categories[i]
              )
            ),
          ),
        ),
      );
    }

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: SizedBox(
                width: cardSize * 1.428571,
                height: cardSize * 0.5625,
                child: PageView(
                  scrollBehavior: const MaterialScrollBehavior(),
                  controller: controller,
                  scrollDirection: Axis.horizontal,
                  children: res,
                ),
              ),
            ),
            FABButtons(cardSize, setState),
          ],
        );
      },
    );
  }

  Widget FABButtons(double cardSize, StateSetter setState) {
    Widget leftButton, rightButton;

    if (widget.currentPage > 0) {
      leftButton = Align(
        alignment: Alignment.bottomLeft,
        child: SizedBox(
          width: cardSize * 0.15,
          height: cardSize * 0.15,
          child: ElevatedButton(
            onPressed: () {
              if (widget.currentPage <= 0) return;
              setState(() {
                widget.currentPage -= 1;
              });
              controller.animateToPage(
                widget.currentPage,
                duration: const Duration(milliseconds: 150),
                curve: Curves.linear,
              );
            },
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(PalleteHint.gradient3),
            ),
            child: const Icon(
              Icons.arrow_back,
              size: 40,
              color: Colors.white,
            ),
          ),
        ),
      );
    } else {
      leftButton = Align(
        alignment: Alignment.bottomLeft,
        child: SizedBox(
          width: cardSize * 0.15,
          height: cardSize * 0.15,
        ),
      );
    }

    if (widget.currentPage < widget.categories.length - 1) {
      rightButton = Align(
        alignment: Alignment.centerRight,
        child: SizedBox(
          width: cardSize * 0.15,
          height: cardSize * 0.15,
          child: ElevatedButton(
            onPressed: () {
              if (widget.currentPage >= widget.categories.length - 1) return;
              setState(() {
                widget.currentPage += 1;
              });
              controller.animateToPage(
                widget.currentPage,
                duration: const Duration(milliseconds: 150),
                curve: Curves.linear,
              );
            },
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(PalleteHint.gradient3),
            ),
            child: const Icon(
              Icons.arrow_forward,
              size: 40,
              color: Colors.white,
            ),
          ),
        ),
      );
    } else {
      rightButton = Align(
        alignment: Alignment.centerRight,
        child: SizedBox(
          width: cardSize * 0.15,
          height: cardSize * 0.15,
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        leftButton,
        SizedBox(width: cardSize * 1.28),
        rightButton
      ],
    );
  }

  Widget estateInformation(double width, double height) {
    return 
      StatefulBuilder(
        builder:  (BuildContext context, StateSetter setState) => Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ImagesDisplay(
              estate: widget.estate,
              lang: widget.lang!,
              showAvatar: false,
              enableEditing: !widget.isNew,
            ),
            SizedBox(height: height * 0.1),
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
            SizedBox(height: height * 0.04),
            showMandatoryFields(),
            if (!widget.isNew) SizedBox(height: height * 0.1),
            if (!widget.isNew) ...showSlideVariables(width, height, setState),
            if (!widget.isNew) SizedBox(height: height * 0.075),
          ],
        ),
      );
  }

  Widget showMandatoryFields() {
    return Row(
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
    );
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

    LatLng? coordinates = await Geocoding.geocode(widget.estate.street, widget.estate.zip, widget.estate.city, widget.estate.country);
    widget.estate.coordinates = coordinates;

    Map<String, dynamic>? estateMap = Estate.toJSON(widget.estate);
    if (estateMap == null) return;

    estateMap["ownerId"] = widget.userId;

    Estate? res = await EstateRepository.createEstate(estateMap);
    if (res == null) return;

    setState(() {
      widget.estate = res;
      widget.isNew = false;
    });
  }

  void updateEstateAndCategories(/*double width, double height*/) async {
    if (!checkMandatoryData()) return;


    Map<String, dynamic>? estateMap = Estate.toJSON(widget.estate);
    if (estateMap == null) return null;

    bool estateRes = await EstateRepository.updateEstate(widget.estate.id, estateMap);
    
    if (!estateRes) {
      // TODO: set failure snackbar
    }
    // TODO: set success snackbar
  }

  void deleteEstate(/*double width, double height*/) async {
    if (widget.estate.id.isEmpty) return;

    bool res = await EstateRepository.deleteEstate(widget.estate.id);

    if (res) {
      Navigator.pop(context);
      Navigator.pop(context);
    }

    if (!res) {
      // TODO: add failure snackbar
    }
    // TODO: add success snackbar
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