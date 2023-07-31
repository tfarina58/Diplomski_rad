import 'package:diplomski_rad/other/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math';

class CardWidget extends StatelessWidget {
  final String? city;
  final String? country;
  final String? name;
  final double? height;
  final double? width;
  final Image? backgroundImage;

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

  CardWidget({
    Key? key,
    this.city,
    this.country,
    this.name,
    this.height,
    this.width,
    this.backgroundImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: setDecoration(),
      child: SizedBox(
        height: height,
        width: width,
        child: Padding(
          padding: EdgeInsets.only(
              left: width! * 0.04, top: width! * 0.04, bottom: width! * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${city!}, ${country!}',
                style: TextStyle(
                    fontSize: width! * 0.036,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(
                height: height! * 0.02,
              ),
              name != null
                  ? Text(
                      name!,
                      style: TextStyle(
                          fontSize: width! * 0.026,
                          fontWeight: FontWeight.w300,
                          color: Colors.white),
                    )
                  : Container(),
              Expanded(
                child: Container(),
              ),
              SvgPicture.asset(
                randomSvg(),
                height: height! * 0.2,
                width: width! * 0.2,
                color: Colors.white,
              )
            ],
          ),
        ),
      ),
    );
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
        borderRadius: BorderRadius.circular(width! * 0.043),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: backgroundImage!.image,
        ),
      );
    } else {
      return BoxDecoration(
        borderRadius: BorderRadius.circular(width! * 0.043),
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
