enum BlocStatus {
  initial,
  loading,
  success,
  error,
}

extension BlocStatusX on BlocStatus {
  bool get isInitial => this == BlocStatus.initial;
  bool get isLoading => this == BlocStatus.loading;
  bool get isSuccess => this == BlocStatus.success;
  bool get isError => this == BlocStatus.error;
}
