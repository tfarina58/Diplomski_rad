import 'package:flutter/material.dart';
import 'package:diplomski_rad/other/pallete.dart';

class GradientButton extends StatelessWidget {
  final String buttonText;
  final Function callback;
  List<dynamic> arguments;
  final List<Color> colors;

  GradientButton({
    Key? key,
    required this.buttonText,
    required this.callback,
    this.arguments = const [],
    this.colors = const [
      PalleteCommon.gradient1,
      PalleteCommon.gradient2,
      PalleteCommon.gradient3,
    ],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(7),
      ),
      child: ElevatedButton(
        onPressed: () => callback(),
        style: ElevatedButton.styleFrom(
          fixedSize: const Size(395, 55),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Text(
          buttonText,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 17,
          ),
        ),
      ),
    );
  }
}
