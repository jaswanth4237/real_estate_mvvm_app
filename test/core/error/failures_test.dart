import 'package:flutter_test/flutter_test.dart';
import 'package:real_estate_mvvm_app/core/error/failures.dart';

void main() {
  test('ServerFailure should hold message', () {
    final failure = ServerFailure('error');
    expect(failure.message, 'error');
  });

  test('CacheFailure should have default message', () {
    final failure = CacheFailure();
    expect(failure.message, 'Cache Error');
  });

  test('NetworkFailure should have default message', () {
    final failure = NetworkFailure();
    expect(failure.message, 'No Internet Connection');
  });

  test('ValidationFailure should have default message', () {
    final failure = ValidationFailure();
    expect(failure.message, 'Validation Error');
  });
}
