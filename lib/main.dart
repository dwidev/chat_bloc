import 'package:chat_bloc/homepage/cubit/bottom_navigation_menu/bottom_navigation_menu_cubit.dart';
import 'package:chat_bloc/homepage/pages/home_page.dart';
import 'package:chat_bloc/swipe_library/example.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'chat/data/datasources/http_datasource.dart';
import 'chat/data/datasources/ws_datasource.dart';
import 'chat/data/repository/chat_repository.dart';
import 'core/theme/theme.dart';
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
          child: const HomePage(),
        ),
      ),
    );
  }
}

class TextMenuSwipeCard extends StatelessWidget {
  const TextMenuSwipeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              push(context: context, page: const TestSwipePage());
            },
            child: const Text("Swipe card"),
          ),
        ],
      ),
    );
  }
}
