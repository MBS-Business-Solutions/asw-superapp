import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class LogHelper {
  static File? _logFile;

  static Future<void> init() async {
    if (kDebugMode) {
      print('LogHelper initialized');
      final dir = await getApplicationDocumentsDirectory();
      _logFile = File('${dir.path}/app_log.txt');
    }
  }

  static Future<void> log(String message) async {
    if (kDebugMode) {
      print('Logging message: $message');
      final timestamp = DateTime.now().toIso8601String();
      final line = '[$timestamp] $message\n';
      await _logFile?.writeAsString(line, mode: FileMode.append);
    }
  }

  static Future<String> readLog() async {
    return _logFile?.readAsString() ?? '';
  }

  static Future<void> clear() async {
    await _logFile?.writeAsString('');
  }
}
