import 'package:diplomski_rad/interfaces/preferences/user-preferences.dart';
import 'package:diplomski_rad/services/language.dart';
import 'package:diplomski_rad/services/weather.dart';
import 'package:diplomski_rad/other/pallete.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math';
import 'dart:ui';

class CardWidget extends StatefulWidget {
  final String? city;
  final String? country;
  final String? name;
  final String? backgroundImage;
  final bool isEmptyCard;
  final LatLng? coordinates;
  late final String? weather;
  bool? day;
  int? temperature;
  final String temperaturePreference;
  final LanguageService lang;

  bool isDisposed = false;

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
    this.coordinates,
    this.temperaturePreference = "C",
    required this.lang,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height * (widget.isEmptyCard == false ? 1 : 0.75),
      width: widget.width,
      decoration: setDecoration(),
      child: SizedBox(
        child: Stack(
          children: [
            //...addBlur(),
            Padding(
              padding: EdgeInsets.only(
                  left: widget.width * 0.04,
                  top: widget.width * 0.04,
                  bottom: widget.width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.isEmptyCard
                        ? widget.lang.dictionary["add_new_estate"]!
                        : '${widget.city != null ? "${widget.city}, " : ""}${widget.country ?? ""}',
                    style: TextStyle(
                      fontSize: widget.width * 0.036,
                      fontWeight: FontWeight.bold,
                      color: widget.upperTextColor,
                    ),
                  ),
                  SizedBox(
                    height: widget.height * 0.02,
                  ),
                  widget.name != null
                      ? Text(
                          widget.name!,
                          style: TextStyle(
                            fontSize: widget.width * 0.026,
                            fontWeight: FontWeight.w300,
                            color: widget.upperTextColor,
                          ),
                        )
                      : Container(),
                  Expanded(
                    child: Container(),
                  ),
                  if (!widget.isEmptyCard)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        widget.day != null && widget.weather != null
                            ? SvgPicture.asset(
                                "svgs/${widget.day! ? widget.weather : "night"}.svg",
                                height: widget.height * 0.12,
                                width: widget.width * 0.12,
                                color: widget.lowerTextColor,
                              )
                            : const SizedBox(),
                        SizedBox(
                          width: widget.width * 0.04,
                        ),
                        Center(
                          child: Text(
                            widget.temperature != null
                                ? "${widget.temperature}°${widget.temperaturePreference}"
                                : "",
                            style: TextStyle(
                              fontSize: widget.height * 0.08,
                              color: widget.lowerTextColor,
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

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.coordinates == null) return;
      if (widget.isDisposed) return;

      Map<String, dynamic>? tmpWeather =
          await OpenWeatherMap.getWeather(widget.coordinates!);

      if (tmpWeather == null) return;

      setState(() {
        widget.weather =
            (tmpWeather["weather"][0]["main"][0] as String).toLowerCase() +
                (tmpWeather["weather"][0]["main"] as String).substring(1);

        widget.day = tmpWeather["sys"]["sunrise"] < tmpWeather["dt"] &&
            tmpWeather["dt"] < tmpWeather["sys"]["sunset"];

        widget.temperature = widget.temperaturePreference == "F"
            ? UserPreferences.K2F(tmpWeather["main"]["temp"]).toInt()
            : UserPreferences.K2C(tmpWeather["main"]["temp"]).toInt();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    widget.isDisposed = true;
    super.dispose();
  }

  List<Widget> addBlur() {
    return [
      ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(widget.width * 0.043),
          topRight: Radius.circular(widget.width * 0.043),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            height: widget.height * 0.23,
          ),
        ),
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(widget.width * 0.043),
            bottomRight: Radius.circular(widget.width * 0.043),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2.5, sigmaY: 2.5),
            child: Container(
              height: widget.height * 0.2,
            ),
          ),
        ),
      ),
    ];
  }

  List<Color> randomColorPair() {
    var rng = Random();
    return widget.colorPairs[rng.nextInt(widget.colorPairs.length)];
  }

  BoxDecoration setDecoration() {
    /*if (widget.backgroundImage != null) {
      return BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(widget.width * 0.043),
        image: DecorationImage(
          fit: BoxFit.cover,
          // image: Image.asset("images/chick.jpg").image,
          image: NetworkImage(widget.backgroundImage!),
        ),
      );
    } else {*/
    return BoxDecoration(
      border: Border.all(color: Colors.white),
      borderRadius: BorderRadius.circular(widget.width * 0.043),
      gradient: LinearGradient(
        colors: [
          ...randomColorPair(),
        ],
        begin: Alignment.centerLeft,
        end: Alignment.bottomRight,
      ),
    );
    //}
  }
}
