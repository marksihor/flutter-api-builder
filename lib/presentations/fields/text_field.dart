import 'package:flutter/material.dart';

import 'package:api_builder/models/field.dart';
import 'field_mixin.dart';

class TextField_ extends StatelessWidget with FieldMixin {
  @override
  final Field field;

  const TextField_({super.key, required this.field});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: field.value,
      decoration: InputDecoration(hintText: field.hint),
      onChanged: (value) {
        setFieldValue(context, value);
      },
    );
  }
}
