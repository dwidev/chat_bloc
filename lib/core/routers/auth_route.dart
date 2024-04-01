import 'package:matchloves/core/routers/routergo.dart';
import 'package:matchloves/features/auth/presentation/bloc/authentication_bloc.dart';
import 'package:matchloves/features/masterdata/cubit/master_data_cubit.dart';

import '../depedency_injection/injection.dart';
import '../extensions/go_router_state_extension.dart';
import '../../features/auth/presentation/pages/complete_profile/complete_profile_page.dart';
import '../../features/auth/presentation/pages/login/login_page.dart';
import '../../features/auth/presentation/pages/welcome_and_tnc_page.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/bloc/complete_profile_bloc.dart';
import '../../features/auth/presentation/pages/login/login_with_phone_number.dart';
import '../../features/auth/presentation/pages/login/verify_otp_page.dart';
import '../../features/auth/presentation/pages/spalsh_page.dart';

final authRoute = <RouteBase>[
  GoRoute(
    parentNavigatorKey: AppRouter.rootNavigatorKey,
    path: SplashPage.path,
    builder: (context, state) => const SplashPage(),
  ),
  GoRoute(
    parentNavigatorKey: AppRouter.rootNavigatorKey,
    path: LoginPage.path,
    pageBuilder: (context, state) {
      return state.fadeTransition(
        child: BlocProvider(
          create: (context) => getIt<AuthenticationBloc>(),
          child: const LoginPage(),
        ),
      );
    },
    routes: [
      GoRoute(
        parentNavigatorKey: AppRouter.rootNavigatorKey,
        name: LoginWithPhoneNumberPage.path,
        path: LoginWithPhoneNumberPage.path,
        builder: (context, state) => const LoginWithPhoneNumberPage(),
      ),
      GoRoute(
        parentNavigatorKey: AppRouter.rootNavigatorKey,
        name: VerifyOtpPage.path,
        path: VerifyOtpPage.path,
        builder: (context, state) => const VerifyOtpPage(),
      ),
      GoRoute(
        parentNavigatorKey: AppRouter.rootNavigatorKey,
        name: WelcomeAndTncPage.path,
        path: WelcomeAndTncPage.path,
        pageBuilder: (context, state) => state.fadeTransition(
          transitionDuration: 200.ms,
          child: const WelcomeAndTncPage(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: AppRouter.rootNavigatorKey,
        path: CompleteProfilePage.path,
        name: CompleteProfilePage.path,
        builder: (context, state) {
          final authBloc = state.extra as AuthenticationBloc;
          return MultiBlocProvider(
            providers: [
              BlocProvider.value(value: authBloc),
              BlocProvider(create: (context) => getIt<CompleteProfileBloc>()),
              BlocProvider(create: (context) => getIt<MasterDataCubit>()),
            ],
            child: const CompleteProfilePage(),
          );
        },
      ),
    ],
  ),
];
