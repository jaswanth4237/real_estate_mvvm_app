import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:real_estate_mvvm_app/core/error/error_logger.dart';

void main() {
  test('ErrorLogger should create file and log error', () async {
    await ErrorLogger.logError(
      errorType: 'TestErr',
      message: 'msg',
    );

    final file = File('app_data/error_logs.json');
    expect(await file.exists(), true);
  });
}
