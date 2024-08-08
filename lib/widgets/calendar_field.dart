import 'package:diplomski_rad/services/language.dart';
import 'package:diplomski_rad/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:diplomski_rad/other/pallete.dart';

class CalendarField extends StatefulWidget {
  final String labelText;
  final Function callback;
  bool selectingBirthday;
  late DateTime? firstDate = DateTime.utc(1998, 3, 12);
  late DateTime? lastDate = DateTime.now();
  final String dateFormat;
  DateTime? selectedDate;
  DateTime? tmpDate;
  bool readOnly;
  LanguageService lang;

  CalendarField({
    Key? key,
    required this.labelText,
    required this.callback,
    required this.lang,
    this.selectingBirthday = false,
    this.firstDate,
    this.lastDate,
    this.dateFormat = "yyyy-MM-dd",
    this.selectedDate,
    this.readOnly = false,
  }) : super(key: key);

  @override
  State<CalendarField> createState() => _CalendarFieldState();
}

class _CalendarFieldState extends State<CalendarField> {
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width * 0.3;
    final double height = MediaQuery.of(context).size.height * 0.55;

    widget.selectedDate ??= DateTime.now();
    widget.tmpDate = widget.selectedDate;

    textController.text = DateFormat(widget.dateFormat).format(widget.tmpDate!);

    return ConstrainedBox(
      constraints: const BoxConstraints(
        maxWidth: 400,
      ),
      child: TextFormField(
        controller: textController,
        readOnly: true,
        onTap: () {
          if (!widget.readOnly) {
            showDialog<String>(
              context: context,
              builder: (BuildContext context) => Dialog(
                backgroundColor: PalleteCommon.backgroundColor,
                alignment: Alignment.center,
                child: SizedBox(
                  width: width + 20,
                  height: height,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(),
                            ),
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                child: const Icon(
                                  Icons.close,
                                  color: PalleteCommon.gradient2,
                                ),
                                onTap: () => Navigator.pop(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: PalleteCommon.borderColor)),
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: MediaQuery.of(context).size.height * 0.4,
                        padding: const EdgeInsets.all(16),
                        child: CalendarDatePicker(
                          firstDate: widget.firstDate ?? DateTime(1900),
                          initialDate: widget.tmpDate!,
                          lastDate: widget.lastDate ?? (widget.selectingBirthday ? DateTime.now() : DateTime(2100)),
                          onDateChanged: (DateTime value) {
                            widget.tmpDate = value;
                          },
                        ),
                      ),
                      const SizedBox(height: 30),
                      GradientButton(
                        buttonText: widget.lang.translate('set_date'),
                        callback: () {
                          setState(() {
                            widget.selectedDate = widget.tmpDate;
                            widget.callback(widget.tmpDate);
                            textController.text = DateFormat(widget.dateFormat)
                                .format(widget.tmpDate!);
                          });
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
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
