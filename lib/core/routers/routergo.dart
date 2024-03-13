import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/bloc/complete_profile_bloc.dart';
import '../../features/auth/pages/complete_profile/complete_profile_page.dart';
import '../photos_picker/photos_widget.dart';
import 'auth_route.dart';

final router = GoRouter(
  routes: <RouteBase>[
    ...authRoute,
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
      path: GalleryViewPage.path,
      builder: (context, state) {
        final index = state.extra as int?;

        return BlocProvider.value(
          value: photoPickerCubit,
          child: GalleryViewPage(index: index),
        );
      },
    ),
  ],
);
