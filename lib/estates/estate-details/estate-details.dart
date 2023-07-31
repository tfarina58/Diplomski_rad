import 'package:diplomski_rad/components/header.dart';
import 'package:flutter/material.dart';
import 'package:diplomski_rad/other/pallete.dart';
import 'package:diplomski_rad/widgets/string_field.dart';
import 'package:diplomski_rad/widgets/gradient_button.dart';
import 'package:diplomski_rad/interfaces/estate/estate.dart';
import 'dart:math';

class EstateDetailsPage extends StatefulWidget {
  CompanyEstate? companyEstate;
  IndividualEstate? individualEstate;

  EstateDetailsPage({Key? key, this.companyEstate, this.individualEstate})
      : super(key: key);

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
      Pallete.gradient1,
      Pallete.gradient3,
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
    final double size = MediaQuery.of(context).size.width;
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
                      ...getImages(size),
                      if (isHovering)
                        Padding(
                          // padding: EdgeInsets.fromLTRB(300, 100, 0, 100),
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () => showDialog(
                                context: context,
                                builder: (BuildContext context) => const Dialog(
                                  backgroundColor: Pallete.backgroundColor,
                                  alignment: Alignment.center,
                                  child: Center(
                                    child: Text("Text"),
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
                                    Text("Manage photos and templates"),
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
                      const SizedBox(height: 60),
                      StringField(
                        labelText: 'Street',
                        callback: (value) => widget.individualEstate != null
                            ? widget.individualEstate!.street = value
                            : widget.companyEstate != null
                                ? widget.companyEstate!.street = value
                                : null,
                        presetText: widget.individualEstate != null
                            ? widget.individualEstate!.street
                            : widget.companyEstate != null
                                ? widget.companyEstate!.street
                                : null,
                      ),
                      const SizedBox(height: 15),
                      StringField(
                        labelText: 'Zip',
                        callback: (value) => widget.individualEstate != null
                            ? widget.individualEstate!.zip = value
                            : widget.companyEstate != null
                                ? widget.companyEstate!.zip = value
                                : null,
                        presetText: widget.individualEstate != null
                            ? widget.individualEstate!.zip
                            : widget.companyEstate != null
                                ? widget.companyEstate!.zip
                                : null,
                      ),
                      const SizedBox(height: 15),
                      StringField(
                        labelText: 'City',
                        callback: (value) => widget.individualEstate != null
                            ? widget.individualEstate!.city = value
                            : widget.companyEstate != null
                                ? widget.companyEstate!.city = value
                                : null,
                        presetText: widget.individualEstate != null
                            ? widget.individualEstate!.city
                            : widget.companyEstate != null
                                ? widget.companyEstate!.city
                                : null,
                      ),
                      const SizedBox(height: 15),
                      StringField(
                        labelText: 'Country',
                        callback: (value) => widget.individualEstate != null
                            ? widget.individualEstate!.country = value
                            : widget.companyEstate != null
                                ? widget.companyEstate!.country = value
                                : null,
                        presetText: widget.individualEstate != null
                            ? widget.individualEstate!.country
                            : widget.companyEstate != null
                                ? widget.companyEstate!.country
                                : null,
                      ),
                      const SizedBox(height: 15),
                      StringField(
                        labelText: 'Coordinates',
                        callback: (value) => widget.individualEstate != null
                            ? widget.individualEstate!.coordinates = value
                            : widget.companyEstate != null
                                ? widget.companyEstate!.coordinates = value
                                : null,
                        presetText: coorToStr(),
                        readOnly: true,
                      ),
                      const SizedBox(height: 15),
                      StringField(
                        labelText: 'Phone',
                        callback: (value) => widget.individualEstate != null
                            ? widget.individualEstate!.phone = value
                            : widget.companyEstate != null
                                ? widget.companyEstate!.phone = value
                                : null,
                        presetText: widget.individualEstate != null
                            ? widget.individualEstate!.phone
                            : widget.companyEstate != null
                                ? widget.companyEstate!.phone
                                : null,
                      ),
                      const SizedBox(height: 15),
                      StringField(
                        labelText: 'Description',
                        callback: (value) => widget.individualEstate != null
                            ? widget.individualEstate!.description = value
                            : widget.companyEstate != null
                                ? widget.companyEstate!.description = value
                                : null,
                        presetText: widget.individualEstate != null
                            ? widget.individualEstate!.description
                            : widget.companyEstate != null
                                ? widget.companyEstate!.description
                                : null,
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
    print("Init 2");

    super.initState();
  }

  String coorToStr() {
    return '45.083333, 13.6333308';
  }

  List<Widget> getImages(double size) {
    List<Widget> res = [];

    if (widget.individualEstate != null) {
      for (int i = 0;
          i < widget.individualEstate!.images.length && i < 3;
          ++i) {
        res.add(
          Padding(
            padding: EdgeInsets.fromLTRB(
                i * 100 + 100, 300 - i * 100, 300 - i * 100, i * 100 + 100),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(16),
              ),
              child: Hero(
                tag: widget.individualEstate!.images[
                    widget.individualEstate!.images.length > 3
                        ? 2 - i
                        : widget.individualEstate!.images.length - 1 - i],
                child: Image(
                  width: size,
                  height: size * 0.5625,
                  image: AssetImage(
                    widget.individualEstate!.images[
                        widget.individualEstate!.images.length > 3
                            ? 2 - i
                            : widget.individualEstate!.images.length - 1 - i],
                  ),
                ),
              ),
            ),
          ),
        );
      }
    } else if (widget.companyEstate != null) {
      for (int i = 0; i < widget.companyEstate!.images.length && i < 3; ++i) {
        res.add(
          Padding(
            padding: EdgeInsets.fromLTRB(
                i * 100 + 100, 300 - i * 100, 300 - i * 100, i * 100 + 100),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(16),
              ),
              child: Hero(
                tag: widget.companyEstate!.images[
                    widget.companyEstate!.images.length > 3
                        ? 2 - i
                        : widget.companyEstate!.images.length - 1 - i],
                child: Image(
                  width: size,
                  height: size * 0.5625,
                  image: AssetImage(
                    widget.companyEstate!.images[
                        widget.companyEstate!.images.length > 3
                            ? 2 - i
                            : widget.companyEstate!.images.length - 1 - i],
                  ),
                ),
              ),
            ),
          ),
        );
      }
    }
    return res;
  }

  void saveChanges() {
    if (widget.companyEstate != null) {
      print(widget.companyEstate!.name);
      print(widget.companyEstate!.street);
      print(widget.companyEstate!.zip);
      print(widget.companyEstate!.city);
      print(widget.companyEstate!.country);
      print(widget.companyEstate!.coordinates);
      print(widget.companyEstate!.phone);
      print(widget.companyEstate!.description);
    } else if (widget.individualEstate != null) {
      print(widget.individualEstate!.name);
      print(widget.individualEstate!.street);
      print(widget.individualEstate!.zip);
      print(widget.individualEstate!.city);
      print(widget.individualEstate!.country);
      print(widget.individualEstate!.coordinates);
      print(widget.individualEstate!.phone);
      print(widget.individualEstate!.description);
    }
  }
}
