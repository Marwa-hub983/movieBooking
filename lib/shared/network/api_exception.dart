import 'package:dio/dio.dart';
import 'package:movieapp/shared/models/failure.dart';

/// Typed API exception mapped from Dio / network failures.
class ApiException implements Exception {
  const ApiException({
    required this.message,
    this.statusCode,
    this.data,
  });

  final String message;
  final int? statusCode;
  final dynamic data;

  factory ApiException.fromDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return const ApiException(
          message: 'Request timed out. Please try again.',
        );
      case DioExceptionType.connectionError:
        return const ApiException(
          message: 'No internet connection. Please check your network.',
        );
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        return ApiException(
          message: _extractMessage(error.response?.data) ??
              _messageForStatus(statusCode),
          statusCode: statusCode,
          data: error.response?.data,
        );
      case DioExceptionType.cancel:
        return const ApiException(message: 'Request was cancelled.');
      case DioExceptionType.badCertificate:
        return const ApiException(message: 'Invalid SSL certificate.');
      case DioExceptionType.unknown:
        final msg = error.message ?? '';
        if (msg.contains('SocketException')) {
          return const ApiException(
            message: 'No internet connection. Please check your network.',
          );
        }
        return ApiException(
          message: msg.isEmpty ? 'An unexpected error occurred.' : msg,
        );
    }
  }

  Failure toFailure() {
    final code = statusCode;
    if (code == 401 || code == 403) {
      return UnauthorizedFailure(message, statusCode: code);
    }
    if (code == 404) return NotFoundFailure(message);
    if (code != null && code >= 500) {
      return ServerFailure(message, statusCode: code);
    }
    if (message.toLowerCase().contains('internet') ||
        message.toLowerCase().contains('socket')) {
      return NetworkFailure(message);
    }
    if (message.toLowerCase().contains('timed out') ||
        message.toLowerCase().contains('timeout')) {
      return TimeoutFailure(message);
    }
    if (message.toLowerCase().contains('json') ||
        message.toLowerCase().contains('parse') ||
        message.toLowerCase().contains('format')) {
      return ParseFailure(message);
    }
    if (code != null) return ServerFailure(message, statusCode: code);
    return UnknownFailure(message, statusCode: code);
  }

  static String? _extractMessage(dynamic data) {
    if (data is Map) {
      final statusMessage = data['status_message'];
      if (statusMessage is String && statusMessage.isNotEmpty) {
        return statusMessage;
      }
      final message = data['message'];
      if (message is String && message.isNotEmpty) return message;
    }
    return null;
  }

  static String _messageForStatus(int? statusCode) {
    return switch (statusCode) {
      400 => 'Bad request.',
      401 => 'Unauthorized. Check your API key.',
      403 => 'Access forbidden.',
      404 => 'Resource not found.',
      429 => 'Too many requests. Please try again later.',
      500 => 'Internal server error.',
      502 => 'Bad gateway.',
      503 => 'Service unavailable.',
      _ => 'Request failed${statusCode != null ? ' ($statusCode)' : ''}.',
    };
  }

  @override
  String toString() => 'ApiException($statusCode): $message';
}
