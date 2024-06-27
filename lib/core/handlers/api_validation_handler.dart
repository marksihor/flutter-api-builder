import 'package:api_builder/data/models/field.dart';
import 'package:api_builder/data/models/form.dart';

class ApiValidationHandler {
  final List<String> Function(Form_ form, Field field) getFieldErrors;

  ApiValidationHandler({required this.getFieldErrors});
}
