import 'dart:js_interop';

import 'package:diplomski_rad/auth/login/login.dart';
import 'package:diplomski_rad/home/home.dart';
import 'package:diplomski_rad/settings/settings.dart';
import 'package:diplomski_rad/estates/estates.dart';
import 'package:diplomski_rad/users/users.dart';
import 'package:diplomski_rad/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:diplomski_rad/other/pallete.dart';
import 'package:diplomski_rad/interfaces/user/user.dart';
import 'package:diplomski_rad/services/firebase.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:diplomski_rad/widgets/gradient_button.dart';
import 'package:diplomski_rad/widgets/string_field.dart';

class HeaderComponent extends StatelessWidget implements PreferredSizeWidget {
  String currentPage;
  bool drawer;
  User user = Individual.getUser1();

  String oldPassword = "", newPassword = "", repeatNewPassword = "";

  HeaderComponent({
    Key? key,
    required this.currentPage,
    this.drawer = false,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return AppBar(
      backgroundColor: PalleteCommon.backgroundColor,
      automaticallyImplyLeading: drawer,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(4.0),
        child: Container(
          color: PalleteCommon.borderColor,
          height: 4.0,
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Expanded(flex: 1, child: SizedBox()),
            Expanded(
              flex: 3,
              child: InkWell(
                onHover: (value) {},
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  );
                },
                child: SizedBox(
                  height: height * 0.05,
                  child: Center(
                    child: Text(
                      "Diplomski rad",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
            const Expanded(flex: 25, child: SizedBox()),
            Expanded(
              flex: 6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UsersPage(),
                          ),
                        );
                      },
                      child: SizedBox(
                        height: height * 0.05,
                        child: const Center(
                          child: Text(
                            "Users",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EstatesPage(),
                          ),
                        );
                      },
                      child: SizedBox(
                        height: height * 0.05,
                        child: const Center(
                          child: Text(
                            "Estates",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onHover: (value) {},
                      onTap: () {
                        showDialog(
                          barrierColor: Colors.transparent,
                          context: context,
                          builder: (BuildContext context) => Dialog(
                              insetPadding: EdgeInsets.fromLTRB(
                                  0, height * 0.055, width * 0.015, 0),
                              shape: Border.all(
                                width: 2,
                                color: PalleteCommon.gradient2,
                              ),
                              alignment: Alignment.topRight,
                              child: SizedBox(
                                height: height * 0.2,
                                width: width * 0.1,
                                child: ListView(
                                  children: [
                                    ListTile(
                                      textColor: PalleteCommon.gradient2,
                                      hoverColor: PalleteCommon.highlightColor
                                          .withOpacity(0.35),
                                      tileColor: PalleteCommon.backgroundColor,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ProfilePage(),
                                          ),
                                        );
                                      },
                                      leading: const Icon(Icons.person),
                                      title: const Text("Profile page"),
                                    ),
                                    ListTile(
                                      textColor: PalleteCommon.gradient2,
                                      hoverColor: PalleteCommon.highlightColor
                                          .withOpacity(0.35),
                                      tileColor: PalleteCommon.backgroundColor,
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              changePasswordDialog(
                                            width,
                                            height,
                                            context,
                                            oldPassword,
                                            newPassword,
                                            repeatNewPassword,
                                          ),
                                        );
                                      },
                                      leading: const Icon(Icons.password),
                                      title: const Text("Change password"),
                                    ),
                                    ListTile(
                                      textColor: PalleteCommon.gradient2,
                                      hoverColor: PalleteCommon.highlightColor
                                          .withOpacity(0.35),
                                      tileColor: PalleteCommon.backgroundColor,
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) =>
                                              deleteAccountDialog(
                                                  width, height, context, user),
                                        );
                                      },
                                      leading: const Icon(Icons.gavel),
                                      title: const Text("Delete profile"),
                                    ),
                                    ListTile(
                                      textColor: PalleteCommon.gradient2,
                                      hoverColor: PalleteCommon.highlightColor
                                          .withOpacity(0.35),
                                      tileColor: PalleteCommon.backgroundColor,
                                      onTap: () {
                                        Navigator.popUntil(
                                            context, (route) => false);

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => LoginPage(),
                                          ),
                                        );
                                      },
                                      leading: const Icon(Icons.logout),
                                      title: const Text("Sign out"),
                                    ),
                                  ],
                                ),
                              )),
                        );
                      },
                      child: SizedBox(
                        height: height * 0.05,
                        child: Padding(
                            padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                            child: getUserImage(user, height)),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget changePasswordDialog(double width, double height, BuildContext context,
    String oldPassword, String newPassword, String repeatNewPassword) {
  return Dialog(
    insetPadding: EdgeInsets.fromLTRB(
      width * 0.25,
      height * 0.25,
      width * 0.25,
      height * 0.25,
    ),
    backgroundColor: PalleteCommon.backgroundColor,
    alignment: Alignment.center,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          StringField(
            osbcure: true,
            labelText: "Old password",
            callback: (String value) => oldPassword = value,
          ),
          const SizedBox(
            height: 22,
          ),
          StringField(
            osbcure: true,
            labelText: "New password",
            callback: (String value) => newPassword = value,
          ),
          const SizedBox(
            height: 22,
          ),
          StringField(
            osbcure: true,
            labelText: "Repeat new password",
            callback: (String value) => repeatNewPassword = value,
          ),
          const SizedBox(
            height: 28,
          ),
          GradientButton(
            buttonText: "Change password",
            callback: () {
              Navigator.pop(context);
              print("Password changed!");
            },
          ),
        ],
      ),
    ),
  );
}

