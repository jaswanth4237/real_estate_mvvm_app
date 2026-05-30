import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../utils/app_data_path.dart';
import '../constants.dart';

/// A singleton service for tracking and exporting application performance metrics.
///
/// Metrics are appended to the file path defined in `AppConstants.filePerformanceMetrics`
/// in the app data directory. Each entry records a `metricType`, a numeric
/// `value`, a timestamp, and the originating `screenName`.
class PerformanceMonitor {
  static final PerformanceMonitor _instance = PerformanceMonitor._internal();

  /// Returns the singleton instance of [PerformanceMonitor].
  factory PerformanceMonitor() => _instance;
  PerformanceMonitor._internal();

  /// Records a performance metric entry to the JSON metrics log file.
  ///
  /// [metricType] identifies the kind of metric (e.g. `"scrollFps"`, `"screenOpen"`).
  /// [value] is the numeric measurement associated with this metric.
  /// [screenName] identifies which screen produced the metric.
  Future<void> logMetric({
    required String metricType,
    required double value,
    required String screenName,
  }) async {
    try {
      final file = await AppDataPath.getFile(AppConstants.filePerformanceMetrics);
      Map<String, dynamic> data = {'metrics': []};

      if (await file.exists()) {
        final content = await file.readAsString();
        if (content.isNotEmpty) {
          data = json.decode(content) as Map<String, dynamic>;
        }
      }

      (data['metrics'] as List).add({
        'metricType': metricType,
        'value': value,
        'timestamp': DateTime.now().toIso8601String(),
        'screenName': screenName,
      });

      await file.writeAsString(json.encode(data));
    } catch (e) {
      debugPrint('Failed to log performance metric: $e');
    }
  }
}
