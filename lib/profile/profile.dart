import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:diplomski_rad/components/header.dart';
import 'package:diplomski_rad/interfaces/user/user.dart';
import 'package:diplomski_rad/other/pallete.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

class ProfilePage extends StatefulWidget {
  User individualUser = Individual(images: ['images/background.jpg']);

  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderComponent(currentPage: 'ProfilePage'),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: ImagesDisplay(
              user: widget.individualUser,
            ),
          ),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    "Richie Lorie",
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum UserChoice { editImage, changeImage }

class ImagesDisplay extends StatefulWidget {
  User user;
  UserChoice choice = UserChoice.editImage;

  ImagesDisplay({Key? key, required this.user}) : super(key: key);

  @override
  State<ImagesDisplay> createState() => _ImagesDisplayState();
}

class _ImagesDisplayState extends State<ImagesDisplay> {
  late DropzoneViewController dvController;
  bool isHovering = false;
  FileImage? selectedImage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        backgroundImage(context, widget.user),
        Align(
          alignment: Alignment.bottomCenter,
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: () => showDialog(
                context: context,
                builder: (BuildContext context) => showImageOptions(context),
              ),
              child: SizedBox(
                width: 150,
                height: 150,
                child: Stack(
                  children: [
                    // User's image
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1470&q=80')),
                      ),
                    ),
                    // Camera icon
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        child: Container(
                          margin: const EdgeInsets.all(8.0),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget backgroundImage(BuildContext context, User user) {
    if (user is Admin) {
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
            image: Image(
              fit: BoxFit.fitWidth,
              image: user is Individual
                  ? AssetImage((user).images[0])
                  : AssetImage((user as Company).images[0]),
            ).image,
          ),
        ),
      );
    }
  }

  Widget showImageOptions(BuildContext context) {
    double width = MediaQuery.of(context).size.width,
        height = MediaQuery.of(context).size.height;

    return Dialog(
      backgroundColor: Pallete.backgroundColor,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: width * 0.4,
                      height: height * 0.05,
                      child: ElevatedButton(
                        style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Pallete.backgroundColor),
                        ),
                        onPressed: () {
                          setState(() {
                            widget.choice = UserChoice.editImage;
                          });
                        },
                        child: const Text(
                          'Edit image',
                          style: TextStyle(
                            color: Pallete.gradient2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.4,
                      height: height * 0.05,
                      child: ElevatedButton(
                        style: const ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Pallete.backgroundColor),
                        ),
                        onPressed: () {
                          setState(() {
                            widget.choice = UserChoice.changeImage;
                          });
                        },
                        child: const Text(
                          'Change image',
                          style: TextStyle(
                            color: Pallete.gradient2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Body features
                if (widget.choice == UserChoice.editImage)
                  Container(
                    padding: const EdgeInsets.fromLTRB(150, 50, 150, 50),
                    child: InkWell(
                      onTap: () {},
                      onHover: (value) {
                        setState(() {
                          isHovering = value;
                        });
                        print(value);
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(6)),
                              border: Border(
                                left: BorderSide(
                                    color: isHovering
                                        ? Pallete.gradient2
                                        : Colors.white),
                                top: BorderSide(
                                    color: isHovering
                                        ? Pallete.gradient2
                                        : Colors.white),
                                right: BorderSide(
                                    color: isHovering
                                        ? Pallete.gradient2
                                        : Colors.white),
                                bottom: BorderSide(
                                    color: isHovering
                                        ? Pallete.gradient2
                                        : Colors.white),
                              ),
                              color: Pallete.backgroundColor,
                            ),
                            width: width * 0.7,
                            height: height * 0.6,
                            child: DropzoneView(
                              mime: const ['image/jpg', 'image/png'],
                              onDropInvalid: declineFile,
                              onDrop: acceptFile,
                              onCreated: (controller) =>
                                  dvController = controller,
                            ),
                          ),
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () => showFilePicker(),
                              child: const Column(
                                children: [
                                  Icon(
                                    Icons.cloud_upload,
                                    size: 80,
                                    color: Pallete.gradient2,
                                  ),
                                  Text(
                                    "Drop images here or browse through files",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  const Padding(
                    padding: EdgeInsets.fromLTRB(50, 50, 50, 50),
                    child: Center(
                      child: Text("changeImage"),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> acceptFile(dynamic event) async {
    final name = event.name;
    final mime = await dvController.getFileMIME(event);
    final bytes = await dvController.getFileSize(event);
    final url = await dvController.createFileUrl(event);

    print(event.runtimeType);
    print(name);
    print(mime);
    print(bytes);
    print(url);
  }

  Future<void> declineFile(dynamic event) async {
    print("Failed (declined)!");
  }

  Future<void> errorFile(dynamic event) async {
    print("Failed (error)!");
  }

  Future<void> showFilePicker() async {
    if (kIsWeb) {
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android) {
    } else if (defaultTargetPlatform == TargetPlatform.linux) {
    } else if (defaultTargetPlatform == TargetPlatform.macOS) {
    } else if (defaultTargetPlatform == TargetPlatform.windows) {
      FilePickerResult? picked =
          await FilePicker.platform.pickFiles(type: FileType.image);
      if (picked != null) {
        print(picked.files.first.name);
      }
    } else if (defaultTargetPlatform == TargetPlatform.fuchsia) {}
  }
}
