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
import 'package:diplomski_rad/services/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  String firstname = "Sandi";
  String lastname = "Ljubić";
  DateTime birthday = DateTime.now();

  String ownerFirstname = "Sandi";
  String ownerLastname = "Ljubić";
  String companyName = "Ljubić Ltd.";

  String typeOfUser = "com";
  String email = "sandi.ljubic@gmail.com";
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
                widget.lang.translate('sign_up'),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                ),
              ),
              const SizedBox(height: 50),
              DropdownField(
                labelText: widget.lang.translate('type_of_customer'),
                choices: [
                  widget.lang.translate('individual'),
                  widget.lang.translate('company')
                ],
                selected: widget.typeOfUser == "ind"
                    ? widget.lang.translate('individual')
                    : widget.lang.translate('company'),
                callback: (String value) {
                  setState(() {
                    if (value == widget.lang.translate('individual')) {
                      widget.typeOfUser = "ind";
                    } else if (value == widget.lang.translate('company')) {
                      widget.typeOfUser = "com";
                    }
                  });
                },
              ),
              const SizedBox(height: 15),
              widget.typeOfUser == "ind"
                  ? StringField(
                      presetText: widget.firstname,
                      labelText: widget.lang.translate('firstname'),
                      callback: (value) => widget.firstname = value,
                    )
                  : StringField(
                      presetText: widget.ownerFirstname,
                      labelText: widget.lang.translate('owner_firstname'),
                      callback: (value) => widget.ownerFirstname = value,
                    ),
              const SizedBox(height: 15),
              widget.typeOfUser == "ind"
                  ? StringField(
                      presetText: widget.lastname,
                      labelText: widget.lang.translate('lastname'),
                      callback: (value) => widget.lastname = value,
                    )
                  : StringField(
                      presetText: widget.ownerLastname,
                      labelText: widget.lang.translate('owner_lastname'),
                      callback: (value) => widget.ownerLastname = value,
                    ),
              const SizedBox(height: 15),
              widget.typeOfUser == "ind"
                  ? CalendarField(
                      selectingBirthday: true,
                      selectedDate: widget.birthday,
                      labelText: widget.lang.translate('date_of_birth'),
                      callback: (DateTime value) => widget.birthday = value,
                      lang: widget.lang,
                    )
                  : StringField(
                      presetText: widget.companyName,
                      labelText: widget.lang.translate('company_name'),
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
                labelText: widget.lang.translate('password'),
                callback: (value) => widget.password = value,
              ),
              const SizedBox(height: 15),
              StringField(
                osbcure: true,
                presetText: widget.repeatPassword,
                labelText: widget.lang.translate('repeat_password'),
                callback: (value) => widget.repeatPassword = value,
              ),
              const SizedBox(height: 20),
              GradientButton(
                  buttonText: widget.lang.translate('sign_up'),
                  callback: () => signUp(width, height),
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
                    }
                  ),
                  Text(widget.lang.translate('keep_me_logged_in')),
                ],
              ),
              const SizedBox(height: 15),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => toLoginPage(),
                  child: Text(widget.lang.translate('have_account_login_here')),
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
        "avatarImage": "",
        "backgroundImage": "",
        "city": "",
        "coordinates": null,
        "country": "",
        "dateFormat": "yyyy-MM-dd",
        "distance": "km",
        "language": "en",
        "numOfEstates": 0,
        "phone": "",
        "street": "",
        "zip": "",
        "firstname": widget.firstname,
        "lastname": widget.lastname,
        "birthday": widget.birthday,
        "email": widget.email,
        "typeOfUser": widget.typeOfUser,
        "password": widget.password,
        "banned": false,
        "blocked": false,
      };
    } else if (widget.typeOfUser == 'com') {
      userMap = {
        "avatarImage": "",
        "backgroundImage": "",
        "city": "",
        "coordinates": null,
        "country": "",
        "dateFormat": "yyyy-MM-dd",
        "distance": "km",
        "language": "en",
        "numOfEstates": 0,
        "phone": "",
        "street": "",
        "zip": "",
        "ownerFirstname": widget.ownerFirstname,
        "ownerLastname": widget.ownerLastname,
        "companyName": widget.companyName,
        "email": widget.email,
        "typeOfUser": widget.typeOfUser,
        "password": widget.password,
        "banned": false,
        "blocked": false,
      };
    } else {
      return;
    }

    User? user = await UserRepository.createCustomer(userMap);
    if (user == null) {
      showSnackBar(width, height, widget.lang.translate('cant_register'));
      return;
    }

    SharedPreferencesService sharedPreferencesService = SharedPreferencesService(await SharedPreferences.getInstance());
    await sharedPreferencesService.setUserId(user.id);
    if (user is Individual) {
      await sharedPreferencesService.setTypeOfUser("ind");
    } else if (user is Company) {
      await sharedPreferencesService.setTypeOfUser("com");
    }
    await sharedPreferencesService.setLanguage(user.preferences.language.isNotEmpty ? user.preferences.language : "en");
    await sharedPreferencesService.setKeepLoggedIn(widget.keepLoggedIn);
    await sharedPreferencesService.setAvatarImage(user is Customer ? user.avatarImage : "");
    
    showSnackBar(width, height, widget.lang.translate('account_successfully_created'));
    toHomePage();
  }

  void showSnackBar(double width, double height, String text) {
    // TODO: fix colors!
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

  void toLoginPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LoginPage(),
      ),
    );
  }
}
