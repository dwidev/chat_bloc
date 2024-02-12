import 'package:chat_bloc/auth/pages/complete_profile_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/constant/png_assets.dart';
import '../../core/theme/colors.dart';
import '../../core/widget/gradient_button.dart';
import '../../homepage/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                    TextSpan(
                      text: "Love ",
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                        fontSize: 25,
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
            ),
            const SizedBox(height: 40),
            const IntroWidget(),
            const SizedBox(height: 40),
            SizedBox(
              width: size.width / 1.3,
              child: Text(
                "Join us to discover your ideal partner and ignite the sparks of romance in your journey.",
                style: textTheme.bodySmall?.copyWith(),
                textAlign: TextAlign.center,
              ),
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
              ),
            ),
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
              ),
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
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
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
        ),
        const Positioned(
          top: 100,
          left: 20,
          child: CircleAvatar(
            backgroundColor: softyellowColor,
            radius: 10,
          ),
        ),
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
        ),
        Positioned(
          top: 20,
          child: CircleAvatar(
            backgroundImage: NetworkImage(
              dummyUsers[2],
            ),
          ),
        ),
        Positioned(
          bottom: 60,
          right: 50,
          child: Transform.translate(
            offset: const Offset(50, 0),
            child: const CircleAvatar(
              backgroundColor: softyellowColor,
              radius: 5,
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            backgroundImage: NetworkImage(
              dummyUsers[8],
            ),
          ),
        ).animate().fade(duration: const Duration(seconds: 1)),
        Positioned(
          top: 20,
          right: 0,
          child: CircleAvatar(
            radius: 25,
            backgroundImage: NetworkImage(
              dummyUsers[4],
            ),
          ),
        ),
        Positioned(
          right: 20,
          bottom: 0,
          child: CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(
              dummyUsers[6],
            ),
          ),
        ),
        Positioned(
          top: 0,
          bottom: 0,
          left: 50,
          right: 50,
          child: CircleAvatar(
            backgroundImage: NetworkImage(
              dummyUsers[3],
            ),
          ),
        ),
      ],
    );
  }
}
