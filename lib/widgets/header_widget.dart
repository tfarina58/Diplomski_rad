import 'package:diplomski_rad/pages/auth/login.dart';
import 'package:diplomski_rad/pages/header/home.dart';
import 'package:diplomski_rad/services/language.dart';
import 'package:diplomski_rad/pages/estates/estates.dart';
import 'package:diplomski_rad/pages/header/users.dart';
import 'package:diplomski_rad/pages/header/profile.dart';
import 'package:flutter/material.dart';
import 'package:diplomski_rad/other/pallete.dart';
import 'package:diplomski_rad/services/firebase.dart';
import 'package:diplomski_rad/widgets/gradient_button.dart';
import 'package:diplomski_rad/widgets/string_field.dart';

class HeaderComponent extends StatefulWidget implements PreferredSizeWidget {
  String currentPage;
  Map<String, dynamic> headerValues; //userId, typeOfUser, userImage, language;
  String oldPassword = "", newPassword = "", repeatNewPassword = "";
  LanguageService lang;
  bool drawer;

  HeaderComponent({
    Key? key,
    required this.currentPage,
    required this.headerValues,
    required this.lang,
    this.drawer = false,
  }) : super(key: key);

  @override
  State<HeaderComponent> createState() => _HeaderComponentState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _HeaderComponentState extends State<HeaderComponent> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return AppBar(
      backgroundColor: PalleteCommon.backgroundColor,
      automaticallyImplyLeading: widget.drawer,
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
                      builder: (context) => HomePage(),
                    ),
                  );
                },
                child: SizedBox(
                  height: height * 0.05,
                  child: Center(
                    child: Text(
                      widget.lang.translate('project_title'),
                      style: const TextStyle(fontWeight: FontWeight.bold),
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
                        child: Center(
                          child: Text(
                            widget.lang.translate('users'),
                            style: const TextStyle(fontSize: 18),
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
                        child: Center(
                          child: Text(
                            widget.lang.translate('estates'),
                            style: const TextStyle(fontSize: 18),
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
                                  scrollDirection: Axis.vertical,
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
                                            builder: (context) => ProfilePage(enableEditing: true,),
                                          ),
                                        );
                                      },
                                      leading: const Icon(Icons.person),
                                      title: Text(
                                        widget.lang.translate('profile_page'),
                                      ),
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
                                                  width, height, context),
                                        );
                                      },
                                      leading: const Icon(Icons.password),
                                      title: Text(
                                        widget.lang
                                            .translate('change_password'),
                                      ),
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
                                                  width,
                                                  height,
                                                  context,
                                                  widget
                                                      .headerValues["userId"]),
                                        );
                                      },
                                      leading: const Icon(Icons.gavel),
                                      title: Text(widget
                                          .lang.translate('delete_account')),
                                    ),
                                    ListTile(
                                      textColor: PalleteCommon.gradient2,
                                      hoverColor: PalleteCommon.highlightColor
                                          .withOpacity(0.35),
                                      tileColor: PalleteCommon.backgroundColor,
                                      onTap: () {
                                        // await GoogleAuthService.signOut();

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
                                      title: Text(
                                        widget.lang.translate('sign_out'),
                                      ),
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
                          child: getUserImage()
                        ),
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

  @override
  void initState() {
    super.initState();
  }

  Widget changePasswordDialog(
      double width, double height, BuildContext context) {
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
              labelText: widget.lang.translate('old_password'),
              callback: (String value) => widget.oldPassword = value,
            ),
            const SizedBox(
              height: 22,
            ),
            StringField(
              osbcure: true,
              labelText: widget.lang.translate('new_password'),
              callback: (String value) => widget.newPassword = value,
            ),
            const SizedBox(
              height: 22,
            ),
            StringField(
              osbcure: true,
              labelText: widget.lang.translate('repeat_password'),
              callback: (String value) => widget.repeatNewPassword = value,
            ),
            const SizedBox(
              height: 28,
            ),
            GradientButton(
              buttonText: widget.lang.translate('change_password'),
              callback: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget deleteAccountDialog(
      double width, double height, BuildContext context, String userId) {
    if (userId.isEmpty) return const Text("Missing user ID");
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
            Expanded(
              flex: 2,
              child: Text(
                widget.lang.translate('delete_account_warning_message'),
                style: const TextStyle(
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
                labelText: widget.lang.translate('password'),
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
                      buttonText: widget.lang.translate('delete_account'),
                      callback: () async {
                        await deleteUser(
                            width, height, context, userId, password);
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
                      buttonText: widget.lang.translate('cancel'),
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
      String userId, String password) async {
    bool res = await UserRepository.deleteUser(userId, password);

    if (!res) {
      final snackBar = SnackBar(
        content: Text(
          widget.lang.translate('error_while_deleting'),
        ),
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
          label: widget.lang.translate('dismiss'),
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      Navigator.pop(context);
      return;
    }

    final snackBar = SnackBar(
      content: Text(
        widget.lang.translate('successfull_delete_account'),
      ),
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
        label: widget.lang.translate('dismiss'),
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

  Image getUserImage() {
    if (widget.headerValues["avatarImage"].isNotEmpty) {
      return Image.network(
        widget.headerValues["avatarImage"],
        fit: BoxFit.contain,
        errorBuilder: (context, error, StackTrace? stackTrace) {
          return Image.asset("images/default_user.png");
        },
      );
    } else {
      return Image.asset("images/default_user.png");
    }
  }

  String? getCurrentPage(BuildContext context) {
    return ModalRoute.of(context)!.settings.name;
  }
}
