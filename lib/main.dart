import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth/pages/login_page.dart';
import 'chat/data/datasources/http_datasource.dart';
import 'chat/data/datasources/ws_datasource.dart';
import 'chat/data/repository/chat_repository.dart';
import 'core/theme/theme.dart';
import 'homepage/cubit/bottom_navigation_menu/bottom_navigation_menu_cubit.dart';
import 'nearbypeople/cubit/details_card_cubit.dart';

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
        home: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => DetailsCardCubit()),
            BlocProvider(create: (context) => BottomNavigationMenuCubit())
          ],
          child: const LoginPage(),
        ),
      ),
    );
  }
}
