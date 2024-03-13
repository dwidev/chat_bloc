import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/react_animation_cubit.dart';

class FloatingReactionAnimation extends StatefulWidget {
  final int index;
  final Size screenSize;
  final String me;

  const FloatingReactionAnimation({
    super.key,
    required this.index,
    required this.screenSize,
    required this.me,
  });

  @override
  State<FloatingReactionAnimation> createState() =>
      FloatingReactionAnimationState();
}

class FloatingReactionAnimationState extends State<FloatingReactionAnimation>
    with TickerProviderStateMixin {
  /// Reaction floating animation
  final animationDuration = const Duration(seconds: 4);
  late final AnimationController _reactFloatingController;

  late Animation<double> translateXAnimation;
  late Animation<double> translateYAnimation;
  late Animation<double> scaleAnimation;

  final random = math.Random();
  late final TweenSequence<double> tweenX;
  late final TweenSequence<double> tweenY;
  late final endXposition =
      random.nextInt(widget.screenSize.width.toInt()).toDouble();
  late final endYposition =
      random.nextInt(widget.screenSize.height ~/ 5).toDouble();
  late final scaleRandom = random.nextDouble() * 3.5;

  @override
  void initState() {
    _reactFloatingController = AnimationController(
      vsync: this,
      duration: animationDuration,
    );
    final curved = CurvedAnimation(
      parent: _reactFloatingController,
      curve: Curves.decelerate,
    );

    final xEnd = widget.index % 5 == 0 ? -endXposition : endXposition;
    tweenX = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween(begin: 0.0, end: xEnd)
              .chain(CurveTween(curve: Curves.fastEaseInToSlowEaseOut)),
          weight: 1,
        ),
        TweenSequenceItem<double>(
          tween: ConstantTween(xEnd)
              .chain(CurveTween(curve: Curves.fastEaseInToSlowEaseOut)),
          weight: 1,
        ),
      ],
    );
    translateXAnimation = tweenX.animate(curved);

    final endY = widget.index % 2 == 1 ? endYposition : -endYposition;
    tweenY = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween(begin: 0.0, end: endY)
              .chain(CurveTween(curve: Curves.fastEaseInToSlowEaseOut)),
          weight: 1,
        ),
        TweenSequenceItem<double>(
          tween: Tween(
            begin: endY,
            end: widget.screenSize.height,
          ).chain(CurveTween(curve: Curves.easeInToLinear)),
          weight: 0.5,
        ),
      ],
    );

    translateYAnimation = tweenY.animate(curved);
    final tweenRotate = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem(
          tween: Tween(
            begin: 1.0,
            end: scaleRandom < 1.0 ? 1.0 : scaleRandom.toDouble(),
          ),
          weight: 0.1,
        )
      ],
    );
    scaleAnimation = tweenRotate.animate(_reactFloatingController);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _reactFloatingController.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          context.read<ReactAnimationCubit>().resetReactAnimationState();
        }
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _reactFloatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _reactFloatingController.reset();
        _reactFloatingController.stop(canceled: true);
        return true;
      },
      child: BlocConsumer<ReactAnimationCubit, ReactAnimationState>(
        listener: (context, state) {
          if (state.startFloatingAnimation) {
            _reactFloatingController.forward(from: 0);
          }
        },
        builder: (context, state) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: state.startFloatingAnimation
                ? AnimatedBuilder(
                    animation: _reactFloatingController,
                    builder: (context, child) {
                      final isMe = widget.me == state.selectedChat.senderID;
                      final xOffsetPosition =
                          isMe ? widget.screenSize.width - 30 : 20.0;
                      final xOffsetAnimation = isMe
                          ? -translateXAnimation.value
                          : translateXAnimation.value;

                      return Transform.translate(
                        offset: Offset(
                          xOffsetPosition,
                          state.offsetBubleChat.dy + 18,
                        ),
                        child: Transform.translate(
                          offset: Offset(
                            xOffsetAnimation,
                            -translateYAnimation.value,
                          ),
                          child: Transform.rotate(
                            angle: widget.index % 5 == 1
                                ? translateXAnimation.value.isNegative
                                    ? -0.1
                                    : 0.1
                                : 1,
                            child: Transform.scale(
                              scale: scaleAnimation.value,
                              child: Text(
                                state.getEmoticon(state.selectedChat.messageId),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : const Offstage(),
          );
        },
      ),
    );
  }
}
