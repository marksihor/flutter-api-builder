import 'package:api_builder/data/models/form.dart';
import 'package:api_builder/presentations/conditions/condition.dart';

class OptionMetaKeyEqualCondition implements Condition {
  @override
  String path;
  String key;
  dynamic value;

  OptionMetaKeyEqualCondition({
    required this.path,
    required this.key,
    required this.value,
  });

  @override
  bool check(Form_ form) {
    return form.getSubmitData()[path]?.metas[key] == value;
  }
}
