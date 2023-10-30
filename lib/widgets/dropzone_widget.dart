import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:diplomski_rad/other/pallete.dart';
import 'package:diplomski_rad/services/language.dart';

class DropzoneWidget extends StatefulWidget {
  final ValueChanged<DroppedFile> onDroppedFile;
  LanguageService lang;

  DropzoneWidget({Key? key, required this.onDroppedFile, required this.lang})
      : super(key: key);

  @override
  State<DropzoneWidget> createState() => _DropzoneWidgetState();
}

class _DropzoneWidgetState extends State<DropzoneWidget> {
  late DropzoneViewController dvController;
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: width * 0.7,
          height: height * 0.6,
          child: DropzoneView(
            cursor: CursorType.alias,
            mime: const ['image/jpg', 'image/png', 'image/gif'],
            onDropInvalid: declineFile,
            onDrop: acceptFile,
            onCreated: (controller) => dvController = controller,
          ),
        ),
        SizedBox(
          width: width * 0.7,
          height: height * 0.6,
          child: InkWell(
            onHover: (bool value) {
              setState(() {
                isHovering = value;
              });
            },
            onTap: () {},
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(6)),
                  border: Border(
                    left: BorderSide(
                        color: isHovering
                            ? PalleteCommon.gradient2
                            : Colors.white),
                    top: BorderSide(
                        color: isHovering
                            ? PalleteCommon.gradient2
                            : Colors.white),
                    right: BorderSide(
                        color: isHovering
                            ? PalleteCommon.gradient2
                            : Colors.white),
                    bottom: BorderSide(
                        color: isHovering
                            ? PalleteCommon.gradient2
                            : Colors.white),
                  ),
                  color: PalleteCommon.backgroundColor,
                ),
                width: width * 0.7,
                height: height * 0.6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.cloud_upload,
                      size: 80,
                      color: PalleteCommon.gradient2,
                    ),
                    Text(
                      widget.lang.dictionary["dropzone_text"]!,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      child: Text(widget.lang.dictionary["choose_file"]!),
                      onPressed: () async {
                        final events = await dvController.pickFiles();
                        if (events.isEmpty) return;

                        acceptFile(events.first);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Future<void> declineFile(dynamic event) async {}

  Future<void> errorFile(dynamic event) async {}

  Future<void> acceptFile(dynamic event) async {
    final name = event.name;
    final mime = await dvController.getFileMIME(event);
    final bytes = await dvController.getFileSize(event);
    final url = await dvController.createFileUrl(event);

    final droppedFile = DroppedFile(
      name: name,
      mime: mime,
      bytes: bytes,
      url: url,
    );

    widget.onDroppedFile(droppedFile);
    setState(() {
      isHovering = false;
    });
  }
}

class DroppedFileWidget extends StatelessWidget {
  final DroppedFile? file;
  LanguageService lang;
  bool isHighlighted = false;

  DroppedFileWidget({Key? key, required this.file, required this.lang})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (file == null) {
      return Container(
        width: 120,
        height: 120,
        color: Colors.blue.shade300,
        child: Center(
          child: Text(
            lang.dictionary["no_file"]!,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    return Image.asset(
      file!.url,
      width: 120,
      height: 120,
      fit: BoxFit.contain,
      errorBuilder: (context, error, _) {
        return Container(
          width: 120,
          height: 120,
          color: Colors.blue.shade300,
          child: Center(
            child: Text(
              lang.dictionary["cannot_preview"]!,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}

class DroppedFile {
  final String url, name, mime;
  final int bytes;

  const DroppedFile({
    required this.url,
    required this.name,
    required this.mime,
    required this.bytes,
  });

  String get size {
    final kb = bytes / 1024;
    final mb = kb / 1024;

    return mb > 1 ? '${mb.toStringAsFixed(2)}' : '${kb.toStringAsFixed(2)}';
  }
}
