import 'dart:html';

import 'package:diplomski_rad/interfaces/category.dart';
import 'package:diplomski_rad/interfaces/element.dart' as local;
import 'package:diplomski_rad/services/firebase.dart';
import 'package:diplomski_rad/services/shared_preferences.dart';
import 'package:diplomski_rad/widgets/sequential_field.dart';
import 'package:flutter/material.dart';
import 'package:diplomski_rad/widgets/header_widget.dart';
import 'package:diplomski_rad/widgets/card_widget.dart';
import 'package:diplomski_rad/other/pallete.dart';
import 'package:diplomski_rad/widgets/gradient_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:diplomski_rad/services/language.dart';
import 'package:diplomski_rad/widgets/images_display_widget.dart';
import 'package:diplomski_rad/widgets/string_field.dart';
import 'package:diplomski_rad/widgets/dropzone_widget.dart';

class ElementsPage extends StatefulWidget {

  String? userId;
  Category category;
  LanguageService? lang;
  FirebaseStorageService? storage;
  Map<String, dynamic> headerValues = {};
  List<local.Element> elements;
  int elementIndex = 0;
  int currentImage = 0;

  ElementsPage({
    Key? key,
    required this.category,
    this.elements = const [],
  }) : super(key: key);

  @override
  State<ElementsPage> createState() => _ElementsPageState();
}

class _ElementsPageState extends State<ElementsPage> {
  final controller = PageController(
    initialPage: 0,
    viewportFraction: 0.7,
  );

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
        currentPage: 'ElementsPage',
        lang: widget.lang!,
        headerValues: widget.headerValues,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(32.0),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('elements')
                  .where('categoryId', isEqualTo: widget.category.id)
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
                  widget.elements = local.Element.setupElementsFromFirebaseDocuments(document);

                  // This way user can add a new element
                  local.Element? emptyElement = local.Element.toElement({"categoryId": widget.category.id});
                  widget.elements.add(emptyElement!);
      