Widget deleteAccountDialog(
    double width, double height, BuildContext context, User user) {
  String password = "";

  return Dialog(
    insetPadding: EdgeInsets.fromLTRB(
      width * 0.25,
      height * 0.25,
      width * 0.25,
      height * 0.25,
    ),
    backgroundColor: PalleteCommon.backgroundColor,
    alignment: Alignment.center,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Expanded(flex: 2, child: SizedBox()),
          const Expanded(
            flex: 2,
            child: Text(
              "Are you sure you want to delete your account?",
              style: TextStyle(
                fontSize: 18,
                color: PalleteCommon.gradient2,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Expanded(child: SizedBox()),
          Expanded(
            flex: 2,
            child: StringField(
              osbcure: true,
              labelText: "Password",
              callback: (String value) => password = value,
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
                    colors: [...PalleteDanger.getGradients()],
                    buttonText: "Delete account",
                    callback: () async {
                      await deleteUser(width, height, context, user, password);
                    },
                  ),
                ),
                const Expanded(
                  flex: 1,
                  child: SizedBox(),
                ),
                Expanded(
                  flex: 3,
                  child: GradientButton(
                    buttonText: "Cancel",
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

Future<void> deleteUser(double width, double height, BuildContext context,
    User user, String password) async {
  bool res = false;

  Map<String, dynamic>? userMap = User.toJSON(user);
  if (userMap != null) {
    res = await UserRepository.deleteUser(userMap, password);
  }

  if (!res) {
    final snackBar = SnackBar(
      content: const Text(
          'There was an error while deleting your account. Please try again (later)...'),
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

    Navigator.pop(context);
    return;
  }

  final snackBar = SnackBar(
    content: const Text('Your account has successfully been deleted!'),
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

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => LoginPage(),
    ),
  );
}

Image getUserImage(User user, double height) {
  if (user is Customer && user.avatarImage.isNotEmpty) {
    return Image.asset(
      user.avatarImage,
      fit: BoxFit.contain,
    );
  } else if (user is Company && user.avatarImage.isNotEmpty) {
    return Image.asset(
      user.avatarImage,
      fit: BoxFit.contain,
    );
  } else {
    return Image.asset("images/default_user.png");
  }
}

String? getCurrentPage(BuildContext context) {
  // print(ModalRoute.of(context)!.settings);
  return ModalRoute.of(context)!.settings.name;
}
