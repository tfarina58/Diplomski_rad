import 'package:flutter/material.dart';
import 'package:diplomski_rad/other/pallete.dart';

class LoadingBar extends StatelessWidget {
  final double dimensionLength;
  final double strokeWidth;

  const LoadingBar({
    Key? key,
    this.dimensionLength = 100,
    this.strokeWidth = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: dimensionLength,
        width: dimensionLength,
        child: const CircularProgressIndicator(
          strokeWidth: 10,
          color: PalleteCommon.gradient2,
          backgroundColor: PalleteCommon.backgroundColor,
        ),
      ),
    );
  }
}
