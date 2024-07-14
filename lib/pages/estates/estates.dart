import 'package:diplomski_rad/interfaces/estate.dart';
import 'package:diplomski_rad/widgets/snapshot_error_field.dart';
import 'package:flutter/material.dart';
import 'package:diplomski_rad/widgets/header_widget.dart';
import 'package:diplomski_rad/widgets/card_widget.dart';
import 'package:diplomski_rad/widgets/loading_bar.dart';
import 'package:diplomski_rad/other/pallete.dart';
import 'package:diplomski_rad/pages/estates/estate-details.dart';
import 'package:diplomski_rad/widgets/maps.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:diplomski_rad/services/language.dart';
import 'package:diplomski_rad/services/shared_preferences.dart';

// Types of showing the estates
enum UserChoice { list, map }

class EstatesPage extends StatefulWidget {

  // If user searches for its own estates, only userId will be set (for StreamBuilder and HeaderComponent).
  String? userId;

  // If searchedCustomerId is also set, the app's user (admin) is searching for other people's estates.
  // The userId will be used only for HeaderComponent.
  String? searchedCustomerId;

  List<Estate> estates = [];

  String? temperaturePreference;
  UserChoice choice = UserChoice.list;
  final bool showEmptyCard;

  LanguageService? lang;
  Map<String, dynamic> headerValues = <String, dynamic>{};

  EstatesPage({
    Key? key,
    this.showEmptyCard = true,
    this.searchedCustomerId = "",
  }) : super(key: key);

  @override
  State<EstatesPage> createState() => _EstatesPageState();
}

class _EstatesPageState extends State<EstatesPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double cardSize = width * 0.4166;

    if (widget.lang == null || widget.userId == null) {
      return Scaffold(
        body: LoadingBar(dimensionLength: width > height ? height * 0.5 : width * 0.5),
      );
    }

    return Scaffold(
      appBar: HeaderComponent(
        currentPage: 'EstatesPage',
        lang: widget.lang!,
        headerValues: widget.headerValues,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('estates')
            .where('ownerId',
              isEqualTo: widget.searchedCustomerId!.isNotEmpty
                  ? widget.searchedCustomerId
                  : widget.userId
            )
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingBar(dimensionLength: width > height ? height * 0.5 : width * 0.5);
          } else if (snapshot.hasError) {
            return SnapshotErrorField(text: widget.lang!.translate('cant_obtain_estates'));
          } else {            
            final document = snapshot.data?.docs;
            widget.estates = Estate.setupEstatesFromFirebaseDocuments(document);

            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ...showListAndMapButtons(width, height),
      
                  if (widget.choice == UserChoice.map) getMap(width, height)
                  else getList(cardSize),
                ],
              ),
            );
          }
        }
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
      String tmpTemperaturePreference = sharedPreferencesService.getTemperaturePreference();

      if (tmpUserId.isEmpty) return;
      if (tmpTypeOfUser.isEmpty) return;
      if (tmpLanguage.isEmpty) return;

      LanguageService tmpLang = LanguageService.getInstance(tmpLanguage);

      setState(() {
        widget.userId = tmpUserId;
        widget.lang = tmpLang;
        widget.temperaturePreference = tmpTemperaturePreference ?? "C";
        widget.headerValues["userId"] = tmpUserId;
        widget.headerValues["typeOfUser"] = tmpTypeOfUser;
        widget.headerValues["avatarImage"] = tmpAvatarImage ?? "";
      });
    });
  }

  Widget getList(double cardSize) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (widget.showEmptyCard == true)
          CardWidget(
            title: widget.lang!.translate('add_new_estate'),
            isEmptyCard: true,
            width: cardSize,
            lang: widget.lang!,
            height: cardSize * 0.5625,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EstateDetailsPage(isNewEstate: true, estate: Estate(name: Map.from({"en": "", "de": "", "hr": ""}))),
                ),
              );
            },
          ),
        const SizedBox(height: 36),

        for (int i = 0; i < widget.estates.length; ++i)
          ...[
            getEstateCard(cardSize, i),
            const SizedBox(height: 36),
          ],
      ]
    );
  }

  Widget getEstateCard(double cardSize, int index) {
    return CardWidget(
      lang: widget.lang!,
      title: "${widget.estates[index].city}, ${widget.estates[index].country}",
      subtitle: widget.estates[index].name![widget.lang!.language]!,
      width: cardSize,
      height: cardSize * 0.5625,
      coordinates: widget.estates[index].coordinates,
      temperaturePreference: widget.temperaturePreference!,
      backgroundImage: widget.estates[index].image.isNotEmpty ? widget.estates[index].image : "",
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EstateDetailsPage(estate: widget.estates[index],),
        ),
      ),
    );
  }

  Widget getMap(double width, double height) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 3,
          color: PalleteCommon.gradient3,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(3)),
      ),
      height: height * 0.8,
      width: width * 0.8,
      child: MapsWidget(
        estates: widget.estates,
        lang: widget.lang!,
      ),
    );
  }

  List<Widget> showListAndMapButtons(double width, double height) {
    return [
      const SizedBox(height: 26),
      if (widget.estates.isNotEmpty)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Expanded(child: SizedBox()),
            Expanded(
              flex: 2,
              child: optionButton(
                width,
                height,
                () => setState(() {
                  widget.choice = UserChoice.list;
                }),
                widget.lang!.translate('list'),
              ),
            ),
            Expanded(
              flex: 2,
              child: optionButton(
                width,
                height,
                () => setState(() {
                  widget.choice = UserChoice.map;
                }),
                widget.lang!.translate('map'),
              ),
            ),
            const Expanded(child: SizedBox()),
          ],
        ),
      if (widget.estates.isNotEmpty)
        const SizedBox(height: 26),
    ];
  }

  Widget optionButton(double width, double height, Function onPressed, String title) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(3),
        ),
        border: Border.all(
          color: Colors.white,
        ),
      ),
      width: width * 0.4,
      height: height * 0.05,
      child: ElevatedButton(
        style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(PalleteCommon.backgroundColor),
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
}
