import 'package:api_builder/models/form.dart';

class ApiPaginationHandler {
  final int Function(Form_ form) getCurrentPage;
  final int? Function(Form_ form) getNextPage;

  ApiPaginationHandler({
    required this.getCurrentPage,
    required this.getNextPage,
  });
}
