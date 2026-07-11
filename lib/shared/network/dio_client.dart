import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:movieapp/shared/config/api_constants.dart';
import 'package:movieapp/shared/models/failure.dart';
import 'package:movieapp/shared/models/result.dart';
import 'package:movieapp/shared/network/api_exception.dart';
import 'package:movieapp/shared/network/interceptors/auth_interceptor.dart';
import 'package:movieapp/shared/network/interceptors/error_interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// Centralized Dio client with timeouts, auth, logging, and error mapping.
@lazySingleton
class DioClient {
  DioClient() : _dio = _createDio();

  final Dio _dio;

  Dio get dio => _dio;

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
        sendTimeout: ApiConstants.sendTimeout,
        responseType: ResponseType.json,
      ),
    );

    dio.interceptors.addAll([
      AuthInterceptor(),
      ErrorInterceptor(),
      if (kDebugMode)
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
          compact: true,
        ),
    ]);

    return dio;
  }

  /// Generic GET that returns a typed [Result].
  Future<Result<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic data) parser,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _request(
      () => _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
      parser: parser,
    );
  }

  /// Generic POST (future-ready).
  Future<Result<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic data) parser,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _request(
      () => _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      ),
      parser: parser,
    );
  }

  Future<Result<T>> _request<T>(
    Future<Response<dynamic>> Function() call, {
    required T Function(dynamic data) parser,
  }) async {
    try {
      final response = await call();
      try {
        return Success(parser(response.data));
      } catch (e) {
        return Error(ParseFailure('Invalid JSON response: $e'));
      }
    } on DioException catch (error) {
      return Error(_mapDioException(error));
    } catch (error) {
      return Error(UnknownFailure(error.toString()));
    }
  }

  Failure _mapDioException(DioException error) {
    if (error.error is ApiException) {
      return (error.error as ApiException).toFailure();
    }
    return ApiException.fromDioException(error).toFailure();
  }
}
