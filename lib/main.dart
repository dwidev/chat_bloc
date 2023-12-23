import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'chat/data/datasources/http_datasource.dart';
import 'chat/data/datasources/ws_datasource.dart';
import 'chat/data/repository/chat_repository.dart';
import 'core/theme/theme.dart';
import 'homepage/home_page.dart';

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
        home: const HomePage(),
      ),
    );
  }
}
