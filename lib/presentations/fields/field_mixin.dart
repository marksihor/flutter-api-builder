import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:api_builder/data/models/field.dart';

import 'package:api_builder/bloc/form_bloc.dart';

mixin FieldMixin on Widget {
  Field get field;

  void setFieldValue(BuildContext context, dynamic value) {
    if (field.value != value) {
      field.value = value;

      var form = context.read<FormBloc>().form;
      context.read<FormBloc>().add(
            FormFieldValueChangedEvent(
              form: form,
              field: field,
            ),
          );
    }
  }
}
