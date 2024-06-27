import 'package:api_builder/data/models/form.dart';

class ApiErrorHandler {
  final void Function(Form_ form) handle;

  ApiErrorHandler({required this.handle});
}
