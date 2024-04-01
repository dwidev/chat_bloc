import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constant/contants.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/widget/gradient_button.dart';
import '../../../nearbypeople/pages/swipe_cards_page.dart';

class AllowPermissionLocationPage extends StatefulWidget {
  const AllowPermissionLocationPage({super.key});

  @override
  State<AllowPermissionLocationPage> createState() =>
      _AllowPermissionLocationPageState();

  static const path = '/allow-location';
}

class _AllowPermissionLocationPageState
    extends State<AllowPermissionLocationPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              softPinkColor,
              softyellowColor,
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: size.width / 1.8,
                height: size.width / 1.8,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(location),
                  ),
                ),
              ).animate().fade(
                    delay: const Duration(milliseconds: 300),
                    duration: const Duration(milliseconds: 200),
                  ),
              SizedBox(
                width: size.width / 1.2,
                child: Column(
                  children: [
                    Text(
                      "Enable your location",
                      textAlign: TextAlign.center,
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Choose your location to start find people around you.",
                      textAlign: TextAlign.center,
                      style: textTheme.bodyMedium?.copyWith(),
                    ),
                  ],
                ),
              ).animate().fade(
                    delay: const Duration(milliseconds: 300),
                    duration: const Duration(milliseconds: 200),
                  ),
              const SizedBox(height: 20),
              GradientButton(
                gradient: LinearGradient(colors: [
                  primaryColor,
                  darkColor,
                ]),
                onPressed: () {
                  context.push(SwipeCardsPage.path);
                },
                child: Text(
                  "Allow location access",
                  style: textTheme.bodyMedium?.copyWith(color: whiteColor),
                ),
              )
                  .animate()
                  .boxShadow(borderRadius: BorderRadius.circular(20))
                  .fade(
                    delay: const Duration(milliseconds: 600),
                    duration: const Duration(milliseconds: 200),
                  )
                  .shake(delay: const Duration(milliseconds: 700), hz: 10)
            ],
          ),
        ),
      ),
    );
  }
}
