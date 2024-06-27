import 'package:api_builder/bloc/form_bloc.dart';
import 'package:api_builder/models/field.dart';
import 'package:api_builder/models/option.dart';
import 'package:api_builder/presentations/fields/field_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectField extends StatefulWidget with FieldMixin {
  @override
  final Field field;

  SelectField({super.key, required this.field});

  @override
  State<SelectField> createState() => _SelectFieldState();
}

class _SelectFieldState extends State<SelectField> {
  Option? dropdownValue;

  @override
  void initState() {
    dropdownValue = widget.field.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: BlocBuilder<FormBloc, FormState_>(
        builder: (context, state) {
          return DropdownButtonFormField<Option>(
            value: widget.field.options.contains(dropdownValue)
                ? dropdownValue
                : null,
            hint: widget.field.hint == null
                ? null
                : Text(
                    widget.field.hint!,
                    style: Theme.of(context).inputDecorationTheme.hintStyle,
                  ),
            onChanged: widget.field.readonly
                ? null
                : (value) {
                    setState(() {
                      dropdownValue = value;
                    });

                    widget.setFieldValue(context, value);
                  },
            items: getOptions(state),
            isExpanded: true,
          );
        },
      ),
    );
  }

  List<DropdownMenuItem<Option>>? getOptions(FormState_ state) {
    return widget.field.options.map<DropdownMenuItem<Option>>((option) {
      return DropdownMenuItem<Option>(
        value: option,
        child: Text(option.label),
      );
    }).toList();
  }
}
