import 'package:flutter/material.dart';
import 'package:watchfrom/config/router.dart';
import 'package:watchfrom/config/theme.dart';

class WatchFromApp extends StatelessWidget {
  const WatchFromApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'WatchFrom',
      theme: AppTheme.dark,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
