import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:real_estate_mvvm_app/core/utils/image_cache_manager.dart';

void main() {
  test('ImageCacheManager should create stats file', () async {
    await ImageCacheManager.logCacheStats(
      totalImages: 10,
      cacheSizeMb: 5.0,
      hitRate: 0.9,
    );

    final file = File('app_data/image_cache_stats.json');
    expect(await file.exists(), true);
  });
}
