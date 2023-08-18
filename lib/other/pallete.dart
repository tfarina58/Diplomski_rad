import 'package:flutter/material.dart';

class PalleteCommon {
  static const Color backgroundColor = Color.fromRGBO(24, 24, 32, 1);
  static const Color gradient1 = Color.fromRGBO(187, 63, 221, 1);
  static const Color gradient2 = Color.fromRGBO(251, 109, 169, 1);
  static const Color gradient3 = Color.fromRGBO(255, 159, 124, 1);
  static const Color borderColor = Color.fromRGBO(52, 51, 67, 1);
  static const Color highlightColor = Color.fromRGBO(124, 124, 152, 1);

  static List<Color> getGradients() {
    return [gradient1, gradient2, gradient3];
  }
}

class PalleteDanger {
  // static const Color backgroundColor = Color.fromRGBO(24, 24, 32, 1);
  static const Color gradient1 = Color.fromRGBO(118, 8, 8, 1);
  static const Color gradient2 = Color.fromRGBO(255, 91, 0, 1);
  static const Color gradient3 = Color.fromRGBO(255, 195, 2, 1);
  // static const Color borderColor = Color.fromRGBO(52, 51, 67, 1);

  static List<Color> getGradients() {
    return [gradient1, gradient2, gradient3];
  }
}

class PalleteSuccess {
  // static const Color backgroundColor = Color.fromRGBO(24, 24, 32, 1);
  static const Color gradient1 = Color.fromRGBO(101, 199, 175, 1);
  static const Color gradient2 = Color.fromRGBO(47, 179, 94, 1);
  static const Color gradient3 = Color.fromRGBO(171, 202, 70, 1);
  // static const Color borderColor = Color.fromRGBO(52, 51, 67, 1);

  static List<Color> getGradients() {
    return [gradient1, gradient2, gradient3];
  }
}

class PalleteHint {
  // static const Color backgroundColor = Color.fromRGBO(24, 24, 32, 1);
  static const Color gradient1 = Color.fromRGBO(228, 199, 33, 1);
  static const Color gradient2 = Color.fromRGBO(141, 143, 11, 1);
  static const Color gradient3 = Color.fromRGBO(84, 84, 84, 1);
  // static const Color borderColor = Color.fromRGBO(52, 51, 67, 1);

  static List<Color> getGradients() {
    return [gradient1, gradient2, gradient3];
  }
}
