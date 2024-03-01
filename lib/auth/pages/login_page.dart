import 'package:chat_bloc/auth/pages/login_with_phone_number.dart';
import 'package:chat_bloc/core/extensions/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/constant/contants.dart';
import '../../core/theme/colors.dart';
import '../../core/widget/gradient_button.dart';
import '../../homepage/pages/home_page.dart';
import 'complete_profile_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  late AnimationController animationController =
      AnimationController(vsync: this);

  late AnimationController animationLogoController =
      AnimationController(vsync: this);

  late AnimationController animationDescController =
      AnimationController(vsync: this);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SizedBox(
        width: size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: size.width / 1.8,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        const TextSpan(
                          text: "Discover ",
                        ),
                        WidgetSpan(
                          child: Text(
                            "Love ",
                            style: textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                              fontSize: 25,
                            ),
                          ).animate(
                            onComplete: (controller) {
                              controller.repeat();
                            },
                          ).shimmer(
                            color: whiteColor,
                            delay: 1000.ms,
                            duration: 1000.ms,
                          ),
                        ),
                        const TextSpan(
                          text: "where your story",
                        ),
                        TextSpan(
                          text: " begins.",
                          style: textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                    .animate()
                    .slide(
                      delay: 1500.ms,
                      curve: Curves.fastEaseInToSlowEaseOut,
                    )
                    .fade(duration: 1000.ms),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      CupertinoIcons.heart_circle_fill,
                      size: 30,
                      color: primaryColor,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      "Love Match",
                      style: context.textTheme.labelLarge?.copyWith(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    )
                  ],
                )
                    .animate(
                      onComplete: (controller) {
                        animationLogoController.forward();
                      },
                    )
                    .fade(delay: 500.ms)
                    .then()
                    .shimmer(duration: 500.ms)
                    .animate(
                      autoPlay: false,
                      controller: animationLogoController,
                    )
                    .slideY(
                      begin: 0,
                      end: -4.5,
                      curve: Curves.fastEaseInToSlowEaseOut,
                      duration: 1000.ms,
                    ),
              ],
            ),
            const SizedBox(height: 40),
            IntroWidget(
              animationController: animationController,
            ).animate().shimmer(
                  color: whiteColor,
                  delay: 1.seconds,
                  duration: 1.seconds,
                ),
            const SizedBox(height: 40),
            SizedBox(
              width: size.width / 1.3,
              child: Text(
                "Join us to discover your ideal partner and ignite the sparks of romance in your journey.",
                style: textTheme.bodySmall?.copyWith(),
                textAlign: TextAlign.center,
              ),
            )
                .animate()
                .slideY(begin: 2, delay: 500.ms)
                .fade()
                .then(delay: 200.ms)
                .animate()
                .shimmer(
                  color: whiteColor,
                  delay: 1000.ms,
                  duration: 1000.ms,
                ),
            const SizedBox(height: 40),
            GradientButton(
              onPressed: () {
                push(context: context, page: const CompleteProfilePage());
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    google,
                    width: 15,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    "Login with Google",
                    style: textTheme.bodyMedium?.copyWith(color: Colors.white),
                  ),
                ],
              ).animate().shimmer(
                    color: darkColor,
                    delay: 1000.ms,
                    duration: 1000.ms,
                  ),
            )
                .animate()
                .boxShadow(borderRadius: BorderRadius.circular(20))
                .fade(delay: 600.ms),
            const SizedBox(height: 10),
            GradientButton(
              onPressed: () {
                push(context: context, page: const CompleteProfilePage());
              },
              gradient: LinearGradient(
                colors: [
                  darkColor,
                  Colors.black,
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.apple,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    "Login with Apple",
                    style: textTheme.bodyMedium?.copyWith(color: Colors.white),
                  ),
                ],
              ).animate().shimmer(
                    color: darkColor,
                    delay: 1000.ms,
                    duration: 1000.ms,
                  ),
            )
                .animate()
                .boxShadow(borderRadius: BorderRadius.circular(20))
                .fade(delay: 600.ms),
            const SizedBox(height: 15),
            SizedBox(
              width: size.width / 2,
              child: TextButton(
                onPressed: () {
                  animationController.reverse(from: 0.3).whenComplete(() {
                    push(
                      context: context,
                      page: const LoginWithPhoneNumberPage(),
                    ).then(
                      (value) => animationController.forward(),
                    );
                  });
                },
                child: Text(
                  "Register or login with Phone number dan email",
                  style: textTheme.bodySmall?.copyWith(),
                  textAlign: TextAlign.center,
                ),
              ),
            )
                .animate()
                .fade(delay: 600.ms)
                .then(delay: 200.ms)
                .animate()
                .shimmer(
                  color: whiteColor,
                  delay: 1000.ms,
                  duration: 1000.ms,
                ),
          ],
        ),
      ),
    );
  }
}

