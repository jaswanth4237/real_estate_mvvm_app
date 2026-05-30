import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../domain/interfaces/i_accessibility_service.dart';
import '../../utils/app_data_path.dart';
import '../../constants.dart';

class AccessibilityService implements IAccessibilityService {
  final SharedPreferences prefs;

  AccessibilityService(this.prefs);

  @override
  bool get isAccessibilityEnabled => prefs.getBool(AppConstants.keyAccessibilityEnabled) ?? false;
  
  @override
  bool get isHighContrastMode => prefs.getBool(AppConstants.keyHighContrastMode) ?? false;

  @override
  Future<void> setAccessibilityEnabled(bool value) async {
    await prefs.setBool(AppConstants.keyAccessibilityEnabled, value);
  }

  @override
  Future<void> setHighContrastMode(bool value) async {
    await prefs.setBool(AppConstants.keyHighContrastMode, value);
  }

  @override
  Future<void> generateReport(List<Map<String, dynamic>> widgets) async {
    try {
      final file = await AppDataPath.getFile(AppConstants.fileAccessibilityReport);
      final report = {
        "widgets": widgets
      };
      await file.writeAsString(json.encode(report));
    } catch (e) {
      debugPrint("Failed to generate accessibility report: $e");
    }
  }
}
