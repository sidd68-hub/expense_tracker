// core/network/api_result.dart

sealed class ApiResult<T> {
  const ApiResult();

  R when<R>({
    required R Function(T data) success,
    required R Function(String message, int? code) failure,
  }) {
    if (this is ApiSuccess<T>) {
      return success((this as ApiSuccess<T>).data);
    } else if (this is ApiFailure<T>) {
      return failure(
        (this as ApiFailure<T>).message,
        (this as ApiFailure<T>).code,
      );
    } else {
      throw Exception("Unhandled case");
    }
  }

  void onSuccess(void Function(T data) callback) {
    if (this is ApiSuccess<T>) {
      callback((this as ApiSuccess<T>).data);
    }
  }

  void onError(void Function(String message, int? code) callback) {
    if (this is ApiFailure<T>) {
      callback((this as ApiFailure<T>).message, (this as ApiFailure<T>).code);
    }
  }
}

class ApiSuccess<T> extends ApiResult<T> {
  final T data;
  const ApiSuccess(this.data);
}

class ApiFailure<T> extends ApiResult<T> {
  final String message;
  final int? code;
  const ApiFailure(this.message, [this.code]);

  @override
  String toString() => 'ApiException: $message (Code: $code)';
}

