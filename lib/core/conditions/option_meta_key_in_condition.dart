import 'package:api_builder/data/models/form.dart';
import 'package:api_builder/core/conditions/condition.dart';

class OptionMetaKeyInCondition implements Condition {
  @override
  String path;
  String key;
  List values;

  OptionMetaKeyInCondition({
    required this.path,
    required this.key,
    required this.values,
  });

  @override
  bool check(Form_ form) {
    return values.contains(form.getSubmitData()[path]?.metas[key]);
  }
}
