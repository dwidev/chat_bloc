import 'package:flutter/material.dart';

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
        ),
        SizedBox(
          width: size.width / 1.2,
          child: Text(
            "Tell us about your gender so we can provide you with the best match.",
            style: textTheme.bodySmall?.copyWith(),
            textAlign: TextAlign.center,
          ),
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
                    (e) => InkWell(
                      onTap: () {
                        setState(() {
                          selectedGender = e;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 30),
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
                              color:
                                  e == selectedGender ? whiteColor : blackColor,
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
                      ),
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
