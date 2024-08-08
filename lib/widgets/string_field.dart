import 'package:flutter/material.dart';
import 'package:diplomski_rad/other/pallete.dart';
import 'package:flutter/services.dart';

class StringField extends StatefulWidget {
  final String labelText;
  final Function callback;
  final String? presetText;
  final int multiline;
  final bool readOnly;
  final bool osbcure;
  final double maxWidth;
  final TextInputType inputType;
  final int? maxNum;

  const StringField({
    Key? key,
    required this.labelText,
    required this.callback,
    this.presetText = "",
    this.multiline = 1,
    this.readOnly = false,
    this.osbcure = false,
    this.maxWidth = 400,
    this.inputType = TextInputType.multiline,
    this.maxNum,
  }) : super(key: key);

  @override
  State<StringField> createState() => _StringFieldState();
}

class _StringFieldState extends State<StringField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: widget.maxWidth,
      ),
      child: TextFormField(
        inputFormatters: [
          if (widget.inputType == TextInputType.number)
            TextInputFormatter.withFunction((oldValue, newValue) {
              if (newValue.text.isEmpty) {
                return newValue.copyWith(
                  text: '0',
                  selection: const TextSelection.collapsed(offset: 1),
                );
              }

              final i = int.tryParse(newValue.text);
              if (i == null) return oldValue;
              if (widget.maxNum != null) {
                if (i > widget.maxNum!) {
                  return newValue.copyWith(
                      text: '10',
                      selection: const TextSelection.collapsed(offset: 2));
                }
              }
              return newValue;
            }),
        ],
        obscureText: widget.osbcure,
        readOnly: widget.readOnly,
        textInputAction: TextInputAction.next,
        onChanged: (dynamic value) {
          widget.callback(value);
        },
        maxLines: widget.multiline,
        maxLength: null,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(27),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: PalleteCommon.borderColor,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          labelText: widget.labelText,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: PalleteCommon.gradient2,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        initialValue: widget.presetText,
      ),
    );
  }
}
