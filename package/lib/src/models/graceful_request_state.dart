abstract class GracefulRequestState<T> {
  const GracefulRequestState();
}

class GracefulRequestInitial<T> extends GracefulRequestState<T> {
  const GracefulRequestInitial();
}

class GracefulRequestWaiting<T> extends GracefulRequestState<T> {
  const GracefulRequestWaiting();
}

class GracefulRequestCompleted<T> extends GracefulRequestState<T> {
  const GracefulRequestCompleted(this.data);
  final T data;
}

class GracefulRequestError<T> extends GracefulRequestState<T> {
  const GracefulRequestError(this.error, this.stackTrace);
  final Object error;
  final StackTrace stackTrace;
}
