import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movieapp/shared/routes/route_generator.dart';
import 'package:movieapp/shared/utils/responsive_widgets.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GoRouter router = RouteGenerator.generateRoute();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Movie App',
      themeMode: ThemeMode.dark,
      routerConfig: router,
      builder: (context, child) {
        return ResponsiveScope(
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
