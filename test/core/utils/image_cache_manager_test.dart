import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:real_estate_mvvm_app/core/utils/app_data_path.dart';
import 'package:real_estate_mvvm_app/core/utils/image_cache_manager.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (MethodCall methodCall) async => Directory.systemTemp.path,
    );
  });

  test('ImageCacheManager should create stats file', () async {
    await ImageCacheManager.logCacheStats(
      totalImages: 10,
      cacheSizeMb: 5.0,
      hitRate: 0.9,
    );

    final file = await AppDataPath.getFile('image_cache_stats.json');
    expect(await file.exists(), true);
  });
}
