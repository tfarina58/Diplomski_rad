import 'package:diplomski_rad/auth/register/register.dart';
import 'package:diplomski_rad/interfaces/user/user.dart';
import 'package:flutter/material.dart';
import 'package:diplomski_rad/widgets/gradient_button.dart';
import 'package:diplomski_rad/widgets/string_field.dart';
import 'package:diplomski_rad/widgets/social_button.dart';
import 'package:diplomski_rad/other/pallete.dart';
import 'package:diplomski_rad/home/home.dart';
import 'package:diplomski_rad/services/firebase.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  bool keepLoggedIn = false;
  String email = "tfarina58@gmail.com";
  String password = "password";

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
        child: Center(
          child: Column(
            children: [
              SizedBox(
                child: null,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              const Text(
                'Sign in.',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                ),
              ),
              const SizedBox(height: 50),
              const SocialButton(
                iconPath: 'svgs/google.svg',
                label: 'Continue with Google',
                method: 'Google',
              ),
              const SizedBox(height: 20),
              const SocialButton(
                iconPath: 'svgs/facebook.svg',
                label: 'Continue with Facebook',
                method: 'Facebook',
                horizontalPadding: 90,
              ),
              const SizedBox(height: 15),
              const Text(
                'or',
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              const SizedBox(height: 15),
              StringField(
                presetText: widget.email,
                labelText: 'Email',
                callback: (value) => setState(() {
                  widget.email = value;
                }),
              ),
              const SizedBox(height: 15),
              StringField(
                osbcure: true,
                presetText: widget.password,
                labelText: 'Password',
                callback: (value) => setState(() {
                  widget.password = value;
                }),
              ),
              const SizedBox(height: 20),
              GradientButton(
                buttonText: 'Sign in',
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
                  const Text("Keep me logged in."),
                ],
              ),
              const SizedBox(height: 15),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => toRegisterPage(),
                  child: const Text("Don't have an account? Sign up here."),
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
    User? user = await UserRepository.readUser(email, password);
    if (user == null) {
      // TODO: fix colors!
      final snackBar = SnackBar(
        content: const Text(
            'There was an error while logging in. Please try again (later)...'),
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
      return;
    }

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
