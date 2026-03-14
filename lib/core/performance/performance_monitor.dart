import 'dart:convert';

import '../utils/app_data_path.dart';

class PerformanceMonitor {
  static final PerformanceMonitor _instance = PerformanceMonitor._internal();
  factory PerformanceMonitor() => _instance;
  PerformanceMonitor._internal();

  Future<void> logMetric({
    required String metricType,
    required double value,
    required String screenName,
  }) async {
    try {
      final file = await AppDataPath.getFile('performance_metrics.json');
      Map<String, dynamic> data = {"metrics": []};
      
      if (await file.exists()) {
        final content = await file.readAsString();
        if (content.isNotEmpty) {
          data = json.decode(content);
        }
      }

      data["metrics"].add({
        "metricType": metricType,
        "value": value,
        "timestamp": DateTime.now().toIso8601String(),
        "screenName": screenName
      });

      await file.writeAsString(json.encode(data));
    } catch (e) {
      print("Failed to log performance metric: $e");
    }
  }
}
