import 'package:bloc/bloc.dart';
import 'package:detrack/core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:permission_handler/permission_handler.dart';

part 'permission_state.dart';

class PermissionCubit extends Cubit<PermissionCubitState> {
  PermissionCubit() : super(PermissionCubitState.initial());

  Future<void> checkPermissions() async {
    emit(state.copyWith(status: BlocStatus.loading));
    final status = await Permission.location.status;
    emit(state.copyWith(
      status: BlocStatus.success,
      locationPermissionStatus: status,
    ));
  }

  Future<void> requestPermission() async {
    emit(state.copyWith(status: BlocStatus.loading));
    final status = await Permission.location.request();
    emit(state.copyWith(
      status: BlocStatus.success,
      locationPermissionStatus: status,
    ));
  }
}
