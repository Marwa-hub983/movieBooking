import 'package:dio/dio.dart';
import 'package:movieapp/shared/network/api_exception.dart';

/// Maps Dio errors into [ApiException] for consistent handling upstream.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final apiException = err.error is ApiException
        ? err.error as ApiException
        : ApiException.fromDioException(err);

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: apiException,
        message: apiException.message,
      ),
    );
  }
}
