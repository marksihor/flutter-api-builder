import 'package:api_builder/data/models/field.dart';
import 'package:api_builder/data/models/rule.dart';

class LocalValidationHandler {
  final String Function(ValidationRule)? getRuleMessage;

  LocalValidationHandler({this.getRuleMessage});

  void validate(Field field) {
    if (field.rules != null && field.rules!.isNotEmpty) {
      for (var rule in field.rules!) {
        switch (rule.rule) {
          case ValidationRule.required:
            _validateRequired(field, rule);
          default:
            throw Exception('Wrong validation rule: ${rule.rule}');
        }
      }
    }
  }

  void _validateRequired(Field field, Rule rule) {
    if (field.value == null) {
      field.errors.add(rule.message ?? _getRuleMessage(rule.rule));
    }
  }

  String _getRuleMessage(ValidationRule validationRule) {
    if (getRuleMessage != null) {
      return getRuleMessage!(validationRule);
    } else {
      return switch (validationRule) {
        ValidationRule.required => 'required',
      };
    }
  }
}
