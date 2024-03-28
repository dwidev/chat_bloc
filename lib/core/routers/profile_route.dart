import 'package:matchloves/core/routers/routergo.dart';
import 'package:matchloves/features/profile/pages/profile_page.dart';
import 'package:go_router/go_router.dart';

import '../../features/profile/pages/preview_profile_page.dart';
import '../../features/profile/pages/update_profile_page.dart';

final profileRoute = <RouteBase>[
  GoRoute(
    parentNavigatorKey: AppRouter.shellProfileKey,
    path: ProfilePage.path,
    builder: (context, state) {
      return const ProfilePage();
    },
    routes: [
      GoRoute(
        parentNavigatorKey: AppRouter.rootNavigatorKey,
        path: UpdateProfilePage.path,
        name: UpdateProfilePage.path,
        builder: (context, state) {
          return const UpdateProfilePage();
        },
      ),
      GoRoute(
        parentNavigatorKey: AppRouter.rootNavigatorKey,
        path: PreviewProfilePage.path,
        name: PreviewProfilePage.path,
        builder: (context, state) {
          return const PreviewProfilePage();
        },
      ),
    ],
  )
];
