import 'package:chat_bloc/core/extensions/go_router_state_extension.dart';
import 'package:chat_bloc/features/auth/pages/login/login_page.dart';
import 'package:chat_bloc/features/auth/pages/welcome_and_tnc_page.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/pages/login/login_with_phone_number.dart';
import '../../features/auth/pages/login/verify_otp_page.dart';
import '../../features/auth/pages/spalsh_page.dart';

final authRoute = <RouteBase>[
  GoRoute(
    path: SplashPage.path,
    builder: (context, state) => const SplashPage(),
  ),
  GoRoute(
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
    ],
  ),
];
