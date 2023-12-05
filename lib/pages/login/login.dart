import 'package:diplomski_rad/pages/register/register.dart';
import 'package:diplomski_rad/services/language.dart';
import 'package:flutter/material.dart';
import 'package:diplomski_rad/widgets/gradient_button.dart';
import 'package:diplomski_rad/widgets/string_field.dart';
import 'package:diplomski_rad/widgets/social_button.dart';
import 'package:diplomski_rad/other/pallete.dart';
import 'package:diplomski_rad/pages/home/home.dart';
import 'package:diplomski_rad/services/firebase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:diplomski_rad/interfaces/user/user.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  bool keepLoggedIn = false;
  String email = "tfarina58@gmail.com";
  String password = "password";
  LanguageService lang = LanguageService.getInstance("en");

  @override
  State<LoginPage> createState() => _LoginPageState();

  final _key = GlobalKey<ScaffoldState>();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      key: widget._key,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Center(
          child: Column(
            children: [
              SizedBox(
                child: null,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              Text(
                widget.lang.dictionary["sign_in"]!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                ),
              ),
              const SizedBox(height: 50),
              SocialButton(
                iconPath: 'svgs/google.svg',
                label: widget.lang.dictionary["sign_in_with_google"]!,
                method: () {},
                horizontalPadding: 110,
              ),
              /*const SizedBox(height: 20),
              SocialButton(
                iconPath: 'svgs/facebook.svg',
                label: widget.lang.dictionary["sign_in_with_facebook"]!,
                method: () {},
                horizontalPadding: 100,
              ),*/
              const SizedBox(height: 15),
              Text(
                widget.lang.dictionary["or"]!,
                style: const TextStyle(
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 15),
              StringField(
                presetText: widget.email,
                labelText: widget.lang.dictionary["email"]!,
                callback: (value) => setState(() {
                  widget.email = value;
                }),
              ),
              const SizedBox(height: 15),
              StringField(
                osbcure: true,
                presetText: widget.password,
                labelText: widget.lang.dictionary["password"]!,
                callback: (value) => setState(() {
                  widget.password = value;
                }),
              ),
              const SizedBox(height: 20),
              GradientButton(
                buttonText: widget.lang.dictionary["sign_in"]!,
                callback: () => setState(() {
                  signIn(
                    width,
                    height,
                    widget.email,
                    widget.password,
                    widget.keepLoggedIn,
                  );
                }),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    activeColor: PalleteCommon.gradient2,
                    value: widget.keepLoggedIn,
                    onChanged: (bool? value) {
                      setState(() {
                        widget.keepLoggedIn = value!;
                      });
                    },
                  ),
                  Text(widget.lang.dictionary["keep_me_logged_in"]!),
                ],
              ),
              const SizedBox(height: 15),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => toRegisterPage(),
                  child: Text(widget
                      .lang.dictionary["dont_have_account_register_here"]!),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void signIn(double width, double height, String email, String password,
      bool keepLoggedIn) async {
    User? user = await UserRepository.loginUser(email, password);

    // TODO: fix colors!
    SnackBar feedback;
    if (user != null) {
      if (user is Customer && user.banned == true) {
        feedback = SnackBar(
          content: Text(
            widget.lang.dictionary["banned_by_admin"]!,
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
            label: widget.lang.dictionary["dismiss"]!,
            onPressed: () {},
          ),
        );
      } else if (user is Customer && user.blocked == true) {
        feedback = SnackBar(
          content: Text(
            widget.lang.dictionary["blocked_by_admin"]!,
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
            label: widget.lang.dictionary["dismiss"]!,
            onPressed: () {},
          ),
        );
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("userId", user.id);
        if (user is Individual) {
          await prefs.setString("typeOfUser", "ind");
          await prefs.setString(
              "language",
              user.preferences.language.isEmpty
                  ? user.preferences.language
                  : "en");
          await prefs.setString(
              "avatarImage", user.avatarImage.isEmpty ? user.avatarImage : "");
        } else if (user is Company) {
          await prefs.setString("typeOfUser", "com");
          await prefs.setString(
            "language",
            user.preferences.language.isEmpty
                ? user.preferences.language
                : "en",
          );
          await prefs.setString(
            "avatarImage",
            user.avatarImage.isEmpty ? user.avatarImage : "",
          );
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(),
          ),
        );
      }
    } else {
      feedback = SnackBar(
        content: Text(widget.lang.dictionary["cant_log_in"]!),
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
          label: widget.lang.dictionary["dismiss"]!,
          onPressed: () {},
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(feedback);
    }
  }

  void toRegisterPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterPage(),
      ),
    );
  }
}
