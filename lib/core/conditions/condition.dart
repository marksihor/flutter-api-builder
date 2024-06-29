import 'package:api_builder/data/models/form.dart';

abstract class Condition {
  String path;

  Condition({required this.path});

  bool check(Form_ form);
}