import 'package:flutter/material.dart';
import 'package:diplomski_rad/widgets/header_widget.dart';
import 'package:diplomski_rad/services/language.dart';
import 'package:diplomski_rad/interfaces/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:diplomski_rad/services/firebase.dart';

class HomePage extends StatefulWidget {
  User? user;
  LanguageService? lang;
  Map<String, dynamic> headerValues = <String, dynamic>{};

  HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? tmpUserId = prefs.getString("userId");
      String? tmpTypeOfUser = prefs.getString("typeOfUser");
      String? tmpAvatarImage = prefs.getString("avatarImage");
      String? tmpLanguage = prefs.getString("language");

      if (tmpUserId == null || tmpUserId.isEmpty) return;
      if (tmpTypeOfUser == null || tmpTypeOfUser.isEmpty) return;
      if (tmpLanguage == null || tmpLanguage.isEmpty) return;

      LanguageService tmpLang = LanguageService.getInstance(tmpLanguage);
      Map<String, dynamic>? userMap =
          await UserRepository.readUserWithId(tmpUserId);
      if (userMap == null) return;

      setState(() {
        widget.user = User.toUser(userMap);
        widget.lang = tmpLang;
        widget.headerValues["userId"] = tmpUserId;
        widget.headerValues["typeOfUser"] = tmpTypeOfUser;
        widget.headerValues["avatarImage"] = tmpAvatarImage ?? "";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.lang == null || widget.user == null) {
      return const SizedBox();
    }

    return Scaffold(
      appBar: HeaderComponent(
        currentPage: 'HomePage',
        headerValues: widget.headerValues,
        lang: widget.lang!,
      ),
      body: const Center(
        child: Text(
          "Credits?",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
