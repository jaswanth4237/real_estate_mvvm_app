import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:real_estate_mvvm_app/data/datasources/remote/api_interceptors.dart';

class MockRequestInterceptorHandler extends Mock implements RequestInterceptorHandler {}
class MockResponseInterceptorHandler extends Mock implements ResponseInterceptorHandler {}
class MockErrorInterceptorHandler extends Mock implements ErrorInterceptorHandler {}

void main() {
  test('LoggingInterceptor should call next on request', () {
    final interceptor = LoggingInterceptor();
    final options = RequestOptions(path: '/test');
    final handler = MockRequestInterceptorHandler();
    
    interceptor.onRequest(options, handler);
    verify(() => handler.next(options)).called(1);
  });

  test('ErrorHandlingInterceptor should call next on error', () {
    final interceptor = ErrorHandlingInterceptor();
    final error = DioException(requestOptions: RequestOptions(path: '/test'));
    final handler = MockErrorInterceptorHandler();
    
    interceptor.onError(error, handler);
    verify(() => handler.next(error)).called(1);
  });
}
