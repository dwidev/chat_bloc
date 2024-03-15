import 'package:chat_bloc/core/routers/routergo.dart';
import 'package:chat_bloc/features/chat/bloc/chat_bloc/chat_bloc.dart';
import 'package:chat_bloc/features/chat/bloc/conversations_bloc/conversations_bloc.dart';
import 'package:chat_bloc/features/chat/bloc/ws_connection_bloc/ws_connection_bloc.dart';
import 'package:chat_bloc/features/chat/data/repository/chat_repository.dart';
import 'package:chat_bloc/features/chat/pages/chat_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/chat/cubit/react_animation_cubit.dart';
import '../../features/chat/pages/converstaions_page.dart';

final chatsRoute = <RouteBase>[
  GoRoute(
    parentNavigatorKey: AppRouter.shellChatKey,
    path: ConversationsPage.path,
    builder: (context, state) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => WsConnectionBloc(
              chatRepository: context.read<ChatRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => ConversationsBloc(
              chatRepository: context.read<ChatRepository>(),
            ),
          ),
        ],
        child: const ConversationsPage(me: 'dwi'),
      );
    },
    routes: [
      GoRoute(
        parentNavigatorKey: AppRouter.rootNavigatorKey,
        path: ChatPage.path,
        name: ChatPage.path,
        builder: (context, state) {
          final options = state.extra as ChatPageOptions;
          return MultiBlocProvider(
            providers: [
              BlocProvider.value(value: context.read<ConversationsBloc>()),
              BlocProvider(create: (context) => ReactAnimationCubit()),
              BlocProvider(
                create: (context) => ChatBloc(
                  chatRepository: context.read<ChatRepository>(),
                ),
              ),
            ],
            child: ChatPage(options: options),
          );
        },
      ),
    ],
  ),
];
