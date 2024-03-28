import 'package:flutter/material.dart';

import 'core/depedency_injection/injection.dart';
import 'core/environtments/flavors.dart';
import 'core/routers/routergo.dart';
import 'core/theme/theme.dart';

void main() {
  configureDepedencies(environment: EnvFlavors.mock);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Match loves',
      theme: lightTheme,
      routerConfig: AppRouter.router,
      builder: (context, child) {
        return child ?? const Offstage();
      },
    );
  }
}
