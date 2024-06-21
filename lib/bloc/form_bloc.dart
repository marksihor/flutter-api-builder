import 'package:api_builder/handlers/local_validation_handler.dart';
import 'package:api_builder/models/field.dart';
import 'package:api_builder/models/form.dart';
import 'package:api_builder/usecases/form_submit_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'form_event.dart';

part 'form_state.dart';

class FormBloc extends Bloc<FormEvent, FormState_> {
  Form_ form;

  FormBloc({required this.form}) : super(FormInitial(form: form)) {
    on<FormSubmitEvent>(_onSubmitEvent);
    on<FormFieldValueChangedEvent>(_onFieldValueChangedEvent);
    on<FormFieldLoadSubfieldsEvent>(_onFormFieldLoadSubfieldsEvent);
    on<FormFieldLoadOptionsEvent>(_onFormFieldLoadOptionsEvent);
  }

  _onSubmitEvent(
    FormSubmitEvent event,
    Emitter<FormState_> emitter,
  ) async {
    emitter(
      FormSubmittingState(
        form: event.form
          ..clearFieldsValidationErrors()
          ..error = null
          ..clearResponseData(),
      ),
    );

    var valid = _preValidate(event.form);
    if (valid) {
      var res = await FormSubmitUsecase.execute(event.form);
      res.fold(
        (error) => emitter(switch (error.code) {
          422 => FormValidationErrorState(
              form: event.form
                ..error = error
                ..setFieldsValidationErrors(),
            ),
          _ => FormSubmittingErrorState(
              form: event.form
                ..error = error
                ..onSubmitError(event.form),
            )
        }),
        (response) {
          event.form.setResponseData(response?.data);
          // log(event.form.responseData.toString());

          if (event.form.onSubmitSuccess != null) {
            event.form.onSubmitSuccess!(event.form);
          }

          emitter(FormSubmittedState(form: event.form));
        },
      );
    } else {
      emitter(FormValidationErrorState(form: event.form));
    }
  }

  _onFieldValueChangedEvent(
    FormFieldValueChangedEvent event,
    Emitter<FormState_> emitter,
  ) async {
    emitter(FormFieldValueChangedState(form: event.form, field: event.field));
    // emitter(FormRebuiltState(form: event.form));
  }

  _onFormFieldLoadSubfieldsEvent(
    FormFieldLoadSubfieldsEvent event,
    Emitter<FormState_> emitter,
  ) async {
    var subfields = await event.field.getSubfields!(event.field);
    event.field.setSubfields(subfields);

    emitter(
      FormFieldSubfieldsFetchedState(form: event.form, field: event.field),
    );
  }

  _onFormFieldLoadOptionsEvent(
    FormFieldLoadOptionsEvent event,
    Emitter<FormState_> emitter,
  ) async {
    var options = await event.field.getOptions!(event.parentField);
    event.field.setOptions(options);

    emitter(
      FormFieldOptionsFetchedState(form: event.form, field: event.field),
    );
  }

  bool _preValidate(Form_ form) {
    bool hasErrors = false;

    for (var field in form.fields) {
      LocalValidationHandler(field: field).validate();
      if (field.errors.isNotEmpty) {
        hasErrors = true;
      }
    }

    return !hasErrors;
  }
}
