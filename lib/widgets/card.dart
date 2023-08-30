import 'package:diplomski_rad/other/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math';
import 'dart:ui';

class CardWidget extends StatelessWidget {
  final String? city;
  final String? country;
  final String? name;
  final Image? backgroundImage;
  final bool isEmptyCard;

  final double height;
  final double width;

  final Color upperTextColor;
  final Color lowerTextColor;

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

  CardWidget({
    Key? key,
    this.city,
    this.country,
    this.name,
    required this.height,
    required this.width,
    this.backgroundImage,
    this.isEmptyCard = false,
    this.upperTextColor = Colors.white,
    this.lowerTextColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: setDecoration(),
      child: SizedBox(
        height: height * (isEmptyCard == false ? 1 : 0.75),
        width: width,
        child: Stack(
          children: [
            //...addBlur(),
            Padding(
              padding: EdgeInsets.only(
                  left: width * 0.04, top: width * 0.04, bottom: width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isEmptyCard
                        ? "Add a new estate"
                        : '${city != null ? "$city, " : ""}${country ?? ""}',
                    style: TextStyle(
                      fontSize: width * 0.036,
                      fontWeight: FontWeight.bold,
                      color: upperTextColor,
                    ),
                  ),
                  SizedBox(
                    height: height * 0.02,
                  ),
                  name != null
                      ? Text(
                          name!,
                          style: TextStyle(
                            fontSize: width * 0.026,
                            fontWeight: FontWeight.w300,
                            color: upperTextColor,
                          ),
                        )
                      : Container(),
                  Expanded(
                    child: Container(),
                  ),
                  if (!isEmptyCard)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          randomSvg(),
                          height: height! * 0.12,
                          width: width! * 0.12,
                          color: lowerTextColor,
                        ),
                        SizedBox(
                          width: width * 0.04,
                        ),
                        Center(
                          child: Text(
                            "15°C",
                            style: TextStyle(
                              fontSize: height! * 0.08,
                              color: lowerTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> addBlur() {
    return [
      ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(width * 0.043),
          topRight: Radius.circular(width * 0.043),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            height: height * 0.23,
          ),
        ),
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(width * 0.043),
            bottomRight: Radius.circular(width * 0.043),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
            child: Container(
              height: height * 0.2,
            ),
          ),
        ),
      ),
    ];
  }

  List<Color> randomColorPair() {
    var rng = Random();
    return colorPairs[rng.nextInt(colorPairs.length)];
  }

  String randomSvg() {
    var rng = Random();
    return "svgs/${svgs[rng.nextInt(svgs.length)]}";
  }

  BoxDecoration setDecoration() {
    if (backgroundImage != null) {
      return BoxDecoration(
        borderRadius: BorderRadius.circular(width * 0.043),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: backgroundImage!.image,
        ),
      );
    } else {
      return BoxDecoration(
        borderRadius: BorderRadius.circular(width * 0.043),
        gradient: LinearGradient(
          colors: [
            ...randomColorPair(),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.bottomRight,
        ),
      );
    }
  }
}
