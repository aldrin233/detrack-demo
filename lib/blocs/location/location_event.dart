part of 'location_bloc.dart';

sealed class LocationBlocEvent extends Equatable {
  const LocationBlocEvent();
}

class LocationBlocStartLocationStreamEvent extends LocationBlocEvent {
  @override
  List<Object?> get props => [];
}

class LocationBlocStopLocationStreamEvent extends LocationBlocEvent {
  @override
  List<Object?> get props => [];
}

class LocationBlocUpdateLocationEvent extends LocationBlocEvent {
  final LocationData locationData;

  const LocationBlocUpdateLocationEvent(this.locationData);

  @override
  List<Object?> get props => [locationData];
}

class LocationBlocStartPeriodicLocationEvent extends LocationBlocEvent {
  const LocationBlocStartPeriodicLocationEvent();

  @override
  List<Object?> get props => [];
}

class LocationBlocStopPeriodicLocationEvent extends LocationBlocEvent {
  const LocationBlocStopPeriodicLocationEvent();

  @override
  List<Object?> get props => [];
}
