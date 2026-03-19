import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

class PerformanceTrace {
  PerformanceTrace._();

  static final Map<String, Stopwatch> _activeTraces = <String, Stopwatch>{};

  static bool get _enabled =>
      kDebugMode || const bool.fromEnvironment('ENABLE_PERF_LOGS');

  static void start(String key) {
    if (!_enabled || _activeTraces.containsKey(key)) {
      return;
    }
    _activeTraces[key] = Stopwatch()..start();
    developer.log('Started trace: $key', name: 'PerformanceTrace');
  }

  static void finish(String key, {String? label}) {
    if (!_enabled) {
      return;
    }
    final Stopwatch? stopwatch = _activeTraces.remove(key);
    if (stopwatch == null) {
      return;
    }
    stopwatch.stop();
    final String message = label ?? key;
    developer.log(
      '$message completed in ${stopwatch.elapsedMilliseconds}ms',
      name: 'PerformanceTrace',
    );
  }

  static void logRebuild(String label) {
    if (!_enabled) {
      return;
    }
    developer.log('Rebuilt: $label', name: 'PerformanceTrace');
  }
}
