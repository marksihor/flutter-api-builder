import 'dart:developer';

import 'package:dio/dio.dart';

import 'package:api_builder/exceptions/form_http_client_error.dart';

class FormHttpClient {
  final Dio dio = Dio();
  final String apiUrl;

  FormHttpClient({required this.apiUrl}) {
    dio.options.headers['accept'] = 'application/json';
    dio.options.headers['content-type'] = 'application/json';
  }

  void setHeader(String key, dynamic value) {
    dio.options.headers[key] = value;
  }

  void unsetHeader(String key) {
    dio.options.headers[key] = null;
  }

  Future<Response<dynamic>?> post(String path, Object? data) async {
    return await _decorate(
      dio.post("$apiUrl/$path", data: data),
    );
  }

  Future<Response<dynamic>?> patch(String path, Object? data) async {
    return await _decorate(
      dio.patch("$apiUrl/$path", data: data),
    );
  }

  Future<Response<dynamic>?> get(String path, Object? data) async {
    Map<String, dynamic> query = {};
    if (data is Map) {
      data.forEach((key, value) {
        if (value != null) query[key] = value;
      });
    }

    return await _decorate(
      dio.get("$apiUrl/$path", queryParameters: query.isEmpty ? null : query),
    );
  }

  Future<Response<dynamic>?> _decorate(request) async {
    try {
      return await request;
    } on DioException catch (e) {
      log('on DioException catch (e)');
      log(e.message.toString());
      throw FormHttpClientError(
        code: e.response?.statusCode ?? 500,
        data: e.response?.data ?? {},
      );
    }
  }
}
