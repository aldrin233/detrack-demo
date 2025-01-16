part of 'location_bloc.dart';

class LocationBlocState extends Equatable {
  const LocationBlocState({
    this.locationInfo,
    this.status = BlocStatus.initial,
    this.streamStatus = StreamStatus.none,
    this.message,
    this.oldLocations = const <LocationInfo>[],
  });

  final LocationInfo? locationInfo;
  final BlocStatus status;
  final StreamStatus streamStatus;
  final List<LocationInfo> oldLocations;
  final String? message;

  @override
  List<Object?> get props => [
        locationInfo,
        status,
        streamStatus,
        message,
        oldLocations,
      ];

  LocationBlocState copyWith({
    LocationInfo? locationInfo,
    BlocStatus? status,
    StreamStatus? streamStatus,
    String? message,
    List<LocationInfo>? oldLocations,
  }) {
    return LocationBlocState(
      locationInfo: locationInfo ?? this.locationInfo,
      status: status ?? this.status,
      streamStatus: streamStatus ?? this.streamStatus,
      message: message ?? this.message,
      oldLocations: oldLocations ?? this.oldLocations,
    );
  }
}
