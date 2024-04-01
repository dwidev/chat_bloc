import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/widget/gradient_button.dart';
import 'complete_profile/complete_profile_page.dart';

class WelcomeAndTncPage extends StatefulWidget {
  const WelcomeAndTncPage({super.key});

  @override
  State<WelcomeAndTncPage> createState() => _WelcomeAndTncPageState();

  static const path = 'welcome-tnc';
}

class _WelcomeAndTncPageState extends State<WelcomeAndTncPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.clear),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  WidgetSpan(
                    child: Text(
                      "Welcome to ",
                      style: context.textTheme.labelLarge?.copyWith(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  WidgetSpan(
                    child: Row(
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
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ).animate(delay: 500.ms).fade(duration: 1.seconds).slide(
                  begin: const Offset(0, 2),
                  delay: 200.ms,
                  duration: 500.ms,
                  curve: Curves.fastEaseInToSlowEaseOut,
                ),
            Text(
              "Pleasse follow our rules",
              style: context.textTheme.labelSmall,
            ).animate(delay: 600.ms).fade(duration: 1.seconds).slide(
                  begin: const Offset(0, 2),
                  delay: 200.ms,
                  duration: 500.ms,
                  curve: Curves.fastEaseInToSlowEaseOut,
                ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      "Be yourself.",
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ).animate(delay: 700.ms).fade(duration: 1.seconds).slide(
                          begin: const Offset(0, 2),
                          delay: 200.ms,
                          duration: 500.ms,
                          curve: Curves.fastEaseInToSlowEaseOut,
                        ),
                    Text(
                      "Make sure your photos, age, and bio are true to who you are.",
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: darkColor,
                      ),
                    ).animate(delay: 800.ms).fade(duration: 1.seconds).slide(
                          begin: const Offset(0, 2),
                          delay: 200.ms,
                          duration: 500.ms,
                          curve: Curves.fastEaseInToSlowEaseOut,
                        ),
                    const SizedBox(height: 20),
                    Text(
                      "Stay safe.",
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ).animate(delay: 900.ms).fade(duration: 1.seconds).slide(
                          begin: const Offset(0, 2),
                          delay: 200.ms,
                          duration: 500.ms,
                          curve: Curves.fastEaseInToSlowEaseOut,
                        ),
                    Text(
                      "Don't too be quick to give out personal information.",
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: darkColor,
                      ),
                    ).animate(delay: 1000.ms).fade(duration: 1.seconds).slide(
                          begin: const Offset(0, 2),
                          delay: 200.ms,
                          duration: 500.ms,
                          curve: Curves.fastEaseInToSlowEaseOut,
                        ),
                    const SizedBox(height: 20),
                    Text(
                      "Play it cool.",
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ).animate(delay: 1100.ms).fade(duration: 1.seconds).slide(
                          begin: const Offset(0, 2),
                          delay: 200.ms,
                          duration: 500.ms,
                          curve: Curves.fastEaseInToSlowEaseOut,
                        ),
                    Text(
                      "Respect others and treat them as you would like to be treated.",
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: darkColor,
                      ),
                    ).animate(delay: 1200.ms).fade(duration: 1.seconds).slide(
                          begin: const Offset(0, 2),
                          delay: 200.ms,
                          duration: 500.ms,
                          curve: Curves.fastEaseInToSlowEaseOut,
                        ),
                    const SizedBox(height: 20),
                    Text(
                      "Be Proactive.",
                      style: context.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ).animate(delay: 1300.ms).fade(duration: 1.seconds).slide(
                          begin: const Offset(0, 2),
                          delay: 200.ms,
                          duration: 500.ms,
                          curve: Curves.fastEaseInToSlowEaseOut,
                        ),
                    Text(
                      "Always report bad behaviour.",
                      style: context.textTheme.bodyMedium?.copyWith(
                        color: darkColor,
                      ),
                    ).animate(delay: 1400.ms).fade(duration: 1.seconds).slide(
                          begin: const Offset(0, 2),
                          delay: 200.ms,
                          duration: 500.ms,
                          curve: Curves.fastEaseInToSlowEaseOut,
                        ),
                  ],
                ),
              ),
            ),
            GradientButton(
              width: context.width,
              onPressed: () {
                context.pushNamed(CompleteProfilePage.path);
              },
              child: Text(
                "I Agree",
                style: context.textTheme.bodyMedium?.copyWith(
                  color: whiteColor,
                ),
              ),
            )
                .animate()
                .boxShadow(borderRadius: BorderRadius.circular(20))
                .then()
                .animate(delay: 1600.ms)
                .fade(duration: 1.seconds)
                .slide(
                  begin: const Offset(0, 2),
                  delay: 200.ms,
                  duration: 500.ms,
                  curve: Curves.fastEaseInToSlowEaseOut,
                ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
