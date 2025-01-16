import 'package:detrack/blocs/blocs.dart';
import 'package:detrack/routes/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(
    MaterialApp.router(
      routerConfig: goRouter,
      title: 'Detrack',
      builder: (context, child) {
        if (child == null) return CircularProgressIndicator.adaptive();

        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => PermissionCubit(),
            ),
            BlocProvider(
              create: (context) => LocationBloc(),
            ),
          ],
          child: child,
        );
      },
    ),
  );
}
