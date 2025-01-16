import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:detrack/core/bloc_status.dart';
import 'package:detrack/core/stream_status.dart';
import 'package:equatable/equatable.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:location/location.dart';
import '../../models/models.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationBlocEvent, LocationBlocState> {
  LocationBloc() : super(LocationBlocState()) {
    on<LocationBlocStartLocationStreamEvent>(
      _onStartLocationStream,
    );
    on<LocationBlocStopLocationStreamEvent>(
      _onStopLocationStream,
    );
    on<LocationBlocUpdateLocationEvent>(
      _onUpdateLocation,
    );
    on<LocationBlocStartPeriodicLocationEvent>(
      _onStartPeriodicLocation,
    );
    on<LocationBlocStopPeriodicLocationEvent>(
      _onStopPeriodicLocation,
    );
  }

  final _loc = Location();
  StreamSubscription<LocationData>? _locationStreamSubscription;
  Timer? _timer;

  Future<void> _onStartLocationStream(
      LocationBlocStartLocationStreamEvent event,
      Emitter<LocationBlocState> emit) async {
    try {
      emit(state.copyWith(status: BlocStatus.loading));

      final isBGEnabled = await _loc.enableBackgroundMode(enable: true);

      if (!isBGEnabled) {
        await _loc.enableBackgroundMode(enable: true);
      }

      _locationStreamSubscription = _loc.onLocationChanged.listen((v) {});

      _locationStreamSubscription?.onData(
        (data) {
          add(LocationBlocUpdateLocationEvent(data));
        },
      );
    } catch (e) {
      emit(state.copyWith(status: BlocStatus.error, message: e.toString()));
    }
  }

  Future<void> _onStopLocationStream(LocationBlocStopLocationStreamEvent event,
      Emitter<LocationBlocState> emit) async {
    try {
      emit(
        state.copyWith(
          status: BlocStatus.loading,
        ),
      );
      await _locationStreamSubscription?.cancel();
      _timer?.cancel();

      emit(
        state.copyWith(
          status: BlocStatus.initial,
          streamStatus: StreamStatus.none,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: BlocStatus.error, message: e.toString()));
    }
  }

  Future<void> _onUpdateLocation(LocationBlocUpdateLocationEvent event,
      Emitter<LocationBlocState> emit) async {
    try {
      var addressList = await geo.placemarkFromCoordinates(
        event.locationData.latitude ?? 0,
        event.locationData.longitude ?? 0,
      );

      final address =
          '${addressList.first.name}, ${addressList.first.street} ${addressList.first.postalCode} ${addressList.first.locality} ${addressList.first.administrativeArea} ${addressList.first.country}';

      var loc = state.locationInfo?.copyWith(
        lat: event.locationData.latitude ?? 0,
        long: event.locationData.longitude ?? 0,
        address: address,
        date: DateTime.now(),
      );

      loc ??= LocationInfo(
        lat: event.locationData.latitude ?? 0,
        long: event.locationData.longitude ?? 0,
        date: DateTime.now(),
        address: address,
      );

      emit(
        state.copyWith(
          status: BlocStatus.success,
          streamStatus: StreamStatus.active,
          locationInfo: loc,
          oldLocations: [...state.oldLocations, loc],
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: BlocStatus.error, message: e.toString()));
    }
  }

  Future<void> _onStartPeriodicLocation(
      LocationBlocStartPeriodicLocationEvent event,
      Emitter<LocationBlocState> emit) async {
    try {
      emit(state.copyWith(status: BlocStatus.loading));

      final isBGEnabled = await _loc.enableBackgroundMode(enable: true);

      if (!isBGEnabled) {
        await _loc.enableBackgroundMode(enable: true);
      }

      final location = await _loc.getLocation();
      add(LocationBlocUpdateLocationEvent(location));

      _timer = Timer.periodic(
        const Duration(seconds: 5),
        (timer) async {
          final location = await _loc.getLocation();
          add(LocationBlocUpdateLocationEvent(location));
        },
      );
    } catch (e) {
      emit(state.copyWith(status: BlocStatus.error, message: e.toString()));
    }
  }

  Future<void> _onStopPeriodicLocation(
      LocationBlocStopPeriodicLocationEvent event,
      Emitter<LocationBlocState> emit) async {
    try {
      emit(state.copyWith(status: BlocStatus.loading));
      await _locationStreamSubscription?.cancel();
      _timer?.cancel();

      emit(
        state.copyWith(
          status: BlocStatus.initial,
          streamStatus: StreamStatus.none,
        ),
      );
    } catch (e) {
      emit(state.copyWith(status: BlocStatus.error, message: e.toString()));
    }
  }
}
