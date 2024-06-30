import 'package:api_builder/core/exceptions/form_http_client_error.dart';
import 'package:api_builder/core/handlers/api_validation_handler.dart';
import 'package:api_builder/core/injection.dart';
import 'package:api_builder/data/models/endpoint.dart';
import 'package:api_builder/data/models/field.dart';
import 'package:api_builder/presentations/styles/form_style.dart';
import 'package:flutter/material.dart';

class Form_ {
  Endpoint endpoint;
  final List<Field> _fields;

  Widget? submitButton;
  FormStyle? style;
  final List<String> Function(Form_ form, Field field)? getFieldErrors;
  final void Function(Form_ form)? onSubmitError;
  final void Function(Form_ form)? onSubmitSuccess;
  FormHttpClientError? error;
  Map? _responseData;
  Map<String, dynamic> extraSubmitData = {};
  String? label;

  Form_({
    required this.endpoint,
    List<Field>? fields,
    this.submitButton,
    this.style,
    this.getFieldErrors,
    this.onSubmitError,
    this.onSubmitSuccess,
    this.label,
    Map<String, dynamic>? extraSubmitData,
  })  : _fields = fields ?? [],
        extraSubmitData = extraSubmitData ?? {};

  Map<String, dynamic> getSubmitData() {
    Map<String, dynamic> res = {};

    void setSubmitData(Field field) {
      if (field.path != null && field.visible) res[field.path!] = field.value;
      if (field.subfields.isNotEmpty && field.visible) {
        for (var subfield in field.subfields) {
          setSubmitData(subfield);
        }
      }
    }

    for (var field in fields) {
      setSubmitData(field);
    }

    if (extraSubmitData.isNotEmpty) res.addAll(extraSubmitData);

    return res;
  }

  void setFieldsValidationErrors() {
    ApiValidationHandler apiValidationHandler =
        FormInjector.serviceLocator<ApiValidationHandler>();

    void handle(field) {
      if (getFieldErrors != null) {
        field.errors = getFieldErrors!(this, field);
      } else {
        field.errors = apiValidationHandler.getFieldErrors(this, field);
      }

      for (var subfield in field.subfields) {
        handle(subfield);
      }
    }

    for (var field in _fields) {
      handle(field);
    }
  }

  void clearFieldsValidationErrors() {
    for (var field in _fields) {
      field.errors = [];
      for (var subfield in field.subfields) {
        subfield.errors = [];
      }
    }
  }

  List<Field> get fields => _fields;

  void setFieldsVisibility() {
    void setFieldVisibility(Field field) {
      field.visible = true;
      if (field.visibilityConditions.isNotEmpty) {
        for (var condition in field.visibilityConditions) {
          if (!condition.check(this)) {
            field.visible = false;
            break;
          }
        }
      }

      if (field.visible) {
        for (var subfield in field.subfields) {
          setFieldVisibility(subfield);
        }
      }
    }

    for (var field in _fields) {
      setFieldVisibility(field);
    }
  }

  Map get responseData => _responseData ?? {};

  void setResponseData(Map data) => _responseData = data;

  void clearResponseData() => _responseData = null;
}
