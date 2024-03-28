import 'package:matchloves/core/routers/routergo.dart';
import 'package:matchloves/features/masterdata/cubit/master_data_cubit.dart';

import '../depedency_injection/injection.dart';
import '../extensions/go_router_state_extension.dart';
import '../../features/auth/pages/complete_profile/complete_profile_page.dart';
import '../../features/auth/pages/login/login_page.dart';
import '../../features/auth/pages/welcome_and_tnc_page.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/bloc/complete_profile_bloc.dart';
import '../../features/auth/pages/login/login_with_phone_number.dart';
import '../../features/auth/pages/login/verify_otp_page.dart';
import '../../features/auth/pages/spalsh_page.dart';

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
      return state.fadeTransition(child: const LoginPage());
    },
    routes: [
      GoRoute(
        name: LoginWithPhoneNumberPage.path,
        path: LoginWithPhoneNumberPage.path,
        builder: (context, state) => const LoginWithPhoneNumberPage(),
      ),
      GoRoute(
        name: VerifyOtpPage.path,
        path: VerifyOtpPage.path,
        builder: (context, state) => const VerifyOtpPage(),
      ),
      GoRoute(
        name: WelcomeAndTncPage.path,
        path: WelcomeAndTncPage.path,
        pageBuilder: (context, state) => state.fadeTransition(
          transitionDuration: 200.ms,
          child: const WelcomeAndTncPage(),
        ),
      ),
      GoRoute(
        path: CompleteProfilePage.path,
        name: CompleteProfilePage.path,
        builder: (context, state) {
          return MultiBlocProvider(
            providers: [
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
