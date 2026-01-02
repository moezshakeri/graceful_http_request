import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graceful_http_request/graceful_http_request.dart';

enum RequestType {
  fast,
  slow,
}

class RequestState {
  final bool isLoading;
  final bool isWaiting;
  final String? result;
  final String? error;

  const RequestState({
    this.isLoading = false,
    this.isWaiting = false,
    this.result,
    this.error,
  });

  RequestState copyWith({
    bool? isLoading,
    bool? isWaiting,
    String? result,
    String? error,
  }) {
    return RequestState(
      isLoading: isLoading ?? this.isLoading,
      isWaiting: isWaiting ?? this.isWaiting,
      result: result ?? this.result,
      error: error ?? this.error,
    );
  }
}

class RequestCubit extends Cubit<RequestState> {
  RequestCubit() : super(const RequestState());

  Future<void> executeRequest(RequestType type) async {
    emit(state.copyWith(isLoading: true, error: null, result: null));

    try {
      await execute<String>(
        request: () => _simulateRequest(type),
        waitingThreshold: const Duration(milliseconds: 500),
        maxWaitTime: const Duration(milliseconds: 1000),
        onWaiting: () {
          emit(state.copyWith(isWaiting: true));
        },
      );

      final result = type == RequestType.fast
          ? 'Fast response completed'
          : 'Slow response completed';
      emit(state.copyWith(
        isLoading: false,
        isWaiting: false,
        result: result,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isWaiting: false,
        error: e.toString(),
      ));
    }
  }

  Future<String> _simulateRequest(RequestType type) {
    final duration = type == RequestType.fast
        ? const Duration(milliseconds: 200)
        : const Duration(milliseconds: 1200);
    return Future.delayed(duration, () => 'Success');
  }
}
