import 'package:diplomski_rad/auth/login/login.dart';
import 'package:diplomski_rad/home/home.dart';
import 'package:flutter/material.dart';
import 'package:diplomski_rad/widgets/gradient_button.dart';
import 'package:diplomski_rad/widgets/string_field.dart';
import 'package:diplomski_rad/widgets/calendar_field.dart';
import 'package:diplomski_rad/widgets/dropdown_field.dart';
import 'package:diplomski_rad/other/pallete.dart';

class RegisterPage extends StatefulWidget {
  String firstName = "";
  String lastName = "";
  String typeOfUser = "ind";
  String email = "";
  String password = "";
  String repeatPassword = "";
  DateTime birthday = DateTime.now();
  bool keepLoggedIn = false;

  RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
                height: MediaQuery.of(context).size.height * 0.06,
              ),
              const Text(
                'Sign up.',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                ),
              ),
              const SizedBox(height: 50),
              StringField(
                labelText: 'First name',
                callback: (value) => widget.firstName = value,
              ),
              const SizedBox(height: 15),
              StringField(
                labelText: 'Last name',
                callback: (value) => widget.lastName = value,
              ),
              const SizedBox(height: 15),
              CalendarField(
                labelText: 'Date of birth',
                callback: (value) => widget.birthday = value,
              ),
              const SizedBox(height: 15),
              DropdownField(
                labelText: 'Type of customer',
                choices: const ["Individual", "Company"],
                callback: (value) => widget.typeOfUser = value,
              ),
              // const SizedBox(height: 15),
              Divider(
                height: 33,
                thickness: 3,
                indent: MediaQuery.of(context).size.width * 0.5 - 200,
                endIndent: MediaQuery.of(context).size.width * 0.5 - 200,
                color: PalleteCommon.gradient2,
              ),
              StringField(
                labelText: 'Email',
                callback: (value) => widget.email = value,
              ),
              const SizedBox(height: 15),
              StringField(
                labelText: 'Password',
                callback: (value) => widget.password = value,
              ),
              const SizedBox(height: 15),
              StringField(
                labelText: 'Repeat password',
                callback: (value) => widget.repeatPassword = value,
              ),
              const SizedBox(height: 20),
              GradientButton(buttonText: 'Sign up', callback: signUp),
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
                      }),
                  const Text("Keep me logged in."),
                ],
              ),
              const SizedBox(height: 15),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => toLoginPage(),
                  child: const Text("Already have an account? Sign in here."),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void signUp() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(),
      ),
    );
  }

  void toLoginPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }
}
