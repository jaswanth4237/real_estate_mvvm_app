import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:real_estate_mvvm_app/core/accessibility/accessibility_service.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late AccessibilityService service;
  late MockSharedPreferences mockPrefs;

  setUp(() {
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
    final file = File('app_data/accessibility_report.json');
    expect(await file.exists(), true);
  });
}
