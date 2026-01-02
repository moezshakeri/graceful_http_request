import '../utils/clock.dart';

class WaitingDecision {
  const WaitingDecision({
    required this.shouldEmitWaiting,
    required this.deliveryDelay,
  });

  final bool shouldEmitWaiting;
  final Duration deliveryDelay;
}

abstract class WaitingStrategy {
  WaitingDecision shouldWait({
    required DateTime requestStartTime,
    required DateTime requestCompletionTime,
  });
}

class DefaultWaitingStrategy implements WaitingStrategy {
  const DefaultWaitingStrategy({
    required this.waitingThreshold,
    required this.maxWaitTime,
    required this.clock,
  });

  final Duration waitingThreshold;
  final Duration maxWaitTime;
  final Clock clock;

  @override
  WaitingDecision shouldWait({
    required DateTime requestStartTime,
    required DateTime requestCompletionTime,
  }) {
    final elapsedTime = requestCompletionTime.difference(requestStartTime);

    if (elapsedTime <= waitingThreshold) {
      return const WaitingDecision(
        shouldEmitWaiting: false,
        deliveryDelay: Duration.zero,
      );
    }

    final minDeliveryTime =
        requestStartTime.add(waitingThreshold).add(maxWaitTime);

    if (requestCompletionTime.isBefore(minDeliveryTime)) {
      final deliveryDelay = minDeliveryTime.difference(requestCompletionTime);
      return WaitingDecision(
        shouldEmitWaiting: true,
        deliveryDelay: deliveryDelay,
      );
    }

    return const WaitingDecision(
      shouldEmitWaiting: true,
      deliveryDelay: Duration.zero,
    );
  }
}
