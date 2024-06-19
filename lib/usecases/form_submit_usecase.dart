import 'package:api_builder/injection.dart';
import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:api_builder/data/form_http_client.dart';
import 'package:api_builder/exceptions/form_http_client_error.dart';
import 'package:api_builder/models/endpoint.dart';
import 'package:api_builder/models/form.dart';

class FormSubmitUsecase {
  static Future<Either<FormHttpClientError, Response<dynamic>?>> execute(
      Form_ form) async {
    final formHttpClient = FormInjector().serviceLocator<FormHttpClient>();
    var request = switch (form.endpoint.method) {
      FormSubmitMethod.post => formHttpClient.post(
          form.endpoint.path,
          form.getSubmitData(),
        ),
      FormSubmitMethod.patch => formHttpClient.patch(
          form.endpoint.path,
          form.getSubmitData(),
        ),
      FormSubmitMethod.get => formHttpClient.get(
          form.endpoint.path,
          form.getSubmitData(),
        ),
    };

    try {
      var res = await request;
      return Right(res);
    } on FormHttpClientError catch (e) {
      return Left(e);
    }
  }
}
