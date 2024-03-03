import 'package:diplomski_rad/pages/auth/login.dart';
import 'package:diplomski_rad/pages/header/home.dart';
import 'package:flutter/material.dart';
import 'package:diplomski_rad/widgets/gradient_button.dart';
import 'package:diplomski_rad/widgets/string_field.dart';
import 'package:diplomski_rad/widgets/calendar_field.dart';
import 'package:diplomski_rad/widgets/dropdown_field.dart';
import 'package:diplomski_rad/interfaces/user.dart';
import 'package:diplomski_rad/services/firebase.dart';
import 'package:diplomski_rad/other/pallete.dart';
import 'package:diplomski_rad/services/language.dart';

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

  LanguageService lang = LanguageService.getInstance("en");

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
              Text(
                widget.lang.dictionary["sign_up"]!,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                ),
              ),
              const SizedBox(height: 50),
              DropdownField(
                labelText: widget.lang.dictionary["type_of_customer"]!,
                choices: [
                  widget.lang.dictionary["individual"]!,
                  widget.lang.dictionary["company"]!
                ],
                selected: widget.typeOfUser == "ind"
                    ? widget.lang.dictionary["individual"]!
                    : widget.lang.dictionary["company"]!,
                callback: (String value) {
                  setState(() {
                    if (value == widget.lang.dictionary["individual"]!) {
                      widget.typeOfUser = "ind";
                    } else if (value == widget.lang.dictionary["company"]!) {
                      widget.typeOfUser = "com";
                    }
                  });
                },
              ),
              const SizedBox(height: 15),
              widget.typeOfUser == "ind"
                  ? StringField(
                      presetText: widget.firstname,
                      labelText: widget.lang.dictionary["firstname"]!,
                      callback: (value) => widget.firstname = value,
                    )
                  : StringField(
                      presetText: widget.ownerFirstname,
                      labelText: widget.lang.dictionary["owner_firstname"]!,
                      callback: (value) => widget.ownerFirstname = value,
                    ),
              const SizedBox(height: 15),
              widget.typeOfUser == "ind"
                  ? StringField(
                      presetText: widget.lastname,
                      labelText: widget.lang.dictionary["lastname"]!,
                      callback: (value) => widget.lastname = value,
                    )
                  : StringField(
                      presetText: widget.ownerLastname,
                      labelText: widget.lang.dictionary["owner_lastname"]!,
                      callback: (value) => widget.ownerLastname = value,
                    ),
              const SizedBox(height: 15),
              widget.typeOfUser == "ind"
                  ? CalendarField(
                      selectingBirthday: true,
                      selectedDate: widget.birthday,
                      labelText: widget.lang.dictionary["date_of_birth"]!,
                      callback: (DateTime value) => widget.birthday = value,
                    )
                  : StringField(
                      presetText: widget.companyName,
                      labelText: widget.lang.dictionary["company_name"]!,
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
                labelText: widget.lang.dictionary["password"]!,
                callback: (value) => widget.password = value,
              ),
              const SizedBox(height: 15),
              StringField(
                osbcure: true,
                presetText: widget.repeatPassword,
                labelText: widget.lang.dictionary["repeat_password"]!,
                callback: (value) => widget.repeatPassword = value,
              ),
              const SizedBox(height: 20),
              GradientButton(
                  buttonText: widget.lang.dictionary["sign_up"]!,
                  callback: () {
                    signUp(width, height);
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
                    }
                  ),
                  Text(widget.lang.dictionary["keep_me_logged_in"]!),
                ],
              ),
              const SizedBox(height: 15),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => toLoginPage(),
                  child: Text(widget.lang.dictionary["have_account_login_here"]!),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void signUp(double width, double height) async {
    Map<String, dynamic> userMap;
    if (widget.typeOfUser == 'ind') {
      userMap = {
        "firstname": widget.firstname,
        "lastname": widget.lastname,
        "birthday": widget.birthday,
        "email": widget.email,
        "typeOfUser": widget.typeOfUser,
        "password": widget.password,
        "banned": false,
        "blocked": false,
        "numOfEstates": 0,
      };
    } else if (widget.typeOfUser == 'com') {
      userMap = {
        "ownerFirstname": widget.firstname,
        "ownerLastname": widget.lastname,
        "companyName": widget.companyName,
        "email": widget.email,
        "typeOfUser": widget.typeOfUser,
        "password": widget.password,
        "banned": false,
        "blocked": false,
        "numOfEstates": 0,
      };
    } else {
      return;
    }

    User? user = await UserRepository.createCustomer(userMap);
    if (user == null) {
      // TODO: fix colors!
      showSnackBar(width, height, widget.lang.dictionary["cant_register"]!);
      return;
    }
    // TODO: fix colors!
    showSnackBar(width, height, widget.lang.dictionary["account_successfully_created"]!);
    toHomePage();
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
        label: widget.lang.dictionary["dismiss"]!,
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

  void toLoginPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }
}
