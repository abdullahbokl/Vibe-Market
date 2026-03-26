import 'package:flutter/material.dart';

import '../services/countdown_ticker.dart';
import 'countdown_pill_frame.dart';

class CountdownPill extends StatelessWidget {
  const CountdownPill({
    required this.endTime,
    super.key,
    this.precision = CountdownPrecision.seconds,
  });

  final DateTime endTime;
  final CountdownPrecision precision;

  static CountdownPrecision resolvePrecision(DateTime endTime) {
    final Duration remaining = endTime.difference(DateTime.now());
    return remaining.inMinutes < 60
        ? CountdownPrecision.seconds
        : CountdownPrecision.minutes;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DateTime>(
      stream: CountdownTicker.shared.streamFor(precision),
      initialData: DateTime.now(),
      builder: (BuildContext context, AsyncSnapshot<DateTime> snapshot) {
        final Duration remaining = endTime.difference(
          snapshot.data ?? DateTime.now(),
        );
        return CountdownPillFrame(label: _formatLabel(remaining));
      },
    );
  }

  String _formatLabel(Duration remaining) {
    final Duration safeRemaining = remaining.isNegative ? Duration.zero : remaining;
    final int hours = safeRemaining.inHours;
    final int minutes = safeRemaining.inMinutes.remainder(60);
    final int seconds = safeRemaining.inSeconds.remainder(60);
    if (safeRemaining == Duration.zero) {
      return 'Drop ended';
    }
    return '${hours.toString().padLeft(2, '0')}:'
        '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }
}
