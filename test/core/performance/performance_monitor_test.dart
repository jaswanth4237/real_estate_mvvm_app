import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:real_estate_mvvm_app/core/performance/performance_monitor.dart';

void main() {
  late PerformanceMonitor monitor;

  setUp(() {
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
    final file = File('app_data/performance_metrics.json');
    expect(await file.exists(), true);
  });
}