class IntroWidget extends StatelessWidget {
  const IntroWidget({
    super.key,
    required this.animationController,
  });

  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: size.width / 1.3,
          height: size.width / 1.3,
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(
              500 / 2,
            ),
          ),
        )
            .animate(controller: animationController)
            .scale(
              delay: 200.ms,
              duration: 2.seconds,
              curve: Curves.fastLinearToSlowEaseIn,
            )
            .fade(),
        const Positioned(
          top: 100,
          left: 20,
          child: CircleAvatar(
            backgroundColor: softyellowColor,
            radius: 10,
          ),
        )
            .animate(controller: animationController)
            .slide(
              begin: const Offset(5, 0.5),
              delay: 500.ms,
              duration: 2.seconds,
              curve: Curves.fastLinearToSlowEaseIn,
            )
            .fade(),
        Positioned(
          top: 0,
          right: 50,
          child: Transform.translate(
            offset: const Offset(0, -10),
            child: const CircleAvatar(
              backgroundColor: softyellowColor,
              radius: 5,
            ),
          ),
        )
            .animate(controller: animationController)
            .slide(
              begin: const Offset(-5, 15),
              delay: 500.ms,
              duration: 2.seconds,
              curve: Curves.fastLinearToSlowEaseIn,
            )
            .fade(),
        const Positioned(
          left: 0,
          top: 20,
          child: CircleAvatar(
            backgroundImage: AssetImage(man1),
          ),
        )
            .animate(controller: animationController)
            .slide(
              begin: const Offset(3, 2.8),
              delay: 500.ms,
              duration: 2.seconds,
              curve: Curves.fastLinearToSlowEaseIn,
            )
            .fade(),
        Positioned(
          bottom: 60,
          right: 10,
          child: Transform.translate(
            offset: const Offset(0, 0),
            child: const CircleAvatar(
              backgroundColor: softyellowColor,
              radius: 5,
            ),
          ),
        )
            .animate(controller: animationController)
            .slide(
              begin: const Offset(-13, -5),
              delay: 500.ms,
              duration: 2.seconds,
              curve: Curves.fastLinearToSlowEaseIn,
            )
            .fade(),

        /// Left bottom image
        const Positioned(
          left: 0,
          bottom: 20,
          child: CircleAvatar(
            radius: 23,
            backgroundImage: AssetImage(woman2),
          ),
        )
            .animate(controller: animationController)
            .slide(
              begin: const Offset(3, -2.8),
              delay: 500.ms,
              duration: 2.seconds,
              curve: Curves.fastLinearToSlowEaseIn,
            )
            .fade(),

        /// Right top image
        const Positioned(
          top: 20,
          right: 0,
          child: CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage(woman3),
          ),
        )
            .animate(controller: animationController)
            .slide(
              begin: const Offset(-2.5, 2.3),
              delay: 500.ms,
              duration: 2.seconds,
              curve: Curves.fastLinearToSlowEaseIn,
            )
            .fade(),

        /// Right bottom image
        const Positioned(
          right: 20,
          bottom: 0,
          child: CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(man2),
          ),
        )
            .animate(controller: animationController)
            .slide(
              begin: const Offset(-1.8, -2.8),
              delay: 500.ms,
              duration: 2.seconds,
              curve: Curves.fastLinearToSlowEaseIn,
            )
            .fade(),

        /// Center image
        const Positioned(
          top: 0,
          bottom: 0,
          left: 50,
          right: 50,
          child: CircleAvatar(
            backgroundImage: AssetImage(woman),
          ),
        ).animate(controller: animationController).fade().scale(
              delay: 250.ms,
              duration: 1.seconds,
              curve: Curves.fastLinearToSlowEaseIn,
            )
      ],
    );
  }
}
