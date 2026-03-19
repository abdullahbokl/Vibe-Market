import 'package:flutter/material.dart';

import '../performance/performance_trace.dart';

class PerformanceMarker extends StatefulWidget {
  const PerformanceMarker({
    required this.traceKey,
    required this.child,
    super.key,
    this.label,
  });

  final String traceKey;
  final String? label;
  final Widget child;

  @override
  State<PerformanceMarker> createState() => _PerformanceMarkerState();
}

class _PerformanceMarkerState extends State<PerformanceMarker> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      PerformanceTrace.finish(widget.traceKey, label: widget.label);
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
