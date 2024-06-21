import 'package:api_builder/models/field.dart';
import 'package:api_builder/models/form.dart';

class ApiValidationHandler {
  final List<String> Function(Form_ form, Field field) getFieldErrors;

  ApiValidationHandler({required this.getFieldErrors});
}
