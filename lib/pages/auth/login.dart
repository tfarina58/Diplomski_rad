import 'package:diplomski_rad/pages/auth/register.dart';
import 'package:diplomski_rad/services/language.dart';
import 'package:diplomski_rad/services/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:diplomski_rad/widgets/gradient_button.dart';
import 'package:diplomski_rad/widgets/string_field.dart';
import 'package:diplomski_rad/other/pallete.dart';
import 'package:diplomski_rad/pages/header/home.dart';
import 'package:diplomski_rad/services/firebase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:diplomski_rad/interfaces/user.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  bool keepLoggedIn = false;
  String email = "sandi.ljubic@gmail.com"; // "tfarina58@gmail.com";
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
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              Text(
                widget.lang.translate('sign_in'),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                ),
              ),
              const SizedBox(height: 65),
              StringField(
                presetText: widget.email,
                labelText: widget.lang.translate('email'),
                callback: (value) => setState(() {
                  widget.email = value;
                }),
              ),
              const SizedBox(height: 15),
              StringField(
                osbcure: true,
                presetText: widget.password,
                labelText: widget.lang.translate('password'),
                callback: (value) => setState(() {
                  widget.password = value;
                }),
              ),
              const SizedBox(height: 20),
              GradientButton(
                buttonText: widget.lang.translate('sign_in'),
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
                  Text(widget.lang.translate('keep_me_logged_in')),
                ],
              ),
              const SizedBox(height: 15),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => toRegisterPage(),
                  child: Text(widget.lang.translate('dont_have_account_register_here')),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferencesService sharedPreferencesService = SharedPreferencesService(await SharedPreferences.getInstance());
      bool tmpKeepLoggedIn = sharedPreferencesService.getKeepLoggedIn();
      String tmpUserId = sharedPreferencesService.getUserId();
      String tmpTypeOfUser = sharedPreferencesService.getTypeOfUser();
      if (!tmpKeepLoggedIn || tmpUserId.isEmpty && tmpTypeOfUser.isEmpty) return;

      toHomePage();
    });
  }

  void signIn(double width, double height, String email, String password, bool keepLoggedIn) async {
    User? user = await UserRepository.loginUser(email, password);

    // TODO: fix colors!
    // TODO: keepLoggedIn!
    if (user != null) {
      if (user is Customer && user.banned == true) {
        showSnackBar(width, height, widget.lang.translate('banned_by_admin'));
      } else if (user is Customer && user.blocked == true) {
        showSnackBar(width, height, widget.lang.translate('blocked_by_admin'));
      } else {
        SharedPreferencesService sharedPreferencesService = SharedPreferencesService(await SharedPreferences.getInstance());
        await sharedPreferencesService.setUserId(user.id);
        if (user is Individual) {
          await sharedPreferencesService.setTypeOfUser("ind");
        } else if (user is Company) {
          await sharedPreferencesService.setTypeOfUser("com");
        } else if (user is Admin) {
          await sharedPreferencesService.setTypeOfUser("adm");
        }
        await sharedPreferencesService.setDateFormat(user.preferences.dateFormat.isNotEmpty ? user.preferences.dateFormat : "en");
        await sharedPreferencesService.setLanguage(user.preferences.language.isNotEmpty ? user.preferences.language : "en");
        await sharedPreferencesService.setKeepLoggedIn(keepLoggedIn);
        await sharedPreferencesService.setAvatarImage(user is Customer && user.avatarImage.isNotEmpty ? user.avatarImage : "");

        toHomePage();
      }
    } else {
      showSnackBar(width, height, widget.lang.translate('cant_log_in'));
    }
  }

  void showSnackBar(double width, double height, String text) {
    SnackBar feedback = SnackBar(
      content: Text(text),
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
    ScaffoldMessenger.of(context).showSnackBar(feedback);
  }

  void toHomePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(),
      ),
    );
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
