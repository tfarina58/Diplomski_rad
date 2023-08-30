import 'package:diplomski_rad/components/header.dart';
import 'package:flutter/material.dart';
import 'package:diplomski_rad/other/pallete.dart';
import 'package:diplomski_rad/widgets/string_field.dart';
import 'package:diplomski_rad/widgets/gradient_button.dart';
import 'package:diplomski_rad/interfaces/estate/estate.dart';
import 'package:diplomski_rad/estates/estate-details/manage-presentation/manage-presentation.dart';
import 'dart:math';

class EstateDetailsPage extends StatefulWidget {
  Estate estate;

  EstateDetailsPage({Key? key, required this.estate}) : super(key: key);

  @override
  State<EstateDetailsPage> createState() => _EstateDetailsPageState();
}

class _EstateDetailsPageState extends State<EstateDetailsPage> {
  Random rand = Random();
  bool isHovering = false;

  final List<List<Color>> colorPairs = [
    [
      const Color.fromARGB(15, 244, 65, 223),
      const Color.fromARGB(255, 78, 129, 235)
    ],
    [
      PalleteCommon.gradient1,
      PalleteCommon.gradient3,
    ],
    [
      const Color.fromARGB(255, 254, 81, 1),
      const Color.fromARGB(255, 129, 69, 0)
    ],
    [
      const Color.fromARGB(255, 1, 105, 88),
      const Color.fromARGB(255, 20, 207, 61)
    ],
    [
      const Color.fromARGB(255, 8, 23, 241),
      const Color.fromARGB(255, 7, 159, 185)
    ],
    [
      const Color.fromARGB(255, 77, 77, 77),
      const Color.fromARGB(255, 185, 167, 7)
    ],
  ];

  final List<String> svgs = [
    "cloudy.svg",
    "thunder.svg",
    "tornado.svg",
    "umbrella.svg",
    "windy.svg",
  ];

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: HeaderComponent(currentPage: 'EstateDetailsPage'),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(32.0),
          child: Row(
            children: [
              Expanded(
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
                      ...getImages(width),
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
                                child: const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.manage_search,
                                      color: Colors.white,
                                    ),
                                    Text("Manage presentation"),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
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
                      const Text(
                        "General information",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      StringField(
                        labelText: 'Street',
                        callback: (value) => widget.estate.street = value,
                        presetText: widget.estate.street,
                      ),
                      const SizedBox(height: 15),
                      StringField(
                        labelText: 'Zip',
                        callback: (value) => widget.estate.zip = value,
                        presetText: widget.estate.zip,
                      ),
                      const SizedBox(height: 15),
                      StringField(
                        labelText: 'City',
                        callback: (value) => widget.estate.city = value,
                        presetText: widget.estate.city,
                      ),
                      const SizedBox(height: 15),
                      StringField(
                        labelText: 'Country',
                        callback: (value) => widget.estate.country = value,
                        presetText: widget.estate.country,
                      ),
                      const SizedBox(height: 15),
                      StringField(
                        labelText: 'Phone',
                        callback: (value) => widget.estate.phone = value,
                        presetText: widget.estate.phone,
                      ),
                      const SizedBox(height: 15),
                      StringField(
                        labelText: 'Description',
                        callback: (value) => widget.estate.description = value,
                        presetText: widget.estate.description,
                        multiline: 5,
                      ),
                      const SizedBox(height: 30),
                      GradientButton(
                        buttonText: 'Save changes',
                        callback: saveChanges,
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
                tag: widget.estate!.images[widget.estate!.images.length > 3
                    ? 2 - i
                    : widget.estate!.images.length - 1 - i],
                child: Image(
                  width: width,
                  height: width * 0.5625,
                  image: AssetImage(
                    widget.estate!.images[widget.estate!.images.length > 3
                        ? 2 - i
                        : widget.estate!.images.length - 1 - i],
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
              tag: widget.estate!.images[widget.estate!.images.length > 3
                  ? 2 - i
                  : widget.estate!.images.length - 1 - i],
              child: Image(
                width: width,
                height: width * 0.5625,
                image: AssetImage(
                  widget.estate!.images[widget.estate!.images.length > 3
                      ? 2 - i
                      : widget.estate!.images.length - 1 - i],
                ),
              ),
            ),
          ),
        ),
      );
    }
    return res;
  }

  void saveChanges() {}
}
