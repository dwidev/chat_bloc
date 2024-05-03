import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:matchloves/core/extensions/flushbar_extension.dart';
import 'package:matchloves/features/auth/presentation/bloc/authentication_bloc.dart';
import 'package:matchloves/features/auth/presentation/pages/login/auth_page_listener.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../core/widget/gradient_button.dart';
import '../../widgets/otp_fields.dart';
import '../welcome_and_tnc_page.dart';

class VerifyOtpPage extends StatefulWidget {
  const VerifyOtpPage({super.key});

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();

  static const path = 'verify-otp';
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  String otpCode = '';

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;

    return AuthPageListener<AuthenticationOTPBloc>(
      builder: (context, prov) {
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
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [softPinkColor, whiteColor],
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
                          onCodeChanged: (value) {
                            setState(() {
                              otpCode += value;
                            });
                          },
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
                    right: 50,
                    bottom: 20,
                    child: GradientButton(
                      gradient: LinearGradient(
                        colors: [primaryColor, darkColor],
                      ),
                      onPressed: () {
                        if (otpCode.isEmpty || otpCode.length < 4) {
                          context.showWarningFlush(
                            message: "Please fill otp code",
                          );
                          return;
                        }

                        prov.add(VerifyOTPEvent(otp: otpCode));
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
      },
    );
  }
}
