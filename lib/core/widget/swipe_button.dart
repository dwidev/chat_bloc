import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../theme/colors.dart';

const swipeButtonDefaultSize = 30.0;

class SwipeButton extends StatefulWidget {
  const SwipeButton({
    super.key,
    this.size = swipeButtonDefaultSize,
  });

  final double size;

  @override
  State<SwipeButton> createState() => _SwipeButtonState();
}

class _SwipeButtonState extends State<SwipeButton>
    with TickerProviderStateMixin {
  late CurvedAnimation curvedAnimation;
  late Tween<Offset> tweenOffsetButton = Tween(
    begin: Offset.zero,
    end: Offset.zero,
  );
  late Animation<Offset> animationOffsetButton;
  late AnimationController animationController;
  static const animationDuration = Duration(milliseconds: 450);

  Offset offsetButton = Offset.zero;
  double? trackWidth;
  bool swipeDone = false;
  double textOpacityAnimation = 1;

  double get translateValue {
    return max((offsetButton.dx > 1 ? 1.0 : offsetButton.dx), 0);
  }

  double get additionalHeight => widget.size / 10;

  double calculateWidth(BoxConstraints constraints) =>
      (constraints.maxWidth - widget.size - (additionalHeight * 2));

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: animationDuration,
    )..addListener(onListenAnimationController);
    curvedAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.fastLinearToSlowEaseIn,
    );
    animationOffsetButton = tweenOffsetButton.animate(curvedAnimation);
    super.initState();
  }

  void onListenAnimationController() {
    setState(() {
      offsetButton = animationOffsetButton.value;
    });
  }

  void _doHorizontalDragStart(DragStartDetails details) {}

  void _doHorizontalDragUpdate(
    DragUpdateDetails details,
    BoxConstraints constraints,
  ) {
    if (!swipeDone) {
      setState(() {
        final width = calculateWidth(constraints);
        final dx = details.primaryDelta! / width;
        offsetButton += Offset(dx, 0);

        trackWidth =
            (trackWidth ?? constraints.maxWidth) - details.primaryDelta!;

        if (offsetButton.dx >= 0.3) {
          textOpacityAnimation = 0;
        }

        if (offsetButton.dx >= 1) {
          swipeDone = true;
        }
      });
    }
  }

  void onHorizontalDragEnd(DragEndDetails details) {
    tweenOffsetButton.begin = offsetButton;
    tweenOffsetButton.end = Offset.zero;
    trackWidth = null;

    animationController
      ..reset()
      ..forward(from: 0.0).whenComplete(() {
        setState(() {
          swipeDone = false;
          textOpacityAnimation = 1;
        });
      });
  }

  @override
  void dispose() {
    animationController
      ..removeListener(onListenAnimationController)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: widget.size + additionalHeight,
      child: LayoutBuilder(builder: (context, constraints) {
        return Stack(
          alignment: Alignment.centerRight,
          clipBehavior: Clip.none,
          children: [
            track(constraints),
            Positioned(
              left: additionalHeight,
              child: button(constraints),
            ),
          ],
        );
      }),
    );
  }

  Widget button(BoxConstraints constraints) {
    return GestureDetector(
      onHorizontalDragStart: _doHorizontalDragStart,
      onHorizontalDragUpdate: (details) =>
          _doHorizontalDragUpdate(details, constraints),
      onHorizontalDragEnd: onHorizontalDragEnd,
      child: Transform(
        transform: Matrix4.identity()
          ..translate(translateValue * calculateWidth(constraints)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.size),
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor, softyellowColor],
                tileMode: TileMode.clamp,
              ),
            ),
            // padding: const EdgeInsets.all(10),
            child: const Icon(
              CupertinoIcons.heart_solid,
              size: 20,
              color: whiteColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget track(BoxConstraints constraints) {
    final textTheme = Theme.of(context).textTheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.size),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          width: trackWidth ?? constraints.maxWidth,
          alignment: Alignment.center,
          child: AnimatedOpacity(
            duration: animationDuration,
            opacity: textOpacityAnimation,
            child: Text(
              "Swipe to like",
              style: textTheme.bodySmall?.copyWith(
                fontSize: widget.size / 4.2,
                color: whiteColor,
              ),
            )
                .animate(
                  onPlay: (controller) => controller.repeat(),
                )
                .shimmer(
                  color: darkColor,
                  duration: const Duration(
                    milliseconds: 1000,
                  ),
                  delay: const Duration(
                    milliseconds: 500,
                  ),
                ),
          ),
        ),
      ),
    );
  }
}
