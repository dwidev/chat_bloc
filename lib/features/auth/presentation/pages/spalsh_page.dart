import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:matchloves/core/depedency_injection/injection.dart';
import 'package:matchloves/features/auth/presentation/bloc/authentication_bloc.dart';
import 'package:matchloves/features/auth/presentation/pages/complete_profile/complete_profile_page.dart';
import 'package:matchloves/features/nearbypeople/pages/swipe_cards_page.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/theme/colors.dart';
import 'login/login_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();

  static const path = '/';
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if (state is AuthorizeState) {
          animationController.forward();

          if (state is AuthorizeSignComplete) {
            context.go(SwipeCardsPage.path);
          }

          if (state is AuthorizeSignNotComplete) {
            final authBloc = getIt<AuthenticationBloc>();
            context.goNamed(CompleteProfilePage.path, extra: authBloc);
          }

          if (state is AuthorizeSignNotValidOrLogout) {
            context.go(LoginPage.path);
          }
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, secondaryColor],
            ),
          ),
          width: context.width,
          height: context.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    CupertinoIcons.heart_circle_fill,
                    size: 30,
                    color: whiteColor,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    "Match loves",
                    style: context.textTheme.labelLarge?.copyWith(
                      color: whiteColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ],
              )
                  .animate()
                  .shimmer(
                    delay: 200.ms,
                    duration: 1.seconds,
                    color: primaryColor,
                  )
                  .animate(controller: animationController, autoPlay: false)
                  .slideY(
                    begin: 0,
                    end: -(context.height / 103.8),
                    duration: 500.ms,
                    curve: Curves.fastEaseInToSlowEaseOut,
                  ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomPageRoute<T> extends PageRoute<T> {
  CustomPageRoute(this.child, {this.duration});
  @override
  Color get barrierColor => Colors.black;

  @override
  String? get barrierLabel => null;

  final Widget child;
  final Duration? duration;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  @override
  bool get maintainState => true;

  @override
  Duration get transitionDuration => duration ?? 1.seconds;
}
