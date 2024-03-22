import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:numberpicker/numberpicker.dart';

import '../../../../core/theme/colors.dart';
import '../../bloc/complete_profile_bloc.dart';

class CompleteAgeViewPage extends StatelessWidget {
  const CompleteAgeViewPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final completeBloc = context.read<CompleteProfileBloc>();

    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        const SizedBox(height: 25 + kToolbarHeight),
        Text(
          "How Old Are You?",
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
            "Please provide your age in years",
            style: textTheme.bodySmall?.copyWith(),
            textAlign: TextAlign.center,
          ),
        ).animate().fade(
              delay: const Duration(milliseconds: 200),
              duration: const Duration(seconds: 1),
            ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: size.height / 2.5,
                child: BlocBuilder<CompleteProfileBloc, CompleteProfileState>(
                  builder: (_, s) {
                    return NumberPicker(
                      minValue: 17,
                      maxValue: 100,
                      value: s.age,
                      onChanged: (age) {
                        completeBloc.add(CompleteProfileSetAgeEvent(age: age));
                      },
                      infiniteLoop: true,
                      itemCount: 5,
                      itemHeight: 70,
                      selectedTextStyle: textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 50,
                        color: primaryColor,
                      ),
                      textStyle: textTheme.labelLarge?.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      // selectedTextStyle: textTheme.titleLarge,
                    );
                  },
                ),
              ).animate().fade(
                    delay: const Duration(milliseconds: 200),
                    duration: const Duration(seconds: 1),
                  )
            ],
          ),
        ),
        const SizedBox(height: kToolbarHeight * 1.5)
      ],
    );
  }
}
