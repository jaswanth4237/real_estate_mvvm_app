import 'package:flutter_test/flutter_test.dart';
import 'package:real_estate_mvvm_app/core/utils/result.dart';
import 'package:real_estate_mvvm_app/core/error/failures.dart';

void main() {
  test('Success result should return data', () {
    const result = Success(10);
    expect(result.data, 10);
    expect(result.isSuccess, true);
  });

  test('Failure result should return error', () {
    final failure = ServerFailure('err');
    final result = FailureResult<int>(failure);
    expect(result.failure, failure);
    expect(result.isFailure, true);
  });

  test('fold should work correctly', () {
    const success = Success(20);
    final val = success.fold((data) => data * 2, (err) => 0);
    expect(val, 40);
  });
}
