enum StreamStatus { none, waiting, active, done, error }

extension StreamStatusX on StreamStatus {
  bool get isWaiting => this == StreamStatus.waiting;
  bool get isActive => this == StreamStatus.active;
  bool get isDone => this == StreamStatus.done;
  bool get isError => this == StreamStatus.error;
}
