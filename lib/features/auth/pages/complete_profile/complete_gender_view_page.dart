import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/enums/gender_enum.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/theme/colors.dart';
import '../../bloc/complete_profile_bloc.dart';
import 'complete_profile_page.dart';

class CompleteGenderViewPage extends StatelessWidget {
  const CompleteGenderViewPage({
    super.key,
    required this.delegate,
    required this.controller,
  });

  final CompleteProfilePageDelegate delegate;
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    final completeBloc = context.read<CompleteProfileBloc>();

    final textTheme = context.textTheme;

    return BlocListener<CompleteProfileBloc, CompleteProfileState>(
      listenWhen: (previous, current) => previous.gender != current.gender,
      listener: (context, state) {
        controller.reverse().whenComplete(() {
          delegate.onNext();
        });
      },
      child: Column(
        children: [
          const SizedBox(height: 25 + kToolbarHeight),
          Text(
            "Haiii Fahmi 👋🏻",
            style: textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ).animate().fade(delay: 200.ms, duration: 1.seconds),
          Text(
            "What's Your Gender?",
            style: textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ).animate().fade(
                delay: const Duration(milliseconds: 200),
                duration: const Duration(seconds: 1),
              ),
          SizedBox(
            width: context.width / 1.2,
            child: Text(
              "Tell us about your gender so we can provide you with the best match.",
              style: textTheme.bodySmall?.copyWith(),
              textAlign: TextAlign.center,
            ),
          ).animate().fade(
                delay: const Duration(milliseconds: 200),
                duration: const Duration(seconds: 1),
              ),
          const SizedBox(height: 50),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: kToolbarHeight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: Gender.values
                    .map(
                      (gender) => Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: Material(
                          borderRadius: BorderRadius.circular(context.width),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(context.width),
                            onTap: () {
                              final e = CompleteProfileSetGenderEvent(
                                gender: gender,
                              );
                              completeBloc.add(e);
                            },
                            child: GenderButtonWidget(gender: gender),
                          ),
                        ),
                      )
                          .animate(controller: controller)
                          .fade(
                            delay: const Duration(milliseconds: 200),
                            duration: const Duration(milliseconds: 500),
                          )
                          .slide(
                            begin: gender == Gender.male
                                ? const Offset(-10, 0)
                                : const Offset(10, 0),
                            delay: const Duration(milliseconds: 200),
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.fastLinearToSlowEaseIn,
                          ),
                    )
                    .toList(),
              ),
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}

class GenderButtonWidget extends StatelessWidget {
  const GenderButtonWidget({super.key, required this.gender});

  final Gender gender;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;

    return BlocBuilder<CompleteProfileBloc, CompleteProfileState>(
      builder: (context, state) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.fastEaseInToSlowEaseOut,
          width: context.width / 2.5,
          height: context.width / 2.5,
          decoration: BoxDecoration(
            color: gender == state.gender ? primaryColor : darkLightColor,
            borderRadius: BorderRadius.circular(context.width),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                gender.icon,
                size: 80,
                color: gender == state.gender ? whiteColor : blackColor,
              ),
              Text(
                gender.title,
                style: textTheme.bodyLarge?.copyWith(
                  color: gender == state.gender ? whiteColor : blackColor,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
