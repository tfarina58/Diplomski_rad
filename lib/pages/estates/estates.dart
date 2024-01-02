import 'package:diplomski_rad/interfaces/estate.dart';
import 'package:flutter/material.dart';
import 'package:diplomski_rad/widgets/header_widget.dart';
import 'package:diplomski_rad/widgets/card_widget.dart';
import 'package:diplomski_rad/other/pallete.dart';
import 'package:diplomski_rad/pages/estates/estate-details.dart';
import 'package:diplomski_rad/widgets/maps.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:diplomski_rad/services/language.dart';

enum UserChoice { list, map }

class EstatesPage extends StatefulWidget {
  // If user searches for its own estates, only the userId will be set (for StreamBuilder and HeaderComponent)
  String? userId;
  // If customer is also set, the user searches for other people's estates, hence the userId will be used only for HeaderComponent
  String? searchedCustomerId;

  List<Estate> estates = [];
  final bool showEmptyCard;
  UserChoice choice = UserChoice.list;
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
    double cardSize = MediaQuery.of(context).size.width * 0.4166;

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    if (widget.lang == null || widget.userId == null) {
      return const SizedBox();
    }

    return Scaffold(
      appBar: HeaderComponent(
        currentPage: 'EstatesPage',
        lang: widget.lang!,
        headerValues: widget.headerValues,
      ),
      body: SizedBox(
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 26,
                ),
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
                          widget.lang!.dictionary["list"]!,
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
                          widget.lang!.dictionary["map"]!,
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                const SizedBox(
                  height: 26,
                ),
                if (widget.choice == UserChoice.map)
                  getMap(width, height)
                else
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: getList(cardSize),
                  )
              ],
            ),
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
        widget.userId = tmpUserId;
        widget.lang = tmpLang;
        widget.headerValues["userId"] = tmpUserId;
        widget.headerValues["typeOfUser"] = tmpTypeOfUser;
        widget.headerValues["avatarImage"] = tmpAvatarImage ?? "";
      });
    });
  }

  List<Widget> getList(double cardSize) {
    List<Widget> res = [];

    if (widget.showEmptyCard == true) {
      res.add(
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  EstateDetailsPage(isNew: true, estate: Estate()),
            ),
          ),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: CardWidget(
              isEmptyCard: true,
              width: cardSize,
              lang: widget.lang!,
              height: cardSize * 0.5625,
            ),
          ),
        ),
      );
    }
    res.add(
      SizedBox(
        height: 36,
        width: MediaQuery.of(context).size.width,
      ),
    );

    res.add(
      StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('estates')
            .where('ownerId',
                isEqualTo: widget.searchedCustomerId!.isNotEmpty
                    ? widget.searchedCustomerId
                    : widget.userId)
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
            Estate? tmp;

            if (document == null) return Text('Error: ${snapshot.error}');

            List<Estate> tmpEstates = [];
            document.map((DocumentSnapshot doc) {
              Map<String, dynamic>? tmpMap =
                  doc.data() as Map<String, dynamic>?;

              if (tmpMap == null) return;

              tmpMap['id'] = doc.id;

              tmp = Estate.toEstate(tmpMap);
              if (tmp == null) return;

              print(tmp);
              tmpEstates.add(tmp!);
            }).toList();

            widget.estates = tmpEstates;
            print("Estates: ${widget.estates}");

            if (widget.estates.isEmpty) {
              return Text(widget.lang!.dictionary["no_estates"]!);
            }

            return Column(
              children: [
                for (int i = 0; i < widget.estates.length; ++i) ...[
                  getRow(cardSize, i),
                  SizedBox(
                    height: 36,
                    width: MediaQuery.of(context).size.width,
                  ),
                ],
              ],
            );
          }
        },
      ),
    );
    return res;
  }

  Widget getRow(double cardSize, int index) {
    if (widget.estates[index].image.isNotEmpty) {
      return Hero(
        tag: widget.estates[index].image,
        child: GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  EstateDetailsPage(estate: widget.estates[index]),
            ),
          ),
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: CardWidget(
              lang: widget.lang!,
              city: widget.estates[index].city,
              country: widget.estates[index].country,
              name: widget.estates[index].name,
              width: cardSize,
              height: cardSize * 0.5625,
              coordinates: widget.estates[index].coordinates,
              backgroundImage: widget.estates[index].image,
            ),
          ),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                EstateDetailsPage(estate: widget.estates[index]),
          ),
        ),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: CardWidget(
            lang: widget.lang!,
            city: widget.estates[index].city,
            country: widget.estates[index].country,
            name: widget.estates[index].name,
            width: cardSize,
            height: cardSize * 0.5625,
            coordinates: widget.estates[index].coordinates,
          ),
        ),
      );
    }
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
          estates: widget.estates /*, customerId: widget.customerId*/),
    );
  }

  Widget optionButton(
      double width, double height, Function onPressed, String title) {
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
}
