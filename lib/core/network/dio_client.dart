import 'package:dio/dio.dart';
import 'package:expense_tracker/core/network/dio_config.dart';
import 'package:expense_tracker/core/network/interceptor/error_interceptor.dart';
import 'package:expense_tracker/core/network/interceptor/pretty_log.dart';

class DioClient {
  final Dio _dio;

  DioClient() : _dio = Dio(DioConfig.baseOptions) {
    _dio.interceptors.addAll([
      ErrorInterceptor(),
      ...AppDioLogger.get(enableLogging: true),
    ]);
  }

  Dio get client => _dio;
}