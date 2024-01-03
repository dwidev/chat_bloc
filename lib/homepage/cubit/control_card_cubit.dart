import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'control_card_enum.dart';

part 'control_card_state.dart';

abstract class ControlCardCubitDelegate {
  void onSwipeUpdate(double distance);
}

class ControlCardCubit extends Cubit<ControlCardState> {
  ControlCardCubit(this.delegate) : super(const ControlCardInitial());

  final ControlCardCubitDelegate delegate;

  late AnimationController swipeAnimationController;
  late Tween<Offset> tweenPosition;
  late Animation<Offset> positionAnimation;
  late Tween<double> tweenAngle;
  late Animation<double> angleAnimation;
  late Tween<double> tweenOverlay;
  late Animation<double> overlayAnimation;

  static const swipeAnimationDuration = Duration(milliseconds: 500);
  static const swipeBackAnimationDuration = Duration(milliseconds: 1000);

  void initializeSwipeAnimation({
    required TickerProvider sync,
  }) {
    swipeAnimationController = AnimationController(
      vsync: sync,
      duration: swipeAnimationDuration,
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

    swipeAnimationController
      ..addListener(onListenSwipeController)
      ..addStatusListener(onListenStatusSwipeController);
  }

  void onListenStatusSwipeController(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      emit(state.copyWith(cardListenerType: CardListenerType.outCard));
    }
  }

  void onListenSwipeController() {
    if (state.cardListenerType == CardListenerType.backCard) {
      swipeAnimationController.duration = swipeBackAnimationDuration;

      emit(state.copyWith(
        position: Offset.lerp(
          tweenPosition.begin,
          Offset.zero,
          Curves.elasticOut.transform(swipeAnimationController.value),
        ),
        angle: _rotation(state.anchorBounds),
        overlay: overlayAnimation.value,
      ));

      delegate.onSwipeUpdate(state.position.distance);
      return;
    }

    swipeAnimationController.duration = swipeAnimationDuration;

    emit(state.copyWith(
      position: positionAnimation.value,
      angle: angleAnimation.value,
      overlay: overlayAnimation.value,
    ));
    delegate.onSwipeUpdate(state.position.distance);
  }

  double _rotation(Rect dragBounds) {
    final rotationCornerMultiplier =
        state.positionStart.dy >= dragBounds.top + (dragBounds.height / 2)
            ? 1
            : -1;
    return (pi / 8) *
        (state.position.dx / dragBounds.width) *
        rotationCornerMultiplier;
  }

  void onActionSkip(Size screnSize) {
    tweenPosition.begin = Offset.zero;
    tweenPosition.end = Offset(-(2 * screnSize.width), 0.0);
    tweenAngle.begin = 0.0;
    tweenAngle.end = -0.2;
    tweenOverlay.begin = 0.5;
    tweenOverlay.end = 0.9;

    swipeAnimationController
      ..stop(canceled: true)
      ..reset();
    swipeAnimationController.forward(from: 0.0).whenComplete(() {
      emit(const ControlCardSkipedState());
    });
  }

  void onActionLove(Size screnSize) {
    tweenPosition.begin = Offset.zero;
    tweenPosition.end = Offset(2 * screnSize.width, 0.0);
    tweenAngle.begin = 0.0;
    tweenAngle.end = 0.5;
    tweenOverlay.begin = 0.5;
    tweenOverlay.end = 0.9;

    swipeAnimationController
      ..stop(canceled: true)
      ..reset();
    swipeAnimationController.forward(from: 0.0).whenComplete(() {
      emit(const ControlCardSkipedState());
    });
  }

  void onResetPosition() {
    swipeAnimationController
      ..reset()
      ..stop();
    swipeAnimationController.value = 1.0;
    emit(state.copyWith(position: Offset.zero));
  }

  void onDragStart(DragStartDetails details) {
    emit(state.copyWith(positionStart: details.globalPosition));
  }

  void onDragCard(DragUpdateDetails details, Size screnSize) {
    // final angle = 30 * state.position.dx / screnSize.width;
    final angle = _rotation(state.anchorBounds);
    // final newPostion = state.position + details.delta;
    final newPostion = details.globalPosition - state.positionStart;

    var newOverlay = 0.0;

    if (state.swipeOverlayType == CardSwipeType.love) {
      var overlay = (newPostion.dx - 50) / 100;
      newOverlay = overlay < 0.7 ? overlay : state.overlay;
    } else if (state.swipeOverlayType == CardSwipeType.skip) {
      var overlay = (-newPostion.dx - 50) / 100;
      newOverlay = overlay < 0.7 ? overlay : state.overlay;
    } else if (state.swipeOverlayType == CardSwipeType.gift) {
      var overlay = (-newPostion.dy - 50) / 100;
      newOverlay = overlay < 0.7 ? overlay : state.overlay;
    }

    delegate.onSwipeUpdate(newPostion.distance);

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
      case CardSwipeType.gift:
        gift(screnSize);
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

    emit(state.copyWith(cardListenerType: CardListenerType.backCard));
    swipeAnimationController
      ..reset()
      ..forward(from: 0.0);
  }

  void love(Size screnSize) {
    tweenPosition.begin = state.position;
    tweenPosition.end = state.dragVector * (2 * screnSize.width);
    tweenAngle.begin = state.angle;
    tweenAngle.end = state.angle;
    tweenOverlay.begin = state.overlay;
    tweenOverlay.end = state.overlay;

    swipeAnimationController.reset();
    swipeAnimationController.forward(from: 0.0).whenComplete(() {
      emit(const ControlCardLovedState());
    });
  }

  void skip(Size screnSize) {
    tweenPosition.begin = state.position;
    tweenPosition.end = state.dragVector * (2 * screnSize.width);
    tweenAngle.begin = state.angle;
    tweenAngle.end = state.angle;
    tweenOverlay.begin = state.overlay;
    tweenOverlay.end = state.overlay;

    swipeAnimationController.reset();
    swipeAnimationController.forward(from: 0.0).whenComplete(() {
      emit(const ControlCardSkipedState());
    });
  }

  void gift(Size screnSize) {
    tweenPosition.begin = state.position;
    tweenPosition.end = state.dragVector * (2 * screnSize.height);
    tweenAngle.begin = state.angle;
    tweenAngle.end = state.angle;
    tweenOverlay.begin = state.overlay;
    tweenOverlay.end = state.overlay;

    swipeAnimationController.reset();
    swipeAnimationController.forward(from: 0.0).whenComplete(() {
      emit(const ControlCardSkipedState());
    });
  }

  dispose() {
    swipeAnimationController.removeListener(onListenSwipeController);
    swipeAnimationController.dispose();
  }
}
