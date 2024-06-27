import 'package:api_builder/data/models/field.dart';
import 'package:api_builder/data/models/rule.dart';

class LocalValidationHandler {
  final Field field;

  LocalValidationHandler({required this.field});

  void validate() {
    if (field.rules != null && field.rules!.isNotEmpty) {
      for (var rule in field.rules!) {
        switch (rule.rule) {
          case 'required':
            _validateRequired(rule);
          default:
            throw Exception('Wrong validation rule: ${rule.rule}');
        }
      }
    }
  }

  void _validateRequired(Rule rule) {
    if (field.value == null) {
      field.errors.add(rule.message);
    }
  }
}
