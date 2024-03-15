import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/bloc/complete_profile_bloc.dart';
import '../../features/auth/pages/allow_permission_location_page.dart';
import '../../features/auth/pages/complete_profile/complete_profile_page.dart';
import '../../features/auth/pages/spalsh_page.dart';
import '../../features/main/pages/main_page.dart';
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
        path: CompleteProfilePage.path,
        builder: (context, state) {
          return BlocProvider(
            create: (context) => CompleteProfileBloc(),
            child: const CompleteProfilePage(),
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: GalleryViewPage.path,
        builder: (context, state) {
          final index = state.extra as int?;

          return BlocProvider.value(
            value: photoPickerCubit,
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
