sealed class Failure {
  const Failure(this.message, {this.statusCode});

  final String message;
  final int? statusCode;
}

class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = 'No internet connection. Please check your network.',
  ]);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure([
    super.message = 'Request timed out. Please try again.',
  ]);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.statusCode});
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(
    super.message, {
    super.statusCode = 401,
  });
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([
    super.message = 'Resource not found.',
  ]) : super(statusCode: 404);
}

class ParseFailure extends Failure {
  const ParseFailure([
    super.message = 'Failed to parse server response.',
  ]);
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message, {super.statusCode});
}
