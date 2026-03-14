import 'dart:convert';

import 'app_data_path.dart';

class ImageCacheManager {
  static Future<void> logCacheStats({
    required int totalImages,
    required double cacheSizeMb,
    required double hitRate,
  }) async {
    try {
      final file = await AppDataPath.getFile('image_cache_stats.json');
      final stats = {
        "totalImages": totalImages,
        "cacheSize_mb": cacheSizeMb,
        "hitRate": hitRate,
        "lastCleanup": DateTime.now().toIso8601String()
      };
      await file.writeAsString(json.encode(stats));
    } catch (e) {
      print("Failed to log image cache stats: $e");
    }
  }
}
