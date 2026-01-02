import 'controller/graceful_request_controller.dart';
import 'utils/clock.dart';

/// Executes a request with controlled timing behavior.
///
/// This function ensures that the request is not delivered too quickly
/// (before [waitingThreshold]) and waits up to [maxWaitTime] if the request
/// takes longer than [waitingThreshold].
///
/// Example:
/// ```dart
/// final result = await execute(
///   request: () => httpClient.get(url),
///   waitingThreshold: Duration(milliseconds: 500),
///   maxWaitTime: Duration(seconds: 2),
///   onWaiting: () => showLoadingIndicator(),
/// );
/// ```
Future<T> execute<T>({
  /// The asynchronous function to execute (e.g., HTTP request).
  required Future<T> Function() request,

  /// Minimum time that should elapse before delivering the result.
  required Duration waitingThreshold,

  /// Maximum additional time to wait if request exceeds [waitingThreshold].
  required Duration maxWaitTime,

  /// Optional callback invoked when waiting is necessary.
  void Function()? onWaiting,

  /// Optional clock for testing purposes.
  Clock? clock,
}) {
  final controller = GracefulRequestController<T>(
    waitingThreshold: waitingThreshold,
    maxWaitTime: maxWaitTime,
    clock: clock,
  );

  return controller.execute(
    request: request,
    onWaiting: onWaiting,
  );
}
