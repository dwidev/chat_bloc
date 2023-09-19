import 'package:chat_bloc/chat/cubit/react_chat_animation_value.dart';
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
  // final emoticonAnimationDuration = const Duration(milliseconds: 3000);
  // late final AnimationController emoticonAnimationController;
  // late CurvedAnimation curvedEmoticonAnimation;

  // late TweenSequence<Offset> tweenOffsetEmoticon;
  // late Animation<Offset> emoticonOffsetAnimation;

  // late TweenSequence<double> tweenShadowEmoticon;
  // late Animation<double> emoticonshadowAnimation;

  // late Tween<double> tweenOpacityEmoticon;
  // late Animation<double> emoticonOpcityAnimation;

  // late TweenSequence<double> tweenScaleEmoticon;
  // late Animation<double> emoticonScaleAnimation;

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
    emit(state.copyWith(startFloatingAnimation: false));
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

  void initEmoticonValues({
    required ChatMessageModel selectedChat,
    required AnimationController emoticonAnimationController,
    required AnimationController emoticonBackgroundController,
    required Tween<double> tweenEmotBgWidth,
    required String selectedEmoticon,
  }) {
    final newAnimationValues = state.chatReactEmoticonValues.toList();
    final index = state.chatReactEmoticonValues.indexWhere(
      (e) => e.keyAnimation == selectedChat.messageId,
    );

    if (index == -1) {
      final emotAnimationValue = ChatReactEmoticonValue(
        keyAnimation: selectedChat.messageId,
        emoticonAnimationStatus: EmoticonAnimationStatus.intial,
        emoticonAnimationController: emoticonAnimationController,
        emoticonBackgroundController: emoticonBackgroundController,
        selectedEmoticon: selectedEmoticon,
        tweenEmotBgWidth: tweenEmotBgWidth,
      );

      newAnimationValues.add(emotAnimationValue);
    }

    emit(state.copyWith(chatReactEmoticonValues: newAnimationValues));
  }

  void showChatReactOverlay({
    required Offset offset,
    required ChatMessageModel selectedChat,
  }) {
    emit(
      state.copyWith(
        startFloatingAnimation: false,
        isShowReactOverlay: true,
        selectedChat: selectedChat,
        offsetBubleChat: offset,
      ),
    );

    animationController.forward();
  }

  void closeChatReactOverlay({
    String? selectedEmoticon,
  }) {
    if (selectedEmoticon == null || selectedEmoticon.isEmpty) {
      emit(state.copyWith(
        isShowReactOverlay: false,
        startFloatingAnimation: false,
      ));
      return;
    }

    if (state.selectedChat.senderEmoticon.isNotEmpty) {
      state.emotAnimationValue.tweenEmotBgWidth.begin =
          state.emotAnimationValue.tweenEmotBgWidth.end;
      state.emotAnimationValue.tweenEmotBgWidth.end = 25 * 2;
    }

    // disposeAnimationForEmoticon();
    animationController.reset();

    state.emotAnimationValue.emoticonBackgroundController.reset();
    state.emotAnimationValue.emoticonAnimationController.reset();

    state.emotAnimationValue.emoticonBackgroundController
        .forward(from: 0)
        .whenComplete(() async {
      state.emotAnimationValue.emoticonAnimationController.forward(from: 0);
    });

    final emotAnimationValue = state.chatReactEmoticonValues.firstWhere(
      (e) => e.keyAnimation == state.selectedChat.messageId,
    );

    final newAnimationValue = emotAnimationValue.copyWith(
      selectedEmoticon: selectedEmoticon,
    );

    final index = state.chatReactEmoticonValues
        .indexWhere((e) => e.keyAnimation == state.selectedChat.messageId);

    state.chatReactEmoticonValues
        .replaceRange(index, index + 1, [newAnimationValue]);

    emit(
      state.copyWith(
        isShowReactOverlay: false,
        chatReactEmoticonValues: state.chatReactEmoticonValues,
        startFloatingAnimation: true,
      ),
    );

    // emit(ReactAnimationSelectEmoji(
    //   selectedEmoticon: selectedEmoticon ?? "",
    //   offsetBubleChat: state.offsetBubleChat,
    //   chat: state.selectedChat,
    //   // reactEmoticonAnimationControllers:
    //   //     state.reactEmoticonAnimationControllers,
    // ));
  }

  // void initAnimationForEmoticon({
  //   required TickerProvider vsync,
  //   // required bool isSender,
  // }) {
  //   emoticonAnimationController = AnimationController(
  //     vsync: vsync,
  //     duration: emoticonAnimationDuration,
  //   )..addStatusListener(onListenEmoticonController);

  //   curvedEmoticonAnimation = CurvedAnimation(
  //     parent: emoticonAnimationController,
  //     curve: Curves.easeInOutCubicEmphasized,
  //   );

  //   // set offset animation
  //   tweenOffsetEmoticon = TweenSequence([
  //     TweenSequenceItem(
  //       tween: Tween(
  //         begin: const Offset(0, -45),
  //         end: const Offset(0, 0),
  //       ).chain(CurveTween(curve: Curves.fastLinearToSlowEaseIn)),
  //       weight: 0.5,
  //     ),
  //     // TweenSequenceItem(
  //     //   tween: Tween(
  //     //     begin: const Offset(2, -35),
  //     //     end: const Offset(2, 10),
  //     //   ),
  //     //   weight: 0.5,
  //     // ),
  //   ]);
  //   emoticonOffsetAnimation = tweenOffsetEmoticon.animate(
  //     curvedEmoticonAnimation,
  //   );

  //   // set shadow of emoticon
  //   tweenShadowEmoticon = TweenSequence([
  //     TweenSequenceItem<double>(
  //       tween: Tween(begin: 0.0, end: 10),
  //       weight: 0.2,
  //     ),
  //     TweenSequenceItem<double>(
  //       tween: Tween(begin: 10.0, end: 0.0),
  //       weight: 1,
  //     ),
  //   ]);
  //   emoticonshadowAnimation = tweenShadowEmoticon.animate(
  //     curvedEmoticonAnimation,
  //   );

  //   // set opacity emoticon
  //   tweenOpacityEmoticon = Tween(begin: 0.2, end: 1.0);
  //   emoticonOpcityAnimation = tweenOpacityEmoticon.animate(
  //     curvedEmoticonAnimation,
  //   );

  //   // set scale emoticon
  //   tweenScaleEmoticon = TweenSequence([
  //     TweenSequenceItem(
  //       tween: Tween(begin: 2.5, end: 1.0),
  //       weight: 0.3,
  //     ),
  //     TweenSequenceItem(
  //       tween: Tween(begin: 1.0, end: 2.5),
  //       weight: 0.3,
  //     ),
  //     TweenSequenceItem(
  //       tween: Tween(begin: 2.5, end: 3.0).chain(
  //         CurveTween(curve: Curves.bounceInOut),
  //       ),
  //       weight: 0.3,
  //     ),
  //     TweenSequenceItem(
  //       tween: Tween(begin: 3.0, end: 1.0).chain(
  //         CurveTween(curve: Curves.bounceInOut),
  //       ),
  //       weight: 0.3,
  //     ),
  //   ]);
  //   emoticonScaleAnimation = tweenScaleEmoticon.animate(
  //     curvedEmoticonAnimation,
  //   );
  // }

  // void disposeAnimationForEmoticon() {
  //   emoticonAnimationController.removeStatusListener(
  //     onListenEmoticonController,
  //   );
  //   emoticonAnimationController.dispose();
  // }

  void startFLoatingAnimation() {
    print("START FLOATING");
    // if (status == AnimationStatus.completed) {
    //   tweenScaleEmoticon.begin = 1;
    //   tweenOpacityEmoticon.begin = 1;
    //   tweenOffsetEmoticon.begin = Offset(tweenOffsetEmoticon.begin!.dx, 0);
    //   emoticonAnimationController.reverse();
    // }

    // emit(
    //   ReactAnimationStartFloating(
    //     selectedEmoticon: state.selectedEmoticon,
    //     offsetBubleChat: state.offsetBubleChat,
    //     selectedChat: state.selectedChat,
    //   ),
    // );
  }

  @override
  Future<void> close() {
    animationController.dispose();
    return super.close();
  }
}
