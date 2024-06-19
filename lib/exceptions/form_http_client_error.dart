class FormHttpClientError implements Exception {
  final int code;
  final Map data;
  FormHttpClientError({required this.code, required this.data});
}
