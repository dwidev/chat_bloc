import 'package:chat_bloc/features/auth/bloc/complete_profile_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/colors.dart';

class CompleteLookingForViewPage extends StatelessWidget {
  const CompleteLookingForViewPage({
    super.key,
  });

  List<Map<String, dynamic>> get lookings => [
        {"code": "LT_PARTNER", "label": "A long-term partner 🥰💘"},
        {"code": "LOOKING_FRIENDS", "label": "Looking for friends 👋🏻🤙🏻"},
        {
          "code": "LOOKING_SIBLING",
          "label": "Looking for a brother or sister 🙋🏻‍♂️🙋🏻‍♀️"
        },
        {"code": "FIGURING_IT_OUT", "label": "Still figuring it out 🤔"}
      ];

  @override
  Widget build(BuildContext context) {
    final completeBloc = context.read<CompleteProfileBloc>();

    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        const SizedBox(height: 25 + kToolbarHeight),
        Text(
          "I'm Looking for...",
          style: textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ).animate().fade(
              delay: const Duration(milliseconds: 200),
              duration: const Duration(seconds: 1),
            ),
        SizedBox(
          width: size.width / 1.2,
          child: Text(
            "Provide us with further insights into your preferences",
            style: textTheme.bodySmall?.copyWith(),
            textAlign: TextAlign.center,
          ),
        ).animate().fade(
              delay: const Duration(milliseconds: 200),
              duration: const Duration(seconds: 1),
            ),
        const SizedBox(height: 50),
        Expanded(
          child: BlocBuilder<CompleteProfileBloc, CompleteProfileState>(
            builder: (_, state) {
              return ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: lookings.length,
                itemBuilder: (context, index) {
                  final item = lookings[index];
                  final label = item["label"];
                  final code = item["code"];
                  return InkWell(
                    onTap: () {
                      completeBloc.add(
                        CompleteProfileSetLookingEvent(code: code),
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 30,
                      ),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(50),
                        border: code == state.lookingForCode
                            ? Border.all(color: primaryColor, width: 2)
                            : null,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            label,
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: code == state.lookingForCode
                                  ? FontWeight.bold
                                  : null,
                            ),
                          ),
                          if (code == state.lookingForCode)
                            const Icon(
                              CupertinoIcons.check_mark_circled_solid,
                              color: primaryColor,
                              size: 20,
                            )
                        ],
                      ),
                    )
                        .animate()
                        .fade(
                          delay: const Duration(milliseconds: 200),
                          duration: const Duration(milliseconds: 500),
                        )
                        .slide(
                          begin: Offset(0, index.toDouble() + 1 * 0.2),
                          delay: const Duration(milliseconds: 200),
                          duration: const Duration(milliseconds: 700),
                          curve: Curves.fastLinearToSlowEaseIn,
                        ),
                  );
                },
              );
            },
          ),
        ),
        const SizedBox(height: 50),
      ],
    );
  }
}
