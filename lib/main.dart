import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/depedency_injection/injection.dart';
import 'core/routers/routergo.dart';
import 'core/theme/theme.dart';

void main() {
  configureDepedencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Love match',
      theme: lightTheme,
      routerConfig: AppRouter.router,
      builder: (context, child) {
        return child ?? const Offstage();
      },
    );
  }
}
