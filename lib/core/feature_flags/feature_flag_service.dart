import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../utils/app_data_path.dart';
import '../../domain/interfaces/i_feature_flag_service.dart';
import '../constants.dart';

class FeatureFlagService implements IFeatureFlagService {
  Map<String, dynamic> _flags = {};

  @override
  Future<void> init() async {
    final String response = await rootBundle.loadString('assets/feature_flags.json');
    final data = await json.decode(response);
    _flags = {for (var item in data['flags']) item['flagKey']: item};
  }

  @override
  bool isEnabled(String flagKey) {
    return _flags[flagKey]?['enabled'] ?? false;
  }

  @override
  String getVariant(String flagKey) {
    final variants = _flags[flagKey]?['variants'] as List<dynamic>?;
    if (variants != null && variants.isNotEmpty) {
      return variants.first;
    }
    return "default";
  }

  @override
  Future<void> logUsage(String flagKey) async {
    try {
      final file = await AppDataPath.getFile(AppConstants.fileFeatureUsage);
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
      debugPrint("Failed to log feature usage: $e");
    }
  }
}
