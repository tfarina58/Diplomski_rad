import 'package:diplomski_rad/widgets/header_widget.dart';
import 'package:diplomski_rad/services/firebase.dart';
import 'package:diplomski_rad/widgets/dropzone_widget.dart';
import 'package:flutter/material.dart';
import 'package:diplomski_rad/widgets/string_field.dart';
import 'package:diplomski_rad/widgets/gradient_button.dart';
import 'package:diplomski_rad/interfaces/estate.dart';
import 'package:diplomski_rad/interfaces/presentation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:diplomski_rad/services/language.dart';
import 'package:diplomski_rad/other/pallete.dart';
import 'package:diplomski_rad/widgets/images_display_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EstateDetailsPage extends StatefulWidget {
  String? userId;
  Estate estate;
  bool isNew;
  LanguageService? lang;
  Map<String, dynamic> headerValues = <String, dynamic>{};
  int currentPage = 0;

  EstateDetailsPage({
    Key? key,
    required this.estate,
    this.isNew = false,
  }) : super(key: key);

  @override
  State<EstateDetailsPage> createState() => _EstateDetailsPageState();
}

class _EstateDetailsPageState extends State<EstateDetailsPage> {
  final controller = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    if (widget.lang == null || widget.userId == null) {
      return const SizedBox();
    }

