import 'package:matchloves/features/auth/presentation/bloc/complete_profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CompleteNameViewPage extends StatelessWidget {
  const CompleteNameViewPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final completeBloc = context.read<CompleteProfileBloc>();
    final name = context.select<CompleteProfileBloc, String>(
      (value) => value.state.name,
    );
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 25 + kToolbarHeight),
          Text(
            "Whats your name?",
            style: textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ).animate().fade(
                delay: const Duration(milliseconds: 200),
                duration: const Duration(seconds: 1),
              ),
          Text(
            "Let's get to know each other",
            style: textTheme.bodySmall?.copyWith(),
          ).animate().fade(
                delay: const Duration(milliseconds: 200),
                duration: const Duration(seconds: 1),
              ),
          const SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                initialValue: name,
                decoration: const InputDecoration(hintText: "Your name...."),
                onChanged: (value) {
                  completeBloc.add(CompleteProfileSetNameEvent(name: value));
                },
              ),
            ),
          ).animate().fade(
                delay: const Duration(milliseconds: 200),
                duration: const Duration(seconds: 1),
              ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
