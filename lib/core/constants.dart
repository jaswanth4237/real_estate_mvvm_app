/// Application-wide string constants.
///
/// Centralising keys, file names, and other magic strings here prevents typos
/// and makes global refactoring straightforward.
class AppConstants {
  // SharedPreferences Keys

  /// SharedPreferences key for the user's selected theme identifier.
  static const String keySelectedTheme = 'selected_theme';

  /// SharedPreferences key for the accessibility-enabled preference.
  static const String keyAccessibilityEnabled = 'accessibility_enabled';

  /// SharedPreferences key for the high-contrast-mode preference.
  static const String keyHighContrastMode = 'high_contrast_mode';

  /// SharedPreferences key for the serialised active property filter.
  static const String keyActivePropertyFilters = 'active_property_filters';

  /// SharedPreferences key for the ISO-8601 timestamp of the last sync.
  static const String keyLastPropertiesSyncTimestamp =
      'last_properties_sync_timestamp';

  // File Names

  /// Relative path of the JSON error log file within the app-data directory.
  static const String fileErrorLogs = 'error_logs.json';

  /// Relative path of the JSON performance-metrics file.
  static const String filePerformanceMetrics = 'performance_metrics.json';

  /// Relative path of the JSON feature-usage log file.
  static const String fileFeatureUsage = 'feature_usage.json';

  /// Relative path of the JSON accessibility-report file.
  static const String fileAccessibilityReport = 'accessibility_report.json';

  /// Relative path of the JSON image-cache statistics file.
  static const String fileImageCacheStats = 'image_cache_stats.json';
}
