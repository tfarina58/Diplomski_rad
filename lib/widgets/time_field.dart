import 'package:diplomski_rad/services/language.dart';
import 'package:diplomski_rad/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:diplomski_rad/other/pallete.dart';

class TimeField extends StatefulWidget {
  final String labelText;
  final Function callback;
  final String timeFormat;
  TimeOfDay? selectedTime;
  TimeOfDay? tmpTime;
  LanguageService lang;

  TimeField({
    Key? key,
    required this.labelText,
    required this.callback,
    required this.lang,
    this.timeFormat = "yyyy-MM-dd",
    this.selectedTime,
  }) : super(key: key);

  @override
  State<TimeField> createState() => _TimeFieldState();
}

class _TimeFieldState extends State<TimeField> {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width * 0.3;
    final double height = MediaQuery.of(context).size.height * 0.55;

    widget.selectedTime ??= TimeOfDay.now();
    widget.tmpTime = widget.selectedTime;

    String tmpHour = "0${widget.tmpTime!.hour}";
    tmpHour = tmpHour.substring(tmpHour.length - 2, tmpHour.length);
    String tmpMinute = "0${widget.tmpTime!.minute}";
    tmpMinute = tmpMinute.substring(tmpMinute.length - 2, tmpMinute.length);

    textController.text = "$tmpHour:$tmpMinute";

    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 400,
      ),
      child: TextFormField(
        controller: textController,
        readOnly: true,
        onTap: () async {
          final TimeOfDay? time = await showTimePicker(
            context: context,
            initialTime: widget.selectedTime ?? TimeOfDay.now(),
            initialEntryMode: TimePickerEntryMode.input,
            orientation: null,
            builder: (BuildContext context, Widget? child) {
              // We just wrap these environmental changes around the
              // child in this builder so that we can apply the
              // options selected above. In regular usage, this is
              // rarely necessary, because the default values are
              // usually used as-is.
              return Theme(
                data: ThemeData.dark().copyWith(
                  scaffoldBackgroundColor: PalleteCommon.backgroundColor,
                ),
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      alwaysUse24HourFormat: true,
                    ),
                    child: child!,
                  ),
                ),
              );
            },
          );

          String tmpHour = "0${widget.tmpTime!.hour}";
          tmpHour = tmpHour.substring(tmpHour.length - 2, tmpHour.length);
          String tmpMinute = "0${widget.tmpTime!.minute}";
          tmpMinute = tmpMinute.substring(tmpMinute.length - 2, tmpMinute.length);
          setState(() {
            textController.text = "$tmpHour:$tmpMinute";
            widget.callback(time);
          });
        },
        decoration: InputDecoration(
          labelText: widget.labelText,
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
      ),
    );
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
