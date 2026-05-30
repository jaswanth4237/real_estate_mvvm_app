import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../utils/app_data_path.dart';
import '../constants.dart';

/// A utility class for logging critical errors to a persistent JSON file.
///
/// Errors are appended to [AppConstants.fileErrorLogs] in the app data directory.
/// Each entry contains a timestamp, error type, message, stack trace, and user ID.
class ErrorLogger {
  /// Logs a critical error entry to the JSON error log file.
  ///
  /// [errorType] categorises the error (e.g. `"NetworkError"`).
  /// [message] is the human-readable error description.
  /// [stackTrace] is an optional serialised stack trace string.
  /// [userId] identifies the user; defaults to `"anonymous"`.
  static Future<void> logError({
    required String errorType,
    required String message,
    String? stackTrace,
    String? userId,
  }) async {
    try {
      final file = await AppDataPath.getFile(AppConstants.fileErrorLogs);

      Map<String, dynamic> logData = {'errors': []};
      if (await file.exists()) {
        final content = await file.readAsString();
        if (content.isNotEmpty) {
          logData = json.decode(content) as Map<String, dynamic>;
        }
      }

      final newError = {
        'timestamp': DateTime.now().toIso8601String(),
        'errorType': errorType,
        'message': message,
        'stackTrace': stackTrace ?? '',
        'userId': userId ?? 'anonymous',
      };

      (logData['errors'] as List).add(newError);
      await file.writeAsString(json.encode(logData));
    } catch (e) {
      debugPrint('Failed to log error: $e');
    }
  }
}
