import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../theme/colors.dart';

class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.size,
    this.iconSize,
  });

  /// default is 30
  final double? size;

  /// default is size / 2 (30/2 = 15)
  final double? iconSize;

  final VoidCallback onPressed;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final size = this.size ?? 30;
    return AnimatedContainer(
      duration: 500.ms,
      curve: Curves.fastLinearToSlowEaseIn,
      width: size,
      height: size,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: darkColor.withOpacity(0.6),
        borderRadius: BorderRadius.circular(
          50,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x80000000),
            blurRadius: 8.0,
            offset: Offset(0.0, 4.0),
          )
        ],
      ),
      child: IconButton(
        color: whiteColor,
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: whiteColor,
          size: iconSize ?? (size / 2),
        ),
      ),
    );
  }
}
