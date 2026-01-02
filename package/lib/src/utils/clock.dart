abstract class Clock {
  DateTime now();
}

class FakeClock implements Clock {
  DateTime _currentTime = DateTime.fromMillisecondsSinceEpoch(0);

  @override
  DateTime now() => _currentTime;

  void elapsed(Duration duration) {
    _currentTime = _currentTime.add(duration);
  }

  void setNow(DateTime time) {
    _currentTime = time;
  }
}
