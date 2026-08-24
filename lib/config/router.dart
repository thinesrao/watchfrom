import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:watchfrom/presentation/screens/home_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/detail',
      // TODO(task-7): replace with the real detail screen.
      builder: (context, state) => const Scaffold(
        body: Center(child: Text('Detail')),
      ),
    ),
  ],
);
