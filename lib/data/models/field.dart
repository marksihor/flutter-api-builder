import 'dart:async';

import 'package:api_builder/data/models/option.dart';
import 'package:api_builder/data/models/rule.dart';
import 'package:api_builder/presentations/conditions/condition.dart';
import 'package:flutter/material.dart';

class Field {
  dynamic value;
  final String? path;
  final String? hint;
  final String? label;
  final Function _widgetCreator;
  Widget? _widget;
  List<Option>? _options;
  Future<List<Field>> Function(Field field)? getSubfields;
  Future<List<Option>> Function(Field? field)? getOptions;
  List<Field>? _subfields;
  List<Condition> visibilityConditions;
  bool visible = true;
  bool readonly;
  List<String> errors = [];
  List<Rule>? rules;

  Field({
    this.value,
    required Function builder,
    this.path,
    this.hint,
    this.label,
    List<Option>? options,
    List<Field>? subfields,
    this.getSubfields,
    this.getOptions,
    this.visibilityConditions = const [],
    this.rules,
    this.readonly = false,
  })  : _widgetCreator = builder,
        _options = options,
        _subfields = subfields;

  Widget get widget {
    _widget ??= _widgetCreator(this);
    return _widget!;
  }

  List<Option> get options => _options ?? [];

  List<Field> get subfields => _subfields ?? [];

  void setSubfields(List<Field> subfields) => _subfields = subfields;

  void setOptions(List<Option> options) => _options = options;

  void clearErrors() {
    errors = [];
  }
}
