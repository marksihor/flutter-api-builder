import 'package:api_builder/models/field.dart';
import 'package:api_builder/presentations/conditions/condition.dart';

class ValueEqualCondition implements Condition {
  @override
  String path;
  dynamic value;

  ValueEqualCondition({required this.path, required this.value});

  @override
  bool check(List<Field> fields) {
    Field field = fields.firstWhere((f) => f.path == path);

    return field.value == value;
  }
}
