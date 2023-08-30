import 'dart:typed_data';

class Presentation {
  String estateId;
  String id;
  List<Slide> slides;

  Presentation({
    required this.estateId,
    this.id = "6ec08b6f431bfc4e5e5c025a107ad951",
    this.slides = const [],
  });
}

class Slide {
  int template;
  String title;
  Uint8List? image;
  Map keys;

  Slide({
    this.template = 0,
    this.title = "",
    this.image,
    this.keys = const <String, String>{},
  });
}
