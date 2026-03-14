import 'dart:convert';
import 'package:flutter/services.dart';

import '../utils/app_data_path.dart';

class FeatureFlagService {
  Map<String, dynamic> _flags = {};

  Future<void> init() async {
    final String response = await rootBundle.loadString('assets/feature_flags.json');
    final data = await json.decode(response);
    _flags = {for (var item in data['flags']) item['flagKey']: item};
  }

  bool isEnabled(String flagKey) {
    return _flags[flagKey]?['enabled'] ?? false;
  }

  String getVariant(String flagKey) {
    final variants = _flags[flagKey]?['variants'] as List<dynamic>?;
    if (variants != null && variants.isNotEmpty) {
      return variants.first;
    }
    return "default";
  }

  Future<void> logUsage(String flagKey) async {
    try {
      final file = await AppDataPath.getFile('feature_usage.json');
      Map<String, dynamic> data = {"usages": []};

      if (await file.exists()) {
        final content = await file.readAsString();
        if (content.isNotEmpty) {
          data = json.decode(content);
        }
      }

      data["usages"].add({
        "flagKey": flagKey,
        "variant": getVariant(flagKey),
        "timestamp": DateTime.now().toIso8601String()
      });

      await file.writeAsString(json.encode(data));
    } catch (e) {
      print("Failed to log feature usage: $e");
    }
  }
}
