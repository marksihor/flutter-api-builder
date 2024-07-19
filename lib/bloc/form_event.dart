part of 'form_bloc.dart';

@immutable
sealed class FormEvent {}

class FormSubmitEvent extends FormEvent {
  final Form_ form;

  FormSubmitEvent({required this.form});
}

class FormClearEvent extends FormEvent {
  final Form_ form;

  FormClearEvent({required this.form});
}

class FormFieldLoadSubfieldsEvent extends FormEvent {
  final Form_ form;
  final Field field;

  FormFieldLoadSubfieldsEvent({required this.form, required this.field});
}

class FormFieldLoadOptionsEvent extends FormEvent {
  final Form_ form;
  final Field field;
  final Field? parentField;

  FormFieldLoadOptionsEvent({
    required this.form,
    required this.field,
    this.parentField,
  });
}

class FormFieldValueChangedEvent extends FormEvent {
  final Form_ form;
  final Field field;

  FormFieldValueChangedEvent({required this.form, required this.field});
}
