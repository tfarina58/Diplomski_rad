import 'package:diplomski_rad/auth/register/register.dart';
import 'package:flutter/material.dart';
import 'package:diplomski_rad/widgets/gradient_button.dart';
import 'package:diplomski_rad/widgets/string_field.dart';
import 'package:diplomski_rad/widgets/social_button.dart';
import 'package:diplomski_rad/other/pallete.dart';
import 'package:diplomski_rad/home/home.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool keepLoggedIn = false;
  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  labelText: 'Email', callback: (value) => email = value),
              const SizedBox(height: 15),
              StringField(
                  labelText: 'Password', callback: (value) => password = value),
              const SizedBox(height: 20),
              GradientButton(buttonText: 'Sign in', callback: signIn),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    activeColor: PalleteCommon.gradient2,
                    value: keepLoggedIn,
                    onChanged: (bool? value) {
                      setState(() {
                        keepLoggedIn = value!;
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

  void signIn() async {
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
