part of 'form_bloc.dart';

@immutable
sealed class FormState_ {
  final Form_ form;

  const FormState_({required this.form});
}

final class FormInitial extends FormState_ {
  const FormInitial({required super.form});
}

final class FormSubmittingState extends FormState_ {
  const FormSubmittingState({required super.form});
}

final class FormSubmittedState extends FormState_ {
  const FormSubmittedState({required super.form});
}

final class FormSubmittingErrorState extends FormState_ {
  const FormSubmittingErrorState({required super.form});
}

final class FormRebuiltState extends FormState_ {
  const FormRebuiltState({required super.form});
}

final class FormFieldValueChangedState extends FormState_ {
  final Field field;

  const FormFieldValueChangedState({
    required super.form,
    required this.field,
  });
}

final class FormValidationErrorState extends FormState_ {
  const FormValidationErrorState({required super.form});
}

final class FormFieldSubfieldsFetchedState extends FormState_ {
  final Field field;

  const FormFieldSubfieldsFetchedState({
    required super.form,
    required this.field,
  });
}

final class FormFieldOptionsFetchedState extends FormState_ {
  final Field field;

  const FormFieldOptionsFetchedState({
    required super.form,
    required this.field,
  });
}
