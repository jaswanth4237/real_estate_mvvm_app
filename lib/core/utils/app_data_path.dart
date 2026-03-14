import 'dart:io';

import 'package:path_provider/path_provider.dart';

class AppDataPath {
  static const String _folderName = 'app_data';

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