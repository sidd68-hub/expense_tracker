import 'package:dio/dio.dart';
import 'package:expense_tracker/flavour/environment.dart';

class DioConfig {
  static BaseOptions get baseOptions => BaseOptions(
    baseUrl: Environment.baseUrl,
    headers: {
      'x-api-key': 'reqres-free-v1',
    },
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    responseType: ResponseType.json
  );
}


