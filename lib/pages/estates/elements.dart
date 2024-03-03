import 'package:diplomski_rad/interfaces/category.dart';
import 'package:diplomski_rad/interfaces/element.dart' as local;
import 'package:diplomski_rad/services/firebase.dart';
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
  Map<String, dynamic> headerValues = {};
  List<local.Element> elements;
  int index = 0;
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
                  if (document == null) return Text('Error: ${snapshot.error}');
      
                  widget.elements = [];
      
                  local.Element? tmp;
                  List<local.Element> tmpElement = [];
                  document.map((DocumentSnapshot doc) {
                    Map<String, dynamic>? tmpMap = doc.data() as Map<String, dynamic>?;
                    if (tmpMap == null) return;
      
                    tmpMap['id'] = doc.id;
                    tmp = local.Element.toElement(tmpMap);
                    if (tmp == null) return;
      
                    tmpElement.add(tmp!);
                  }).toList();
      
                  widget.elements = tmpElement;
      
                  if (widget.elements.isEmpty) {
                    return Center(child: Text(widget.lang!.dictionary["no_elements"]!));
                  }
      
                  return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ImagesDisplay(
                            category: widget.category,
                            lang: widget.lang!,
                            showAvatar: false,
                            enableEditing: false,
                          ),
                          SizedBox(height: height * 0.1),
                          ...getTitleRow(height, setState),
                          SizedBox(height: height * 0.04),
                          ...getLinksRow(height, setState),
                          SizedBox(height: height * 0.04),
                          ...getDescriptionRow(width, height, cardSize, setState),
                          SizedBox(height: height * 0.04),
                          ...getBackgroundRow(width, height, setState),
                          SizedBox(height: height * 0.04),
                          getPagination(width, height),
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

  List<Widget> getTitleRow(double height, StateSetter setState) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Text(
                widget.lang!.dictionary["title"]!,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const Expanded(flex: 2, child: SizedBox()),
        ],
      ),
      SizedBox(height: height * 0.04),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Expanded(flex: 1, child: SizedBox()),
          Expanded(
            flex: 3,
            child: StringField(
              labelText: widget.lang!.dictionary['title_text']!,
              callback: (value) => widget.elements[widget.index].title['text'] = value,
              presetText: widget.elements[widget.index].title['text']!,
            ),
          ),
          const Expanded(flex: 2, child: SizedBox()),
          Expanded(
            flex: 3,
            child: SequentialField(
              labelText: widget.lang!.dictionary['title_alignment']!,
              callback: (value) => widget.elements[widget.index].title['alignment'] = getSelectedAlignment(value),
              selected: getSelectedAlignmentIndex(widget.elements[widget.index].title['alignment']!),
              choices: [widget.lang!.dictionary['top-left'], widget.lang!.dictionary['top-center'], widget.lang!.dictionary['top-right'], widget.lang!.dictionary['center']],
            ),
          ),
          const Expanded(flex: 1, child: SizedBox()),
        ],
      ),
      SizedBox(height: height * 0.04,),
    ];
  }

  List<Widget> getLinksRow(double height, StateSetter setState) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Text(
                widget.lang!.dictionary["links"]!,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const Expanded(flex: 2, child: SizedBox(),),
        ],
      ),
      SizedBox(height: height * 0.04,),

      for (int i = 0; i < widget.elements[widget.index].links['url'].length; ++i) ...[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Expanded(child: SizedBox(),),
            Expanded(
              flex: 3,
              child: StringField(
                labelText: widget.lang!.dictionary['links_text']!,
                callback: (value) => widget.elements[widget.index].links['text'][i] = value,
                presetText: widget.elements[widget.index].links['text'][i],
              ),
            ),
            const Expanded(flex: 2, child: SizedBox(),),
            Expanded(
              flex: 3,
              child: StringField(
                labelText: widget.lang!.dictionary['links_url']!,
                callback: (value) => widget.elements[widget.index].links['url'][i] = value,
                presetText: widget.elements[widget.index].links['url'][i],
              ),
            ),
            const Expanded(child: SizedBox(),),
          ],
        ),
        SizedBox(height: height * 0.04,),
      ],
    ];
  }

  List<Widget> getBackgroundRow(double width, double height, StateSetter setState) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Text(
                widget.lang!.dictionary["background"]!,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const Expanded(flex: 2, child: SizedBox(),),
        ],
      ),
      SizedBox(height: height * 0.04,),

      if (widget.elements[widget.index].background.isNotEmpty)
        // Showing image from Firebase
        if (!widget.elements[widget.index].background.contains("#"))
          Stack(
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
                      image: Image.network(widget.elements[widget.index].background).image,
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
                    onTap: () {
                      setState(() {
                        widget.elements[widget.index].background = "";
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
        else Text('TODO') // TODO 
          
      else if (widget.elements[widget.index].tmpBackgroundBytes != null)

        // Showing locally obtained image
        if (!widget.elements[widget.index].tmpBackgroundName!.contains("#"))
          Stack(
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
                      image: Image.memory(widget.elements[widget.index].tmpBackgroundBytes!).image,
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
                    onTap: () {
                      setState(() {
                        widget.elements[widget.index].tmpBackgroundBytes = null;
                        widget.elements[widget.index].tmpBackgroundName = "";
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
        else Text('TODO')// TODO 
      else
        // No image to show
        DropzoneWidget(
          width: width * 0.4,
          height: height * 0.4,
          lang: widget.lang!,
          onDroppedFile: (Map<String, dynamic>? file) {
            if (file == null) return;

            setState(() {
              widget.elements[widget.index].tmpBackgroundName = file['name'];
              widget.elements[widget.index].tmpBackgroundBytes = file['bytes'];
            });
          },
        ),
    ];
  }

  List<Widget> getDescriptionRow(double width, double height, double cardSize, StateSetter setState) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Text(
                widget.lang!.dictionary["description"]!,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const Expanded(flex: 2, child: SizedBox(),),
        ],
      ),
      SizedBox(height: height * 0.04,),
      Center(
        child: StringField(
          labelText: widget.lang!.dictionary['text']!,
          callback: (value) => widget.elements[widget.index].description['text'] = value,
          presetText: widget.elements[widget.index].description['text']!,
          multiline: 10,
          maxWidth: width * 0.5,
        )
      ),
      SizedBox(height: height * 0.04),
      Container(
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
                for (int i = 0; i < widget.elements[widget.index].description['images'].length; ++i)
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
                              image: Image.network(widget.elements[widget.index].description['images'][i]).image,
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
                              onTap: () {
                                setState(() {
                                  widget.elements[widget.index].description['images'][i] = "";
                                  (widget.elements[widget.index].description['images'] as List).removeAt(i);
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
                      ),
                    ],
                  ),

                DropzoneWidget(
                  onDroppedFile: (Map<String, dynamic>? file) {
                    if (file == null) return;

                    setState(() {
                      widget.elements[widget.index].tmpDescriptionImageName = file['name'];
                      widget.elements[widget.index].tmpDescriptionImageBytes = file['bytes'];
                    });
                  },
                  lang: widget.lang!
                ),
              ],
            ),
            FABButtons(cardSize, setState),
          ],
        ),
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
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(PalleteHint.gradient3),
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

    if (widget.currentImage < widget.elements[widget.index].description['images'].length) {
      rightButton = Align(
        alignment: Alignment.centerRight,
        child: SizedBox(
          width: cardSize * 0.15,
          height: cardSize * 0.15,
          child: ElevatedButton(
            onPressed: () {
              if (widget.currentImage >= widget.elements[widget.index].description['images'].length) return;
              setState(() {
                widget.currentImage += 1;
              });
              controller.animateToPage(
                widget.currentImage,
                duration: const Duration(milliseconds: 150),
                curve: Curves.linear,
              );
            },
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(PalleteHint.gradient3),
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

  Widget getPagination(double width, double height) {
    List<Widget> res = [];

    if (widget.elements.isEmpty) {
      return const Expanded(
        child: SizedBox(),
      );
    }

    res.add(
      Expanded(
        child: InkWell(
          onTap: () {
            setState(() {
              widget.index = 0;
            });
          },
          child: SizedBox(
            height: height * 0.07,
            child: Center(
              child: Text(
                "1",
                style: TextStyle(
                  color: widget.index == 0 ? PalleteCommon.gradient2 : Colors.white,
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
    if (widget.index >= 1) {
      res.add(
        Expanded(
          child: InkWell(
            onTap: () {
              setState(() {
                widget.index = widget.index - 1;
              });
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
    if (widget.index != 0 && widget.index != widget.elements.length) {
      res.add(
        Expanded(
          flex: 1,
          child: InkWell(
            onTap: () {},
            child: SizedBox(
              height: width * 0.04,
              child: Center(
                child: Text(
                  (widget.index + 1).toString(),
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
    if (widget.index <= widget.elements.length - 1) {
      res.add(
        Expanded(
          flex: 1,
          child: InkWell(
            onTap: () {
              setState(() {
                widget.index = widget.index + 1;
              });
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
              widget.index = widget.elements.length;
            });
          },
          child: SizedBox(
            height: width * 0.04,
            child: Center(
              child: Text(
                (widget.elements.length + 1).toString(),
                style: TextStyle(
                  color: widget.index == widget.elements.length - 1 ? PalleteCommon.gradient2 : Colors.white,
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

  List<Widget> getImages(double width, double height, int index, StateSetter setState) {
    List<Widget> images = [];
    for (int i = 0; i < widget.elements[index].description['images'].length; ++i) {
      images.add(
        Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(bottom: 50),
                width: width * 0.4,
                height: height * 0.4,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    scale: 0.01,
                    fit: BoxFit.fitWidth,
                    image: Image.network(widget.elements[index].description['images'][i]).image,
                  ),
                ),
              ),
            ),

            // Delete image
            SizedBox(
              width: width * 0.4,
              height: height * 0.4,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.elements[index].description['images'][i] = "";
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
        ),
      );
    }

    return images;
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

  Widget optionButtons(double width, double height) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Expanded(flex: 2, child: SizedBox()),
        Expanded(
          flex: 3,
          child: GradientButton(
            buttonText: widget.lang!.dictionary["save_changes"]!,
            callback: updateElements,
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
              builder: (BuildContext context) => showDeleteAlert(width, height),
            ),
          ),
        ),
        const Expanded(flex: 2, child: SizedBox()),
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

  void updateElements(/*double width, double height*/) async {
    for (int i = 0; i < widget.elements.length; ++i) {
      Map<String, dynamic>? elementMap = local.Element.toJSON(widget.elements[i]);
      if (elementMap == null) return null;

      bool elementRes = await ElementRepository.updateElement(widget.elements[i].id, elementMap);
      if (!elementRes) {
        
      } else {

      }
    }
    
    // TODO: set failure snackbar
    // TODO: set success snackbar
  }

  void deleteElement() async {
    Map<String, dynamic>? elementMap = local.Element.toJSON(widget.elements[widget.index]);
    if (elementMap == null) return null;

    bool elementRes = await ElementRepository.deleteElement(widget.elements[widget.index].id);
    if (!elementRes) {
      
    } else {

    }
  }

  int getSelectedAlignmentIndex(String alignment) {
    if (alignment == 'top-left') return 0;
    if (alignment == 'top-center') return 1;
    if (alignment == 'top-right') return 2;
    if (alignment == 'center') return 3;
    return 0;
  }

  String getSelectedAlignment(int index) {
    if (index == 0) return 'top-left';
    if (index == 1) return 'top-center';
    if (index == 2) return 'top-right';
    if (index == 3) return 'center';
    return 'top-left';
  }
}
