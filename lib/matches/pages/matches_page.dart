import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/theme/colors.dart';
import '../../homepage/pages/home_page.dart';

class MatchesPage extends StatefulWidget {
  const MatchesPage({super.key});

  @override
  State<MatchesPage> createState() => _MatchesPageState();
}

class _MatchesPageState extends State<MatchesPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Matches",
          style: textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              CupertinoIcons.square_fill_line_vertical_square,
              color: blueLightColor,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "This is a list of people who have liked you and your matches.",
                  textAlign: TextAlign.center,
                  style: textTheme.labelSmall?.copyWith(
                    color: darkColor,
                  ),
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(30),
                itemCount: dummyUsers.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 0.7,
                ),
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Container(
                        width: size.width / 2.5,
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(dummyUsers[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        right: 2,
                        top: 0,
                        child: Transform.translate(
                          offset: const Offset(0, -4),
                          child: Container(
                            width: 12,
                            height: 12,
                            // padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: whiteColor,
                                width: 2,
                              ),
                              color: greenColor,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 10,
                        left: 10,
                        bottom: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Row(
                                children: [
                                  Text(
                                    "Michelle, 23",
                                    style: textTheme.labelLarge?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Icon(
                                    CupertinoIcons.checkmark_seal_fill,
                                    color: blueLightColor,
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            if (index != 1)
                              // SwipeButton.expand(
                              //   thumb: Icon(
                              //     CupertinoIcons.heart_solid,
                              //     color: Colors.white,
                              //   ),
                              //   child: Text(
                              //     "Swipe to like",
                              //     style: textTheme.bodySmall?.copyWith(
                              //       fontSize: 10,
                              //     ),
                              //   ),
                              //   activeThumbColor: Colors.red,
                              //   activeTrackColor: Colors.grey.shade300,
                              //   onSwipe: () {},
                              // ),
                              const SwipeButtonGlass(),
                            if (index == 1)
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                // margin:
                                //     const EdgeInsets.symmetric(horizontal: 10)
                                //         .copyWith(
                                //   bottom: 10,
                                // ),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [primaryColor, softyellowColor],
                                    tileMode: TileMode.clamp,
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "Chat now",
                                  style: textTheme.bodySmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                          ],
                        ),
                      )
                    ],
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SwipeButtonGlass extends StatefulWidget {
  const SwipeButtonGlass({
    super.key,
  });
  final height = 50.0;

  @override
  State<SwipeButtonGlass> createState() => _SwipeButtonGlassState();
}

class _SwipeButtonGlassState extends State<SwipeButtonGlass>
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

  double get additionalHeight => widget.height / 10;

  double calculateWidth(BoxConstraints constraints) =>
      (constraints.maxWidth - widget.height - (additionalHeight * 2));

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
      height: widget.height + additionalHeight,
      child: LayoutBuilder(builder: (context, constraints) {
        return Stack(
          alignment: Alignment.centerRight,
          clipBehavior: Clip.none,
          children: [
            buildTrack(constraints),
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
          borderRadius: BorderRadius.circular(widget.height),
          child: Container(
            width: widget.height,
            height: widget.height,
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

  Widget buildTrack(BoxConstraints constraints) {
    final textTheme = Theme.of(context).textTheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.height),
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
                fontSize: widget.height / 4.2,
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

enum _SwipeButtonType {
  swipe,
  expand,
}

class SwipeButton extends StatefulWidget {
  final Widget child;
  final Widget? thumb;

  final Color? activeThumbColor;
  final Color? inactiveThumbColor;
  final EdgeInsets thumbPadding;

  final Color? activeTrackColor;
  final Color? inactiveTrackColor;
  final EdgeInsets trackPadding;

  final BorderRadius? borderRadius;

  final double width;
  final double height;

  final bool enabled;

  final double elevationThumb;
  final double elevationTrack;

  final VoidCallback? onSwipeStart;
  final VoidCallback? onSwipe;
  final VoidCallback? onSwipeEnd;

  final _SwipeButtonType _swipeButtonType;

  final Duration duration;

  const SwipeButton({
    Key? key,
    required this.child,
    this.thumb,
    this.activeThumbColor,
    this.inactiveThumbColor,
    this.thumbPadding = EdgeInsets.zero,
    this.activeTrackColor,
    this.inactiveTrackColor,
    this.trackPadding = EdgeInsets.zero,
    this.borderRadius,
    this.width = double.infinity,
    this.height = 50,
    this.enabled = true,
    this.elevationThumb = 0,
    this.elevationTrack = 0,
    this.onSwipeStart,
    this.onSwipe,
    this.onSwipeEnd,
    this.duration = const Duration(milliseconds: 250),
  })  : assert(elevationThumb >= 0.0),
        assert(elevationTrack >= 0.0),
        _swipeButtonType = _SwipeButtonType.swipe,
        super(key: key);

  const SwipeButton.expand({
    Key? key,
    required this.child,
    this.thumb,
    this.activeThumbColor,
    this.inactiveThumbColor,
    this.thumbPadding = EdgeInsets.zero,
    this.activeTrackColor,
    this.inactiveTrackColor,
    this.trackPadding = EdgeInsets.zero,
    this.borderRadius,
    this.width = double.infinity,
    this.height = 50,
    this.enabled = true,
    this.elevationThumb = 0,
    this.elevationTrack = 0,
    this.onSwipeStart,
    this.onSwipe,
    this.onSwipeEnd,
    this.duration = const Duration(milliseconds: 250),
  })  : assert(elevationThumb >= 0.0),
        assert(elevationTrack >= 0.0),
        _swipeButtonType = _SwipeButtonType.expand,
        super(key: key);

  @override
  State<SwipeButton> createState() => _SwipeState();
}

class _SwipeState extends State<SwipeButton> with TickerProviderStateMixin {
  late AnimationController swipeAnimationController;
  late AnimationController expandAnimationController;

  bool swiped = false;

  @override
  void initState() {
    _initAnimationControllers();
    super.initState();
  }

  _initAnimationControllers() {
    swipeAnimationController = AnimationController(
      vsync: this,
      duration: widget.duration,
      // lowerBound: 0,
      // upperBound: 1,
      value: 0,
    );
    expandAnimationController = AnimationController(
      vsync: this,
      duration: widget.duration,
      // lowerBound: 0,
      // upperBound: 1,
      value: 0,
    );
  }

  @override
  void didUpdateWidget(covariant SwipeButton oldWidget) {
    if (oldWidget.duration != widget.duration) {
      _initAnimationControllers();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    swipeAnimationController.dispose();
    expandAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              _buildTrack(context, constraints),
              _buildThumb(context, constraints),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTrack(BuildContext context, BoxConstraints constraints) {
    final ThemeData theme = Theme.of(context);

    final trackColor = widget.enabled
        ? widget.activeTrackColor ?? theme.backgroundColor
        : widget.inactiveTrackColor ?? theme.disabledColor;

    final borderRadius = widget.borderRadius ?? BorderRadius.circular(150);
    final elevationTrack = widget.enabled ? widget.elevationTrack : 0.0;

    return Padding(
      padding: widget.trackPadding,
      child: Material(
        elevation: elevationTrack,
        borderRadius: borderRadius,
        clipBehavior: Clip.antiAlias,
        color: trackColor,
        child: Container(
          width: constraints.maxWidth,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
          ),
          clipBehavior: Clip.antiAlias,
          alignment: Alignment.center,
          child: widget.child,
        ),
      ),
    );
  }

  Widget _buildThumb(BuildContext context, BoxConstraints constraints) {
    final ThemeData theme = Theme.of(context);

    final thumbColor = widget.enabled
        ? widget.activeThumbColor ?? theme.colorScheme.secondary
        : widget.inactiveThumbColor ?? theme.disabledColor;

    final borderRadius = widget.borderRadius ?? BorderRadius.circular(150);

    final elevationThumb = widget.enabled ? widget.elevationThumb : 0.0;

    return AnimatedBuilder(
      animation: swipeAnimationController,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.identity()
            ..translate(swipeAnimationController.value *
                (constraints.maxWidth - widget.height)),
          child: Container(
            padding: widget.thumbPadding,
            child: GestureDetector(
              onHorizontalDragStart: _onHorizontalDragStart,
              onHorizontalDragUpdate: (details) =>
                  _onHorizontalDragUpdate(details, constraints.maxWidth),
              onHorizontalDragEnd: _onHorizontalDragEnd,
              child: Material(
                elevation: elevationThumb,
                borderRadius: borderRadius,
                color: thumbColor,
                clipBehavior: Clip.antiAlias,
                child: AnimatedBuilder(
                  animation: expandAnimationController,
                  builder: (context, child) {
                    return SizedBox(
                      width: widget.height +
                          (expandAnimationController.value *
                              (constraints.maxWidth - widget.height)) -
                          widget.thumbPadding.horizontal,
                      height: widget.height - widget.thumbPadding.vertical,
                      child: widget.thumb ??
                          Icon(
                            Icons.arrow_forward,
                            color: widget.activeTrackColor ??
                                widget.inactiveTrackColor,
                          ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _onHorizontalDragStart(DragStartDetails details) {
    setState(() {
      swiped = false;
    });
    widget.onSwipeStart?.call();
  }

  _onHorizontalDragUpdate(DragUpdateDetails details, double width) {
    switch (widget._swipeButtonType) {
      case _SwipeButtonType.swipe:
        if (!swiped && widget.enabled) {
          print(details.primaryDelta! / (width - widget.height));
          swipeAnimationController.value +=
              details.primaryDelta! / (width - widget.height);
          print(swipeAnimationController.value);
          if (swipeAnimationController.value == 1) {
            setState(() {
              swiped = true;
              widget.onSwipe?.call();
            });
          }
        }
        break;
      case _SwipeButtonType.expand:
        if (!swiped && widget.enabled) {
          expandAnimationController.value +=
              details.primaryDelta! / (width - widget.height);
          if (expandAnimationController.value == 1) {
            setState(() {
              swiped = true;
              widget.onSwipe?.call();
            });
          }
        }
        break;
    }
  }

  _onHorizontalDragEnd(DragEndDetails details) {
    setState(() {
      swipeAnimationController.animateTo(0);
      expandAnimationController.animateTo(0);
    });
    widget.onSwipeEnd?.call();
  }
}
