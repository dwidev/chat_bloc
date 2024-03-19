import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/chat/bloc/chat_bloc/chat_bloc.dart';
import '../../features/chat/bloc/conversations_bloc/conversations_bloc.dart';
import '../../features/chat/bloc/ws_connection_bloc/ws_connection_bloc.dart';
import '../../features/chat/cubit/react_animation_cubit.dart';
import '../../features/chat/pages/chat_page.dart';
import '../../features/chat/pages/converstaions_page.dart';
import '../depedency_injection/injection.dart';
import 'routergo.dart';

final chatsRoute = <RouteBase>[
  GoRoute(
    parentNavigatorKey: AppRouter.shellChatKey,
    path: ConversationsPage.path,
    builder: (context, state) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => getIt<ConversationsBloc>()),
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
          final convBloc = options.conversationsBloc;

          return MultiBlocProvider(
            providers: [
              BlocProvider.value(value: convBloc),
              BlocProvider(create: (context) => ReactAnimationCubit()),
              BlocProvider(create: (context) => getIt<ChatBloc>()),
            ],
            child: ChatPage(options: options),
          );
        },
      ),
    ],
  ),
];
