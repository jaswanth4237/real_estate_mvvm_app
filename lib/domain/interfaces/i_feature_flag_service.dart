/// Contract for the feature flag service.
///
/// Implementations load flag definitions from `assets/feature_flags.json` and
/// log flag usage to a persistent JSON file for analytics.
abstract class IFeatureFlagService {
  /// Loads flag definitions from the bundled JSON asset. Must be called at startup.
  Future<void> init();

  /// Returns `true` if the feature identified by [flagKey] is enabled.
  bool isEnabled(String flagKey);

  /// Returns the active variant string for [flagKey], or `"default"` if none.
  String getVariant(String flagKey);

  /// Appends a usage event for [flagKey] to the usage log file.
  Future<void> logUsage(String flagKey);
}
