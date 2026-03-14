import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/app_data_path.dart';

class AccessibilityService {
  final SharedPreferences prefs;

  AccessibilityService(this.prefs);

  bool get isAccessibilityEnabled => prefs.getBool('accessibility_enabled') ?? false;
  bool get isHighContrastMode => prefs.getBool('high_contrast_mode') ?? false;

  Future<void> setAccessibilityEnabled(bool value) async {
    await prefs.setBool('accessibility_enabled', value);
  }

  Future<void> setHighContrastMode(bool value) async {
    await prefs.setBool('high_contrast_mode', value);
  }

  Future<void> generateReport(List<Map<String, dynamic>> widgets) async {
    try {
      final file = await AppDataPath.getFile('accessibility_report.json');
      final report = {
        "widgets": widgets
      };
      await file.writeAsString(json.encode(report));
    } catch (e) {
      print("Failed to generate accessibility report: $e");
    }
  }
}
