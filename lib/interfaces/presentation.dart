import 'dart:typed_data';

class Slide {
  String title;
  String subtitle;
  String description;
  String image;
  String? tmpImageName;
  Uint8List? tmpImageBytes;
  int template;

  Slide({
    this.title = "",
    this.subtitle = "",
    this.description = "",
    this.image = "",
    this.template = 0,
  });
}
