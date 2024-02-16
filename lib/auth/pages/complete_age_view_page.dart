import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

import '../../core/theme/colors.dart';

class CompleteAgeViewPage extends StatefulWidget {
  const CompleteAgeViewPage({
    super.key,
  });

  @override
  State<CompleteAgeViewPage> createState() => _CompleeGendereViewPageState();
}

class _CompleeGendereViewPageState extends State<CompleteAgeViewPage> {
  int selectedAge = 25;

  @override
  Widget build(BuildContext context) {
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
        ),
        SizedBox(
          width: size.width / 1.2,
          child: Text(
            "Please provide your age in years",
            style: textTheme.bodySmall?.copyWith(),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: size.height / 2.5,
                child: NumberPicker(
                  minValue: 17,
                  maxValue: 100,
                  value: selectedAge,
                  onChanged: (value) {
                    setState(() {
                      selectedAge = value;
                    });
                  },
                  infiniteLoop: true,
                  itemCount: 5,
                  itemHeight: 80,
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
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: kToolbarHeight * 1.5)
      ],
    );
  }
}
