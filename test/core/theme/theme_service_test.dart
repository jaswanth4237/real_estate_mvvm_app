import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:real_estate_mvvm_app/core/theme/app_theme.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late ThemeService service;
  late MockSharedPreferences mockPrefs;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    when(() => mockPrefs.getString('selected_theme')).thenReturn('light');
    service = ThemeService(mockPrefs);
  });

  test('should set theme and save to prefs', () async {
    // arrange
    when(() => mockPrefs.setString(any(), any()))
        .thenAnswer((_) async => true);

    // act
    await service.setTheme('dark');

    // assert
    expect(service.isDarkMode, true);
    verify(() => mockPrefs.setString('selected_theme', 'dark')).called(1);
  });
}
