import 'package:flutter/material.dart';

class SnapshotErrorField extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color fontColor;

  const SnapshotErrorField({
    Key? key,
    required this.text,
    this.fontSize = 32,
    this.fontColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          color: fontColor
        ),
      )
    );
  }
}
