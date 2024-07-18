import 'dart:typed_data';

import 'package:diplomski_rad/services/language.dart';
import 'package:diplomski_rad/widgets/dropzone_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:diplomski_rad/interfaces/user.dart';
import 'package:diplomski_rad/interfaces/estate.dart';
import 'package:diplomski_rad/interfaces/category.dart' as localCategory;
import 'package:diplomski_rad/other/pallete.dart';
import 'package:diplomski_rad/services/firebase.dart';

class ImagesDisplay extends StatefulWidget {
  User? user;
  Estate? estate;
  localCategory.Category? category;
  LanguageService lang;
  bool showAvatar;
  bool enableEditing;
  String droppedFileName = "";
  Uint8List? droppedFileBytes;
  Function callback;

  ImagesDisplay({
    Key? key,
    this.user,
    this.estate,
    this.category,
    required this.callback,
    required this.showAvatar,
    required this.enableEditing,
    required this.lang,
  }) : assert(user != null && estate == null && category == null || user == null && estate != null && category == null || user == null && estate == null && category != null);

  @override
  State<ImagesDisplay> createState() => _ImagesDisplayState();
}

class _ImagesDisplayState extends State<ImagesDisplay> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      constraints: BoxConstraints(
        maxHeight: height * 0.6,
        minHeight: height * 0.3,
        maxWidth: width,
        minWidth: width,
      ),
      child: Stack(
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () {
                if (!widget.enableEditing) return;
                showDialog(
                  context: context,
                  builder: (BuildContext context) => showImagesDialog(context, false),
                );
              },
              child: Stack(
                children: [
                  backgroundImageDisplay(context),
                  if (widget.enableEditing) cameraIconDisplay(false),
                ],
              ),
            ),
          ),
          if (widget.showAvatar)
            Padding(
              padding: EdgeInsets.fromLTRB(width * 0.12, 0, 0, 0),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      if (!widget.enableEditing) return;
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => showImagesDialog(context, true),
                      );
                    },
                    child: SizedBox(
                      width: 150,
                      height: 150,
                      child: Stack(
                        children: [
                          avatarImageDisplay(),
                          if (widget.enableEditing) cameraIconDisplay(true),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget backgroundImageDisplay(BuildContext context) {
    if (widget.estate != null) {
      if (widget.estate!.image.isEmpty) {
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
              image: Image.network(widget.estate!.image).image,
            ),
          ),
        );
      }
    } else if (widget.user != null) {
      if (widget.user is Admin || widget.user is Customer && (widget.user as Customer).backgroundImage.isEmpty) {
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
              image: Image.network((widget.user as Customer).backgroundImage)
                  .image,
            ),
          ),
        );
      }
    } else if (widget.category != null) {
      if (widget.category!.image.isEmpty) {
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
              image: Image.network(widget.category!.image).image,
            ),
          ),
        );
      }
    } else {
      return const SizedBox();
    }
  }

  Widget avatarImageDisplay() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
        image: DecorationImage(
          fit: BoxFit.cover,
          image: widget.user is Customer && (widget.user as Customer).avatarImage.isNotEmpty
              ? Image.network((widget.user as Customer).avatarImage).image
              : Image.asset('images/default_user.png').image,
        ),
      ),
    );
  }

  Widget cameraIconDisplay(bool choice) {
    if (choice) {
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

  Widget showImagesDialog(BuildContext context, bool choice) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

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
                // Header options
                SizedBox(height: height * 0.025),
                Center(
                  child: Text(
                    widget.lang.translate(choice ? 'avatar_image' : 'background_image'),
                    style: const TextStyle(fontSize: 32),
                  ),
                ),
                SizedBox(height: height * 0.025),
                // Body features
                if (choice)
                  if (widget.droppedFileBytes == null)
                    DropzoneWidget(
                      lang: widget.lang,
                      onDroppedFile: (Map<String, dynamic>? file) {
                        if (file == null) return;

                        setState(() {
                          widget.droppedFileName = file['name'];
                          widget.droppedFileBytes = file['bytes'];
                        });
                      },
                    )
                  else
                    Row(
                      children: [
                        Container(
                          width: width * 0.5,
                          height: height * 0.5,
                          margin: const EdgeInsets.all(8.0),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: Image.memory(widget.droppedFileBytes!),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            optionSaveImage(width, height, choice),
                            SizedBox(height: height * 0.08),
                            optionDiscardImage(width, height),
                            SizedBox(height: height * 0.08),
                            optionCancel(width, height),
                          ],
                        ),
                      ],
                    )
                else if (!choice)
                  if (widget.droppedFileBytes == null)
                    DropzoneWidget(
                      lang: widget.lang,
                      onDroppedFile: (Map<String, dynamic>? file) {
                        if (file == null) return;

                        setState(() {
                          widget.droppedFileName = file['name'];
                          widget.droppedFileBytes = file['bytes'];
                        });
                      },
                    )
                  else
                    Row(
                      children: [
                        Container(
                          width: width * 0.5,
                          height: height * 0.5,
                          margin: const EdgeInsets.all(8.0),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          // child: Image.network(widget.droppedFile!.path),
                          child: Image.memory(widget.droppedFileBytes!),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            optionSaveImage(width, height, choice),
                            SizedBox(height: height * 0.08),
                            optionDiscardImage(width, height),
                            SizedBox(height: height * 0.08),
                            optionCancel(width, height),
                          ],
                        ),
                      ],
                    )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget optionSaveImage(double width, double height, bool choice) {
    return ElevatedButton(
      style: ButtonStyle(
        minimumSize: MaterialStatePropertyAll(Size(width * 0.25, height * 0.08)),
        maximumSize: MaterialStatePropertyAll(Size(width * 0.25, height * 0.4)),
        backgroundColor: const MaterialStatePropertyAll(Color.fromARGB(125, 85, 85, 85)),
      ),
      onPressed: () async {
        if (widget.droppedFileBytes == null) return;

        FirebaseStorageService storage = FirebaseStorageService();
        if (widget.estate != null) {
          await storage.uploadImageForEstate(widget.estate as Estate, widget.droppedFileName, widget.droppedFileBytes!);
        } else if (widget.user != null) {
          storage.uploadImageForCustomer(widget.user as Customer, widget.droppedFileName, widget.droppedFileBytes!, choice);
          if (choice) widget.callback();
        } else if (widget.category != null) {
          storage.uploadImageForCategory(widget.category as localCategory.Category, widget.droppedFileName, widget.droppedFileBytes!);
        }

        Navigator.pop(context);
      },
      child: Text(widget.lang.translate('save_image')),
    );
  }

  Widget optionDiscardImage(double width, double height) {
    return ElevatedButton(
      style: ButtonStyle(
        minimumSize: MaterialStatePropertyAll(Size(width * 0.25, height * 0.08)),
        maximumSize: MaterialStatePropertyAll(Size(width * 0.25, height * 0.4)),
        backgroundColor: const MaterialStatePropertyAll(Color.fromARGB(125, 85, 85, 85)),
      ),
      onPressed: () {
        setState(() {
          widget.droppedFileBytes = null;
          widget.droppedFileName = '';
        });
      },
      child: Text(widget.lang.translate('discard_image')),
    );
  }

  Widget optionCancel(double width, double height) {
    return ElevatedButton(
      style: ButtonStyle(
        minimumSize: MaterialStatePropertyAll(Size(width * 0.25, height * 0.08)),
        maximumSize: MaterialStatePropertyAll(Size(width * 0.25, height * 0.4)),
        backgroundColor: const MaterialStatePropertyAll(Color.fromARGB(125, 85, 85, 85)),
      ),
      onPressed: () {
        setState(() {
          widget.droppedFileBytes = null;
          widget.droppedFileName = '';
        });
        Navigator.pop(context);
      },
      child: Text(widget.lang.translate('cancel')),
    );
  }
}
