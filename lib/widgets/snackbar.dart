import 'package:diplomski_rad/other/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math';
import 'dart:ui';

class SnackBarWidget extends StatelessWidget {
  double? left;
  double? top;
  double? right;
  double? bottom;

  final String text;
  final Color textColor;
  final double fontSize;
  final Color backgroundColor;

  SnackBarAction? action;

  SnackBarWidget({
    Key? key,
    this.left,
    this.top,
    this.right,
    this.bottom,
    required this.text,
    this.textColor = PalleteCommon.gradient2,
    this.fontSize = 22,
    this.backgroundColor = PalleteCommon.backgroundColor,
    this.action,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (left == null && top == null && right == null && bottom == null) {
      double width = MediaQuery.of(context).size.width;
      double height = MediaQuery.of(context).size.height;
      bottom = height * 0.85;
      left = width * 0.8;
      right = width * 0.02;
      top = height * 0.0;
    }

    return SnackBar(
      content: Text(
        text,
        style: TextStyle(color: textColor, fontSize: fontSize),
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
        bottom: bottom!,
        left: left!,
        right: right!,
        top: top!,
      ),
      action: action != null
          ? SnackBarAction(
              label: 'Dismiss',
              onPressed: () {},
            )
          : null,
    );
  }
}
