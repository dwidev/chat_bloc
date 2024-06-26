import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/depedency_injection/injection.dart';
import 'core/environtments/flavors.dart';
import 'core/routers/routergo.dart';
import 'core/theme/theme.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await dotenv.load(fileName: '.env');
  await configureDepedencies(environment: EnvFlavors.mock);

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
