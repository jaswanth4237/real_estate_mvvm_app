import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppTheme {
  static Map<String, dynamic>? _themeConfig;

  static Future<void> init() async {
    _themeConfig ??= json.decode(
      await rootBundle.loadString('assets/theme_config.json'),
    );
  }

  static ThemeData getTheme(bool isDark) {
    final data = _themeConfig;
    if (data == null) {
      return isDark ? ThemeData.dark() : ThemeData.light();
    }

    final themeConfig = Map<String, dynamic>.from(
      (isDark ? data['dark'] : data['light']) as Map? ??
          const <String, dynamic>{},
    );
    final fallbackScheme =
        isDark ? const ColorScheme.dark() : const ColorScheme.light();
    final primary = _parseColor(themeConfig['primary'], fallbackScheme.primary);
    final background = _parseColor(
      themeConfig['background'],
      fallbackScheme.surface,
    );
    final onPrimary = _parseColor(
      themeConfig['onPrimary'],
      fallbackScheme.onPrimary,
    );
    final secondary = _parseColor(
      themeConfig['secondary'],
      fallbackScheme.secondary,
    );
    final onSecondary = _parseColor(
      themeConfig['onSecondary'],
      fallbackScheme.onSecondary,
    );
    final error = _parseColor(themeConfig['error'], fallbackScheme.error);
    final surface = _parseColor(themeConfig['surface'], fallbackScheme.surface);
    final onSurface = _parseColor(
      themeConfig['onSurface'],
      fallbackScheme.onSurface,
    );

    return ThemeData(
      brightness: isDark ? Brightness.dark : Brightness.light,
      primaryColor: primary,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: primary,
        onPrimary: onPrimary,
        secondary: secondary,
        onSecondary: onSecondary,
        error: error,
        onError: Colors.white,
        surface: surface,
        onSurface: onSurface,
      ),
    );
  }

  static Color _parseColor(dynamic value, Color fallback) {
    if (value is! String || value.isEmpty) {
      return fallback;
    }

    final normalized =
        value.startsWith('#') ? value.replaceFirst('#', '0xFF') : value;
    final parsed = int.tryParse(normalized);
    return parsed == null ? fallback : Color(parsed);
  }
}

class ThemeService extends ChangeNotifier {
  final SharedPreferences prefs;
  late String _selectedTheme;

  ThemeService(this.prefs) {
    _selectedTheme = prefs.getString('selected_theme') ?? 'system';
  }

  String get selectedTheme => _selectedTheme;

  bool get isDarkMode {
    if (_selectedTheme == 'dark') return true;
    if (_selectedTheme == 'light') return false;
    return WidgetsBinding.instance.platformDispatcher.platformBrightness ==
        Brightness.dark;
  }

  Future<void> setTheme(String theme) async {
    _selectedTheme = theme;
    await prefs.setString('selected_theme', theme);
    notifyListeners();
  }
}
