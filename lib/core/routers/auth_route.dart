import 'routergo.dart';
import '../../features/auth/presentation/bloc/authentication_bloc.dart';
import '../../features/masterdata/cubit/master_data_cubit.dart';

import '../depedency_injection/injection.dart';
import '../extensions/go_router_state_extension.dart';
import '../../features/auth/presentation/pages/complete_profile/complete_profile_page.dart';
import '../../features/auth/presentation/pages/login/login_page.dart';
import '../../features/auth/presentation/pages/welcome_and_tnc_page.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/bloc/complete_profile_bloc.dart';
import '../../features/auth/presentation/pages/login/login_with_phone_number_page.dart';
import '../../features/auth/presentation/pages/login/verify_otp_page.dart';
import '../../features/auth/presentation/pages/spalsh_page.dart';

final authRoute = <RouteBase>[
  GoRoute(
    parentNavigatorKey: AppRouter.rootNavigatorKey,
    path: SplashPage.path,
    builder: (context, state) => BlocProvider(
      create: (context) =>
          getIt<AuthenticationBloc>()..add(const AuthorizedCheckingEvent()),
      child: const SplashPage(),
    ),
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
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<AuthenticationBloc>(),
          child: const LoginWithPhoneNumberPage(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: AppRouter.rootNavigatorKey,
        name: VerifyOtpPage.path,
        path: VerifyOtpPage.path,
        builder: (context, state) => BlocProvider(
          create: (context) => getIt<AuthenticationBloc>(),
          child: const VerifyOtpPage(),
        ),
      ),
      GoRoute(
        parentNavigatorKey: AppRouter.rootNavigatorKey,
        name: WelcomeAndTncPage.path,
        path: WelcomeAndTncPage.path,
        pageBuilder: (context, state) => state.fadeTransition(
          transitionDuration: 200.ms,
          child: BlocProvider(
            create: (context) => getIt<AuthenticationBloc>(),
            child: const VerifyOtpPage(),
          ),
        ),
      ),
      GoRoute(
        parentNavigatorKey: AppRouter.rootNavigatorKey,
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
