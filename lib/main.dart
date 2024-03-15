// import 'package:auto_route/auto_route.dart';
import 'package:chat_bloc/core/routers/routergo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/theme.dart';
import 'features/chat/data/datasources/http_datasource.dart';
import 'features/chat/data/datasources/ws_datasource.dart';
import 'features/chat/data/repository/chat_repository.dart';
import 'features/nearbypeople/cubit/details_card_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final chatRepository = ChatRepository(
      webSocketDataSource: WebSocketDataSource(),
      httpDataSource: HttpDataSource(),
    );
    return RepositoryProvider(
      create: (context) => chatRepository,
      child: MaterialApp.router(
        title: 'Flutter Dating App animation with Bloc',
        theme: lightTheme,
        routerConfig: AppRouter.router,
        builder: (context, child) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => DetailsCardCubit()),
            ],
            child: child ?? const Offstage(),
          );
        },
      ),
    );
  }
}
