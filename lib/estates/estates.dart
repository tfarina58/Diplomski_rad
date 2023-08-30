import 'dart:math';

import 'package:diplomski_rad/interfaces/coordinates/coordinates.dart';
import 'package:diplomski_rad/interfaces/estate/estate.dart';
import 'package:flutter/material.dart';
import 'package:diplomski_rad/components/header.dart';
import 'package:diplomski_rad/widgets/card.dart';
import 'package:diplomski_rad/other/pallete.dart';
import 'package:diplomski_rad/estates/estate-details/estate-details.dart';
import 'package:diplomski_rad/widgets/maps.dart';
import 'package:diplomski_rad/interfaces/user/user.dart';

enum UserChoice { list, map }

class EstatesPage extends StatefulWidget {
  final double cardSize = 800;
  final bool showEmptyCard;
  UserChoice choice = UserChoice.list;

  User user = Individual.getUser1();

  List<Estate> estates = [
    IndividualEstate.getEstate1(),
    IndividualEstate.getEstate2(),
    IndividualEstate.getEstate3(),
  ];

  EstatesPage({
    Key? key,
    this.showEmptyCard = true,
  }) : super(key: key);

  @override
  State<EstatesPage> createState() => _EstatesPageState();
}

class _EstatesPageState extends State<EstatesPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: HeaderComponent(currentPage: 'EstatesPage'),
      body: SizedBox(
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: widget.estates.isNotEmpty
                ? Column(
                    children: [
                      const SizedBox(
                        height: 26,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: width * 0.2,
                          ),
                          optionButton(
                            width,
                            height,
                            () => setState(() {
                              widget.choice = UserChoice.list;
                            }),
                            "List",
                          ),
                          optionButton(
                            width,
                            height,
                            () => setState(() {
                              widget.choice = UserChoice.map;
                            }),
                            "Map",
                          ),
                          SizedBox(
                            width: width * 0.2,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 26,
                      ),
                      if (widget.choice == UserChoice.map)
                        getMap(width, height)
                      else
                        ...getList(),
                    ],
                  )
                : const Text("There are no estates to be shown!"),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  List<Widget> getList() {
    List<Widget> res = [];

    res.add(
      GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EstateDetailsPage(
              estate: (widget.user is Individual)
                  ? IndividualEstate()
                  : CompanyEstate(),
            ),
          ),
        ),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: CardWidget(
            isEmptyCard: widget.showEmptyCard,
            width: widget.cardSize,
            height: widget.cardSize * 0.5625,
          ),
        ),
      ),
    );
    res.add(
      SizedBox(
        height: 36,
        width: MediaQuery.of(context).size.width,
      ),
    );

    if (widget.estates.isNotEmpty) {
      for (int i = 0; i < widget.estates.length; ++i) {
        res.add(
          Hero(
            tag: widget.estates[i].images[0],
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EstateDetailsPage(estate: widget.estates[i]),
                ),
              ),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: CardWidget(
                  city: widget.estates[i].city,
                  country: widget.estates[i].country,
                  name: widget.estates[i].name,
                  width: widget.cardSize,
                  height: widget.cardSize * 0.5625,
                  backgroundImage: widget.estates[i].images.isNotEmpty
                      ? Image(
                          image: AssetImage(widget.estates[i].images[0]),
                        )
                      : null,
                ),
              ),
            ),
          ),
        );
        res.add(
          SizedBox(
            height: 36,
            width: MediaQuery.of(context).size.width,
          ),
        );
      }
    }
    return res;
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
      child: MapsWidget(),
    );
  }

  Widget optionButton(
      double width, double height, Function onPressed, String title) {
    return Expanded(
      flex: 1,
      child: Container(
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
      ),
    );
  }
}
