abstract class IAccessibilityService {
  bool get isAccessibilityEnabled;
  bool get isHighContrastMode;
  Future<void> setAccessibilityEnabled(bool value);
  Future<void> setHighContrastMode(bool value);
  Future<void> generateReport(List<Map<String, dynamic>> widgets);
}
