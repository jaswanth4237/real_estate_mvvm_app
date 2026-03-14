import 'package:dio/dio.dart';
import '../../../core/error/error_logger.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
    super.onResponse(response, handler);
  }
}

class ErrorHandlingInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    ErrorLogger.logError(
      errorType: "NetworkError",
      message: err.message ?? "Unknown Dio Error",
      stackTrace: err.stackTrace.toString(),
    );
    super.onError(err, handler);
  }
}
