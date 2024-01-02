import 'package:flutter/material.dart';
import 'package:diplomski_rad/other/pallete.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SocialButton extends StatelessWidget {
  final String iconPath;
  final String label;
  final Function method;
  final double horizontalPadding;
  const SocialButton({
    Key? key,
    required this.iconPath,
    required this.label,
    required this.method,
    this.horizontalPadding = 100,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        print("Log in with Google!");
        // await GoogleAuthService.signInWithGoogle();
      },
      icon: SvgPicture.asset(
        iconPath,
        width: 25,
        color: Colors.white,
      ),
      label: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 17,
        ),
      ),
      style: TextButton.styleFrom(
        padding:
            EdgeInsets.symmetric(vertical: 30, horizontal: horizontalPadding),
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            color: PalleteCommon.borderColor,
            width: 3,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
