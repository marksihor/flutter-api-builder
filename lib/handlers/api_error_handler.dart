import 'package:api_builder/models/form.dart';

class ApiErrorHandler {
  final void Function(Form_ form) handle;

  ApiErrorHandler({required this.handle});
}
