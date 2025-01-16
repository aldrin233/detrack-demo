import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/screens.dart';
part 'route_list.dart';

final goRouter = GoRouter(
  routes: routeList,
  initialLocation: '/',
  errorPageBuilder: (context, state) => MaterialPage(
    child: Scaffold(
      body: Center(
        child: Text('Page not found'),
      ),
    ),
  ),
);
