import 'package:chat_bloc/chat/data/model/chat_message_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'react_animation_state.dart';

class ReactAnimationCubit extends Cubit<ReactAnimationState> {
  ReactAnimationCubit() : super(ReactAnimationInitial());

  final listEmot = ['❤️', '🥰', '😂', '😡', '😱', '👍🏻'];

  int get lengthEmot => listEmot.length;

  // [property of Emoji list overlay Animation]
  final duration = const Duration(milliseconds: 500);
  late final AnimationController animationController;
  late Tween<double> tweeOpacity;
  late Animation<double> opacityReactAnimation;
  late CurvedAnimation curvedOfOpacityAnimation;
  // [end property of Emoji list overlay Animation]

  // [propery for emoticon animation]
  final emoticonAnimationDuration = const Duration(milliseconds: 1000);
  late final AnimationController emoticonAnimationController;
  late CurvedAnimation curvedEmoticonAnimation;

  late TweenSequence<Offset> tweenOffsetEmoticon;
  late Animation<Offset> emoticonOffsetAnimation;

  late TweenSequence<double> tweenShadowEmoticon;
  late Animation<double> emoticonshadowAnimation;

  late Tween<double> tweenOpacityEmoticon;
  late Animation<double> emoticonOpcityAnimation;

  late TweenSequence<double> tweenScaleEmoticon;
  late Animation<double> emoticonScaleAnimation;

  // late final TweenSequence<double> tweenEmoticonRotate;
  // late final Animation<double> emoticonRotateAnimation;
  // [end of propery for emoticon animation]

  /// [Currently not used]
  /// Shaking emot animation
  // late final AnimationController _shakingReactController = AnimationController(
  //     vsync: this, duration: const Duration(milliseconds: 1000));

  // vm4.Vector3 _shakeImage() {
  //   final res = vm4.Vector3(math.sin((1) * math.pi * 20.0) * 8, 0.0, 0.0);
  //   return res;
  // }

  void resetReactAnimationState() {
    emit(ReactAnimationInitial());
  }

  /// function for intialize animation on chat long press
  void initAnimationForOnPressChat({required TickerProvider vsync}) {
    animationController = AnimationController(vsync: vsync, duration: duration);
    tweeOpacity = Tween(begin: 0.0, end: 1.0);
    curvedOfOpacityAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOutCubicEmphasized,
    );
    opacityReactAnimation = tweeOpacity.animate(curvedOfOpacityAnimation);
  }

  void showChatReactOverlay({
    required TickerProvider vsync,
    required Offset offset,
    required ChatMessageModel selectedChat,
    required bool isSender,
  }) {
    emit(ReactAnimationOverlay(
      selectedChat: selectedChat,
      offsetBubleChat: offset,
    ));
    animationController.forward();
  }

  void closeChatReactOverlay({String? selectedEmoticon}) {
    // disposeAnimationForEmoticon();
    animationController.reset();

    emit(ReactAnimationSelectEmoji(
      selectedEmoticon: selectedEmoticon ?? "",
      offsetBubleChat: state.offsetBubleChat,
      chat: state.selectedChat,
    ));
  }

  void initAnimationForEmoticon({
    required TickerProvider vsync,
    required bool isSender,
  }) {
    emoticonAnimationController = AnimationController(
      vsync: vsync,
      duration: emoticonAnimationDuration,
    )..addStatusListener(onListenEmoticonController);

    curvedEmoticonAnimation = CurvedAnimation(
      parent: emoticonAnimationController,
      curve: Curves.easeInOutCubicEmphasized,
    );

    // set offset animation
    tweenOffsetEmoticon = TweenSequence([
      TweenSequenceItem(
        tween: Tween(
          begin: const Offset(2, -35),
          end: const Offset(2, 0),
        ).chain(CurveTween(curve: Curves.fastLinearToSlowEaseIn)),
        weight: 1,
      ),
      // TweenSequenceItem(
      //   tween: Tween(
      //     begin: const Offset(2, -35),
      //     end: const Offset(2, 10),
      //   ),
      //   weight: 0.5,
      // ),
    ]);
    emoticonOffsetAnimation = tweenOffsetEmoticon.animate(
      curvedEmoticonAnimation,
    );

    // set shadow of emoticon
    tweenShadowEmoticon = TweenSequence([
      // TweenSequenceItem<double>(
      //   tween: Tween(begin: 0.0, end: 8.0),
      //   weight: 0.5,
      // ),
      TweenSequenceItem<double>(
        tween: Tween(begin: 8.0, end: 0.0),
        weight: 1,
      ),
    ]);
    emoticonshadowAnimation = tweenShadowEmoticon.animate(
      curvedEmoticonAnimation,
    );

    // set opacity emoticon
    tweenOpacityEmoticon = Tween(begin: 0.2, end: 1.0);
    emoticonOpcityAnimation = tweenOpacityEmoticon.animate(
      curvedEmoticonAnimation,
    );

    // set scale emoticon
    tweenScaleEmoticon = TweenSequence([
      TweenSequenceItem(
        tween: Tween(begin: 2.5, end: 1.0),
        weight: 0.3,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 2.5),
        weight: 0.3,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 2.5, end: 3.5).chain(
          CurveTween(curve: Curves.bounceInOut),
        ),
        weight: 0.3,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 3.5, end: 1.0).chain(
          CurveTween(curve: Curves.bounceInOut),
        ),
        weight: 0.3,
      ),
    ]);
    emoticonScaleAnimation = tweenScaleEmoticon.animate(
      curvedEmoticonAnimation,
    );

    // // set rotate emoticon
    // tweenEmoticonRotate = TweenSequence([
    //   TweenSequenceItem(
    //     tween: Tween(begin: 0, end: isSender ? 0.2 : -0.2),
    //     weight: 0.5,
    //   ),
    //   TweenSequenceItem(
    //     tween: Tween(begin: isSender ? 0.2 : -0.2, end: 0),
    //     weight: 0.5,
    //   )
    // ]);
    // emoticonRotateAnimation = tweenEmoticonRotate.animate(
    //   emoticonAnimationController,
    // );
  }

  void disposeAnimationForEmoticon() {
    emoticonAnimationController.removeStatusListener(
      onListenEmoticonController,
    );
    emoticonAnimationController.dispose();
  }

  void onListenEmoticonController(status) {
    // if (status == AnimationStatus.completed) {
    //   tweenScaleEmoticon.begin = 1;
    //   tweenOpacityEmoticon.begin = 1;
    //   tweenOffsetEmoticon.begin = Offset(tweenOffsetEmoticon.begin!.dx, 0);
    //   emoticonAnimationController.reverse();
    // }

    if (status == AnimationStatus.completed) {
      emit(
        ReactAnimationStartFloating(
          selectedEmoticon: state.selectedEmoticon,
          offsetBubleChat: state.offsetBubleChat,
          selectedChat: state.selectedChat,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    disposeAnimationForEmoticon();

    animationController.dispose();
    return super.close();
  }
}
