import 'package:diplomski_rad/auth/login/login.dart';
import 'package:diplomski_rad/home/home.dart';
import 'package:diplomski_rad/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:diplomski_rad/widgets/gradient_button.dart';
import 'package:diplomski_rad/widgets/string_field.dart';
import 'package:diplomski_rad/widgets/calendar_field.dart';
import 'package:diplomski_rad/widgets/dropdown_field.dart';
import 'package:diplomski_rad/interfaces/user/user.dart';
import 'package:diplomski_rad/interfaces/preferences/user-preferences.dart';
import 'package:diplomski_rad/services/firebase.dart';
import 'package:diplomski_rad/other/pallete.dart';
import 'package:intl/intl.dart';

class RegisterPage extends StatefulWidget {
  String firstname = "Toni";
  String lastname = "Farina";
  DateTime birthday = DateTime.now();

  String ownerFirstname = "Toni";
  String ownerLastname = "Farina";
  String companyName = "Farina Inc.";

  String typeOfUser = "ind";
  String email = "tfarina58@gmail.com";
  String password = "password";
  String repeatPassword = "password";
  bool keepLoggedIn = false;

  RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
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
              DropdownField(
                labelText: 'Type of customer',
                choices: const ["Individual", "Company"],
                selected: widget.typeOfUser == "ind" ? "Individual" : "Company",
                callback: (String value) {
                  setState(() {
                    if (value == "Individual") {
                      widget.typeOfUser = "ind";
                    } else if (value == "Company") {
                      widget.typeOfUser = "com";
                    }
                  });
                },
              ),
              const SizedBox(height: 15),
              widget.typeOfUser == "ind"
                  ? StringField(
                      presetText: widget.firstname,
                      labelText: 'First name',
                      callback: (value) => widget.firstname = value,
                    )
                  : StringField(
                      presetText: widget.ownerFirstname,
                      labelText: 'Owner\'s first name',
                      callback: (value) => widget.ownerFirstname = value,
                    ),
              const SizedBox(height: 15),
              widget.typeOfUser == "ind"
                  ? StringField(
                      presetText: widget.lastname,
                      labelText: 'Last name',
                      callback: (value) => widget.lastname = value,
                    )
                  : StringField(
                      presetText: widget.ownerLastname,
                      labelText: 'Owner\'s last name',
                      callback: (value) => widget.ownerLastname = value,
                    ),
              const SizedBox(height: 15),
              widget.typeOfUser == "ind"
                  ? CalendarField(
                      selectedDate: widget.birthday,
                      labelText: 'Date of birth',
                      callback: (DateTime value) => widget.birthday = value,
                    )
                  : StringField(
                      presetText: widget.companyName,
                      labelText: 'Company\'s name',
                      callback: (value) => widget.companyName = value,
                    ),
              Divider(
                height: 33,
                thickness: 3,
                indent: MediaQuery.of(context).size.width * 0.5 - 200,
                endIndent: MediaQuery.of(context).size.width * 0.5 - 200,
                color: PalleteCommon.gradient2,
              ),
              StringField(
                presetText: widget.email,
                labelText: 'Email',
                callback: (value) => widget.email = value,
              ),
              const SizedBox(height: 15),
              StringField(
                osbcure: true,
                presetText: widget.password,
                labelText: 'Password',
                callback: (value) => widget.password = value,
              ),
              const SizedBox(height: 15),
              StringField(
                osbcure: true,
                presetText: widget.repeatPassword,
                labelText: 'Repeat password',
                callback: (value) => widget.repeatPassword = value,
              ),
              const SizedBox(height: 20),
              GradientButton(
                  buttonText: 'Sign up',
                  callback: () {
                    setState(() {
                      signUp(width, height);
                    });
                  }),
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

  void signUp(double width, double height) async {
    Map<String, dynamic> userMap = {
      "firstname": widget.firstname,
      "lastname": widget.lastname,
      "birthday": widget.birthday,
      "email": widget.email,
      "typeOfUser": widget.typeOfUser,
      "password": widget.password,
    };

    User? user = await UserRepository.createCustomer(userMap);
    if (user == null) {
      // TODO: fix colors!
      final snackBar = SnackBar(
        content: const Text(
            'There was an error while creating your account. Please try again (later)...'),
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
      ;
      return;
    }
    // TODO: fix colors!
    final snackBar = SnackBar(
      content: const Text('Your account has successfully been created!'),
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
