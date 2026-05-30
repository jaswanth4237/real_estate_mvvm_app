/// Contract for the dynamic theme management service.
///
/// Implementations load colour values from a JSON asset file and persist the
/// user's preference in SharedPreferences under [AppConstants.keySelectedTheme].
abstract class IThemeService {
  /// The currently selected theme identifier (`"light"`, `"dark"`, or `"system"`).
  String get selectedTheme;

  /// Returns `true` when the app should render in dark mode.
  bool get isDarkMode;

  /// Persists and applies the given [theme] identifier.
  Future<void> setTheme(String theme);
}
