/// Contract for the accessibility settings and reporting service.
///
/// Implementations persist user preferences in SharedPreferences and generate
/// a JSON accessibility report of the current widget tree.
abstract class IAccessibilityService {
  /// Whether the enhanced accessibility mode is currently enabled.
  bool get isAccessibilityEnabled;

  /// Whether high-contrast rendering is currently enabled.
  bool get isHighContrastMode;

  /// Persists whether accessibility mode should be enabled.
  Future<void> setAccessibilityEnabled(bool value);

  /// Persists whether high-contrast mode should be enabled.
  Future<void> setHighContrastMode(bool value);

  /// Writes an accessibility report derived from [widgets] to a JSON file.
  Future<void> generateReport(List<Map<String, dynamic>> widgets);
}
