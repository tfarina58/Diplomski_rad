import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:path/path.dart' as Path;
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';

class ImagePickerWidget extends StatefulWidget {
  final ValueChanged<Uint8List> onDroppedFile;
  // LanguageService lang;

  ImagePickerWidget({
    Key? key,
    required this.onDroppedFile,
    /*required this.lang*/
  }) : super(key: key);

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    html.InputElement uploadInput = html.InputElement(type: "file");

    return ElevatedButton(
        onPressed: () async {
          final result = await FilePicker.platform
              .pickFiles(type: FileType.image, allowMultiple: false);

          if (result != null && result.files.isNotEmpty) {
            String fileName = result.files.first.name;
            Uint8List? fileBytes = result.files.first.bytes;

            if (fileBytes == null) return;

            widget.onDroppedFile(fileBytes);
          }
        },
        child: const Text("Pick your image!"));
  }
}
