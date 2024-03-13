import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/auth/pages/spalsh_page.dart';
import 'features/chat/data/datasources/http_datasource.dart';
import 'features/chat/data/datasources/ws_datasource.dart';
import 'features/chat/data/repository/chat_repository.dart';
import 'core/theme/theme.dart';
import 'features/homepage/cubit/bottom_navigation_menu/bottom_navigation_menu_cubit.dart';
import 'features/nearbypeople/cubit/details_card_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final chatRepository = ChatRepository(
      webSocketDataSource: WebSocketDataSource(),
      httpDataSource: HttpDataSource(),
    );
    return RepositoryProvider(
      create: (context) => chatRepository,
      child: MaterialApp(
        title: 'Flutter Dating App animation with Bloc',
        theme: lightTheme,
        initialRoute: "/",
        routes: {
          "/": (context) => const SplashPage(),
        },
        builder: (context, child) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => DetailsCardCubit()),
              BlocProvider(create: (context) => BottomNavigationMenuCubit())
            ],
            child: child ?? const Offstage(),
          );
        },
      ),
    );
  }
}
