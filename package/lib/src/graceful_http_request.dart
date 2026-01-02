import 'controller/graceful_request_controller.dart';
import 'utils/clock.dart';

Future<T> execute<T>({
  required Future<T> Function() request,
  required Duration waitingThreshold,
  required Duration maxWaitTime,
  void Function()? onWaiting,
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
