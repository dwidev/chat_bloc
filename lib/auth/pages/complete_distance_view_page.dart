import 'package:chat_bloc/core/extensions/extensions.dart';
import 'package:chat_bloc/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CompleteDistanceViewPage extends StatefulWidget {
  const CompleteDistanceViewPage({
    super.key,
  });

  @override
  State<CompleteDistanceViewPage> createState() =>
      _CompleteDistanceViewPageState();
}

class _CompleteDistanceViewPageState extends State<CompleteDistanceViewPage> {
  double value = 10;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 25 + kToolbarHeight),
          Text(
            "Set your distance preference!",
            style: textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ).animate().fade(
                delay: const Duration(milliseconds: 200),
                duration: const Duration(seconds: 1),
              ),
          SizedBox(
            width: context.width / 1.5,
            child: Text(
              "Use the slider to set the maximum distance you want yhour potential matches to be located.",
              style: textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ).animate().fade(
                delay: const Duration(milliseconds: 200),
                duration: const Duration(seconds: 1),
              ),
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Slider(
              autofocus: true,
              // overlayColor: const MaterialStatePropertyAll(darkLightColor),
              min: 1,
              max: 100,
              value: value,
              onChanged: (value) {
                setState(() {
                  this.value = value;
                });
              },
            ),
          ).animate().fade(
                delay: const Duration(milliseconds: 200),
                duration: const Duration(seconds: 1),
              ),
          SizedBox(height: context.height / 7),
          Text(
            "${value.toInt()} km",
            style: context.textTheme.displayLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          )
        ],
      ),
    );
  }
}
