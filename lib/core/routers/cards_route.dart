import 'package:matchloves/core/routers/routergo.dart';
import 'package:go_router/go_router.dart';

import '../../features/nearbypeople/pages/nearby_people_card_detail_page.dart';
import '../../features/nearbypeople/pages/swipe_cards_page.dart';

final cardsRoute = <RouteBase>[
  GoRoute(
    parentNavigatorKey: AppRouter.shellCardsKey,
    path: SwipeCardsPage.path,
    builder: (context, state) => const SwipeCardsPage(),
    routes: [
      GoRoute(
        parentNavigatorKey: AppRouter.rootNavigatorKey,
        path: NearbyPeopleCardDetailPage.path,
        name: NearbyPeopleCardDetailPage.path,
        builder: (context, state) {
          final imageUrl = state.extra as String;

          return NearbyPeopleCardDetailPage(
            imageUrl: imageUrl,
          );
        },
      ),
    ],
  ),
];
