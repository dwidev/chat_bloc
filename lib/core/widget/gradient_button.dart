// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../theme/colors.dart';

class GradientButton extends StatelessWidget {
  const GradientButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.width,
    this.gradient,
  }) : super(key: key);

  final double? width;
  final Widget child;
  final VoidCallback onPressed;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: width ?? size.width / 1.3,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        gradient: gradient ??
            LinearGradient(
              colors: [primaryColor, darkColor],
            ),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        child: child,
      ),
    );
  }
}
