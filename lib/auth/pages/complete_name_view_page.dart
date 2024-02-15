import 'package:flutter/material.dart';

class CompleteNameViewPage extends StatefulWidget {
  const CompleteNameViewPage({
    super.key,
  });

  @override
  State<CompleteNameViewPage> createState() => _CompleteNameViewPageState();
}

class _CompleteNameViewPageState extends State<CompleteNameViewPage> {
  @override
  Widget build(BuildContext context) {
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
          ),
          Text(
            "Let's get to know each other",
            style: textTheme.bodySmall?.copyWith(),
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
                decoration: const InputDecoration(hintText: "Your name...."),
              ),
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
