part of 'router.dart';

final routeList = [
  permissionRoute,
  homeRoute,
];

final permissionRoute = GoRoute(
  path: '/',
  pageBuilder: (context, state) => MaterialPage(child: PermissionScreen()),
);

final homeRoute = GoRoute(
  path: '/home',
  pageBuilder: (context, state) => MaterialPage(
    child: const HomePageScreen(
      title: 'Detrack Demo',
    ),
  ),
);
