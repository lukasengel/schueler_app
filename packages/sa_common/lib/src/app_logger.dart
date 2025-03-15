import 'package:logger/logger.dart';

/// Provides a simple and consistent interface for logging throughout the codebase.
///
/// The technical implementation of the logger is abstracted away so the logging
/// configuration may be changed without affecting the rest of the application.
sealed class SAppLogger {
  // Make class non-instantiable.
  SAppLogger._();

  /// The single instance of [Logger] used.
  static final _instance = Logger();

  /// Log a message at the debug level.
  static void debug(String message) => _instance.d(message);

  /// Log a message at the info level.
  static void info(String message) => _instance.i(message);

  /// Log a message at the warning level.
  static void warning(String message) => _instance.w(message);

  /// LOG a message at the error level.
  static void error(String message) => _instance.e(message);

  /// Log a message at the fatal level.
  static void fatal(String message) => _instance.f(message);
}
