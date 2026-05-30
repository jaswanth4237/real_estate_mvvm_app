import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/interfaces/i_theme_service.dart';
import '../constants.dart';

/// Provides static helpers for building [ThemeData] from a JSON config asset.
///
/// Call [init] once at startup to pre-load the `assets/theme_config.json`
/// configuration; subsequent calls are no-ops.
class AppTheme {
  static Map<String, dynamic>? _themeConfig;

  /// Loads and caches the theme configuration JSON asset.
  ///
  /// This must be called before [getTheme] is used. Safe to call multiple times.
  static Future<void> init() async {
    _themeConfig ??= json.decode(
      await rootBundle.loadString('assets/theme_config.json'),
    );
  }

  /// Returns a [ThemeData] built from the JSON config for the given brightness.
  ///
  /// Falls back to [ThemeData.dark] / [ThemeData.light] if the config is not
  /// yet loaded.
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

/// [ChangeNotifier]-backed implementation of [IThemeService].
///
/// Persists the user's theme choice in SharedPreferences and notifies
/// listeners on change so that the widget tree rebuilds with the new theme.
class ThemeService extends ChangeNotifier implements IThemeService {
  /// The SharedPreferences instance used for persisting the selected theme.
  final SharedPreferences prefs;
  late String _selectedTheme;

  /// Creates a [ThemeService], restoring the last saved theme preference.
  ThemeService(this.prefs) {
    _selectedTheme = prefs.getString(AppConstants.keySelectedTheme) ?? 'system';
  }

  @override
  String get selectedTheme => _selectedTheme;

  @override
  bool get isDarkMode {
    if (_selectedTheme == 'dark') return true;
    if (_selectedTheme == 'light') return false;
    return WidgetsBinding.instance.platformDispatcher.platformBrightness ==
        Brightness.dark;
  }

  @override
  Future<void> setTheme(String theme) async {
    _selectedTheme = theme;
    await prefs.setString(AppConstants.keySelectedTheme, theme);
    notifyListeners();
  }
}