                  return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Column(
                        key: ValueKey(widget.elements[widget.elementIndex]),
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ImagesDisplay(
                            category: widget.category,
                            lang: widget.lang!,
                            showAvatar: false,
                            enableEditing: false,
                            callback: () {},
                          ),
                          SizedBox(height: height * 0.1),

                          showSectionTitle(widget.lang!.translate('titles'), 22, Colors.white),
                          SizedBox(height: height * 0.04),
                          getTitleRow(height, setState),
                          SizedBox(height: height * 0.08),

                          for (int i = 0; i < 3; ++i) ...[
                            showSectionTitle("${widget.lang!.translate('links')} ${i + 1}", 22, Colors.white),
                            SizedBox(height: height * 0.04),
                            ...getLinksRow(width, height, i, setState),
                            SizedBox(height: height * 0.08),
                          ],

                          showSectionTitle(widget.lang!.translate('description'), 22, Colors.white),
                          SizedBox(height: height * 0.04),
                          ...getDescriptionRow(width, height, cardSize, setState),
                          SizedBox(height: height * 0.04),

                          if (widget.elementIndex != widget.elements.length - 1) ...[
                            showSectionTitle(widget.lang!.translate('background'), 22, Colors.white),
                            SizedBox(height: height * 0.04),
                            getBackgroundRow(width, height, setState),
                            SizedBox(height: height * 0.04),

                            showSectionTitle(widget.lang!.translate('images'), 22, Colors.white),
                            SizedBox(height: height * 0.04),
                            getImages(width, height, cardSize, setState),
                            SizedBox(height: height * 0.04),
                          ],

                          getPagination(width, height, setState),
                          SizedBox(height: height * 0.04),

                          optionButtons(width, height),
                        ],
                      );
                    }
                  );
                }
              }
            ),
          ),
        ),
      ),
    );
  }

  Widget getTitleRow(double height, StateSetter setState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Expanded(flex: 1, child: SizedBox()),
        Expanded(
          flex: 3,
          child: StringField(
            labelText: widget.lang!.translate('title_en'),
            callback: (value) => widget.elements[widget.elementIndex].title['en'] = value,
            presetText: widget.elements[widget.elementIndex].title['en']!,
          ),
        ),
        const Expanded(flex: 1, child: SizedBox()),
        Expanded(
          flex: 3,
          child: StringField(
            labelText: widget.lang!.translate('title_de'),
            callback: (value) => widget.elements[widget.elementIndex].title['de'] = value,
            presetText: widget.elements[widget.elementIndex].title['de']!,
          ),
        ),
        const Expanded(flex: 1, child: SizedBox()),
        Expanded(
          flex: 3,
          child: StringField(
            labelText: widget.lang!.translate('title_hr'),
            callback: (value) => widget.elements[widget.elementIndex].title['hr'] = value,
            presetText: widget.elements[widget.elementIndex].title['hr']!,
          ),
        ),
        const Expanded(flex: 1, child: SizedBox()),
      ],
    );
  }


  List<Widget> getLinksRow(double width, double height, int index, StateSetter setState) {
    return [
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(child: SizedBox()),
              Expanded(
                flex: 3,
                child: StringField(
                  labelText: widget.lang!.translate('title_en'),
                  callback: (value) => widget.elements[widget.elementIndex].links[index]['title']['en'] = value,
                  presetText: widget.elements[widget.elementIndex].links[index]['title']['en'],
                ),
              ),
              const Expanded(child: SizedBox()),
              Expanded(
                flex: 3,
                child: StringField(
                  labelText: widget.lang!.translate('title_de'),
                  callback: (value) => widget.elements[widget.elementIndex].links[index]['title']['de'] = value,
                  presetText: widget.elements[widget.elementIndex].links[index]['title']['de'],
                ),
              ),
              const Expanded(child: SizedBox()),
              Expanded(
                flex: 3,
                child: StringField(
                  labelText: widget.lang!.translate('title_hr'),
                  callback: (value) => widget.elements[widget.elementIndex].links[index]['title']['hr'] = value,
                  presetText: widget.elements[widget.elementIndex].links[index]['title']['hr'],
                ),
              ),
              const Expanded(child: SizedBox()),
            ],
          ),
          SizedBox(height: height * 0.04),
          StringField(
            maxWidth: width * 0.82,
            labelText: widget.lang!.translate('links_url'),
            callback: (value) => widget.elements[widget.elementIndex].links[index]['url'] = value,
            presetText: widget.elements[widget.elementIndex].links[index]['url'],
          ),
        ],
      )
    ];
  }


  Widget getBackgroundRow(double width, double height, StateSetter setState) {
    if (widget.elements[widget.elementIndex].background.isNotEmpty) {
      // Showing image from Firebase
      return Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(bottom: 50),
              width: width * 0.5,
              height: height * 0.5,
              decoration: BoxDecoration(
                image: DecorationImage(
                  scale: 0.01,
                  fit: BoxFit.fitWidth,
                  image: Image.network(widget.elements[widget.elementIndex].background).image,
                ),
              ),
            ),
          ),

          // Delete image
          SizedBox(
            width: width * 0.5,
            height: height * 0.5,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () async {
                  await widget.storage!.deleteBackgroundForElement(
                    widget.elements[widget.elementIndex].id,
                    widget.elements[widget.elementIndex].images[widget.currentImage],
                  );
                },
                child: const Align(
                  alignment: AlignmentDirectional.topEnd,
                  child: Icon(Icons.close, color: Colors.red),
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      // No image to show
      return DropzoneWidget(
        width: width * 0.4,
        height: height * 0.4,
        lang: widget.lang!,
        onDroppedFile: (Map<String, dynamic>? file) async {
          if (file == null) return;

          await widget.storage!.uploadBackgroundForElement(
            widget.elements[widget.elementIndex].id,
            file['name'],
            file['bytes'],
          );
        },
      );
    }
  }

