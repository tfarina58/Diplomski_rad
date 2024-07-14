import 'dart:typed_data';
import 'package:diplomski_rad/interfaces/category.dart';
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
  final LatLng? coordinates;

  final bool isEmptyCard;
  bool? day;
  int? temperature;
  final String temperaturePreference;
  late final String? weather;
  final bool showSettings;
  
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

  Category? category;

  CardWidget({
    Key? key,
    this.title = "",
    this.subtitle = "",
    required this.height,
    required this.width,
    this.backgroundImage = "",
    this.isEmptyCard = false,
    this.upperTextColor = Colors.white,
    this.lowerTextColor = Colors.white,
    this.coordinates,
    this.temperaturePreference = "C",
    this.category,
    this.showSettings = false,
    required this.lang,
    // required this.type,
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
                        ? widget.lang.translate('add_new_estate')
                        : widget.title,
                    style: TextStyle(
                      fontSize: widget.width * 0.036,
                      fontWeight: FontWeight.bold,
                      color: widget.upperTextColor,
                    ),
                  ),
                  SizedBox(
                    height: widget.height * 0.02,
                  ),
                  widget.subtitle.isNotEmpty
                      ? Text(
                          widget.subtitle,
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
                        showWeather(),
                        SizedBox(width: widget.width * 0.04),
                        showTemperature(),
                      ],
                    ),
                ],
              ),
            ),
            if (widget.showSettings)
              Align(
                alignment: Alignment.topRight,
                child: SizedBox(
                  width: widget.width * 0.1,
                  height: widget.width * 0.1,
                  child: ElevatedButton(
                    onPressed: () => showImagesDialog(context, false),
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
    if (widget.backgroundImage.isNotEmpty && !widget.backgroundImage.contains("#")) {
      return BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(widget.width * 0.043),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(widget.backgroundImage),
        ),
      );
    } else if (widget.backgroundImage.isNotEmpty) {
      List<int> rgb = getRGBValues(widget.backgroundImage);
      return BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(widget.width * 0.043),
        gradient: LinearGradient(
          colors: [Color.fromARGB(1, rgb[0], rgb[1], rgb[2])],
          begin: Alignment.centerLeft,
          end: Alignment.bottomRight,
        ),
      );
    } else {
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
    }
  }

  List<int> getRGBValues(String rgbString) {
    if (rgbString.isEmpty) return [255, 255, 255];

    Map<String, int> hex = {'0': 0, '1': 1, '2': 2, '3': 3, '4': 4, '5': 5, '6': 6, '7': 7, '8': 8, '9': 9, 'a': 10, 'b': 11, 'c': 12, 'd': 13, 'e': 14, 'f': 15};
    List<int> res = [];

    rgbString = rgbString.toLowerCase();
    
    res[0] = hex[rgbString[1]]! * 16 + hex[rgbString[2]]!;
    res[1] = hex[rgbString[3]]! * 16 + hex[rgbString[4]]!;
    res[2] = hex[rgbString[5]]! * 16 + hex[rgbString[6]]!;

    return res;
  }

  List<Color> randomColorPair() {
    var rng = Random();
    return widget.colorPairs[rng.nextInt(widget.colorPairs.length)];
  }

  void showImagesDialog(BuildContext context, bool choice) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

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
                  SizedBox(height: height * 0.05,),
                  Center(
                    child: Row(
                      children: [
                        const Expanded(child: SizedBox()),
                        Expanded(
                          child: StringField(
                            labelText: widget.lang.translate('title_en'),
                            callback: (value) => widget.category!.title['en'] = value,
                            presetText: widget.category!.title['en']!,
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                        Expanded(
                          child: StringField(
                            labelText: widget.lang.translate('title_de'),
                            callback: (value) => widget.category!.title['de'] = value,
                            presetText: widget.category!.title['de']!,
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                        Expanded(
                          child: StringField(
                            labelText: widget.lang.translate('title_hr'),
                            callback: (value) => widget.category!.title['hr'] = value,
                            presetText: widget.category!.title['hr']!,
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.05,),
                  
                  if (widget.backgroundImage.isNotEmpty)
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
                                image: Image.network(widget.backgroundImage).image,
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
                                  widget.backgroundImage = "";
                                  widget.category!.image = "";
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
                  else if (widget.category!.tmpImageBytes != null)

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
                                image: Image.memory(widget.category!.tmpImageBytes!).image,
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
                                  widget.category!.tmpImageBytes = null;
                                  widget.category!.tmpImageName = "";
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
                      lang: widget.lang,
                      onDroppedFile: (Map<String, dynamic>? file) {
                        if (file == null) return;

                        setState(() {
                          widget.category!.tmpImageName = file['name'];
                          widget.category!.tmpImageBytes = file['bytes'];
                        });
                      },
                    ),

                  SizedBox(height: height * 0.05,),
                  GradientButton(buttonText: widget.lang.translate('save_changes'), callback: saveChanges)
                ],
              ),
            );
          },
        ),
      );
    });
  }

  Widget showWeather() {
    if (widget.day == null || widget.weather == null) return const SizedBox();
    
    return SvgPicture.asset(
      "svgs/${widget.day! ? widget.weather : "night"}.svg",
      height: widget.height * 0.12,
      width: widget.width * 0.12,
      color: widget.lowerTextColor,
    );
  }

  Widget showTemperature() {
    String text = "";
    if (widget.temperature != null) text = "${widget.temperature}°${widget.temperaturePreference}"; 
    
    return Center(
      child: Text(
        text,
        style: TextStyle(
          fontSize: widget.height * 0.08,
          color: widget.lowerTextColor,
        ),
      ),
    );
  }

  Future<void> saveChanges() async {
    if (widget.category!.image.isEmpty && widget.category!.tmpImageBytes != null) {
      widget.category!.image = await uploadNewSlideImage();
    }

    Map<String, dynamic>? categoryMap = Category.toJSON(widget.category);

    if (categoryMap == null) return;

    bool res = await CategoryRepository.updateCategory(widget.category!.id, categoryMap);
    if (res) {
      final snackBar = SnackBar(
        content: Text(widget.lang.translate('account_successfully_updated')),
        backgroundColor: (Colors.white),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: widget.height * 0.85,
          left: widget.width * 0.8,
          right: widget.width * 0.02,
          top: widget.height * 0.02,
        ),
        closeIconColor: PalleteCommon.gradient2,
        action: SnackBarAction(
          label: widget.lang.translate('dismiss'),
          onPressed: () {},
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    final snackBar = SnackBar(
      backgroundColor: PalleteCommon.gradient2,
      content: Text(widget.lang.translate('error_while_updating_user')),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
        bottom: widget.height * 0.85,
        left: widget.width * 0.8,
        right: widget.width * 0.02,
        top: widget.height * 0.02,
      ),
      closeIconColor: PalleteCommon.gradient2,
      action: SnackBarAction(
        label: widget.lang.translate('dismiss'),
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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

