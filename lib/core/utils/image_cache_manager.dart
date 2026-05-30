import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'app_data_path.dart';
import '../constants.dart';

/// Utility class for managing and reporting image-cache statistics.
///
/// Cache statistics are written to [AppConstants.fileImageCacheStats] in the
/// app data directory, providing an audit trail for cache health monitoring.
class ImageCacheManager {
  /// Writes the current image-cache statistics to a JSON file.
  ///
  /// [totalImages] is the number of images currently held in cache.
  /// [cacheSizeMb] is the total cache footprint in megabytes.
  /// [hitRate] is a value between 0.0 and 1.0 indicating the cache-hit ratio.
  static Future<void> logCacheStats({
    required int totalImages,
    required double cacheSizeMb,
    required double hitRate,
  }) async {
    try {
      final file = await AppDataPath.getFile(AppConstants.fileImageCacheStats);
      final stats = {
        'totalImages': totalImages,
        'cacheSize_mb': cacheSizeMb,
        'hitRate': hitRate,
        'lastCleanup': DateTime.now().toIso8601String(),
      };
      await file.writeAsString(json.encode(stats));
    } catch (e) {
      debugPrint('Failed to log image cache stats: $e');
    }
  }
}
