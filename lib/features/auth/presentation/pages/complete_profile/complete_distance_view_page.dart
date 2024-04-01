import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../bloc/complete_profile_bloc.dart';

class CompleteDistanceViewPage extends StatelessWidget {
  const CompleteDistanceViewPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final completeBloc = context.read<CompleteProfileBloc>();

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 25 + kToolbarHeight),
          Text(
            "Set your distance preference!",
            style: context.textTheme.bodyLarge?.copyWith(
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
              style: context.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ).animate().fade(
                delay: const Duration(milliseconds: 200),
                duration: const Duration(seconds: 1),
              ),
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: BlocBuilder<CompleteProfileBloc, CompleteProfileState>(
              builder: (_, s) {
                return Slider(
                  autofocus: true,
                  min: 1,
                  max: 100,
                  value: s.distance.toDouble(),
                  onChanged: (d) {
                    completeBloc.add(
                      CompleteProfileSetDistanceEvent(distance: d.toInt()),
                    );
                  },
                );
              },
            ),
          ).animate().fade(
                delay: const Duration(milliseconds: 200),
                duration: const Duration(seconds: 1),
              ),
          SizedBox(height: context.height / 7),
          BlocBuilder<CompleteProfileBloc, CompleteProfileState>(
            builder: (_, s) {
              return Text(
                "${s.distance.toInt()} km",
                style: context.textTheme.displayLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
