import 'package:flutter/material.dart';
import 'package:diplomski_rad/other/pallete.dart';

class DropdownField extends StatefulWidget {
  final String labelText;
  final Function callback;
  final List<dynamic> choices;
  dynamic selected;
  double maxWidth;
  bool readOnly;

  DropdownField({
    Key? key,
    required this.labelText,
    required this.callback,
    required this.choices,
    this.selected,
    this.maxWidth = 400,
    this.readOnly = false,
  }) : super(key: key) {
    selected ??= choices[0];
  }

  @override
  State<DropdownField> createState() => _DropdownFieldState();
}

class _DropdownFieldState extends State<DropdownField> {
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
            child: DropdownButtonHideUnderline(
              child: DropdownButton<dynamic>(
                isDense: true,
                dropdownColor: PalleteCommon.backgroundColor,
                focusColor: PalleteCommon.backgroundColor,
                value: widget.selected,
                onChanged: (dynamic value) {
                  if (value == null) return;
                  if (!widget.readOnly) {
                    setState(() {
                      widget.selected = value;
                    });
                    widget.callback(value);
                  }
                },
                items: [
                  for (int i = 0; i < widget.choices.length; ++i)
                    DropdownMenuItem<dynamic>(
                      alignment: Alignment.centerLeft,
                      value: widget.choices[i],
                      child: Text(
                        widget.choices[i] is String
                            ? widget.choices[i]
                            : widget.choices[i].toString(),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
