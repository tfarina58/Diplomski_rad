import 'package:flutter/material.dart';
import 'package:diplomski_rad/other/pallete.dart';

class SequentialField extends StatefulWidget {
  final String labelText;
  final Function callback;
  final List<dynamic> choices;
  int selected;
  double maxWidth;

  SequentialField({
    Key? key,
    required this.labelText,
    required this.callback,
    required this.choices,
    this.selected = 0,
    this.maxWidth = 400,
  }) : super();

  @override
  State<SequentialField> createState() => _SequentialFieldState();
}

class _SequentialFieldState extends State<SequentialField> {
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: widget.maxWidth,
          ),
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: widget.labelText,
              fillColor: Colors.transparent,
              focusColor: Colors.transparent,
              contentPadding: const EdgeInsets.all(27),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: PalleteCommon.borderColor,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  color: PalleteCommon.gradient2,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    widget.selected =
                        (widget.selected + 1) % widget.choices.length;
                  });
                  widget.callback(widget.selected);
                },
                child: Text(
                  widget.choices[widget.selected],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
