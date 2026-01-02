import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:graceful_http_request/graceful_http_request.dart';
import 'package:graceful_http_request/src/utils/clock.dart';

void main() {
  group('execute - integration tests', () {
    late FakeClock clock;

    setUp(() {
      clock = FakeClock();
    });

    test('Response before waiting threshold', () async {
      final requestCompleter = Completer<String>();
      int waitingCallCount = 0;

      final future = execute<String>(
        request: () async {
          clock.elapsed(const Duration(milliseconds: 50));
          return await requestCompleter.future;
        },
        waitingThreshold: const Duration(milliseconds: 100),
        maxWaitTime: const Duration(milliseconds: 200),
        onWaiting: () {
          waitingCallCount++;
        },
        clock: clock,
      );

      requestCompleter.complete('fast response');

      expect(await future, 'fast response');
      expect(waitingCallCount, 0);
    });

    test('Response exactly at waiting threshold', () async {
      final requestCompleter = Completer<String>();
      int waitingCallCount = 0;

      final future = execute<String>(
        request: () async {
          clock.elapsed(const Duration(milliseconds: 100));
          return await requestCompleter.future;
        },
        waitingThreshold: const Duration(milliseconds: 100),
        maxWaitTime: const Duration(milliseconds: 200),
        onWaiting: () {
          waitingCallCount++;
        },
        clock: clock,
      );

      requestCompleter.complete('threshold response');

      expect(await future, 'threshold response');
      expect(waitingCallCount, 0);
    });

    test('Response between waiting threshold and max wait time', () async {
      final requestCompleter = Completer<String>();
      final onWaitingCompleter = Completer<void>();

      final future = execute<String>(
        request: () async {
          clock.elapsed(const Duration(milliseconds: 150));
          return await requestCompleter.future;
        },
        waitingThreshold: const Duration(milliseconds: 100),
        maxWaitTime: const Duration(milliseconds: 200),
        onWaiting: () {
          onWaitingCompleter.complete();
        },
        clock: clock,
      );

      requestCompleter.complete('slow response');

      await onWaitingCompleter.future;
      clock.elapsed(const Duration(milliseconds: 150));

      expect(await future, 'slow response');
    });

    test('Response exactly at max wait time', () async {
      final requestCompleter = Completer<String>();
      final onWaitingCompleter = Completer<void>();

      final future = execute<String>(
        request: () async {
          clock.elapsed(const Duration(milliseconds: 300));
          return await requestCompleter.future;
        },
        waitingThreshold: const Duration(milliseconds: 100),
        maxWaitTime: const Duration(milliseconds: 200),
        onWaiting: () {
          onWaitingCompleter.complete();
        },
        clock: clock,
      );

      requestCompleter.complete('max wait response');

      await onWaitingCompleter.future;

      expect(await future, 'max wait response');
    });

    test('Response after max wait time', () async {
      final requestCompleter = Completer<String>();
      final onWaitingCompleter = Completer<void>();

      final future = execute<String>(
        request: () async {
          clock.elapsed(const Duration(milliseconds: 400));
          return await requestCompleter.future;
        },
        waitingThreshold: const Duration(milliseconds: 100),
        maxWaitTime: const Duration(milliseconds: 200),
        onWaiting: () {
          onWaitingCompleter.complete();
        },
        clock: clock,
      );

      requestCompleter.complete('very slow response');

      await onWaitingCompleter.future;

      expect(await future, 'very slow response');
    });

    test('Error before waiting threshold', () async {
      final requestCompleter = Completer<String>();
      final error = Exception('Fast error');
      int waitingCallCount = 0;

      final future = execute<String>(
        request: () async {
          clock.elapsed(const Duration(milliseconds: 50));
          return await requestCompleter.future;
        },
        waitingThreshold: const Duration(milliseconds: 100),
        maxWaitTime: const Duration(milliseconds: 200),
        onWaiting: () {
          waitingCallCount++;
        },
        clock: clock,
      );

      requestCompleter.completeError(error, StackTrace.empty);

      expect(future, throwsA(error));
      expect(waitingCallCount, 0);
    });

    test('Error after waiting threshold', () async {
      final requestCompleter = Completer<String>();
      final error = Exception('Slow error');
      final onWaitingCompleter = Completer<void>();

      final future = execute<String>(
        request: () async {
          clock.elapsed(const Duration(milliseconds: 150));
          return await requestCompleter.future;
        },
        waitingThreshold: const Duration(milliseconds: 100),
        maxWaitTime: const Duration(milliseconds: 200),
        onWaiting: () {
          onWaitingCompleter.complete();
        },
        clock: clock,
      );

      requestCompleter.completeError(error, StackTrace.empty);

      await onWaitingCompleter.future;
      clock.elapsed(const Duration(milliseconds: 150));

      expect(future, throwsA(error));
    });

    test('Ensure onWaiting is called once', () async {
      final requestCompleter = Completer<String>();
      int waitingCallCount = 0;

      final future = execute<String>(
        request: () async {
          clock.elapsed(const Duration(milliseconds: 150));
          return await requestCompleter.future;
        },
        waitingThreshold: const Duration(milliseconds: 100),
        maxWaitTime: const Duration(milliseconds: 200),
        onWaiting: () {
          waitingCallCount++;
        },
        clock: clock,
      );

      requestCompleter.complete('response');
      clock.elapsed(const Duration(milliseconds: 150));

      await future;

      expect(waitingCallCount, 1);
    });

    test('Ensure response is delivered once', () async {
      final requestCompleter = Completer<String>();
      int responseCount = 0;

      final future = execute<String>(
        request: () async {
          clock.elapsed(const Duration(milliseconds: 50));
          return await requestCompleter.future;
        },
        waitingThreshold: const Duration(milliseconds: 100),
        maxWaitTime: const Duration(milliseconds: 200),
        onWaiting: () {},
        clock: clock,
      );

      requestCompleter.complete('response');

      future.then((_) => responseCount++);
      future.then((_) => responseCount++);

      await future;

      expect(responseCount, 2);
    });
  });
}
