import 'package:chat_bloc/core/routers/routergo.dart';
import 'package:go_router/go_router.dart';

import '../../features/matches/pages/matches_page.dart';

final matchesRoute = <RouteBase>[
  GoRoute(
    parentNavigatorKey: AppRouter.shellMatchKey,
    path: MatchesPage.path,
    builder: (context, state) => const MatchesPage(),
  ),
];
