import 'package:diplomski_rad/widgets/gradient_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:diplomski_rad/other/pallete.dart';
import 'package:diplomski_rad/services/language.dart';
import 'dart:typed_data';

class DropzoneWidget extends StatefulWidget {
  final ValueChanged<Map<String, dynamic>> onDroppedFile;
  LanguageService lang;
  double width, height;

  DropzoneWidget(
      {Key? key,
      required this.onDroppedFile,
      required this.lang,
      this.width = 0,
      this.height = 0})
      : super(key: key);

  @override
  State<DropzoneWidget> createState() => _DropzoneWidgetState();
}

class _DropzoneWidgetState extends State<DropzoneWidget> {
  late DropzoneViewController dvController;
  bool highlighted = false;

  @override
  Widget build(BuildContext context) {
    if (widget.width == 0) {
      widget.width = MediaQuery.of(context).size.width * 0.55;
    }
    if (widget.height == 0) {
      widget.height = MediaQuery.of(context).size.height * 0.55;
    }

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
          width: widget.width,
          height: widget.height,
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
                  },
                  onDropInvalid: (ev) {},
                  onDropMultiple: (ev) {},
                ),
              ),
              Center(child: Text(widget.lang.dictionary["drop_image_here"]!)),
            ],
          ),
        ),
        SizedBox(height: widget.height * 0.05),

        // Pick file
        GradientButton(
          callback: () async {
            final result = await FilePicker.platform.pickFiles(type: FileType.image, allowMultiple: false);

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