List<Widget> getDescriptionRow(double width, double height, double cardSize, StateSetter setState) {
    return [
      StringField(
        labelText: widget.lang!.translate('description_en'),
        callback: (value) => widget.elements[widget.elementIndex].description['en'] = value,
        presetText: widget.elements[widget.elementIndex].description['en']!,
        multiline: 20,
        maxWidth: width * 0.8,
      ),
      SizedBox(height: height * 0.04),
      StringField(
        labelText: widget.lang!.translate('description_de'),
        callback: (value) => widget.elements[widget.elementIndex].description['de'] = value,
        presetText: widget.elements[widget.elementIndex].description['de']!,
        multiline: 20,
        maxWidth: width * 0.8,
      ),
      SizedBox(height: height * 0.04),
      StringField(
        labelText: widget.lang!.translate('description_hr'),
        callback: (value) => widget.elements[widget.elementIndex].description['hr'] = value,
        presetText: widget.elements[widget.elementIndex].description['hr']!,
        multiline: 20,
        maxWidth: width * 0.8,
      ),
    ];
  }


  Widget FABButtons(double cardSize, StateSetter setState) {
    Widget leftButton, rightButton;

    if (widget.currentImage > 0) {
      leftButton = Align(
        alignment: Alignment.centerLeft,
        child: SizedBox(
          width: cardSize * 0.15,
          height: cardSize * 0.15,
          child: ElevatedButton(
            onPressed: () {
              if (widget.currentImage <= 0) return;
              setState(() {
                widget.currentImage -= 1;
              });
              controller.animateToPage(
                widget.currentImage,
                duration: const Duration(milliseconds: 150),
                curve: Curves.linear,
              );
            },
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(PalleteCommon.gradient3),
            ),
            child: const Icon(
              Icons.arrow_back,
              size: 40,
              color: Colors.white,
            ),
          ),
        ),
      );
    } else {
      leftButton = Align(
        alignment: Alignment.bottomLeft,
        child: SizedBox(
          width: cardSize * 0.15,
          height: cardSize * 0.15,
        ),
      );
    }

    if (widget.currentImage < widget.elements[widget.elementIndex].images.length + widget.elements[widget.elementIndex].tmpDescriptionImageBytes.length) {
      rightButton = Align(
        alignment: Alignment.centerRight,
        child: SizedBox(
          width: cardSize * 0.15,
          height: cardSize * 0.15,
          child: ElevatedButton(
            onPressed: () {
              if (widget.currentImage >= widget.elements[widget.elementIndex].images.length + widget.elements[widget.elementIndex].tmpDescriptionImageBytes.length) return;
              setState(() {
                widget.currentImage += 1;
              });
              controller.animateToPage(
                widget.currentImage,
                duration: const Duration(milliseconds: 150),
                curve: Curves.linear,
              );
            },
            style: const ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(PalleteCommon.gradient3),
            ),
            child: const Icon(
              Icons.arrow_forward,
              size: 40,
              color: Colors.white,
            ),
          ),
        ),
      );
    } else {
      rightButton = Align(
        alignment: Alignment.centerRight,
        child: SizedBox(
          width: cardSize * 0.15,
          height: cardSize * 0.15,
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        leftButton,
        SizedBox(width: cardSize * 1.28),
        rightButton
      ],
    );
  }

  Widget getPagination(double width, double height, StateSetter setState) {
    List<Widget> res = [];

    if (widget.elements.length <= 1) {
      return const SizedBox();
    }

    res.add(
      Expanded(
        child: InkWell(
          onTap: () {
            setState(() {
              widget.elementIndex = 0;
              widget.currentImage = 0;
            });

            controller.animateToPage(
              widget.currentImage,
              duration: const Duration(milliseconds: 0),
              curve: Curves.linear,
            );
          },
          child: SizedBox(
            height: height * 0.07,
            child: Center(
              child: Text(
                "1",
                style: TextStyle(
                  color: widget.elementIndex == 0 ? PalleteCommon.gradient2 : Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
    if (widget.elementIndex >= 1) {
      res.add(
        Expanded(
          child: InkWell(
            onTap: () {
              setState(() {
                widget.elementIndex = widget.elementIndex - 1;
                widget.currentImage = 0;
              });

              controller.animateToPage(
                widget.currentImage,
                duration: const Duration(milliseconds: 0),
                curve: Curves.linear,
              );
            },
            child: SizedBox(
              height: height * 0.07,
              child: const Center(
                child: Text(
                  "<<",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      );
    }
    if (widget.elementIndex != 0 && widget.elementIndex != widget.elements.length - 1) {
      res.add(
        Expanded(
          flex: 1,
          child: InkWell(
            onTap: () {},
            child: SizedBox(
              height: width * 0.04,
              child: Center(
                child: Text(
                  (widget.elementIndex + 1).toString(),
                  style: const TextStyle(
                    color: PalleteCommon.gradient2,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      );
    }
    if (widget.elementIndex <= widget.elements.length - 2) {
      res.add(
        Expanded(
          flex: 1,
          child: InkWell(
            onTap: () {
              setState(() {
                widget.elementIndex = widget.elementIndex + 1;
                widget.currentImage = 0;
              });
              
              controller.animateToPage(
                widget.currentImage,
                duration: const Duration(milliseconds: 0),
                curve: Curves.linear,
              );
            },
            child: SizedBox(
              height: width * 0.04,
              child: const Center(
                child: Text(
                  ">>",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      );
    }
    res.add(
      Expanded(
        flex: 1,
        child: InkWell(
          onTap: () {
            setState(() {
              widget.elementIndex = widget.elements.length - 1;
              widget.currentImage = 0;
            });
            
            controller.animateToPage(
              widget.currentImage,
              duration: const Duration(milliseconds: 0),
              curve: Curves.linear,
            );
          },
          child: SizedBox(
            height: width * 0.04,
            child: Center(
              child: Text(
                (widget.elements.length).toString(),
                style: TextStyle(
                  color: widget.elementIndex == widget.elements.length - 1 ? PalleteCommon.gradient2 : Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );

    return SizedBox(
      width: width * 0.145,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: res,
      ),
    );
  }

  Widget getImages(double width, double height, double cardSize, StateSetter setState) {
    return SizedBox(
      height: height * 0.7,
      width: width * 0.7,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PageView(
            scrollBehavior: const MaterialScrollBehavior(),
            controller: controller,
            scrollDirection: Axis.horizontal,
            children: [
              for (int i = 0; i < widget.elements[widget.elementIndex].images.length; ++i)
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(width * 0.05, 0, width * 0.05, 0),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 50),
                        width: width * 0.5,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            scale: 0.01,
                            fit: BoxFit.fitWidth,
                            image: Image.network(widget.elements[widget.elementIndex].images[i]).image,
                          ),
                        ),
                      ),
                    ),
        
                    Padding(
                      padding: EdgeInsets.fromLTRB(width * 0.05, 0, width * 0.05, 0),
                      child: SizedBox(
                        width: width * 0.5,
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () async {
                              await widget.storage!.deleteImagesForElement(
                                widget.elements[widget.elementIndex].id,
                                widget.elements[widget.elementIndex].images[widget.currentImage],
                                widget.elements[widget.elementIndex].images
                              );
                            },
                            child: const Align(
                              alignment: AlignmentDirectional.topEnd,
                              child: Icon(Icons.close, color: Colors.red),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

              DropzoneWidget(
                width: width * 0.4,
                height: height * 0.4,
                onDroppedFile: (Map<String, dynamic>? file) async {
                  if (file == null) return;

                  await widget.storage!.uploadNewImageForElement(
                    widget.elements[widget.elementIndex].id,
                    file['name'],
                    file['bytes'],
                    widget.elements[widget.elementIndex].images
                  );
                },
                lang: widget.lang!
              ),
            ],
          ),
          FABButtons(cardSize, setState),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferencesService sharedPreferencesService = SharedPreferencesService(await SharedPreferences.getInstance());
      String tmpUserId = sharedPreferencesService.getUserId();
      String tmpTypeOfUser = sharedPreferencesService.getTypeOfUser();
      String tmpAvatarImage = sharedPreferencesService.getAvatarImage();
      String tmpLanguage = sharedPreferencesService.getLanguage();

      if (tmpUserId.isEmpty) return;
      if (tmpTypeOfUser.isEmpty) return;
      if (tmpLanguage.isEmpty) return;

      LanguageService tmpLang = LanguageService.getInstance(tmpLanguage);
      FirebaseStorageService storage = FirebaseStorageService();

      setState(() {
        widget.storage = storage;
        widget.userId = tmpUserId;
        widget.lang = tmpLang;
        widget.headerValues["userId"] = tmpUserId;
        widget.headerValues["typeOfUser"] = tmpTypeOfUser;
        widget.headerValues["avatarImage"] = tmpAvatarImage;
      });
    });
  }

  Widget optionButtons(double width, double height) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (widget.elements[widget.elementIndex].id.isNotEmpty) ...[
            const Expanded(flex: 2, child: SizedBox()),
            Expanded(
              flex: 3,
              child: GradientButton(
                buttonText: widget.lang!.translate('update_element'),
                callback: updateElement,
              ),
            ),
            const Expanded(flex: 2, child: SizedBox()),
            Expanded(
              flex: 3,
              child: GradientButton(
                buttonText: widget.lang!.translate('delete_estate'),
                callback: () => showDialog(
                  context: context,
                  builder: (BuildContext context) => showDeleteAlert(width, height),
                ),
              ),
            ),
            const Expanded(flex: 2, child: SizedBox()),
          ]
        else ...[
          const Expanded(flex: 2, child: SizedBox()),
          Expanded(
            flex: 1,
            child: GradientButton(
              buttonText: widget.lang!.translate('create_element'),
              callback: () => createElement(),
            ),
          ),
          const Expanded(flex: 2, child: SizedBox()),
        ]
        
      ],
    );
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
                widget.lang!.translate('delete_estate_warning_message'),
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
                      buttonText: widget.lang!.translate('delete_estate'),
                      callback: () => deleteElement(),
                    ),
                  ),
                  const Expanded(
                    flex: 1,
                    child: SizedBox(),
                  ),
                  Expanded(
                    flex: 3,
                    child: GradientButton(
                      buttonText: widget.lang!.translate('cancel'),
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

  void createElement() async {
    Map<String, dynamic>? elementMap = local.Element.toJSON(widget.elements[widget.elementIndex]);
    if (elementMap == null) return null;

    local.Element? element = await ElementRepository.createElement(elementMap);
    if (element == null) {
      
    } else {

    }
  }

  void updateElement() async {
    Map<String, dynamic>? elementMap = local.Element.toJSON(widget.elements[widget.elementIndex]);
    if (elementMap == null) return null;

    bool elementRes = await ElementRepository.updateElement(widget.elements[widget.elementIndex].id, elementMap);
    if (!elementRes) {
      
    } else {

    }
    
    // TODO: set failure snackbar
    // TODO: set success snackbar
  }

  void deleteElement() async {
    Map<String, dynamic>? elementMap = local.Element.toJSON(widget.elements[widget.elementIndex]);
    if (elementMap == null) return null;

    bool elementRes = await ElementRepository.deleteElement(widget.elements[widget.elementIndex].id);
    if (!elementRes) {
      
    } else {

    }
  }


  Widget showSectionTitle(String title, double fontSize, Color fontColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: fontColor,
              ),
            ),
          ),
        ),
        const Expanded(flex: 2, child: SizedBox()),
      ],
    );
  }
}
