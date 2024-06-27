import 'package:api_builder/core/handlers/api_error_handler.dart';
import 'package:api_builder/core/handlers/api_pagination_handler.dart';
import 'package:api_builder/core/handlers/api_validation_handler.dart';
import 'package:api_builder/data/form_http_client.dart';
import 'package:api_builder/presentations/components/loading_overlay.dart';
import 'package:api_builder/presentations/styles/form_style.dart';
import 'package:get_it/get_it.dart';

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
    required ApiErrorHandler apiErrorHandler,
    required ApiPaginationHandler apiPaginationHandler,
    FormStyle? formStyle,
  }) async {
    if (_isInitialized) return;
    _serviceLocator = serviceLocator;
    _apiUrl = apiUrl;

    serviceLocator.registerLazySingleton(() => LoadingOverlay());
    serviceLocator.registerLazySingleton(() => FormHttpClient(apiUrl: apiUrl));
    serviceLocator.registerLazySingleton(() => apiValidationHandler);
    serviceLocator.registerLazySingleton(() => apiErrorHandler);
    serviceLocator.registerLazySingleton(() => formStyle ?? FormStyle());
    serviceLocator.registerLazySingleton(() => apiPaginationHandler);

    _isInitialized = true;
  }

  // Getter to access the service locator
  // GetIt get serviceLocator => _serviceLocator;

  static GetIt get serviceLocator {
    if (!_instance._isInitialized) {
      throw Exception(
          "FormInjector is not initialized. Call initialize() first.");
    }
    return _instance._serviceLocator;
  }

  // Getter to access the apiUrl
  String get apiUrl => _apiUrl;
}
