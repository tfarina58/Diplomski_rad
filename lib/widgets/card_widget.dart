import 'dart:typed_data';
import 'package:diplomski_rad/interfaces/category.dart';
import 'package:diplomski_rad/interfaces/estate.dart';
import 'package:diplomski_rad/interfaces/user-preferences.dart';
import 'package:diplomski_rad/services/language.dart';
import 'package:diplomski_rad/services/weather.dart';
import 'package:diplomski_rad/services/firebase.dart';
import 'package:diplomski_rad/other/pallete.dart';
import 'package:diplomski_rad/widgets/gradient_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math';
import 'package:diplomski_rad/widgets/dropzone_widget.dart';
import 'package:diplomski_rad/widgets/string_field.dart';
import 'dart:ui';

class CardWidget extends StatefulWidget {
  final String title;
  final String subtitle;
  String backgroundImage;
  List<Color> backgroundColors;
  final LatLng? coordinates;
  Function onTap;
  Function? onSettingsTap;

  final bool isEmptyCard;
  final String emptyCardTitle;
  final bool showSettings;

  bool? day;
  String? weather;
  int? temperature;
  final String temperaturePreference;
  
  final LanguageService lang;
  bool isDisposed = false;

  final double height;
  final double width;

  final Color upperTextColor;
  final Color lowerTextColor;
  
  Estate? estate;
  Category? category;

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
    required this.height,
    required this.width,
    required this.lang,
    required this.onTap,
    this.title = "",
    this.subtitle = "",
    this.backgroundImage = "",
    this.backgroundColors = const [],
    this.isEmptyCard = false,
    this.emptyCardTitle = "",
    this.upperTextColor = Colors.white,
    this.lowerTextColor = Colors.white,
    this.coordinates,
    this.temperaturePreference = "C",
    this.estate,
    this.category,
    this.showSettings = false,
    this.onSettingsTap,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onTap(),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          height: widget.height * (widget.isEmptyCard == false ? 1 : 0.75),
          width: widget.width,
          decoration: setDecoration(),
          child: SizedBox(
            child: Stack(
              children: [
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
                        widget.title,
                        style: TextStyle(
                          fontSize: widget.width * 0.036,
                          fontWeight: FontWeight.bold,
                          color: widget.upperTextColor,
                        ),
                      ),
                      SizedBox(height: widget.height * 0.02),
                      Text(
                        widget.subtitle.isNotEmpty ? widget.subtitle : "",
                        style: TextStyle(
                          fontSize: widget.width * 0.026,
                          fontWeight: FontWeight.w300,
                          color: widget.upperTextColor,
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      showWeatherAndTemperature(),
                    ],
                  ),
                ),
                showSettingsIcon(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.coordinates == null) return;
      if (widget.isDisposed) return;

      Map<String, dynamic>? tmpWeather = await OpenWeatherMap.getWeather(widget.coordinates!);
      if (tmpWeather == null) return;

      setState(() {
        widget.weather = (tmpWeather["weather"][0]["main"][0] as String).toLowerCase() + (tmpWeather["weather"][0]["main"] as String).substring(1);
        widget.day = tmpWeather["sys"]["sunrise"] < tmpWeather["dt"] && tmpWeather["dt"] < tmpWeather["sys"]["sunset"];
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

  BoxDecoration setDecoration() {
    if (widget.backgroundImage.isNotEmpty) {
      return BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(widget.width * 0.043),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(widget.backgroundImage),
        ),
      );
    } else {
      if (widget.backgroundColors.isEmpty) {
        var rng = Random();
        widget.backgroundColors = widget.colorPairs[rng.nextInt(widget.colorPairs.length)];
      }

      return BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(widget.width * 0.043),
        gradient: LinearGradient(
          colors: widget.backgroundColors,
          begin: Alignment.centerLeft,
          end: Alignment.bottomRight,
        ),
      );
    }
  }

  Widget showWeatherAndTemperature() {
    Widget weather;

    if (widget.day == null || widget.weather == null) {
      weather = const SizedBox();
    } else {
      weather = SvgPicture.asset(
        "svgs/${widget.day! ? widget.weather : "night"}.svg",
        height: widget.height * 0.12,
        width: widget.width * 0.12,
        color: widget.lowerTextColor,
      );
    }

    String text = "";
    if (widget.temperature != null) text = "${widget.temperature}°${widget.temperaturePreference}"; 
    
    Widget temperature = Center(
      child: Text(
        text,
        style: TextStyle(
          fontSize: widget.height * 0.08,
          color: widget.lowerTextColor,
        ),
      ),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        weather,
        SizedBox(width: widget.width * 0.04),
        temperature,
      ],
    );
  }

  Widget showSettingsIcon() {
    if (widget.showSettings) {
      return Align(
        alignment: Alignment.topRight,
        child: SizedBox(
          width: widget.width * 0.1,
          height: widget.width * 0.1,
          child: ElevatedButton(
            onPressed: () =>
              widget.onSettingsTap != null ?
              widget.onSettingsTap!() :
              () {}, // () => showImagesDialog(context, false),
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(PalleteHint.gradient3),
            ),
            child: Center(
              child: Icon(
                Icons.settings,
                size: widget.width * 0.045,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    }
    return const SizedBox();
  }

  

  Future<String> uploadNewSlideImage() async {
    FirebaseStorageService storage = FirebaseStorageService();
    await storage.uploadImageForCategory(
      widget.category!,
      widget.category!.tmpImageName!,
      widget.category!.tmpImageBytes!
    );
    
    return await storage.downloadImage(
      widget.category!.id,
      widget.category!.tmpImageName!,
    );
  }
}

