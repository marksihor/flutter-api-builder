import 'package:api_builder/bloc/form_bloc.dart';

import 'package:api_builder/core/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/helpers.dart';
import '../../data/models/field.dart';
import '../../data/models/form.dart';
import '../styles/form_style.dart';
import 'loading_overlay.dart';

mixin FormHelperMixin {
  Form_ get form;

  void loadingOverlayHandler(FormState_ state, BuildContext context) {
    final loadingOverlay = FormInjector.serviceLocator<LoadingOverlay>();
    if (state is FormSubmittingState) {
      loadingOverlay.show(context);
    } else {
      loadingOverlay.hide();
    }
  }

  void submit(BuildContext context, FormState_ state) {
    context.read<FormBloc>().add(FormSubmitEvent(form: state.form));
  }

  Widget _buildFormLabel(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        form.label!,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }

  List<Widget> _applyElementsStyles(List<Widget> elements) {
    return elements
        .map((e) => Container(
              padding: form.style?.elementsPadding ??
                  FormInjector.serviceLocator<FormStyle>().elementsPadding,
              child: e,
            ))
        .toList();
  }

  List<Widget> _getFieldsWidgets(BuildContext context, FormState_ state) {
    List<Field> fields = _getFields(context, state);
    return fields.map((field) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (field.label != null)
            Text(
              field.label!,
              textAlign: TextAlign.start,
              style: Theme.of(context).inputDecorationTheme.labelStyle,
            ),
          field.widget,
          if (field.errors.isNotEmpty)
            Column(
              children: field.errors
                  .map((error) => Text(
                        error,
                        style:
                            Theme.of(context).inputDecorationTheme.errorStyle,
                      ))
                  .toList(),
            ),
        ],
      );
    }).toList();
  }

  List<Field> _getFields(BuildContext context, FormState_ state) {
    void getOptions(field, parentField) {
      bool loadOptions = state is FormInitial ||
          (state is FormFieldValueChangedState && state.field == parentField);
      if (loadOptions && field.getOptions != null) {
        context.read<FormBloc>().add(
              FormFieldLoadOptionsEvent(
                form: state.form,
                field: field,
                parentField: parentField,
              ),
            );
      }
    }

    List<Field> fields = [];

    void getSubfields(Field field) {
      for (var subfield in field.subfields.where((e) => e.visible)) {
        fields.add(subfield);
        getOptions(subfield, field);
        getSubfields(subfield);
      }
    }

    for (var field in state.form.fields.where((e) => e.visible)) {
      fields.add(field);
      getOptions(field, null);
      if (field.getSubfields != null) {
        if (state is! FormFieldSubfieldsFetchedState) {
          bool getSubfields = true;
          if (state is FormFieldValueChangedState &&
              state.field.path != field.path) {
            getSubfields = false;
          }
          if (getSubfields) {
            context.read<FormBloc>().add(
                  FormFieldLoadSubfieldsEvent(form: state.form, field: field),
                );
          }
        }

        getSubfields(field);
      } else if (field.subfields.isNotEmpty) {
        getSubfields(field);
      }
    }

    return fields;
  }

  Widget _getSubmitButton(BuildContext context, FormState_ state) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        submit(context, state);
      },
      child: disableGestureDetection(state.form.submitButton!),
    );
  }

  Widget buildForm(BuildContext context, FormState_ state) {
    return Column(
      children: _applyElementsStyles([
        if (form.label != null) _buildFormLabel(context),
        ..._getFieldsWidgets(context, state),
        if (state.form.submitButton != null) _getSubmitButton(context, state),
      ]),
    );
  }
}
