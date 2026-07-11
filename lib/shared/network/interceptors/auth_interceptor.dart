import 'package:dio/dio.dart';
import 'package:movieapp/shared/config/api_constants.dart';
import 'package:movieapp/shared/network/api_exception.dart';

/// Injects TMDB API key on every request (never hardcode the key).
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (ApiConstants.apiKey.isEmpty) {
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.unknown,
          error: const ApiException(
            message:
                'TMDB_API_KEY is missing. Run with --dart-define=TMDB_API_KEY=your_key',
          ),
          message: 'TMDB_API_KEY is missing.',
        ),
      );
      return;
    }

    options.queryParameters = {
      ...options.queryParameters,
      'api_key': ApiConstants.apiKey,
    };
    options.headers.addAll({
      Headers.acceptHeader: Headers.jsonContentType,
      Headers.contentTypeHeader: Headers.jsonContentType,
    });
    handler.next(options);
  }
}
