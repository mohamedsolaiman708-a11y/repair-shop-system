import 'package:logger/logger.dart';

final Logger appLogger = Logger(
  printer: PrettyPrinter(
    methodCount: 2,
    errorMethodCount: 8,
    lineLength: 120,
    colors: true,
    printEmojis: true,
    printTime: true,
  ),
);

class Log {
  static void d(String message, [dynamic error, StackTrace? stackTrace]) {
    appLogger.d(message, error: error, stackTrace: stackTrace);
  }

  static void i(String message, [dynamic error, StackTrace? stackTrace]) {
    appLogger.i(message, error: error, stackTrace: stackTrace);
  }

  static void w(String message, [dynamic error, StackTrace? stackTrace]) {
    appLogger.w(message, error: error, stackTrace: stackTrace);
  }

  static void e(String message, [dynamic error, StackTrace? stackTrace]) {
    appLogger.e(message, error: error, stackTrace: stackTrace);
  }
}
