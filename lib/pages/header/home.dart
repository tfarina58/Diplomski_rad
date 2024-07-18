import 'package:flutter/material.dart';
import 'package:diplomski_rad/widgets/header_widget.dart';
import 'package:diplomski_rad/services/language.dart';
import 'package:diplomski_rad/interfaces/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:diplomski_rad/services/firebase.dart';
import 'package:diplomski_rad/services/shared_preferences.dart';

class HomePage extends StatefulWidget {
  User? user;
  LanguageService? lang;

  HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferencesService sharedPreferencesService = SharedPreferencesService(await SharedPreferences.getInstance());
      String tmpUserId = sharedPreferencesService.getUserId();
      String tmpTypeOfUser = sharedPreferencesService.getTypeOfUser();
      String tmpLanguage = sharedPreferencesService.getLanguage();

      if (tmpUserId.isEmpty) return;
      if (tmpTypeOfUser.isEmpty) return;
      if (tmpLanguage.isEmpty) return;

      LanguageService tmpLang = LanguageService.getInstance(tmpLanguage);
      Map<String, dynamic>? userMap = await UserRepository.readUserWithId(tmpUserId);
      if (userMap == null) return;

      setState(() {
        widget.user = User.toUser(userMap);
        widget.lang = tmpLang;
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
        userId: widget.user?.id ?? "",
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
