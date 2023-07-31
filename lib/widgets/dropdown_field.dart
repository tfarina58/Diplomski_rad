import 'package:flutter/material.dart';
import 'package:diplomski_rad/other/pallete.dart';

class DropdownField extends StatefulWidget {
  final String labelText;
  String selectedType = "ind";
  final Function callback;

  DropdownField({
    Key? key,
    required this.labelText,
    required this.callback,
  }) : super(key: key);

  @override
  State<DropdownField> createState() => _DropdownFieldState();
}

class _DropdownFieldState extends State<DropdownField> {
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 400,
      ),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: widget.labelText,
          fillColor: Colors.transparent,
          focusColor: Colors.transparent,
          contentPadding: const EdgeInsets.all(27),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Pallete.borderColor,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Pallete.gradient2,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isDense: true,
            dropdownColor: Pallete.backgroundColor,
            focusColor: Pallete.backgroundColor,
            value: widget.selectedType,
            onChanged: (String? value) {
              if (value == null) return;
              setState(() {
                widget.selectedType = value;
              });
              widget.callback(value);
            },
            items: const [
              DropdownMenuItem<String>(
                alignment: Alignment.centerLeft,
                value: "ind",
                child: Text("Individual"),
              ),
              DropdownMenuItem<String>(
                alignment: Alignment.centerLeft,
                value: "com",
                child: Text("Company"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
