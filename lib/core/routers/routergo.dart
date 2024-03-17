import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/pages/allow_permission_location_page.dart';
import '../../features/auth/pages/spalsh_page.dart';
import '../../features/main/pages/main_page.dart';
import '../depedency_injection/injection.dart';
import '../photos_picker/photo_picker_cubit.dart';
import '../photos_picker/photos_widget.dart';
import 'auth_route.dart';
import 'cards_route.dart';
import 'chats_route.dart';
import 'matches_route.dart';
import 'profile_route.dart';

abstract class AppRouter {
  static final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: "root");
  static final shellCardsKey = GlobalKey<NavigatorState>(debugLabel: "cards");
  static final shellMatchKey = GlobalKey<NavigatorState>(debugLabel: "match");
  static final shellChatKey = GlobalKey<NavigatorState>(debugLabel: "chat");
  static final shellProfileKey = GlobalKey<NavigatorState>(debugLabel: "chat");

  static get router => _router;

  static final _router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: SplashPage.path,
    routes: <RouteBase>[
      ...authRoute,
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainPage(key: UniqueKey(), navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: cardsRoute,
            navigatorKey: shellCardsKey,
          ),
          StatefulShellBranch(
            routes: matchesRoute,
            navigatorKey: shellMatchKey,
          ),
          StatefulShellBranch(
            routes: chatsRoute,
            navigatorKey: shellChatKey,
          ),
          StatefulShellBranch(
            routes: profileRoute,
            navigatorKey: shellProfileKey,
          ),
        ],
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: GalleryViewPage.path,
        builder: (context, state) {
          final index = state.extra as int?;

          return BlocProvider<PhotoPickerCubit>.value(
            value: getIt<PhotoPickerCubit>(),
            child: GalleryViewPage(index: index),
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: AllowPermissionLocationPage.path,
        builder: (context, state) => const AllowPermissionLocationPage(),
      )
    ],
  );
}
