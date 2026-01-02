import 'package:flutter_test/flutter_test.dart';
import 'package:graceful_http_request/src/utils/clock.dart';

void main() {
  group('FakeClock', () {
    late FakeClock clock;

    setUp(() {
      clock = FakeClock();
    });

    test('should start at zero', () {
      expect(clock.now().millisecondsSinceEpoch, 0);
    });

    test('should return elapsed time in milliseconds', () {
      clock.elapsed(const Duration(milliseconds: 500));
      expect(clock.now().millisecondsSinceEpoch, 500);
    });

    test('should accumulate elapsed time', () {
      clock.elapsed(const Duration(milliseconds: 100));
      clock.elapsed(const Duration(milliseconds: 200));
      clock.elapsed(const Duration(milliseconds: 50));
      expect(clock.now().millisecondsSinceEpoch, 350);
    });

    test('should handle zero elapsed time', () {
      clock.elapsed(Duration.zero);
      expect(clock.now().millisecondsSinceEpoch, 0);
    });

    test('should handle large durations', () {
      clock.elapsed(const Duration(hours: 1, minutes: 30, seconds: 45));
      expect(clock.now().millisecondsSinceEpoch, 5445000);
    });

    test('should allow setting absolute time', () {
      clock.setNow(DateTime(2026, 1, 1, 12, 0, 0));
      expect(clock.now().year, 2026);
      expect(clock.now().month, 1);
      expect(clock.now().day, 1);
      expect(clock.now().hour, 12);
    });

    test('elapsed should add to previously set time', () {
      clock.setNow(DateTime(2026, 1, 1, 12, 0, 0));
      clock.elapsed(const Duration(minutes: 5));
      expect(clock.now().minute, 5);
    });
  });
}
