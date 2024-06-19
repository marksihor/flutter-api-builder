import 'dart:convert';
import 'dart:developer';

import 'package:api_builder/exceptions/form_http_client_error.dart';
import 'package:api_builder/models/endpoint.dart';
import 'package:api_builder/models/field.dart';
import 'package:api_builder/presentations/styles/form_style.dart';
import 'package:flutter/material.dart';

class Form_ {
  Endpoint endpoint;
  final List<Field> _fields;

  Widget? submitButton;
  FormStyle? style;
  final List<String> Function(Form_ form, Field field) getFieldErrors;
  final void Function(Form_ form) onSubmitError;
  final void Function(Form_ form)? onSubmitSuccess;
  FormHttpClientError? error;
  Map? _responseData;
  Map<String, dynamic> extraSubmitData = {};

  Form_({
    required this.endpoint,
    List<Field>? fields,
    this.submitButton,
    this.style,
    required this.getFieldErrors,
    required this.onSubmitError,
    this.onSubmitSuccess,
    Map<String, dynamic>? extraSubmitData,
  })  : _fields = fields ?? [],
        extraSubmitData = extraSubmitData ?? {};

  Map<String, dynamic> getSubmitData() {
    Map<String, dynamic> res = {};

    void setSubmitData(field) {
      if (field.path != null) res[field.path!] = field.value;
      if (field.subfields.isNotEmpty) {
        for (var subfield in field.subfields) {
          setSubmitData(subfield);
        }
      }
    }

    for (var field in fields) {
      setSubmitData(field);
    }

    if (extraSubmitData.isNotEmpty) res.addAll(extraSubmitData);

    log("Submit data:");
    log(json.encode(res));

    return res;
  }

  void setFieldsValidationErrors() {
    for (var field in _fields) {
      field.errors = getFieldErrors(this, field);
    }
  }

  void clearFieldsValidationErrors() {
    for (var f in _fields) {
      f.errors = [];
    }
  }

  List<Field> get fields {
    List<Field> fields = [];

    for (var field in _fields) {
      field.visible = true;

      for (var condition in field.visibilityConditions) {
        if (!condition.check(fields)) {
          field.visible = false;
          break;
        }
      }

      if (field.visible) fields.add(field);
    }

    return fields;
  }

  Map get responseData => _responseData ?? {};

  void setResponseData(Map data) => _responseData = data;

  void clearResponseData() => _responseData = null;
}
