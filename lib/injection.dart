import 'package:api_builder/handlers/api_validation_handler.dart';
import 'package:api_builder/presentations/components/loading_overlay.dart';
import 'package:api_builder/presentations/styles/form_style.dart';
import 'package:get_it/get_it.dart';

import 'data/form_http_client.dart';

class FormInjector {
  // Singleton instance
  static final FormInjector _instance = FormInjector._internal();

  // Service locator
  late GetIt _serviceLocator;
  late String _apiUrl;
  bool _isInitialized = false;

  // Private constructor
  FormInjector._internal();

  // Factory constructor to return the singleton instance
  factory FormInjector() {
    return _instance;
  }

  // Initialization method
  Future<void> initialize({
    required GetIt serviceLocator,
    required String apiUrl,
    required ApiValidationHandler apiValidationHandler,
    FormStyle? formStyle,
  }) async {
    if (_isInitialized) return;
    _serviceLocator = serviceLocator;
    _apiUrl = apiUrl;

    serviceLocator.registerLazySingleton(() => LoadingOverlay());
    serviceLocator.registerLazySingleton(() => FormHttpClient(apiUrl: apiUrl));
    serviceLocator.registerLazySingleton(() => apiValidationHandler);
    serviceLocator.registerLazySingleton(() => formStyle ?? FormStyle());

    _isInitialized = true;
  }

  // Getter to access the service locator
  GetIt get serviceLocator => _serviceLocator;

  // Getter to access the apiUrl
  String get apiUrl => _apiUrl;
}
