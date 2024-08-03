import 'package:api_builder/data/models/field.dart';
import 'package:api_builder/presentations/fields/field_mixin.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimeField extends StatelessWidget with FieldMixin {
  @override
  final Field field;
  final bool dateOnly;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final String dateTimeDisplayFormat;
  final String dateTimeValueFormat;

  DateTimeField({
    super.key,
    required this.field,
    this.firstDate,
    this.lastDate,
    this.dateOnly = false,
    this.dateTimeDisplayFormat = 'yyyy-MM-dd HH:mm',
    this.dateTimeValueFormat = 'yyyy-MM-dd HH:mm',
  });

  // yyyy-MM-dd: 2023-06-28
  // dd/MM/yyyy: 28/06/2023
  // MMM d, yyyy: Jun 28, 2023
  // EEEE, MMM d, yyyy: Wednesday, Jun 28, 2023
  // MM-dd-yyyy HH:mm: 06-28-2023 14:45

  final TextEditingController controller = TextEditingController();

  String _getLocale(BuildContext context) {
    Locale deviceLocale = Localizations.localeOf(context);
    return "${deviceLocale.languageCode}_${deviceLocale.countryCode}";
  }

  Future<void> _selectDateTime(BuildContext context) async {
    var locale = _getLocale(context);

    DateTime now = DateTime.now();
    await showDatePicker(
      context: context,
      initialDate:
          field.value != null ? DateTime.parse(field.value) : DateTime.now(),
      firstDate: firstDate ?? DateTime(now.year - 1, now.month, now.day),
      lastDate: lastDate ?? DateTime(now.year + 1, now.month, now.day),
    ).then((DateTime? selectedDate) async {
      if (selectedDate != null) {
        if (!dateOnly) {
          TimeOfDay? timeOfDay;
          if (controller.text.isNotEmpty) {
            // print(controller.text);
            // var datetime = DateTime.parse(controller.text);
            timeOfDay = TimeOfDay(hour: selectedDate.hour, minute: selectedDate.minute);
          }
          await showTimePicker(
            context: context,
            initialTime: timeOfDay ?? TimeOfDay.now(),
            builder: (BuildContext context, Widget? child) {
              return MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(alwaysUse24HourFormat: true),
                child: child!,
              );
            },
          ).then((TimeOfDay? selectedTime) {
            if (selectedTime != null) {
              final selectedDateTime = DateTime(
                selectedDate.year,
                selectedDate.month,
                selectedDate.day,
                selectedTime.hour,
                selectedTime.minute,
              );
              controller.text = _displayDateTime(selectedDateTime, locale);
              setFieldValue(context, _valueDateTime(selectedDateTime, locale));
            }
          });
        } else {
          final selectedDateTime = DateTime(
            selectedDate.year,
            selectedDate.month,
            selectedDate.day,
          );
          controller.text = _displayDateTime(selectedDateTime, locale);
          setFieldValue(context, _valueDateTime(selectedDateTime, locale));
        }
      }
    });
  }

  String _displayDateTime(DateTime dateTime, String locale) {
    return DateFormat(dateTimeDisplayFormat, locale).format(dateTime);
  }

  String _valueDateTime(DateTime dateTime, String locale) {
    return DateFormat(dateTimeValueFormat, locale).format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    if (field.value is DateTime) {
      var locale = _getLocale(context);
      controller.text = _displayDateTime(field.value, locale);
      setFieldValue(context, _valueDateTime(field.value, locale));
    }
    return TextField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        hintText: field.hint,
        suffixIcon: const Icon(Icons.calendar_today),
        enabled: !field.readonly,
      ),
      onTap: () => _selectDateTime(context),
    );
  }
}
