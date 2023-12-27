import 'package:flutter/cupertino.dart';

import '../../core/theme/colors.dart';

enum CardSwipeType {
  initial,
  love,
  skip,
  gift;

  SwipeOverlay get swipeOverlay {
    switch (this) {
      case CardSwipeType.love:
        return SwipeOverlay.loved();
      case CardSwipeType.skip:
        return SwipeOverlay.skiped();
      case CardSwipeType.gift:
        return SwipeOverlay.gift();
      default:
        return SwipeOverlay.skiped();
    }
  }
}

class SwipeOverlay {
  final IconData icon;
  final Color iconColor;
  final Color overlayColor;

  SwipeOverlay(this.icon, this.iconColor, this.overlayColor);

  factory SwipeOverlay.loved() => SwipeOverlay(
        CupertinoIcons.heart_fill,
        secondaryColor,
        primaryColor,
      );

  factory SwipeOverlay.skiped() => SwipeOverlay(
        CupertinoIcons.clear,
        primaryColor,
        secondaryColor,
      );

  factory SwipeOverlay.gift() => SwipeOverlay(
        CupertinoIcons.gift,
        blackColor.withOpacity(0.2),
        softyellowColor,
      );
}
