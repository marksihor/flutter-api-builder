import 'package:api_builder/models/form.dart';

abstract class Condition {
  String path;

  Condition({required this.path});

  bool check(Form_ form);
}