    return Scaffold(
      appBar: HeaderComponent(
        currentPage: 'EstateDetailsPage',
        lang: widget.lang!,
        headerValues: widget.headerValues,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: widget.estate.id.isEmpty
            ? displayBody(width, height)
            : StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('estates')
                    .doc(widget.estate.id)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator(
                      color: PalleteCommon.gradient2,
                      semanticsLabel: widget.lang!.dictionary["loading"],
                      backgroundColor: PalleteCommon.backgroundColor,
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final estateMap = snapshot.data?.data();
                    if (estateMap == null)
                      return Text('Error: ${snapshot.error}');
                    estateMap['id'] = snapshot.data!.id;

                    Estate? estate = Estate.toEstate(estateMap);
                    if (estate == null) {
                      return const Text('Error: Can\'t proccess data!');
                    }

                    widget.estate = estate;
                    return displayBody(width, height);
                  }
                },
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

  Widget displayBody(double width, double height) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ImagesDisplay(
              estate: widget.estate,
              lang: widget.lang!,
              showAvatar: false,
              enableEditing: !widget.isNew,
            ),
            SizedBox(
              width: width,
              height: height * 0.1,
            ),
            ...generalInformation(height),
            SizedBox(
              width: width,
              height: height * 0.08,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Center(
                    child: Text(
                      widget.lang!.dictionary["slides"]!,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const Expanded(
                  flex: 5,
                  child: SizedBox(),
                ),
              ],
            ),
            SizedBox(
              height: height * 0.04,
            ),
            StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    showPresentationOptions(width, height, setState),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        buttonShowPrevSlide(width, height, setState),
                        showPresentation(width, height, setState),
                        buttonShowNextSlide(width, height, setState),
                      ],
                    ),
                  ],
                );
              },
            ),
            SizedBox(
              height: height * 0.08,
            ),
            StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return showSlideMap(width, setState);
              },
            ),
            SizedBox(
              height: height * 0.08,
            ),
            optionButtons(width, height),
            const SizedBox(
              height: 65,
            ),
          ],
        ),
      ),
    );
  }

  Widget buttonShowPrevSlide(
      double width, double height, StateSetter setState) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor:
            const MaterialStatePropertyAll(PalleteCommon.backgroundColor),
        minimumSize: MaterialStatePropertyAll(
          Size(width * 0.1, height * 0.81),
        ),
      ),
      onPressed: () {
        if (widget.currentPage > 0) {
          controller.animateToPage(
            widget.currentPage - 1,
            duration: const Duration(milliseconds: 350),
            curve: Curves.linear,
          );
          widget.currentPage -= 1;
        }
      },
      child: const Text("Left"),
    );
  }

  Widget buttonShowNextSlide(
      double width, double height, StateSetter setState) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor:
            const MaterialStatePropertyAll(PalleteCommon.backgroundColor),
        minimumSize: MaterialStatePropertyAll(
          Size(width * 0.1, height * 0.81),
        ),
      ),
      onPressed: () {
        if (widget.currentPage < widget.estate.slides.length - 1) {
          controller.animateToPage(
            widget.currentPage + 1,
            duration: const Duration(milliseconds: 350),
            curve: Curves.linear,
          );
          widget.currentPage += 1;
        }
      },
      child: const Text("Right"),
    );
  }

  Widget showSlideMap(double width, StateSetter setState) {
    return DataTable(
      columnSpacing: width * 0.15,
      columns: [
        const DataColumn(
          label: Text("#"),
        ),
        DataColumn(
          label: Text(widget.lang!.dictionary["key"]!),
        ),
        DataColumn(
          label: Text(widget.lang!.dictionary["value"]!),
        ),
        DataColumn(
          label: Text(widget.lang!.dictionary["from"]!),
        ),
        DataColumn(
          label: Text(widget.lang!.dictionary["to"]!),
        ),
      ],
      rows: [
        DataRow(cells: [
          DataCell(Text("1")),
          DataCell(Text("family")),
          DataCell(Text("Wilzkopf")),
          DataCell(Text("12.10.2022.")),
          DataCell(Text("19.10.2022.")),
        ]),
      ],
    );
  }

  Widget optionButtons(double width, double height) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (!widget.isNew) ...[
          const Expanded(flex: 2, child: SizedBox()),
          Expanded(
            flex: 3,
            child: GradientButton(
              buttonText: widget.lang!.dictionary["save_changes"]!,
              callback: updateEstate,
            ),
          ),
          const Expanded(
            flex: 2,
            child: SizedBox(),
          ),
          Expanded(
            flex: 3,
            child: GradientButton(
              buttonText: widget.lang!.dictionary["delete_estate"]!,
              callback: () => showDialog(
                context: context,
                builder: (BuildContext context) =>
                    showDeleteAlert(width, height),
              ),
            ),
          ),
          const Expanded(flex: 2, child: SizedBox()),
        ],
        if (widget.isNew) ...[
          const Expanded(flex: 3, child: SizedBox()),
          Expanded(
            flex: 2,
            child: GradientButton(
              buttonText: widget.lang!.dictionary["create_estate"]!,
              callback: createEstate,
            ),
          ),
          const Expanded(flex: 3, child: SizedBox()),
        ],
      ],
    );
  }

  List<Widget> generalInformation(double height) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Text(
                widget.lang!.dictionary["general_information"]!,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const Expanded(
            flex: 2,
            child: SizedBox(),
          ),
        ],
      ),
      SizedBox(
        height: height * 0.04,
      ),
      Row(
        children: [
          Expanded(
            flex: 2,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  StringField(
                    labelText: widget.lang!.dictionary["name"]!,
                    callback: (value) => widget.estate.name = value,
                    presetText: widget.estate.name,
                  ),
                  const SizedBox(height: 15),
                  StringField(
                    labelText: widget.lang!.dictionary["street"]!,
                    callback: (value) => widget.estate.street = value,
                    presetText: widget.estate.street,
                  ),
                  const SizedBox(height: 15),
                  StringField(
                    labelText: widget.lang!.dictionary["zip"]!,
                    callback: (value) => widget.estate.zip = value,
                    presetText: widget.estate.zip,
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: Column(
                children: [
                  StringField(
                    labelText: widget.lang!.dictionary["phone_number"]!,
                    callback: (value) => widget.estate.phone = value,
                    presetText: widget.estate.phone,
                  ),
                  const SizedBox(height: 15),
                  StringField(
                    labelText: widget.lang!.dictionary["city"]!,
                    callback: (value) => widget.estate.city = value,
                    presetText: widget.estate.city,
                  ),
                  const SizedBox(height: 15),
                  StringField(
                    labelText: widget.lang!.dictionary["country"]!,
                    callback: (value) => widget.estate.country = value,
                    presetText: widget.estate.country,
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ],
      )
    ];
  }

  Widget showPresentationOptions(
      double width, double height, StateSetter setState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Add slide as previous
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(3),
            ),
            border: Border.all(
              color: Colors.white,
            ),
          ),
          width: width * 0.233,
          height: height * 0.05,
          child: ElevatedButton(
            style: const ButtonStyle(
              backgroundColor:
                  MaterialStatePropertyAll(PalleteCommon.backgroundColor),
            ),
            onPressed: () {
              setState(() {
                // widget.currentPage = widget.currentPage;
                widget.estate.slides.insert(widget.currentPage, Slide());
              });
              controller.animateToPage(
                widget.currentPage,
                duration: const Duration(milliseconds: 350),
                curve: Curves.linear,
              );
            },
            child: Text(
              widget.lang!.dictionary["add_prev_slide"]!,
              style: const TextStyle(
                color: PalleteCommon.gradient2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        // Delete slide
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(3),
            ),
            border: Border.all(
              color: Colors.white,
            ),
          ),
          width: width * 0.233,
          height: height * 0.05,
          child: ElevatedButton(
            style: const ButtonStyle(
              backgroundColor:
                  MaterialStatePropertyAll(PalleteCommon.backgroundColor),
            ),
            onPressed: () {
              setState(() {
                widget.estate.slides.removeAt(widget.currentPage);
                if (widget.estate.slides.isEmpty) {
                  widget.estate.slides.add(Slide());
                }
                if (widget.currentPage >= widget.estate.slides.length) {
                  widget.currentPage = widget.estate.slides.length - 1;
                }
              });
            },
            child: Text(
              widget.lang!.dictionary["delete_slide"]!,
              style: const TextStyle(
                color: PalleteCommon.gradient2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        // Add slide as next
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(3),
            ),
            border: Border.all(
              color: Colors.white,
            ),
          ),
          width: width * 0.233,
          height: height * 0.05,
          child: ElevatedButton(
            style: const ButtonStyle(
              backgroundColor:
                  MaterialStatePropertyAll(PalleteCommon.backgroundColor),
            ),
            onPressed: () {
              setState(() {
                widget.currentPage += 1;
                widget.estate.slides.insert(widget.currentPage, Slide());
              });
              controller.animateToPage(
                widget.currentPage,
                duration: const Duration(milliseconds: 350),
                curve: Curves.linear,
              );
            },
            child: Text(
              widget.lang!.dictionary["add_next_slide"]!,
              style: const TextStyle(
                color: PalleteCommon.gradient2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget showPresentation(double width, double height, StateSetter setState) {
    List<Widget> res = [];

    // Show all slides
    for (int i = 0; i < widget.estate.slides.length; ++i) {
      res.add(
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  const Expanded(child: SizedBox()),
                  Expanded(
                    flex: 2,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        StringField(
                          labelText: widget.lang!.dictionary["title"]!,
                          callback: (value) =>
                              widget.estate.slides[i].title = value,
                          presetText: widget.estate.slides[i].title,
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        StringField(
                          labelText: widget.lang!.dictionary["subtitle"]!,
                          callback: (value) =>
                              widget.estate.slides[i].subtitle = value,
                          presetText: widget.estate.slides[i].subtitle,
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        StringField(
                          labelText: widget.lang!.dictionary["template"]!,
                          callback: (String value) => widget
                              .estate.slides[i].template = int.parse(value),
                          inputType: TextInputType.number,
                          presetText:
                              widget.estate.slides[i].template.toString(),
                        ),
                      ],
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                  Expanded(
                    flex: 3,
                    child: StringField(
                      multiline: 10,
                      labelText: widget.lang!.dictionary["description"]!,
                      callback: (value) =>
                          widget.estate.slides[i].description = value,
                      presetText: widget.estate.slides[i].description,
                    ),
                  ),
                  const Expanded(child: SizedBox()),
                ],
              ),
              SizedBox(
                height: height * 0.002,
              ),
              if (widget.estate.slides[i].image.isNotEmpty)

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
                            image: Image.network(widget.estate.slides[i].image)
                                .image,
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
                              widget.estate.slides[i].image = "";
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
              else if (widget.estate.slides[i].tmpImageBytes != null)

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
                            image: Image.memory(
                                    widget.estate.slides[i].tmpImageBytes!)
                                .image,
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
                              widget.estate.slides[i].tmpImageBytes = null;
                              widget.estate.slides[i].tmpImageName = null;
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
                  lang: widget.lang!,
                  onDroppedFile: (Map<String, dynamic>? file) {
                    if (file == null) return;

                    setState(() {
                      widget.estate.slides[i].tmpImageName = file['name'];
                      widget.estate.slides[i].tmpImageBytes = file['bytes'];
                    });
                  },
                ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: PalleteCommon.gradient3,
          width: 2,
        ),
      ),
      width: width * 0.7,
      height: height * 0.8,
      child: PageView(
        scrollBehavior: const MaterialScrollBehavior(),
        controller: controller,
        scrollDirection: Axis.horizontal,
        children: res,
      ),
    );
  }

  Widget backgroundImageDisplay(BuildContext context) {
    if (widget.estate.image.isEmpty) {
      return Container(
        margin: const EdgeInsets.only(bottom: 50),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Color(0xff0043ba), Color(0xff006df1)]),
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.only(bottom: 50),
        decoration: BoxDecoration(
          image: DecorationImage(
            scale: 0.01,
            fit: BoxFit.fitWidth,
            image: Image.network(widget.estate.image).image,
          ),
        ),
      );
    }
  }

  Widget cameraIconDisplay(bool avatarImage) {
    if (avatarImage) {
      return Positioned(
        bottom: 0,
        right: 0,
        child: CircleAvatar(
          radius: 20,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          child: Container(
            margin: const EdgeInsets.all(8.0),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.camera_alt),
          ),
        ),
      );
    } else {
      return Positioned(
        bottom: 60,
        right: 15,
        child: CircleAvatar(
          radius: 20,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          child: Container(
            margin: const EdgeInsets.all(8.0),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.camera_alt),
          ),
        ),
      );
    }
  }

  bool checkMandatoryData() {
    return widget.estate.street.isNotEmpty &&
        widget.estate.zip.isNotEmpty &&
        widget.estate.city.isNotEmpty &&
        widget.estate.country.isNotEmpty &&
        widget.estate.name.isNotEmpty;
  }

  void createEstate(/*double width, double height*/) async {
    if (!checkMandatoryData()) return;

    Map<String, dynamic>? estateMap = Estate.toJSON(widget.estate);
    if (estateMap == null) return;
    print("X");

    estateMap["ownerId"] = widget.userId;

    Estate? res = await EstateRepository.createEstate(estateMap);
    if (res == null) return;

    print("Y");

    setState(() {
      widget.estate = res;
      widget.isNew = false;
    });

    // TODO: process data
  }

  void updateEstate(/*double width, double height*/) async {
    if (!checkMandatoryData()) return;

    for (int i = 0; i < widget.estate.slides.length; ++i) {
      if (widget.estate.slides[i].image.isEmpty &&
          widget.estate.slides[i].tmpImageBytes != null) {
        FirebaseStorageService storage = FirebaseStorageService();
        await storage.uploadFile(
          widget.estate,
          widget.estate.slides[i].tmpImageName!,
          widget.estate.slides[i].tmpImageBytes!,
          true,
        );
        widget.estate.slides[i].image = await storage.downloadFile(
          widget.estate.id,
          widget.estate.slides[i].tmpImageName!,
        );
      }
    }

    Map<String, dynamic>? estateMap = Estate.toJSON(widget.estate);
    if (estateMap == null) return null;

    bool res = await EstateRepository.updateEstate(estateMap, widget.estate.id);

    /*if (!res) {
      final snackBar = SnackBar(
        content: const Text(
            'There was an error while updating your estate. Please try again (later)...'),
        backgroundColor: (Colors.white),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: height * 0.85,
          left: width * 0.8,
          right: width * 0.02,
          top: height * 0.02,
        ),
        closeIconColor: PalleteCommon.gradient2,
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    final snackBar = SnackBar(
      content: const Text('Your estate has been updated successfully!'),
      backgroundColor: (Colors.white),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
        bottom: height * 0.85,
        left: width * 0.8,
        right: width * 0.02,
        top: height * 0.02,
      ),
      closeIconColor: PalleteCommon.gradient2,
      action: SnackBarAction(
        label: 'Dismiss',
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);*/

    // TODO: process data
  }

  void deleteEstate(/*double width, double height*/) async {
    if (widget.estate.id.isEmpty) return;

    bool res = await EstateRepository.deleteEstate(widget.estate.id);

    if (res) {
      Navigator.pop(context);
      Navigator.pop(context);
    }

    /*if (!res) {
      final snackBar = SnackBar(
        content: const Text(
            'There was an error while updating your estate. Please try again (later)...'),
        backgroundColor: (Colors.white),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: height * 0.85,
          left: width * 0.8,
          right: width * 0.02,
          top: height * 0.02,
        ),
        closeIconColor: PalleteCommon.gradient2,
        action: SnackBarAction(
          label: 'Dismiss',
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    final snackBar = SnackBar(
      content: const Text('Your estate has been updated successfully!'),
      backgroundColor: (Colors.white),
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
        bottom: height * 0.85,
        left: width * 0.8,
        right: width * 0.02,
        top: height * 0.02,
      ),
      closeIconColor: PalleteCommon.gradient2,
      action: SnackBarAction(
        label: 'Dismiss',
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);*/

    // TODO: process data
  }

  Widget showDeleteAlert(double width, double height) {
    return Dialog(
      insetPadding: EdgeInsets.fromLTRB(
        width * 0.28,
        height * 0.3,
        width * 0.28,
        height * 0.3,
      ),
      backgroundColor: PalleteCommon.backgroundColor,
      alignment: Alignment.center,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Expanded(flex: 2, child: SizedBox()),
            Expanded(
              flex: 2,
              child: Text(
                widget.lang!.dictionary["delete_estate_warning_message"]!,
                style: const TextStyle(
                  fontSize: 18,
                  color: PalleteCommon.gradient2,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Expanded(flex: 2, child: SizedBox()),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Expanded(
                    flex: 2,
                    child: SizedBox(),
                  ),
                  Expanded(
                    flex: 3,
                    child: GradientButton(
                      colors: PalleteDanger.getGradients(),
                      buttonText: widget.lang!.dictionary["delete_estate"]!,
                      callback: () => deleteEstate(),
                    ),
                  ),
                  const Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),
                  Expanded(
                    flex: 3,
                    child: GradientButton(
                      buttonText: widget.lang!.dictionary["cancel"]!,
                      callback: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const Expanded(
                    flex: 2,
                    child: SizedBox(),
                  ),
                ],
              ),
            ),
            const Expanded(flex: 1, child: SizedBox()),
          ],
        ),
      ),
    );
  }
}
