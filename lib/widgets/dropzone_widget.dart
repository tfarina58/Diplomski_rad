import 'package:diplomski_rad/widgets/gradient_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:diplomski_rad/other/pallete.dart';
import 'package:diplomski_rad/services/language.dart';
import 'package:diplomski_rad/services/firebase.dart';
import 'package:reflectable/reflectable.dart';
import 'dart:io';
import 'dart:typed_data';

class DropzoneWidget extends StatefulWidget {
  final ValueChanged<Map<String, dynamic>> onDroppedFile;
  LanguageService lang;

  DropzoneWidget({Key? key, required this.onDroppedFile, required this.lang})
      : super(key: key);

  @override
  State<DropzoneWidget> createState() => _DropzoneWidgetState();
}

class _DropzoneWidgetState extends State<DropzoneWidget> {
  late DropzoneViewController dvController;
  bool highlighted = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Dropzone
        Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 3,
              color: PalleteCommon.gradient2,
            ),
            color: highlighted ? Colors.red : Colors.transparent,
          ),
          width: width * 0.55,
          height: height * 0.55,
          child: Stack(
            children: [
              Builder(
                builder: (context) => DropzoneView(
                  operation: DragOperation.copy,
                  cursor: CursorType.grab,
                  onCreated: (ctrl) => dvController = ctrl,
                  onLoaded: () {},
                  onError: (ev) {},
                  onHover: () {
                    setState(() => highlighted = true);
                  },
                  onLeave: () => setState(() => highlighted = false),
                  onDrop: (ev) async {
                    // final url = await dvController.createFileUrl(ev);
                    String path = await dvController.createFileUrl(ev);
                    Uint8List bytes = await dvController.getFileData(ev);
                    String name = await dvController.getFilename(ev);

                    setState(() {
                      highlighted = false;
                    });

                    Map<String, dynamic> file = {
                      'name': name,
                      'bytes': bytes,
                      'path': path,
                    };
                    widget.onDroppedFile(file);

                    /*final result = await FilePicker.platform
                        .pickFiles(type: FileType.image, allowMultiple: false);

                    if (result != null && result.files.isNotEmpty) {
                      final fileBytes = result.files.first.bytes;
                      final fileName = result.files.first.name;

                      if (fileBytes == null) return;

                      setState(() {
                        highlighted = false;
                      });
                      widget.onDroppedFile(result);
                    }*/
                  },
                  onDropInvalid: (ev) {},
                  onDropMultiple: (ev) {},
                ),
              ),
              const Center(child: Text("Drop image here!")),
            ],
          ),
        ),
        SizedBox(height: height * 0.05),

        // Pick file
        GradientButton(
          callback: () async {
            final result = await FilePicker.platform
                .pickFiles(type: FileType.image, allowMultiple: false);
                
            if (result != null && result.files.isNotEmpty) {
              Uint8List? bytes = result.files.first.bytes;
              String name = result.files.first.name;

              if (bytes == null) return;

              setState(() {
                highlighted = false;
              });
              Map<String, dynamic> file = {'name': name, 'bytes': bytes};
              widget.onDroppedFile(file);
            }
          },
          buttonText: "Pick file",
        ),
      ],
    );
  }
}
