import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../core/error/error_logger.dart';

/// A Dio [Interceptor] that logs request and response details to the debug console.
///
/// In production, `debugPrint` is a no-op, ensuring no sensitive information
/// is leaked to the system log.
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('REQUEST[${options.method}] => PATH: ${options.path}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint(
      'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
    );
    super.onResponse(response, handler);
  }
}

/// A Dio [Interceptor] that captures network errors and writes them to the
/// persistent JSON error log via [ErrorLogger].
class ErrorHandlingInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    ErrorLogger.logError(
      errorType: 'NetworkError',
      message: err.message ?? 'Unknown Dio Error',
      stackTrace: err.stackTrace.toString(),
    );
    super.onError(err, handler);
  }
}
