// network_state.dart
enum Status { loading, success, error }

class NetworkState<T> {
  final Status status;
  final T? data;
  final String? message;

  const NetworkState._({required this.status, this.data, this.message});

  // Factory constructors for each state
  factory NetworkState.loading() => NetworkState._(status: Status.loading);

  factory NetworkState.success(T data) =>
      NetworkState._(status: Status.success, data: data);

  factory NetworkState.error(String message) =>
      NetworkState._(status: Status.error, message: message);

  // Checkers for each state
  bool get isLoading => status == Status.loading;
  bool get isSuccess => status == Status.success;
  bool get isError => status == Status.error;
}
