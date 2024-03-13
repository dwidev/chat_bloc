import 'login_page.dart';
import 'verify_otp_page.dart';
import '../../../homepage/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/widget/gradient_button.dart';

class LoginWithPhoneNumberPage extends StatefulWidget {
  const LoginWithPhoneNumberPage({super.key});

  @override
  State<LoginWithPhoneNumberPage> createState() =>
      _LoginWithPhoneNumberPageState();

  static const path = 'login-with-phone';
}

class _LoginWithPhoneNumberPageState extends State<LoginWithPhoneNumberPage> {
  int pageIndex = 0;
  late Color linearColor;

  @override
  void initState() {
    linearColor = softPinkColor;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              linearColor,
              whiteColor,
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    width: size.width / 1.5,
                    child: Text(
                      "Please input your phone number!",
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ).animate().fade(
                          delay: const Duration(milliseconds: 200),
                          duration: const Duration(seconds: 1),
                        ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      "Let's get to know each other",
                      style: textTheme.bodySmall?.copyWith(),
                    ).animate().fade(
                          delay: const Duration(milliseconds: 200),
                          duration: const Duration(seconds: 1),
                        ),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: "Phone number ex:08956xxxxxx",
                        ),
                      ),
                    ),
                  ).animate().fade(
                        delay: const Duration(milliseconds: 200),
                        duration: const Duration(seconds: 1),
                      ),
                  const SizedBox(height: 50),
                ],
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 500),
                right: pageIndex > 0 ? 30 : 50,
                bottom: 20,
                child: GradientButton(
                  width: pageIndex > 0 ? 100 : null,
                  gradient: LinearGradient(
                    colors: [primaryColor, darkColor],
                  ),
                  onPressed: () {
                    push(context: context, page: const VerifyOtpPage());
                  },
                  child: Text(
                    "Next",
                    style: textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                )
                    .animate()
                    .boxShadow(borderRadius: BorderRadius.circular(20))
                    .fade(
                      delay: const Duration(milliseconds: 200),
                      duration: const Duration(seconds: 1),
                    ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
