import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/colors.dart';

class CompleteGenderViewPage extends StatefulWidget {
  const CompleteGenderViewPage({
    super.key,
  });

  @override
  State<CompleteGenderViewPage> createState() => _CompleeGendereViewPageState();
}

class _CompleeGendereViewPageState extends State<CompleteGenderViewPage> {
  int? selectedGender;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        const SizedBox(height: 25 + kToolbarHeight),
        Text(
          "What's Your Gender?",
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
              children: [0, 1]
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Material(
                        borderRadius: BorderRadius.circular(size.width),
                        child: InkWell(
                            borderRadius: BorderRadius.circular(size.width),
                            onTap: () {
                              setState(() {
                                selectedGender = e;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.fastEaseInToSlowEaseOut,
                              width: size.width / 2.5,
                              height: size.width / 2.5,
                              decoration: BoxDecoration(
                                color: e == selectedGender
                                    ? primaryColor
                                    : darkLightColor,
                                borderRadius: BorderRadius.circular(size.width),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    e == 1 ? Icons.male : Icons.female,
                                    size: 80,
                                    color: e == selectedGender
                                        ? whiteColor
                                        : blackColor,
                                  ),
                                  Text(
                                    e == 0 ? "Male" : "Female",
                                    style: textTheme.bodyLarge?.copyWith(
                                      color: e == selectedGender
                                          ? whiteColor
                                          : blackColor,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ),
                    )
                        .animate()
                        .fade(
                          delay: const Duration(milliseconds: 200),
                          duration: const Duration(milliseconds: 500),
                        )
                        .slide(
                          begin: e == 0
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
    );
  }
}
