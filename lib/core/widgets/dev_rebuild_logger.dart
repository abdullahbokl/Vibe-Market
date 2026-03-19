import 'package:flutter/widgets.dart';

import '../performance/performance_trace.dart';

class DevRebuildLogger extends StatelessWidget {
  const DevRebuildLogger({
    required this.label,
    required this.child,
    super.key,
  });

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    assert(() {
      PerformanceTrace.logRebuild(label);
      return true;
    }());
    return child;
  }
}
