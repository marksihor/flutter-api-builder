import 'package:flutter/material.dart';

import 'package:api_builder/data/models/field.dart';
import 'field_mixin.dart';

class TextField_ extends StatelessWidget with FieldMixin {
  @override
  final Field field;
  final TextInputType? keyboardType;
  final int? maxLines;
  final int? minLines;

  const TextField_({
    super.key,
    required this.field,
    this.keyboardType,
    this.maxLines,
    this.minLines,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: TextEditingController()..text = field.value ?? '',
      decoration: InputDecoration(
        hintText: field.hint,
        enabled: !field.readonly
      ),
      onChanged: (value) {
        setFieldValue(context, value);
      },
      keyboardType: keyboardType,
      maxLines: maxLines,
      minLines: minLines,
      readOnly: field.readonly,
    );
  }
}
