import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:real_estate_mvvm_app/core/error/error_logger.dart';
import 'package:real_estate_mvvm_app/core/utils/app_data_path.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (MethodCall methodCall) async => Directory.systemTemp.path,
    );
  });

  test('ErrorLogger should create file and log error', () async {
    await ErrorLogger.logError(
      errorType: 'TestErr',
      message: 'msg',
    );

    final file = await AppDataPath.getFile('error_logs.json');
    expect(await file.exists(), true);
  });
}
