import 'dart:html';

import 'package:diplomski_rad/pages/estates/elements.dart';
import 'package:diplomski_rad/services/shared_preferences.dart';
import 'package:diplomski_rad/widgets/calendar_field.dart';
import 'package:diplomski_rad/widgets/snapshot_error_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diplomski_rad/widgets/loading_bar.dart';
import 'package:diplomski_rad/widgets/time_field.dart';
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
import 'package:diplomski_rad/services/geocoding.dart';

class EstateDetailsPage extends StatefulWidget {
  String? userId;
  Estate estate;
  List<Category> categories = [];

  Category newCategorory = Category(title: Map.from({"en": "", "de": "", "hr": ""}));
  int currentPage = 0;
  bool isNewEstate;

  LanguageService? lang;
  Map<String, dynamic> headerValues = <String, dynamic>{};

  EstateDetailsPage({
    Key? key,
    required this.estate,
    this.isNewEstate = false
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
      return Scaffold(
        body: LoadingBar(dimensionLength: width > height ? height * 0.5 : width * 0.5),
      );
    }

    return Scaffold(
      appBar: HeaderComponent(
        currentPage: 'EstateDetailsPage',
        lang: widget.lang!,
        headerValues: widget.headerValues,
      ),
      body: SingleChildScrollView(
      scrollDirection: Axis.vertical,
        child:
          widget.estate.id.isEmpty ?
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                showEstateInformation(width, height),
                if (!widget.isNewEstate) SizedBox(height: height * 0.1),
                showCategoriesInformation(width, height),
                SizedBox(height: height * 0.075),
                optionButtons(width, height),
                SizedBox(height: height * 0.05),
              ],
            ) :
            StreamBuilder(
              stream: FirebaseFirestore.instance
                .collection('estates')
                .doc(widget.estate.id)
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
                    Estate? tmp = Estate.toEstate(userMap);

                    if (tmp == null) {
                      return const Text("Error while converting data!");
                    }
                    widget.estate = tmp;

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        showEstateInformation(width, height),
                        if (!widget.isNewEstate) SizedBox(height: height * 0.1),
                        showCategoriesInformation(width, height),
                        SizedBox(height: height * 0.075),
                        optionButtons(width, height),
                        SizedBox(height: height * 0.05),
                      ],
                    );
                  }
              }
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
        widget.userId = tmpUserId;
        widget.lang = tmpLang;
        widget.headerValues["userId"] = tmpUserId;
        widget.headerValues["typeOfUser"] = tmpTypeOfUser;
        widget.headerValues["avatarImage"] = tmpAvatarImage ?? "";
      });
    });
  }

  List<Widget> showGuestTable(double width, double height, StateSetter setState) {
    List<Widget> guestLines = [];
    List<Widget> line;

    for (int i = 0; i < widget.estate.guests.length; ++i) {
      line = getGuestLine(width, height, setState, index: i);
      for (int j = 0; j < line.length; ++j) {
        guestLines.add(line[j]);
      }
    }

    line = getGuestLine(width, height, setState);
    for (int j = 0; j < line.length; ++j) {
      guestLines.add(line[j]);
    }

    return guestLines;
  }

  List<Widget> getGuestLine(double width, double height, StateSetter setState, {int index = -1}) {
    return [
      Divider(
        height: height * 0.066,
        thickness: 3,
        color: PalleteCommon.gradient2,
        indent: width * 0.025,
        endIndent: width * 0.025,
      ),
      if (index == -1) 
        ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(flex: 26, child: SizedBox()),
              Expanded(
                child: SizedBox(
                  height: height * 0.068,	
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        widget.estate.guests.add(Estate.newGuestRow());
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
            indent: width * 0.025,
            endIndent: width * 0.025,
          )
        ]
      else
        Row(
          key: ValueKey(widget.estate.guests[index]['name']),
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Expanded(child: SizedBox()),
            Expanded(
              flex: 2,
              child: Center(child: Text(index.toString())),
            ),
            Expanded(
              flex: 3,
              child: CalendarField(
                labelText: widget.lang!.translate('from_date'),
                callback: (newValue) => setState(() {
                  widget.estate.guests[index]['from'] = newValue;
                }),
                selectedDate: widget.estate.guests[index]['from'] as DateTime,
                lang: widget.lang!,
              ),
            ),
            const Expanded(child: SizedBox()),
            Expanded(
              flex: 3,
              child: TimeField(
                labelText: widget.lang!.translate('from_time'),
                callback: (TimeOfDay newValue) {
                  DateTime oldDate = widget.estate.guests[index]['from'] as DateTime;
                  DateTime newDate = DateTime(oldDate.year, oldDate.month, oldDate.day, (newValue).hour, (newValue).minute);

                  setState(() {
                    widget.estate.guests[index]['from'] = newDate;
                  });
                },
                selectedTime: TimeOfDay(hour: (widget.estate.guests[index]['from'] as DateTime).hour, minute: (widget.estate.guests[index]['from'] as DateTime).minute),
                lang: widget.lang!,
              ),
            ),
            const Expanded(child: SizedBox()),
            Expanded(
              flex: 6,
              child: StringField(
                labelText: widget.lang!.translate('name'),
                callback: (newValue) => widget.estate.guests[index]['name'] = newValue,
                presetText: widget.estate.guests[index]['name'],
              ),
            ),
            const Expanded(child: SizedBox()),
            Expanded(
              flex: 3,
              child: CalendarField(
                labelText: widget.lang!.translate('to_date'),
                callback: (newValue) => setState(() {
                  widget.estate.guests[index]['to'] = newValue;
                }),
                selectedDate: widget.estate.guests[index]['to'] as DateTime,
                lang: widget.lang!,
              ),
            ),
            const Expanded(child: SizedBox()),
            Expanded(
              flex: 3,
              child: TimeField(
                labelText: widget.lang!.translate('to_time'),
                callback: (TimeOfDay newValue) {
                  DateTime oldDate = widget.estate.guests[index]['to'] as DateTime;
                  DateTime newDate = DateTime(oldDate.year, oldDate.month, oldDate.day, (newValue).hour, (newValue).minute);

                  setState(() {
                    widget.estate.guests[index]['to'] = newDate;
                  });
                },
                selectedTime: TimeOfDay(hour: (widget.estate.guests[index]['to'] as DateTime).hour, minute: (widget.estate.guests[index]['to'] as DateTime).minute),
                lang: widget.lang!,
              ),
            ),
            const Expanded(child: SizedBox()),
            Expanded(
              child: SizedBox(
                height: height * 0.068,	
                child: InkWell(
                  onTap: () {
                    setState(() {
                      widget.estate.guests.removeAt(index);
                    });
                  },
                  onHover: (value) {},
                  child: const Icon(Icons.remove),
                ),
              ),
            ),
            const Expanded(child: SizedBox()),
          ],
        )
    ];
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
                widget.lang!.translate('variables'),
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
            indent: width * 0.025,
            endIndent: width * 0.025,
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
                  labelText: widget.lang!.translate('key'),
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
                  labelText: widget.lang!.translate('value'),
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
                  labelText: widget.lang!.translate('from'),
                  callback: (newValue) => setState(() {
                    widget.estate.variables[i][2] = newValue;
                  }),
                  selectedDate: widget.estate.variables[i][2] as DateTime,
                  lang: widget.lang!,
                ),
              ),
              const Expanded(child: SizedBox()),
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: InkWell(
                    onTap: () {
                      setState(() {
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
        indent: width * 0.025,
        endIndent: width * 0.025,
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
        indent: width * 0.025,
        endIndent: width * 0.025,
      )
    ];
  }

  Widget optionButtons(double width, double height) {
    List<Widget> buttonsRow = [];

    if (!widget.isNewEstate) {
      buttonsRow = [
        const Expanded(flex: 2, child: SizedBox()),
        Expanded(
          flex: 3,
          child: GradientButton(
            buttonText: widget.lang!.translate('delete_estate'),
            callback: () => showDialog(
              context: context,
              builder: (BuildContext context) => showDeleteAlert(width, height),
            ),
          ),
        ),
        const Expanded(
          flex: 2,
          child: SizedBox(),
        ),
        Expanded(
          flex: 3,
          child: GradientButton(
            buttonText: widget.lang!.translate('save_changes'),
            callback: updateEstateAndCategories,
          ),
        ),
        const Expanded(flex: 2, child: SizedBox()),
      ];
    } else {
      buttonsRow = [
        const Expanded(flex: 3, child: SizedBox()),
        Expanded(
          flex: 2,
          child: GradientButton(
            buttonText: widget.lang!.translate('create_estate'),
            callback: createEstate,
          ),
        ),
        const Expanded(flex: 3, child: SizedBox()),
      ];
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: buttonsRow,
    );
  }

  Widget getCategoriesList(double width, double height, double cardSize, BuildContext context) {
    return Center(
      child: SizedBox(
        width: cardSize * 1.428571,
        height: cardSize * 0.5625,
        child: PageView(
          scrollBehavior: const MaterialScrollBehavior(),
          controller: controller,
          scrollDirection: Axis.horizontal,
          children: [
            for (int i = 0; i < widget.categories.length; ++i)
              getCategoryCard(width, height, cardSize, context, index: i),
              
            getCategoryCard(width, height, cardSize, context),
          ],
        ),
      ),
    );
  }

  Widget FABButtons(double cardSize, StateSetter setState) {
    Widget leftButton = Align(
      alignment: Alignment.bottomLeft,
      child: SizedBox(
        width: cardSize * 0.15,
        height: cardSize * 0.15,
        child: ElevatedButton(
          onPressed: () {
            if (widget.currentPage <= 0) return;
            widget.currentPage -= 1;
            controller.animateToPage(
              widget.currentPage,
              duration: const Duration(milliseconds: 150),
              curve: Curves.linear,
            );
          },
          style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(PalleteCommon.gradient3),
          ),
          child: const Icon(
            Icons.arrow_back,
            size: 40,
            color: Colors.white,
          ),
        ),
      ),
    );

    Widget rightButton = Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: cardSize * 0.15,
        height: cardSize * 0.15,
        child: ElevatedButton(
          onPressed: () {
            if (widget.currentPage >= widget.categories.length) return;
            widget.currentPage += 1;
            controller.animateToPage(
              widget.currentPage,
              duration: const Duration(milliseconds: 150),
              curve: Curves.linear,
            );
          },
          style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(PalleteCommon.gradient3),
          ),
          child: const Icon(
            Icons.arrow_forward,
            size: 40,
            color: Colors.white,
          ),
        ),
      ),
    );

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

  Widget showEstateInformation(double width, double height) {
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
              enableEditing: !widget.isNewEstate,
              callback: (String value) => setState(() {
                widget.estate.image = value;
              }),
            ),
            SizedBox(height: height * 0.1),
            showSectionTitle(widget.lang!.translate('general_information'), 22, Colors.white),
            SizedBox(height: height * 0.04),
            showMandatoryFields(),
            if (!widget.isNewEstate) SizedBox(height: height * 0.1),
            if (!widget.isNewEstate) showSectionTitle(widget.lang!.translate('guests'), 22, Colors.white),
            if (!widget.isNewEstate) SizedBox(height: height * 0.01),
            if (!widget.isNewEstate) ...showGuestTable(width, height, setState),
            /*if (!widget.isNewEstate) ...showSlideVariables(width, height, setState),
            if (!widget.isNewEstate) SizedBox(height: height * 0.075),*/
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
                  labelText: widget.lang!.translate('name_en'),
                  callback: (String value) => widget.estate.name['en'] = value,
                  presetText: widget.estate.name['en'],
                ),
                const SizedBox(height: 15),
                StringField(
                  labelText: widget.lang!.translate('name_de'),
                  callback: (value) => widget.estate.name['de'] = value,
                  presetText: widget.estate.name['de'],
                ),
                const SizedBox(height: 15),
                StringField(
                  labelText: widget.lang!.translate('name_hr'),
                  callback: (value) => widget.estate.name['hr'] = value,
                  presetText: widget.estate.name['hr'],
                ),
                const SizedBox(height: 15),
                StringField(
                  labelText: widget.lang!.translate('phone_number'),
                  callback: (value) => widget.estate.phone = value,
                  presetText: widget.estate.phone,
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
                  labelText: widget.lang!.translate('street'),
                  callback: (value) => widget.estate.street = value,
                  presetText: widget.estate.street,
                ),
                const SizedBox(height: 15),
                StringField(
                  labelText: widget.lang!.translate('zip'),
                  callback: (value) => widget.estate.zip = value,
                  presetText: widget.estate.zip,
                ),
                const SizedBox(height: 15),
                StringField(
                  labelText: widget.lang!.translate('city'),
                  callback: (value) => widget.estate.city = value,
                  presetText: widget.estate.city,
                ),
                const SizedBox(height: 15),
                StringField(
                  labelText: widget.lang!.translate('country'),
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
        (widget.estate.name['en'] as String).isNotEmpty &&
        (widget.estate.name['de'] as String).isNotEmpty &&
        (widget.estate.name['hr'] as String).isNotEmpty;
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
                widget.lang!.translate('delete_estate_warning_message'),
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
                      buttonText: widget.lang!.translate('delete_estate'),
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
                      buttonText: widget.lang!.translate('cancel'),
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

  Future<String> uploadNewCategoryImage() async {
    FirebaseStorageService storage = FirebaseStorageService();
    await storage.uploadImageForCategory(
      widget.newCategorory,
      widget.newCategorory.tmpImageName!,
      widget.newCategorory.tmpImageBytes!
    );
    
    return await storage.downloadImage(
      widget.newCategorory.id,
      widget.newCategorory.tmpImageName!,
    );
  }

   Widget showCategoriesInformation(double width, double height) {
    double cardSize = width * 0.4166;

    if (!widget.isNewEstate) {
      return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('categories')
            .where('estateId', isEqualTo: widget.estate.id)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingBar(dimensionLength: width > height ? height * 0.5 : width * 0.5);
          } else if (snapshot.hasError) {
            return SizedBox(
              width: width,
              height: height * 0.2,
              child: SnapshotErrorField(
                text: widget.lang!.translate('cant_obtain_categories')
              ),
            );
          } else {
            final document = snapshot.data?.docs;
            widget.categories = Category.setupCategoriesFromFirebaseDocuments(document);

            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    getCategoriesList(width, height, cardSize, context),
                    FABButtons(cardSize, setState),
                  ],
                );
              },
            );
          }
        },
      );
    }
    
    return const SizedBox();
  }

  Widget showSectionTitle(String text, double fontSize, Color fontColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: fontColor,
              ),
            ),
          ),
        ),
        const Expanded(flex: 2, child: SizedBox(),),
      ],
    );
  }

  Widget getCategoryCard(double width, double height, double cardSize, BuildContext context, {int index = -1}) {
    if (index == -1) {
      return Padding(
        padding: EdgeInsets.fromLTRB(width * 0.005, 0, width * 0.005, 0),
        child: CardWidget(
          title: widget.lang!.translate('add_category'),
          width: cardSize,
          height: cardSize * 0.5625,
          lang: widget.lang!,
          onTap: () => showEmptyCategoryDialog(width, height, context),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(width * 0.005, 0, width * 0.005, 0),
      child: CardWidget(
        title: widget.categories[index].title[widget.lang!.language]!,
        showSettings: true,
        width: cardSize,
        height: cardSize * 0.5625,
        lang: widget.lang!,
        backgroundImage: widget.categories[index].image,
        category: widget.categories[index],
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ElementsPage(category: widget.categories[index]),
          ),
        ),
        onSettingsTap: () => showCategoryDialog(width, height, context, index),
      ),
    );
  }

  Widget showTitlesForLanguages() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Expanded(child: SizedBox()),
        Expanded(
          flex: 2,
          child: StringField(
            labelText: widget.lang!.translate('title_en'),
            callback: (value) => widget.newCategorory.title = value,
            presetText: widget.newCategorory.title['en'] ?? "",
          ),
        ),
        Expanded(
          flex: 2,
          child: StringField(
            labelText: widget.lang!.translate('title_de'),
            callback: (value) => widget.newCategorory.title = value,
            presetText: widget.newCategorory.title['de'] ?? "",
          ),
        ),
        Expanded(
          flex: 2,
          child: StringField(
            labelText: widget.lang!.translate('title_hr'),
            callback: (value) => widget.newCategorory.title = value,
            presetText: widget.newCategorory.title['hr'] ?? "",
          ),
        ),
        const Expanded(child: SizedBox()),
      ],
    );
  }

  Widget dropzoneOrShowImage(double width, double height) {
    // Showing locally obtained image
    if (widget.newCategorory.tmpImageBytes != null) {
      return Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(bottom: 50),
              width: width * 0.3,
              height: height * 0.3,
              decoration: BoxDecoration(
                image: DecorationImage(
                  scale: 0.01,
                  fit: BoxFit.fitWidth,
                  image: Image.memory(widget.newCategorory.tmpImageBytes!).image,
                ),
              ),
            ),
          ),

          // Delete image
          SizedBox(
            width: width * 0.3,
            height: height * 0.3,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    widget.newCategorory.tmpImageBytes = null;
                    widget.newCategorory.tmpImageName = "";
                  });
                },
                child: const Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: Icon(
                    Icons.close,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ),
        ],
      );        
    }
    // No image to show
    else {
      return DropzoneWidget(
        width: width * 0.4,
        height: height * 0.4,
        lang: widget.lang!,
        onDroppedFile: (Map<String, dynamic>? file) {
          if (file == null) return;

          setState(() {
            widget.newCategorory.tmpImageName = file['name'];
            widget.newCategorory.tmpImageBytes = file['bytes'];
          });
        },
      );
    }
  }

  void showEmptyCategoryDialog(double width, double height, BuildContext context) async {
    showDialog(context: context, builder: (BuildContext context) {
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
                  SizedBox(height: height * 0.05),
                  Center(
                    child: Row(
                      children: [
                        const Expanded(child: SizedBox()),
                        Expanded(
                          child: StringField(
                            labelText: widget.lang!.translate('title_en'),
                            callback: (value) => widget.newCategorory.title['en'] = value,
                            presetText: widget.newCategorory.title['en'],
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                        Expanded(
                          child: StringField(
                            labelText: widget.lang!.translate('title_de'),
                            callback: (value) => widget.newCategorory.title['de'] = value,
                            presetText: widget.newCategorory.title['de'],
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                        Expanded(
                          child: StringField(
                            labelText: widget.lang!.translate('title_hr'),
                            callback: (value) => widget.newCategorory.title['hr'] = value,
                            presetText: widget.newCategorory.title['hr'],
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.05),
                  
                  if (widget.newCategorory.image.isNotEmpty)
                    // Showing image from Firebase
                    Stack(
                      alignment: AlignmentDirectional.topCenter,
                      children: [
                        Center(
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 50),
                            width: width * 0.3,
                            height: height * 0.3,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                scale: 0.01,
                                fit: BoxFit.fitWidth,
                                image: Image.network(widget.newCategorory.image).image,
                              ),
                            ),
                          ),
                        ),

                        // Delete image
                        SizedBox(
                          width: width * 0.3,
                          height: height * 0.3,
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  widget.newCategorory.image = "";
                                });
                              },
                              child: const Align(
                                alignment: AlignmentDirectional.topEnd,
                                child: Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  else if (widget.newCategorory.tmpImageBytes != null)

                    // Showing locally obtained image
                    Stack(
                      alignment: AlignmentDirectional.topCenter,
                      children: [
                        Center(
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 50),
                            width: width * 0.3,
                            height: height * 0.3,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                scale: 0.01,
                                fit: BoxFit.fitWidth,
                                image: Image.memory(widget.newCategorory.tmpImageBytes!).image,
                              ),
                            ),
                          ),
                        ),

                        // Delete image
                        SizedBox(
                          width: width * 0.3,
                          height: height * 0.3,
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  widget.newCategorory.tmpImageBytes = null;
                                  widget.newCategorory.tmpImageName = "";
                                });
                              },
                              child: const Align(
                                alignment: AlignmentDirectional.topEnd,
                                child: Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    // No image to show
                    DropzoneWidget(
                      width: width * 0.4,
                      height: height * 0.4,
                      lang: widget.lang!,
                      onDroppedFile: (Map<String, dynamic>? file) {
                        if (file == null) return;

                        setState(() {
                          widget.newCategorory.tmpImageName = file['name'];
                          widget.newCategorory.tmpImageBytes = file['bytes'];
                        });
                      },
                    ),

                  SizedBox(height: height * 0.05),
                  GradientButton(buttonText: widget.lang!.translate('add_category'), callback: () => createCategory())
                ],
              ),
            );
          },
        ),
      );
    });
  }

  void showCategoryDialog(double width, double height, BuildContext context, int index) async {
    showDialog(context: context, builder: (BuildContext context) {
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
                  SizedBox(height: height * 0.05),
                  Center(
                    child: Row(
                      children: [
                        const Expanded(child: SizedBox()),
                        Expanded(
                          child: StringField(
                            labelText: widget.lang!.translate('title_en'),
                            callback: (value) => widget.categories[index].title['en'] = value,
                            presetText: widget.categories[index].title['en'],
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                        Expanded(
                          child: StringField(
                            labelText: widget.lang!.translate('title_de'),
                            callback: (value) => widget.categories[index].title['de'] = value,
                            presetText: widget.categories[index].title['de'],
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                        Expanded(
                          child: StringField(
                            labelText: widget.lang!.translate('title_hr'),
                            callback: (value) => widget.categories[index].title['hr'] = value,
                            presetText: widget.categories[index].title['hr'],
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.05),
                  
                  if (widget.categories[index].image.isNotEmpty)
                    // Showing image from Firebase
                    Stack(
                      alignment: AlignmentDirectional.topCenter,
                      children: [
                        Center(
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 50),
                            width: width * 0.3,
                            height: height * 0.3,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                scale: 0.01,
                                fit: BoxFit.fitWidth,
                                image: Image.network(widget.categories[index].image).image,
                              ),
                            ),
                          ),
                        ),

                        // Delete image
                        SizedBox(
                          width: width * 0.3,
                          height: height * 0.3,
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  widget.categories[index].image = "";
                                });
                              },
                              child: const Align(
                                alignment: AlignmentDirectional.topEnd,
                                child: Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  else if (widget.categories[index].tmpImageBytes != null)

                    // Showing locally obtained image
                    Stack(
                      alignment: AlignmentDirectional.topCenter,
                      children: [
                        Center(
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 50),
                            width: width * 0.3,
                            height: height * 0.3,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                scale: 0.01,
                                fit: BoxFit.fitWidth,
                                image: Image.memory(widget.categories[index].tmpImageBytes!).image,
                              ),
                            ),
                          ),
                        ),

                        // Delete image
                        SizedBox(
                          width: width * 0.3,
                          height: height * 0.3,
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  widget.categories[index].tmpImageBytes = null;
                                  widget.categories[index].tmpImageName = "";
                                });
                              },
                              child: const Align(
                                alignment: AlignmentDirectional.topEnd,
                                child: Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  else
                    // No image to show
                    DropzoneWidget(
                      width: width * 0.4,
                      height: height * 0.4,
                      lang: widget.lang!,
                      onDroppedFile: (Map<String, dynamic>? file) {
                        if (file == null) return;

                        setState(() {
                          widget.categories[index].tmpImageName = file['name'];
                          widget.categories[index].tmpImageBytes = file['bytes'];
                        });
                      },
                    ),

                  SizedBox(height: height * 0.05),
                  GradientButton(buttonText: widget.lang!.translate('save_changes'), callback: () => saveChanges(width, height, index))
                ],
              ),
            );
          },
        ),
      );
    });
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
      widget.isNewEstate = false;
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

  Future<void> createCategory() async {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    if (widget.newCategorory.tmpImageBytes != null) {
      widget.newCategorory.image = await uploadNewCategoryImage();
    }

    widget.newCategorory.estateId = widget.estate.id;
    Map<String, dynamic>? categoryMap = Category.toJSON(widget.newCategorory);

    if (categoryMap == null) return;

    widget.newCategorory = Category(title: Map.from({"en": "", "de": "", "hr": ""}));

    Category? res = await CategoryRepository.createCategory(categoryMap);
    if (res != null) {
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

  Future<void> saveChanges(double width, double height, int index) async {
    if (widget.categories[index].image.isEmpty && widget.categories[index].tmpImageBytes != null) {
      widget.categories[index].image = await uploadNewCategoryImage();
    }

    Map<String, dynamic>? categoryMap = Category.toJSON(widget.categories[index]);

    if (categoryMap == null) return;

    bool res = await CategoryRepository.updateCategory(widget.categories[index].id, categoryMap);
    if (res) {
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