import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:real_estate_mvvm_app/core/performance/performance_monitor.dart';
import 'package:real_estate_mvvm_app/core/utils/app_data_path.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late PerformanceMonitor monitor;

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (MethodCall methodCall) async => Directory.systemTemp.path,
    );
    monitor = PerformanceMonitor();
  });

  test('should log performance metric and create file', () async {
    // act
    await monitor.logMetric(
      metricType: 'apiTime',
      value: 100.5,
      screenName: 'TestScreen',
    );

    // assert
    final file = await AppDataPath.getFile('performance_metrics.json');
    expect(await file.exists(), true);
  });
}
