import 'package:flutter_test/flutter_test.dart';
import 'package:graceful_http_request/src/timing/waiting_strategy.dart';
import 'package:graceful_http_request/src/utils/clock.dart';

void main() {
  group('DefaultWaitingStrategy', () {
    late DefaultWaitingStrategy strategy;
    late FakeClock clock;

    setUp(() {
      clock = FakeClock();
      strategy = DefaultWaitingStrategy(
        waitingThreshold: const Duration(milliseconds: 100),
        maxWaitTime: const Duration(milliseconds: 200),
        clock: clock,
      );
    });

    test('should not wait if request completes before threshold', () {
      final startTime = clock.now();
      final result = strategy.shouldWait(
        requestStartTime: startTime,
        requestCompletionTime: startTime.add(const Duration(milliseconds: 50)),
      );
      expect(result.shouldEmitWaiting, false);
      expect(result.deliveryDelay, Duration.zero);
    });

    test('should not wait if request completes exactly at threshold', () {
      final startTime = clock.now();
      final result = strategy.shouldWait(
        requestStartTime: startTime,
        requestCompletionTime: startTime.add(const Duration(milliseconds: 100)),
      );
      expect(result.shouldEmitWaiting, false);
      expect(result.deliveryDelay, Duration.zero);
    });

    test(
        'should emit waiting and deliver after threshold + maxWait if request completes before max',
        () {
      final startTime = clock.now();
      final result = strategy.shouldWait(
        requestStartTime: startTime,
        requestCompletionTime: startTime.add(const Duration(milliseconds: 150)),
      );
      expect(result.shouldEmitWaiting, true);
      expect(result.deliveryDelay, const Duration(milliseconds: 150));
    });

    test(
        'should emit waiting and deliver immediately if request completes after maxWait',
        () {
      final startTime = clock.now();
      final result = strategy.shouldWait(
        requestStartTime: startTime,
        requestCompletionTime: startTime.add(const Duration(milliseconds: 400)),
      );
      expect(result.shouldEmitWaiting, true);
      expect(result.deliveryDelay, Duration.zero);
    });

    test(
        'should emit waiting and deliver at threshold + maxWait if request completes at threshold + maxWait',
        () {
      final startTime = clock.now();
      final result = strategy.shouldWait(
        requestStartTime: startTime,
        requestCompletionTime: startTime.add(const Duration(milliseconds: 300)),
      );
      expect(result.shouldEmitWaiting, true);
      expect(result.deliveryDelay, Duration.zero);
    });
  });
}
