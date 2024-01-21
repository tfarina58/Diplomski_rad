import 'dart:convert';
import 'dart:typed_data';
import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class Presentation {
  String id;
  String estateId;
  List<Slide> slides;
  Variable variables;
  bool isNew;

  Presentation({
    this.id = "",
    this.estateId = "",
    this.isNew = false,
  }) : slides = [Slide()], variables = Variable();

  static Presentation? toPresentation(Map<String, dynamic>? presentation) {
    if (presentation == null) return null;

    Presentation newPresentation = Presentation();
    newPresentation.id = presentation['id'] ?? "";
    newPresentation.estateId = presentation['estateId'] ?? "";

    List<Slide>? slides = Slide.toSlideList(presentation['slides']);
    if (slides == null || slides.isEmpty) slides = [Slide()];

    Variable? variables = Variable.toVariable(presentation['variables']);

    newPresentation.slides = slides;
    newPresentation.variables = variables;

    return newPresentation;
  }

  static Map<String, dynamic>? toJSON(Presentation? presentation) {
    if (presentation == null) return null;

    List<dynamic>? slides = Slide.toJSONList(presentation.slides);
    slides ??= [];

    Map<String, dynamic>? variables = Variable.toJSON(presentation.variables);
    variables ??= <String, dynamic>{};

    return {
      // "id": presentation.id,
      "estateId": presentation.estateId,
      "slides": slides as List<dynamic>,
      "variables": variables as Map<String, dynamic>,
    };
  }

  static String asString(Presentation? presentation) {
    if (presentation == null) return "null";

    String slides = "[\n";
    for (int i = 0; i < presentation.slides.length; ++i) {
      slides += Slide.asString(presentation.slides[i]);
    }
    slides += "]\n";

    List<List<dynamic>> table = presentation.variables.table;
    String variables = "[\n";
    for (int i = 0; i < table.length; ++i) {
      variables += "[${table[i][0]}, ${table[i][1]}, ${table[i][2]}, ${table[i][3]}],\n";
    };
    variables += "]\n";

    return "id: ${presentation.id}\nestateId: ${presentation.estateId}\nslides: $slides\nvariables: $variables\n";
  }
}

class Slide {
  String title;
  String subtitle;
  String description;
  String image;
  int template;

  // Used to save locally and display an image before saving on Firebase
  String? tmpImageName;
  Uint8List? tmpImageBytes;

  Slide({
    this.title = "",
    this.subtitle = "",
    this.description = "",
    this.image = "",
    this.template = 0,
  });

  static Slide? toSlide(Map<String, dynamic>? slide) {
    if (slide == null) return null;

    Slide newSlide = Slide();
    newSlide.title = slide['title'] ?? "";
    newSlide.subtitle = slide['subtitle'] ?? "";
    newSlide.description = slide['description'] ?? "";
    newSlide.image = slide['image'] ?? "";
    newSlide.template = slide['template'] ?? 0;

    return newSlide;
  }

  static List<Slide>? toSlideList(List<dynamic>? JSONSlides) {
    if (JSONSlides == null) return null;

    List<Slide> output = [];
    Slide? currentSlide;

    for (int i = 0; i < JSONSlides.length; ++i) {
      currentSlide = Slide.toSlide(JSONSlides[i]);
      if (currentSlide == null) continue;
      output.add(currentSlide);
    }

    return output;
  }


  static dynamic toJSON(Slide? slide) {
    if (slide == null) return null;

    return {
      // "id": slide.id,
      'title': slide.title,
      'subtitle': slide.subtitle,
      'description': slide.description,
      'image': slide.image,
      'template': slide.template,
    };
  }

  static List<dynamic>? toJSONList(List<Slide>? slides) {
    if (slides == null) return null;

    List<dynamic> output = [];
    dynamic currentJSONSlide;

    for (int i = 0; i < slides.length; ++i) {
      currentJSONSlide = Slide.toJSON(slides[i]);
      if (currentJSONSlide == null) continue;
      output.add(currentJSONSlide);
    }

    return output;
  }

  static String asString(Slide slide) {
    return "{\ntitle: ${slide.title},\nsubtitle: ${slide.subtitle},\ndescription: ${slide.description},\nimage: ${slide.image},\ntemplate: ${slide.template},}\n";
  }
}

class Variable {
  // Local values are also saved in this variable before sending to Firebase
  List<List<dynamic>> table = [];

  Variable({
    this.table = const []
  });

  static Variable toVariable(Map<String, dynamic>? JSONVariables) {
    if (JSONVariables == null) return Variable();

    Variable newVariables = Variable();

    JSONVariables.forEach((String key, dynamic value) {
      List<dynamic> row = [key, value[0] as String, (value[1] as Timestamp).toDate(), (value[2] as Timestamp).toDate()];
      newVariables.table = [...newVariables.table, row];
    });

    return newVariables;
  }

  static List<dynamic> newRow() {
    DateTime now = DateTime.now();
    return ["", "", DateTime(now.year, now.month, now.day), DateTime(now.year, now.month, now.day),];
  }

  static Map<String, dynamic>? toJSON(Variable? variable) {
    if (variable == null) return null;

    Map<String, dynamic> output = {};

    for (int i = 0; i < variable.table.length; ++i) {
      Timestamp from = Timestamp.fromDate(variable.table[i][2] as DateTime);
      Timestamp to = Timestamp.fromDate(variable.table[i][3] as DateTime);

      DateTime now = DateTime.now();
      if ((variable.table[i][0] as String).isEmpty || (variable.table[i][1] as String).isEmpty || (from.millisecondsSinceEpoch < now.millisecondsSinceEpoch && to.millisecondsSinceEpoch < now.millisecondsSinceEpoch)) {
        continue;
      }

      if (from.millisecondsSinceEpoch > to.millisecondsSinceEpoch) {
        Timestamp tmp = from;
        from = to;
        to = tmp;
      }

      output[variable.table[i][0] as String] = [variable.table[i][1] as String, from, to];
    }

    return output;
  }

  static String asString(Variable variables) {
    String output = "[\n";
    for (int i = 0; i < variables.table.length; ++i) {
      output += "[${variables.table[i][0]}, ${variables.table[i][1]}, ${DateFormat("yyyy-MM-dd").format(variables.table[i][2] as DateTime)}, ${DateFormat("yyyy-MM-dd").format(variables.table[i][3] as DateTime)}]";
    }
    output += "]\n";

    return output;
  }
}
