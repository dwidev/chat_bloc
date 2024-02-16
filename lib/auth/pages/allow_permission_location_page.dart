import 'package:chat_bloc/homepage/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/constant/png_assets.dart';
import '../../core/theme/colors.dart';
import '../../core/widget/gradient_button.dart';

class AllowPermissionLocationPage extends StatefulWidget {
  const AllowPermissionLocationPage({super.key});

  @override
  State<AllowPermissionLocationPage> createState() =>
      _AllowPermissionLocationPageState();
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              darkColor,
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
                      style: textTheme.bodyMedium?.copyWith(color: whiteColor),
                    ),
                  ],
                ),
              ).animate().fade(
                    delay: const Duration(milliseconds: 300),
                    duration: const Duration(milliseconds: 200),
                  ),
              const SizedBox(height: 20),
              GradientButton(
                onPressed: () {
                  push(context: context, page: const HomePage());
                },
                child: Text(
                  "Allow location access",
                  style: textTheme.bodyMedium?.copyWith(color: whiteColor),
                ),
              )
                  .animate()
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
