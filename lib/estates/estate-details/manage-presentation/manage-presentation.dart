import 'package:diplomski_rad/components/header.dart';
import 'package:diplomski_rad/services/language.dart';
import 'package:flutter/material.dart';
import 'package:diplomski_rad/other/pallete.dart';
import 'package:diplomski_rad/widgets/string_field.dart';
import 'package:diplomski_rad/widgets/gradient_button.dart';
import 'package:diplomski_rad/interfaces/estate/estate.dart';
import 'dart:math';

class ManagePresentationPage extends StatefulWidget {
  Estate estate;
  int selected = 0;
  // Presentation presentation;

  ManagePresentationPage({Key? key, required this.estate}) : super(key: key);

  @override
  State<ManagePresentationPage> createState() => _ManagePresentationPageState();
}

class _ManagePresentationPageState extends State<ManagePresentationPage> {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: HeaderComponent(
        currentPage: 'ManagePresentationPage',
        headerValues: {},
        lang: LanguageService(language: "en"),
      ),
      body: Drawer(
        semanticLabel: "Show presentation list",
        width: width * 0.2,
        backgroundColor: PalleteCommon.backgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(),
              child: Stack(
                children: [],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}
