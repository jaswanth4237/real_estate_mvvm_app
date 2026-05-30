import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Utility class for resolving persistent file paths within the app data directory.
///
/// Files are stored under `getApplicationSupportDirectory()/app_data/`. If that
/// directory is unavailable, the temporary directory is used as a fallback.
class AppDataPath {
  static const String _folderName = 'app_data';

  /// Returns (and creates if necessary) the root app-data [Directory].
  static Future<Directory> getAppDataDirectory() async {
    try {
      final baseDir = await getApplicationSupportDirectory();
      final appDataDir = Directory('${baseDir.path}${Platform.pathSeparator}$_folderName');
      if (!await appDataDir.exists()) {
        await appDataDir.create(recursive: true);
      }
      return appDataDir;
    } catch (_) {
      final tempDir = await getTemporaryDirectory();
      final appDataDir = Directory('${tempDir.path}${Platform.pathSeparator}$_folderName');
      if (!await appDataDir.exists()) {
        await appDataDir.create(recursive: true);
      }
      return appDataDir;
    }
  }

  /// Returns the [File] at [relativePath] beneath the app-data directory,
  /// creating any missing parent directories automatically.
  ///
  /// [relativePath] may use forward slashes; they are normalised to the
  /// platform separator automatically.
  static Future<File> getFile(String relativePath) async {
    final appDataDir = await getAppDataDirectory();
    final normalizedPath = relativePath.replaceAll('/', Platform.pathSeparator);
    final file = File('${appDataDir.path}${Platform.pathSeparator}$normalizedPath');

    final parent = file.parent;
    if (!await parent.exists()) {
      await parent.create(recursive: true);
    }

    return file;
  }
}
