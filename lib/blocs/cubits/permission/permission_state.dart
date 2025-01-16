part of 'permission_cubit.dart';

class PermissionCubitState extends Equatable {
  const PermissionCubitState(
      {required this.status, this.locationPermissionStatus});
  final BlocStatus status;
  final PermissionStatus? locationPermissionStatus;

  const PermissionCubitState.initial() : this(status: BlocStatus.initial);

  PermissionCubitState copyWith({
    BlocStatus? status,
    PermissionStatus? locationPermissionStatus,
  }) {
    return PermissionCubitState(
      status: status ?? this.status,
      locationPermissionStatus:
          locationPermissionStatus ?? this.locationPermissionStatus,
    );
  }

  @override
  List<Object?> get props => [status, locationPermissionStatus];
}
