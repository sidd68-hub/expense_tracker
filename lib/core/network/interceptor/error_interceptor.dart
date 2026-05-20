import 'package:dio/dio.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // If we need to handle something on 401 we can handle here
    }
    // You can parse and wrap the error nicely here
    return handler.next(err);
  }
}
