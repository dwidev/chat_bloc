import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/extensions/extensions.dart';
import '../../bloc/complete_profile_bloc.dart';

class CompleteNameViewPage extends StatefulWidget {
  const CompleteNameViewPage({
    super.key,
  });

  @override
  State<CompleteNameViewPage> createState() => _CompleteNameViewPageState();
}

class _CompleteNameViewPageState extends State<CompleteNameViewPage> {
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final completeBloc = context.read<CompleteProfileBloc>();

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 25 + kToolbarHeight),
          Text(
            "Whats your name?",
            style: context.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ).animate().fade(
                delay: const Duration(milliseconds: 200),
                duration: const Duration(seconds: 1),
              ),
          Text(
            "Let's get to know each other",
            style: context.textTheme.bodySmall?.copyWith(),
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
              child: BlocBuilder<CompleteProfileBloc, CompleteProfileState>(
                builder: (context, state) {
                  controller.text = state.name;

                  return TextFormField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: "Your name....",
                    ),
                    onChanged: (value) {
                      completeBloc.add(
                        CompleteProfileSetNameEvent(name: value),
                      );
                    },
                  );
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
