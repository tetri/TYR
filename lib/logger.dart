import 'dart:developer' as developer;
import 'package:logging/logging.dart';

final Logger appLogger = Logger('TYR');

/// Initialize logging. Call `initLogging()` early in app startup (e.g. in
/// `main()`). This routes `package:logging` records to `dart:developer.log`.
void initLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    developer.log(
      '${record.level.name}: ${record.time.toIso8601String()}: ${record.loggerName}: ${record.message}',
      name: record.loggerName,
      level: record.level.value,
      error: record.error,
      stackTrace: record.stackTrace,
    );
  });
}
