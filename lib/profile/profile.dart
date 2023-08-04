import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:diplomski_rad/components/header.dart';
import 'package:diplomski_rad/interfaces/user/user.dart';
import 'package:diplomski_rad/other/pallete.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:flutter/foundation.dart';
import 'package:diplomski_rad/widgets/gradient_button.dart';
import 'package:diplomski_rad/widgets/string_field.dart';
import 'package:diplomski_rad/widgets/calendar_field.dart';
import 'package:diplomski_rad/widgets/maps.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:async';

class ProfilePage extends StatefulWidget {
  User individualUser = Individual(
    images: ['images/background.jpg'],
    firstname: "Toni",
    lastname: "Farina",
    email: "tfarina58@gmail.com",
    street: "Farini 10A",
    zip: "52463",
    city: "Višnjan",
    country: "Croatia",
  );

  String password = "", repeatPassword = "";
  LatLng coordinates = LatLng(0, 0);

  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: HeaderComponent(currentPage: 'ProfilePage'),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            ImagesDisplay(user: widget.individualUser),
            Padding(
              padding: const EdgeInsets.fromLTRB(400, 0, 0, 0),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  (widget.individualUser as Individual).email,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 22),
                ),
              ),
            ),
            SizedBox(
              width: width,
              height: height * 0.1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      StringField(
                        labelText: 'First name',
                        callback: (value) =>
                            (widget.individualUser as Individual).firstname =
                                value,
                      ),
                      const SizedBox(height: 30),
                      StringField(
                        labelText: 'Last name',
                        callback: (value) =>
                            (widget.individualUser as Individual).lastname =
                                value,
                      ),
                      const SizedBox(height: 30),
                      CalendarField(
                        presetText: "12.03.1998.",
                        labelText: 'Date of birth',
                        callback: (value) =>
                            (widget.individualUser as Individual).birthday =
                                value,
                      ),
                      const SizedBox(height: 30),
                      StringField(
                        labelText: 'Phone number',
                        callback: (value) =>
                            (widget.individualUser as Individual).phone = value,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(),
                ),
              ],
            ),
            Divider(
              color: Colors.white,
              thickness: 2,
              height: 100,
              indent: width * 0.1,
              endIndent: width * 0.1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      StringField(
                        labelText: 'Street',
                        callback: (value) =>
                            (widget.individualUser as Individual).street =
                                value,
                      ),
                      const SizedBox(height: 30),
                      StringField(
                        labelText: 'Zip',
                        callback: (value) =>
                            (widget.individualUser as Individual).zip = value,
                      ),
                      const SizedBox(height: 30),
                      StringField(
                        // presetText: ,
                        labelText: 'City',
                        callback: (value) =>
                            (widget.individualUser as Individual).city = value,
                      ),
                      const SizedBox(height: 30),
                      StringField(
                        labelText: 'Country',
                        callback: (value) =>
                            (widget.individualUser as Individual).country =
                                value,
                      ),
                      const SizedBox(height: 30),
                      StringField(
                        labelText: 'Coordinates',
                        callback: () {},
                        readOnly: true,
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: height * 0.5,
                    child: Padding(
                      padding:
                          EdgeInsets.fromLTRB(20, 20, width * 0.1 + 20, 20),
                      child: MapsWidget(),
                    ),
                  ),
                )
              ],
            ),
            Divider(
              color: Colors.white,
              thickness: 2,
              height: 100,
              indent: width * 0.1,
              endIndent: width * 0.1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      StringField(
                        osbcure: true,
                        labelText: 'Password',
                        callback: (value) => widget.password = value,
                      ),
                      const SizedBox(height: 30),
                      StringField(
                        osbcure: true,
                        labelText: 'Repeat password',
                        callback: (value) => widget.repeatPassword = value,
                      ),
                      const SizedBox(height: 30),
                      GradientButton(
                        buttonText: 'Change password',
                        callback: emptyFunction,
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: SizedBox(
                    width: width * 0.4,
                    height: height * 0.4,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      List<Location> locations =
          await locationFromAddress("Gronausestraat 710, Enschede");
      widget.coordinates =
          LatLng(locations[0].latitude, locations[0].longitude);
      print(widget.coordinates);
    });
  }

  void emptyFunction() {}
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
  Uint8List? selectedImage;
  Uint8List? profileImage;

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
          backgroundImage(context, widget.user),
          Padding(
            padding: EdgeInsets.fromLTRB(250, 0, 0, 0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        showImageOptions(context),
                  ),
                  child: SizedBox(
                    width: 150,
                    height: 150,
                    child: Stack(
                      children: [
                        // User's image
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: profileImage != null
                                  ? Image.memory(profileImage!).image
                                  : Image.asset('images/chick.jpg').image,
                            ),
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
          ),
        ],
      ),
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

  Widget optionButton(
      double width, double height, Function onPressed, String title) {
    return SizedBox(
      width: width * 0.4,
      height: height * 0.05,
      child: ElevatedButton(
        style: const ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(Pallete.backgroundColor),
        ),
        onPressed: () => onPressed(),
        child: Text(
          title,
          style: const TextStyle(
            color: Pallete.gradient2,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget showImageOptions(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

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
                    optionButton(
                      width,
                      height,
                      () => setState(() {
                        widget.choice = UserChoice.editImage;
                      }),
                      "Edit image",
                    ),
                    optionButton(
                      width,
                      height,
                      () => setState(() {
                        widget.choice = UserChoice.changeImage;
                      }),
                      "Change image",
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
                              child: selectedImage == null
                                  ? dropOrBrowseImage()
                                  : manageSelectedImage(width, height),
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

  Widget manageSelectedImage(double width, double height) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              constraints: BoxConstraints(
                maxWidth: width * 0.5,
                minWidth: width * 0.5,
                maxHeight: height * 0.5,
                minHeight: height * 0.5,
              ),
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: Image.memory(
                    selectedImage!,
                  ).image,
                ),
              ),
              /*child: Image.memory(
                                              (await selectedImage!.readAsBytes()),
                                              fit: BoxFit.contain,
                                            ),*/
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                GradientButton(buttonText: 'Anything', callback: () {}),
                const SizedBox(
                  width: 100,
                  height: 20,
                ),
                GradientButton(
                  buttonText: 'Save image',
                  callback: () {
                    profileImage = selectedImage;
                    selectedImage = null;
                  },
                ),
                const SizedBox(
                  width: 100,
                  height: 20,
                ),
                GradientButton(
                  buttonText: 'Discard image',
                  colors: const [
                    Color.fromARGB(255, 224, 40, 0),
                    Color.fromARGB(255, 255, 91, 46),
                    Color.fromARGB(255, 179, 60, 0),
                  ],
                  callback: () {
                    setState(() {
                      selectedImage = null;
                    });
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget dropOrBrowseImage() {
    return const Column(
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
    );
  }

  Future<void> declineFile(dynamic event) async {
    print("Failed (declined)!");
  }

  Future<void> errorFile(dynamic event) async {
    print("Failed (error)!");
  }

  Future<void> acceptFile(dynamic event) async {
    final name = event.name;
    final mime = await dvController.getFileMIME(event);
    final bytes = await dvController.getFileSize(event);
    final url = await dvController.createFileUrl(event);
    setState(() {
      selectedImage = event;
    });

    /*print(event.runtimeType);
    print(name);
    print(mime);
    print(bytes);
    print(url);*/
  }

  Future<void> showFilePicker() async {
    /*if (kIsWeb) {
      print("kIsWeb");
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      print("iOS");
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      print("android");
    }
    if (defaultTargetPlatform == TargetPlatform.linux) {
      print("linux");
    }
    if (defaultTargetPlatform == TargetPlatform.macOS) {
      print("macOS");
    }
    if (defaultTargetPlatform == TargetPlatform.windows) {
      print("windows");
    }
    if (defaultTargetPlatform == TargetPlatform.fuchsia) {
      print("fuchsia");
    }*/

    FilePickerResult? picked = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['jpg', 'png', 'gif'],
    );

    if (picked == null || picked.files.single.bytes == null) return;
    setState(() {
      selectedImage = picked.files.single.bytes;
    });
  }
}
