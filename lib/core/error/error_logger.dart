import 'dart:convert';

import '../utils/app_data_path.dart';

class ErrorLogger {
  static Future<void> logError({
    required String errorType,
    required String message,
    String? stackTrace,
    String? userId,
  }) async {
    try {
      final file = await AppDataPath.getFile('error_logs.json');
      
      Map<String, dynamic> logData = {"errors": []};
      if (await file.exists()) {
        final content = await file.readAsString();
        if (content.isNotEmpty) {
          logData = json.decode(content);
        }
      }

      final newError = {
        "timestamp": DateTime.now().toIso8601String(),
        "errorType": errorType,
        "message": message,
        "stackTrace": stackTrace ?? "",
        "userId": userId ?? "anonymous"
      };

      (logData["errors"] as List).add(newError);
      await file.writeAsString(json.encode(logData));
    } catch (e) {
      print("Failed to log error: $e");
    }
  }
}
