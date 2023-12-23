import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/theme/colors.dart';

part 'control_card_state.dart';

enum CardSwipeType {
  initial,
  love,
  skip,
  superlove;

  SwipeOverlay get swipeOverlay {
    switch (this) {
      case CardSwipeType.love:
        return SwipeOverlay.loved();
      case CardSwipeType.skip:
        print("KESINI GA");
        return SwipeOverlay.skiped();
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
}

class ControlCardCubit extends Cubit<ControlCardState> {
  ControlCardCubit() : super(const ControlCardInitial());

  late AnimationController swipeAnimationController;
  late Tween<Offset> tweenPosition;
  late Animation<Offset> positionAnimation;
  late Tween<double> tweenAngle;
  late Animation<double> angleAnimation;
  late Tween<double> tweenOverlay;
  late Animation<double> overlayAnimation;

  void initializeSwipeAnimation({
    required TickerProvider sync,
  }) {
    swipeAnimationController = AnimationController(
      vsync: sync,
      duration: const Duration(milliseconds: 500),
    );
    final curve = CurvedAnimation(
      parent: swipeAnimationController,
      curve: Curves.easeIn,
    );
    tweenPosition = Tween<Offset>();
    positionAnimation = tweenPosition.animate(curve);

    tweenAngle = Tween<double>();
    angleAnimation = tweenAngle.animate(curve);

    tweenOverlay = Tween<double>();
    overlayAnimation = tweenOverlay.animate(curve);

    swipeAnimationController.addListener(onListenSwipeController);
  }

  void onListenSwipeController() {
    emit(state.copyWith(
      position: positionAnimation.value,
      angle: angleAnimation.value,
      overlay: overlayAnimation.value,
    ));
  }

  void onDragCard(DragUpdateDetails details, Size screnSize) {
    final angle = 30 * state.position.dx / screnSize.width;
    final newPostion = state.position + details.delta;

    var newOverlay = 0.0;

    if (state.swipeOverlayType == CardSwipeType.love) {
      var overlay = (newPostion.dx - 50) / 100;
      newOverlay = overlay < 0.7 ? overlay : state.overlay;
    } else if (state.swipeOverlayType == CardSwipeType.skip) {
      var overlay = (-newPostion.dx - 50) / 100;
      newOverlay = overlay < 0.7 ? overlay : state.overlay;
    }

    emit(state.copyWith(
      position: newPostion,
      angle: angle,
      overlay: newOverlay,
    ));
  }

  void onEndDrag(DragEndDetails details, Size screnSize) {
    switch (state.swipeFinishType) {
      case CardSwipeType.love:
        love(screnSize);
        break;
      case CardSwipeType.skip:
        skip(screnSize);
        break;
      default:
        initial();
    }
  }

  void initial() {
    tweenPosition.begin = state.position;
    tweenPosition.end = Offset.zero;
    tweenAngle.begin = state.angle;
    tweenAngle.end = 0;
    tweenOverlay.begin = state.overlay;
    tweenOverlay.end = 0.0;

    swipeAnimationController.reset();
    swipeAnimationController.forward();
  }

  void love(Size screnSize) {
    tweenPosition.begin = state.position;
    tweenPosition.end = Offset(2 * screnSize.width, 0);
    tweenAngle.begin = state.angle;
    tweenAngle.end = state.angle;
    tweenOverlay.begin = state.overlay;
    tweenOverlay.end = state.overlay;

    swipeAnimationController.reset();
    swipeAnimationController.forward().whenComplete(() {
      emit(const ControlCardLovedState());
    });
  }

  void skip(Size screnSize) {
    tweenPosition.begin = state.position;
    tweenPosition.end = Offset(-(2 * screnSize.width), 0);
    tweenAngle.begin = state.angle;
    tweenAngle.end = state.angle;
    tweenOverlay.begin = state.overlay;
    tweenOverlay.end = state.overlay;

    swipeAnimationController.reset();
    swipeAnimationController.forward().whenComplete(() {
      emit(const ControlCardSkipedState());
    });
  }

  dispose() {
    print("DISPONSE");
    swipeAnimationController.dispose();
  }
}
