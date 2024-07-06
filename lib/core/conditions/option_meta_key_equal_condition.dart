import 'package:api_builder/data/models/form.dart';
import 'package:api_builder/core/conditions/condition.dart';

class OptionMetaKeyEqualCondition implements Condition {
  @override
  String path;
  String key;
  dynamic value;
  bool opposite;

  OptionMetaKeyEqualCondition({
    required this.path,
    required this.key,
    required this.value,
    this.opposite = false,
  });

  @override
  bool check(Form_ form) {
    bool res = form.getSubmitData()[path]?.metas[key] == value;
    if (opposite) return !res;
    return res;
  }
}
