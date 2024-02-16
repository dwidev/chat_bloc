import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/colors.dart';

class CompleteLookingForViewPage extends StatefulWidget {
  const CompleteLookingForViewPage({
    super.key,
  });

  @override
  State<CompleteLookingForViewPage> createState() =>
      _CompleeGendereViewPageState();
}

class _CompleeGendereViewPageState extends State<CompleteLookingForViewPage> {
  List<String> lookings = [
    "A Long term partner 🥰💘",
    "Looking for friends 👋🏻🤙🏻",
    "Looking for a brother or sister 🙋🏻‍♂️🙋🏻‍♀️",
    "Still figuring it out 🤔",
  ];
  String selectedLookings = '';

  @override
  Widget build(BuildContext context) {
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
          child: ListView.builder(
            itemCount: lookings.length,
            itemBuilder: (context, index) {
              final item = lookings[index];
              return InkWell(
                onTap: () {
                  setState(() {
                    selectedLookings = item;
                  });
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
                    border: item == selectedLookings
                        ? Border.all(color: primaryColor, width: 2)
                        : null,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        lookings[index],
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight:
                              item == selectedLookings ? FontWeight.bold : null,
                        ),
                      ),
                      if (item == selectedLookings)
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
          ),
        ),
        const SizedBox(height: 50),
      ],
    );
  }
}
