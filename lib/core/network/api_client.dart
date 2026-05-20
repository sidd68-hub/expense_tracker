import 'dart:io';
import 'package:dio/dio.dart';
import 'package:expense_tracker/core/network/network_info.dart';
import 'api_result.dart';

class ApiClient {
  final Dio dio;
  final NetworkInfo networkInfo;

  ApiClient({required this.dio, required this.networkInfo});

  Future<ApiResult<T>> safeApiCall<T>(Future<T> Function() apiCall) async {
    final connected = await networkInfo.isConnected;
    if (!connected) {
      return ApiFailure('No Internet Connection', 1000);
    }
    try {
      final result = await apiCall();
      return ApiSuccess(result);
    } on SocketException catch (_) {
      return ApiFailure('No Internet Connection');
    } on DioException catch (dioError) {
      final statusCode = dioError.response?.statusCode;
      final message = dioError.response?.data?['message']?.toString() ??
          dioError.message ??
          'Unknown error';
      return ApiFailure(message, statusCode);
    } catch (e) {
      return ApiFailure(e.toString());
    }
  }

  Future<ApiResult<Response>> get(String url,
      {Map<String, dynamic>? queryParameters}) {
    return safeApiCall(() => dio.get(url, queryParameters: queryParameters));
  }
}
