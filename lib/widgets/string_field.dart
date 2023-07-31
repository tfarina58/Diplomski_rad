import 'package:flutter/material.dart';
import 'package:diplomski_rad/other/pallete.dart';

class StringField extends StatefulWidget {
  final String labelText;
  final Function callback;
  final String? presetText;
  final int multiline;
  final bool readOnly;

  StringField({
    Key? key,
    required this.labelText,
    required this.callback,
    this.presetText = "",
    this.multiline = 1,
    this.readOnly = false,
  }) : super(key: key);

  @override
  State<StringField> createState() => _StringFieldState();
}

class _StringFieldState extends State<StringField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // ConstrainedBox
      constraints: BoxConstraints(
        maxWidth: 400,
      ),
      child: TextFormField(
        readOnly: widget.readOnly,
        textInputAction: TextInputAction.next,
        onChanged: (value) {
          widget.callback(value);
        },
        keyboardType: TextInputType.multiline,
        maxLines: widget.multiline,
        maxLength: null,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(27),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Pallete.borderColor,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          labelText: widget.labelText,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Pallete.gradient2,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        initialValue: widget.presetText,
      ),
    );
  }

  // BoxConstraints setConstraints() {}
}
