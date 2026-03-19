import 'dart:async';

enum CountdownPrecision { seconds, minutes }

class CountdownTicker {
  CountdownTicker._() {
    _minuteMarker = _truncateToMinute(DateTime.now());
    Timer.periodic(const Duration(seconds: 1), _onTick);
  }

  static final CountdownTicker shared = CountdownTicker._();

  late DateTime _minuteMarker;
  final StreamController<DateTime> _secondController =
      StreamController<DateTime>.broadcast();
  final StreamController<DateTime> _minuteController =
      StreamController<DateTime>.broadcast();

  Stream<DateTime> streamFor(CountdownPrecision precision) {
    return precision == CountdownPrecision.seconds
        ? _secondController.stream
        : _minuteController.stream;
  }

  void _onTick(Timer timer) {
    final DateTime now = DateTime.now();
    _secondController.add(now);
    final DateTime minute = _truncateToMinute(now);
    if (minute == _minuteMarker) {
      return;
    }
    _minuteMarker = minute;
    _minuteController.add(now);
  }

  DateTime _truncateToMinute(DateTime value) {
    return DateTime(
      value.year,
      value.month,
      value.day,
      value.hour,
      value.minute,
    );
  }
}
