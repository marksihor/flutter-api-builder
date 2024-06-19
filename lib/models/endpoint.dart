enum FormSubmitMethod { post, patch, get }

class Endpoint {
  final FormSubmitMethod method;
  final String path;

  Endpoint({required this.method, required this.path});
}
