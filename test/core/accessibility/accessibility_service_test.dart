import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:real_estate_mvvm_app/core/di/accessibility/accessibility_service.dart';
import 'package:real_estate_mvvm_app/core/utils/app_data_path.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AccessibilityService service;
  late MockSharedPreferences mockPrefs;

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (MethodCall methodCall) async => Directory.systemTemp.path,
    );
    mockPrefs = MockSharedPreferences();
    service = AccessibilityService(mockPrefs);
  });

  test('should generate accessibility report and create file', () async {
    // act
    await service.generateReport([
      {
        "widgetType": "TestWidget",
        "hasSemantics": true,
        "semanticLabel": "Test label",
        "contrastRatio": 5.5,
      }
    ]);

    // assert
    final file = await AppDataPath.getFile('accessibility_report.json');
    expect(await file.exists(), true);
  });
}
