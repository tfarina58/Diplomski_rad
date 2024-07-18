import 'package:diplomski_rad/pages/auth/login.dart';
import 'package:diplomski_rad/pages/header/home.dart';
import 'package:diplomski_rad/services/language.dart';
import 'package:diplomski_rad/pages/estates/estates.dart';
import 'package:diplomski_rad/pages/header/users.dart';
import 'package:diplomski_rad/pages/header/profile.dart';
import 'package:diplomski_rad/widgets/snapshot_error_field.dart';
import 'package:flutter/material.dart';
import 'package:diplomski_rad/other/pallete.dart';
import 'package:diplomski_rad/services/firebase.dart';
import 'package:diplomski_rad/widgets/gradient_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diplomski_rad/widgets/string_field.dart';
import 'package:diplomski_rad/interfaces/user.dart';
import 'package:diplomski_rad/services/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class HeaderComponent extends StatefulWidget implements PreferredSizeWidget {
  String currentPage;
  String userId;
  User? user;
  String oldPassword = "", newPassword = "", repeatNewPassword = "";
  LanguageService lang;

  HeaderComponent({
    Key? key,
    required this.currentPage,
    required this.userId,
    required this.lang,
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
      automaticallyImplyLeading: false,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(4.0),
        child: Container(
          color: PalleteCommon.borderColor,
          height: 4.0,
        ),
      ),
      title: 
        widget.userId.isNotEmpty ?
        StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(widget.userId)
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
            final document = snapshot.data;
            if (document == null) return Center(child: Text(widget.lang.translate('error_while_gathering_your_data')));

            Map<String, dynamic>? userMap = document.data();
            if (userMap == null) return Center(child: Text(widget.lang.translate('error_while_gathering_your_data')));

            userMap["id"] = document.id;
            User? tmpUser = User.toUser(userMap);

            if (tmpUser == null) return Center(child: Text(widget.lang.translate('error_while_gathering_your_data')));
            widget.user = tmpUser;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Expanded(flex: 1, child: SizedBox()),
                  Expanded(
                    flex: 4,
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
                        // if (widget.user is Admin)
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
                        // if (widget.user is Customer)
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
                                    insetPadding: EdgeInsets.fromLTRB(0, height * 0.055, width * 0.015, 0),
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
                                            hoverColor: PalleteCommon.highlightColor.withOpacity(0.35),
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
                                            hoverColor: PalleteCommon.highlightColor.withOpacity(0.35),
                                            tileColor: PalleteCommon.backgroundColor,
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) =>
                                                    changePasswordDialog(width, height, context),
                                              );
                                            },
                                            leading: const Icon(Icons.password),
                                            title: Text(
                                              widget.lang.translate('change_password'),
                                            ),
                                          ),
                                          ListTile(
                                            textColor: PalleteCommon.gradient2,
                                            hoverColor: PalleteCommon.highlightColor.withOpacity(0.35),
                                            tileColor: PalleteCommon.backgroundColor,
                                            onTap: () {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) =>
                                                    deleteAccountDialog(width, height, context, widget.user!.id),
                                              );
                                            },
                                            leading: const Icon(Icons.gavel),
                                            title: Text(widget.lang.translate('delete_account')),
                                          ),
                                          ListTile(
                                            textColor: PalleteCommon.gradient2,
                                            hoverColor: PalleteCommon.highlightColor.withOpacity(0.35),
                                            tileColor: PalleteCommon.backgroundColor,
                                            onTap: () async {      
                                              SharedPreferencesService sharedPreferencesService = SharedPreferencesService(await SharedPreferences.getInstance());
                                              await sharedPreferencesService.setUserId("");
                                              await sharedPreferencesService.setTypeOfUser("");
                                              await sharedPreferencesService.setLanguage("en");
                                              await sharedPreferencesService.setKeepLoggedIn(false);
                                              await sharedPreferencesService.setAvatarImage("");
                                              await sharedPreferencesService.setDateFormat("");
          
                                              Navigator.popUntil(context, (route) => false);
          
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
            );
          }
        }
    ) : const SizedBox(),
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
              callback: () async {
                changePassword(width, height);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget deleteAccountDialog(double width, double height, BuildContext context, String userId) {
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
                        await deleteUser(width, height, context, userId, password);
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

  Future<void> deleteUser(double width, double height, BuildContext context, String userId, String password) async {
    String hashedPassword = sha256.convert(utf8.encode(password)).toString();

    bool res = await UserRepository.deleteUser(userId, hashedPassword);

    if (!res) {
      showSnackBar(width, height, widget.lang.translate('error_while_deleting_account'));
      Navigator.pop(context);
      return;
    }

    showSnackBar(width, height, widget.lang.translate('successfull_delete_account'));
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }

  Future<void> changePassword(double width, double height) async {
    String password = sha256.convert(utf8.encode(widget.oldPassword)).toString();

    if (! (await UserRepository.checkPasswordMatching(widget.user!.id, password))) {
      showSnackBar(width, height, widget.lang.translate('old_password_does_not_match'));
      Navigator.pop(context);
      return;
    }

    if (widget.newPassword != widget.repeatNewPassword) {
      showSnackBar(width, height, widget.lang.translate('passwords_do_not_match'));
      Navigator.pop(context);
      return;
    }

    password = sha256.convert(utf8.encode(widget.newPassword)).toString();

    bool res = await UserRepository.updateUser(widget.user!.id, {"password": password});

    if (!res) {
      showSnackBar(width, height, widget.lang.translate('error_while_updating_password'));
      Navigator.pop(context);
      return;
    }

    showSnackBar(width, height, widget.lang.translate('successfull_changed_password'));
    Navigator.pop(context);
    return;
  }

  Image getUserImage() {
    if (widget.user is Customer && (widget.user as Customer).avatarImage.isNotEmpty) {
      return Image.network(
        (widget.user as Customer).avatarImage,
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

  void showSnackBar(double width, double height, String text) {
    SnackBar feedback = SnackBar(
      dismissDirection: DismissDirection.down,
      content: Center(child: Text(text)),
      backgroundColor: (Colors.white),
      behavior: SnackBarBehavior.fixed,
      closeIconColor: PalleteCommon.gradient2,
      action: SnackBarAction(
        label: widget.lang.translate('dismiss'),
        onPressed: () {},
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(feedback);
  }
}
