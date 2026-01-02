import 'dart:async';
import '../timing/waiting_strategy.dart';
import '../utils/clock.dart';

class GracefulRequestController<T> {
  GracefulRequestController({
    required this.waitingThreshold,
    required this.maxWaitTime,
    Clock? clock,
    WaitingStrategy? waitingStrategy,
  })  : clock = clock ?? _DefaultClock(),
        waitingStrategy = waitingStrategy ??
            DefaultWaitingStrategy(
              waitingThreshold: waitingThreshold,
              maxWaitTime: maxWaitTime,
              clock: clock ?? _DefaultClock(),
            );

  final Duration waitingThreshold;
  final Duration maxWaitTime;
  final Clock clock;
  final WaitingStrategy waitingStrategy;

  Future<T> execute({
    required Future<T> Function() request,
    void Function()? onWaiting,
  }) async {
    final requestStartTime = clock.now();

    try {
      final result = await request();
      final requestCompletionTime = clock.now();

      final decision = waitingStrategy.shouldWait(
        requestStartTime: requestStartTime,
        requestCompletionTime: requestCompletionTime,
      );

      if (decision.shouldEmitWaiting) {
        onWaiting?.call();
      }

      if (decision.deliveryDelay > Duration.zero) {
        await _delay(decision.deliveryDelay);
      }

      return result;
    } catch (error, stackTrace) {
      final requestCompletionTime = clock.now();

      final decision = waitingStrategy.shouldWait(
        requestStartTime: requestStartTime,
        requestCompletionTime: requestCompletionTime,
      );

      if (decision.shouldEmitWaiting) {
        onWaiting?.call();
      }

      if (decision.deliveryDelay > Duration.zero) {
        await _delay(decision.deliveryDelay);
      }

      Error.throwWithStackTrace(error, stackTrace);
    }
  }

  Future<void> _delay(Duration duration) async {
    if (duration == Duration.zero) return;

    if (clock is FakeClock) {
      return Future.value();
    }

    return Future<void>.delayed(duration);
  }
}

class _DefaultClock implements Clock {
  @override
  DateTime now() => DateTime.now();
}
