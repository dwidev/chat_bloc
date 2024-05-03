import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:matchloves/core/extensions/string_extension.dart';

import '../../../../../core/extensions/flushbar_extension.dart';
import '../../../../../core/theme/colors.dart';
import '../../../../../core/widget/gradient_button.dart';
import '../../../domain/entities/sign_type.dart';
import '../../bloc/authentication_bloc.dart';
import 'auth_page_listener.dart';
import 'verify_otp_page.dart';

class LoginWithPhoneNumberPage extends StatefulWidget {
  const LoginWithPhoneNumberPage({super.key});

  @override
  State<LoginWithPhoneNumberPage> createState() =>
      _LoginWithPhoneNumberPageState();

  static const path = 'login-with-phone';
}

class _LoginWithPhoneNumberPageState extends State<LoginWithPhoneNumberPage> {
  late TextEditingController controller;
  SignType signType = SignType.phoneNumber;

  bool get isPhone => signType == SignType.phoneNumber;

  String get titleChange =>
      isPhone ? SignType.email.title : SignType.phoneNumber.title;

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void changeSignType(SignType signType) {
    controller.clear();
    setState(() {
      this.signType = signType;
    });
  }

  Future<void> sign() async {
    if (signType == SignType.phoneNumber) {
      signWithPhoneNumber();
    } else {
      signWithEmail();
    }
  }

  void signWithPhoneNumber() {
    final phoneNumber = controller.text;
    if (phoneNumber.isEmpty) {
      context.showWarningFlush(message: "Please fill phone number");
      return;
    }

    if (!phoneNumber.validPhone) {
      context.showWarningFlush(message: "Your phone number is not valid");
      return;
    }

    context
        .read<AuthenticationBloc>()
        .add(SignWithPhoneNumberEvent(phoneNumber: phoneNumber));
  }

  void signWithEmail() {
    final email = controller.text;
    if (email.isEmpty) {
      context.showWarningFlush(message: "Please fill phone number");
      return;
    }

    if (!email.validEmail) {
      context.showWarningFlush(message: "Your email is not valid");
      return;
    }

    context.read<AuthenticationBloc>().add(SignWithEmailEvent(email: email));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;

    return AuthPageListener(
      onSuccess: (context, state) {
        if (state is AuthenticationSignSuccess) {
          context.pushNamed(VerifyOtpPage.path);
        }
      },
      builder: (context, prov) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            shadowColor: Colors.transparent,
            backgroundColor: const Color.fromARGB(0, 0, 0, 0),
            elevation: 0,
          ),
          body: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: size.width,
            height: size.height,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  softPinkColor,
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
                          "Please input your ${signType.title}!",
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
                            keyboardType: isPhone
                                ? TextInputType.number
                                : TextInputType.emailAddress,
                            controller: controller,
                            decoration: InputDecoration(
                              hintText: isPhone
                                  ? "Phone number ex:08956xxxxxx"
                                  : "email ex:johndoe@gmail.com",
                            ),
                          ),
                        ),
                      ).animate().fade(
                            delay: const Duration(milliseconds: 200),
                            duration: const Duration(seconds: 1),
                          ),
                      const SizedBox(height: 20),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            if (signType == SignType.email) {
                              changeSignType(SignType.phoneNumber);
                            } else {
                              changeSignType(SignType.email);
                            }
                          },
                          child: Text(
                            "Login with $titleChange",
                          ),
                        ),
                      ).animate().fade(
                            delay: const Duration(milliseconds: 200),
                            duration: const Duration(seconds: 1),
                          )
                    ],
                  ),
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 500),
                    right: 50,
                    bottom: 20,
                    child: GradientButton(
                      width: null,
                      gradient: LinearGradient(
                        colors: [primaryColor, darkColor],
                      ),
                      onPressed: sign,
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
      },
    );
  }
}
