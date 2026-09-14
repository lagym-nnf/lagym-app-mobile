import 'dart:developer' as developer;

/// Simple logger for the app
class AppLogger {
  AppLogger._();

  static void debug(String message, [String? tag]) {
    _log(message, tag ?? 'DEBUG', level: 500);
  }

  static void info(String message, [String? tag]) {
    _log(message, tag ?? 'INFO', level: 800);
  }

  static void warning(String message, [String? tag]) {
    _log(message, tag ?? 'WARNING', level: 900);
  }

  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    _log(message, 'ERROR', level: 1000, error: error, stackTrace: stackTrace);
  }

  static void _log(
    String message,
    String tag, {
    int level = 0,
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      message,
      name: 'LA_GYM',
      level: level,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
