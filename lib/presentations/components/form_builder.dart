import 'package:api_builder/bloc/form_bloc.dart';
import 'package:api_builder/injection.dart';
import 'package:api_builder/models/field.dart';
import 'package:api_builder/models/form.dart';
import 'package:api_builder/presentations/components/loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FromBuilder extends StatelessWidget {
  final Form_ form;

  const FromBuilder({super.key, required this.form});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FormBloc(form: form),
      child: BlocConsumer<FormBloc, FormState_>(
        listener: (BuildContext context, FormState_ state) {
          _handleLoadingOverlay(state, context);
        },
        builder: (BuildContext context, FormState_ state) {
          return Column(
            children: _applyElementsStyles([
              ..._getFieldsWidgets(context, state),
              if (state.form.submitButton != null)
                _getSubmitButton(context, state),
            ]),
          );
        },
      ),
    );
  }

  List<Widget> _applyElementsStyles(List<Widget> elements) {
    return elements
        .map((e) => Container(padding: form.style?.elementsPadding, child: e))
        .toList();
  }

  List<Widget> _getFieldsWidgets(BuildContext context, FormState_ state) {
    List<Field> fields = _getFields(context, state);
    return fields.map((field) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (field.label != null)
            Text(field.label!, textAlign: TextAlign.start),
          field.widget,
          if (field.errors.isNotEmpty)
            Column(
              children: field.errors
                  .map((error) => Text(
                        error,
                        style: const TextStyle(color: Colors.red),
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
    for (var field in state.form.fields) {
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

        for (var subfield in field.subfields) {
          fields.add(subfield);
          getOptions(subfield, field);
        }
      } else if (field.subfields.isNotEmpty) {
        for (var subfield in field.subfields) {
          fields.add(subfield);
          getOptions(subfield, field);
        }
      }
    }

    return fields;
  }

  Widget _getSubmitButton(BuildContext context, FormState_ state) {
    return GestureDetector(
      onTap: () => _submit(context, state),
      child: Stack(
        children: [
          state.form.submitButton!,
          Positioned.fill(child: Container(color: Colors.transparent))
        ],
      ),
    );
  }

  void _submit(BuildContext context, FormState_ state) {
    FocusManager.instance.primaryFocus?.unfocus();
    context.read<FormBloc>().add(FormSubmitEvent(form: state.form));
  }

  void _handleLoadingOverlay(FormState_ state, BuildContext context) {
    final loadingOverlay = FormInjector().serviceLocator<LoadingOverlay>();
    if (state is FormSubmittingState) {
      loadingOverlay.show(context);
    } else {
      loadingOverlay.hide();
    }
  }
}
