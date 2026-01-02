import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:graceful_http_request/src/controller/graceful_request_controller.dart';
import 'package:graceful_http_request/src/timing/waiting_strategy.dart';
import 'package:graceful_http_request/src/utils/clock.dart';
import 'package:mocktail/mocktail.dart';

class MockWaitingStrategy extends Mock implements WaitingStrategy {}

class MockClock extends Mock implements Clock {}

void main() {
  group('GracefulRequestController', () {
    late GracefulRequestController<String> controller;
    late FakeClock clock;
    late MockWaitingStrategy waitingStrategy;
    late void Function() onWaiting;

    setUp(() {
      clock = FakeClock();
      waitingStrategy = MockWaitingStrategy();
      onWaiting = () {};

      controller = GracefulRequestController<String>(
        waitingThreshold: const Duration(milliseconds: 100),
        maxWaitTime: const Duration(milliseconds: 200),
        clock: clock,
        waitingStrategy: waitingStrategy,
      );
    });

    test('should complete immediately for fast successful response', () async {
      final requestCompleter = Completer<String>();

      when(() => waitingStrategy.shouldWait(
            requestStartTime: any(named: 'requestStartTime'),
            requestCompletionTime: any(named: 'requestCompletionTime'),
          )).thenReturn(const WaitingDecision(
        shouldEmitWaiting: false,
        deliveryDelay: Duration.zero,
      ));

      final future = controller.execute(
        request: () => requestCompleter.future,
        onWaiting: onWaiting,
      );

      requestCompleter.complete('success');

      expect(await future, 'success');
    });

    test('should emit onWaiting and delay for slow successful response',
        () async {
      final requestCompleter = Completer<String>();
      bool waitingEmitted = false;

      when(() => waitingStrategy.shouldWait(
            requestStartTime: any(named: 'requestStartTime'),
            requestCompletionTime: any(named: 'requestCompletionTime'),
          )).thenReturn(const WaitingDecision(
        shouldEmitWaiting: true,
        deliveryDelay: Duration(milliseconds: 100),
      ));

      final future = controller.execute(
        request: () => requestCompleter.future,
        onWaiting: () {
          waitingEmitted = true;
        },
      );

      requestCompleter.complete('success');

      expect(waitingEmitted, false);
      clock.elapsed(const Duration(milliseconds: 100));

      expect(await future, 'success');
      expect(waitingEmitted, true);
    });

    test('should emit onWaiting but not delay for very slow response',
        () async {
      final requestCompleter = Completer<String>();
      bool waitingEmitted = false;

      when(() => waitingStrategy.shouldWait(
            requestStartTime: any(named: 'requestStartTime'),
            requestCompletionTime: any(named: 'requestCompletionTime'),
          )).thenReturn(const WaitingDecision(
        shouldEmitWaiting: true,
        deliveryDelay: Duration.zero,
      ));

      final future = controller.execute(
        request: () => requestCompleter.future,
        onWaiting: () {
          waitingEmitted = true;
        },
      );

      clock.elapsed(const Duration(milliseconds: 100));
      requestCompleter.complete('success');

      expect(await future, 'success');
      expect(waitingEmitted, true);
    });

    test('should propagate errors for fast error', () async {
      final requestCompleter = Completer<String>();
      final error = Exception('Request failed');

      when(() => waitingStrategy.shouldWait(
            requestStartTime: any(named: 'requestStartTime'),
            requestCompletionTime: any(named: 'requestCompletionTime'),
          )).thenReturn(const WaitingDecision(
        shouldEmitWaiting: false,
        deliveryDelay: Duration.zero,
      ));

      final future = controller.execute(
        request: () => requestCompleter.future,
        onWaiting: onWaiting,
      );

      requestCompleter.completeError(error, StackTrace.empty);

      expect(future, throwsA(error));
    });

    test('should propagate errors with timing for slow error', () async {
      final requestCompleter = Completer<String>();
      final error = Exception('Request failed');
      final onWaitingCompleter = Completer<void>();

      when(() => waitingStrategy.shouldWait(
            requestStartTime: any(named: 'requestStartTime'),
            requestCompletionTime: any(named: 'requestCompletionTime'),
          )).thenReturn(const WaitingDecision(
        shouldEmitWaiting: true,
        deliveryDelay: Duration(milliseconds: 50),
      ));

      final future = controller.execute(
        request: () => requestCompleter.future,
        onWaiting: () {
          onWaitingCompleter.complete();
        },
      );

      clock.elapsed(const Duration(milliseconds: 100));
      requestCompleter.completeError(error, StackTrace.empty);

      await onWaitingCompleter.future;
      clock.elapsed(const Duration(milliseconds: 50));

      expect(future, throwsA(error));
    });

    test('should only emit onWaiting once', () async {
      final requestCompleter = Completer<String>();
      int waitingCallCount = 0;

      when(() => waitingStrategy.shouldWait(
            requestStartTime: any(named: 'requestStartTime'),
            requestCompletionTime: any(named: 'requestCompletionTime'),
          )).thenReturn(const WaitingDecision(
        shouldEmitWaiting: true,
        deliveryDelay: Duration(milliseconds: 100),
      ));

      final future = controller.execute(
        request: () => requestCompleter.future,
        onWaiting: () {
          waitingCallCount++;
        },
      );

      clock.elapsed(const Duration(milliseconds: 200));
      requestCompleter.complete('success');

      await future;

      expect(waitingCallCount, 1);
    });

    test('should return generic type', () async {
      final requestCompleter = Completer<int>();

      final intController = GracefulRequestController<int>(
        waitingThreshold: const Duration(milliseconds: 100),
        maxWaitTime: const Duration(milliseconds: 200),
        clock: clock,
        waitingStrategy: waitingStrategy,
      );

      when(() => waitingStrategy.shouldWait(
            requestStartTime: any(named: 'requestStartTime'),
            requestCompletionTime: any(named: 'requestCompletionTime'),
          )).thenReturn(const WaitingDecision(
        shouldEmitWaiting: false,
        deliveryDelay: Duration.zero,
      ));

      final future = intController.execute(
        request: () => requestCompleter.future,
        onWaiting: onWaiting,
      );

      requestCompleter.complete(42);

      expect(await future, 42);
    });
  });
}
