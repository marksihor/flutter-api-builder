import 'package:api_builder/data/models/field.dart';
import 'package:api_builder/data/models/form.dart';
import 'package:api_builder/presentations/conditions/condition.dart';

class ValueEqualCondition implements Condition {
  @override
  String path;
  dynamic value;

  ValueEqualCondition({required this.path, required this.value});

  @override
  bool check(Form_ form) {
    Field field = form.fields.firstWhere((f) => f.path == path);

    return field.value == value;
  }
}
