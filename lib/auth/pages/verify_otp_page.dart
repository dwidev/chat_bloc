// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chat_bloc/auth/pages/welcome_and_tnc_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:chat_bloc/auth/pages/complete_profile_page.dart';
import 'package:chat_bloc/auth/pages/spalsh_page.dart';
import 'package:chat_bloc/core/extensions/context_extendsion.dart';

import '../../core/theme/colors.dart';
import '../../core/widget/gradient_button.dart';
import '../widgets/otp_fields.dart';

class VerifyOtpPage extends StatefulWidget {
  const VerifyOtpPage({super.key});

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
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
                      "Verify your otp code!",
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
                      "Otp code send to your phone number +62896572636776",
                      style: textTheme.bodySmall?.copyWith(),
                    ).animate().fade(
                          delay: const Duration(milliseconds: 200),
                          duration: const Duration(seconds: 1),
                        ),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: OtpTextField(
                      autoFocus: true,
                      borderColor: whiteColor,
                      borderRadius: BorderRadius.circular(90),
                      enabledBorderColor: whiteColor,
                      focusedBorderColor: primaryColor,
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
                    Navigator.push(
                      context,
                      CustomPageRoute(
                        const WelcomeAndTncPage(),
                        duration: 500.ms,
                      ),
                      // (_) => false,
                    );
                  },
                  child: Text(
                    "Send",
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
