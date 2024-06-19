import 'package:api_builder/models/field.dart';

abstract class Condition {
  String path;

  Condition({required this.path});

  bool check(List<Field> fields);
}