import 'package:detrack/blocs/blocs.dart';
import 'package:detrack/core/bloc_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  late PermissionCubit _cubit;

  @override
  void initState() {
    _cubit = context.read<PermissionCubit>();
    _cubit.checkPermissions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PermissionCubit, PermissionCubitState>(
      listenWhen: (prev, current) {
        return prev.locationPermissionStatus !=
            current.locationPermissionStatus;
      },
      listener: (context, state) {
        if (state.locationPermissionStatus == PermissionStatus.granted) {
          context.go('/home');
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Permission Screen'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('status: ${state.locationPermissionStatus}'),
                  SizedBox(height: 20),
                  _buildPermissionButton(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPermissionButton() {
    return BlocSelector<PermissionCubit, PermissionCubitState, bool>(
      selector: (state) {
        return state.status.isLoading;
      },
      builder: (context, isLoading) {
        if (isLoading) {
          return CircularProgressIndicator();
        }

        return OutlinedButton(
          onPressed: () async {
            await _cubit.requestPermission();
          },
          child: Text('request permission'),
        );
      },
    );
  }
}
