// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/animation.dart';

enum EmoticonAnimationStatus {
  intial,
  runningEmot,
  runningFloating,
}

class ChatReactEmoticonValue {
  final String keyAnimation;
  final String selectedEmoticon;

  final EmoticonAnimationStatus emoticonAnimationStatus;
  final AnimationController emoticonAnimationController;

  final Tween<double> tweenEmotBgWidth;
  final AnimationController emoticonBackgroundController;

  ChatReactEmoticonValue({
    required this.keyAnimation,
    required this.selectedEmoticon,
    required this.emoticonAnimationStatus,
    required this.emoticonAnimationController,
    required this.tweenEmotBgWidth,
    required this.emoticonBackgroundController,
  });

  void disponseAnimationControllers() {
    emoticonAnimationController.dispose();
    emoticonBackgroundController.dispose();
  }

  @override
  String toString() {
    return 'ChatReactEmoticonValue(keyAnimation: $keyAnimation, selectedEmoticon: $selectedEmoticon, emoticonAnimationStatus: $emoticonAnimationStatus, emoticonAnimationController: $emoticonAnimationController, tweenEmotBgWidth: $tweenEmotBgWidth, emoticonBackgroundController: $emoticonBackgroundController)';
  }

  ChatReactEmoticonValue copyWith({
    String? keyAnimation,
    String? selectedEmoticon,
    EmoticonAnimationStatus? emoticonAnimationStatus,
    AnimationController? emoticonAnimationController,
    Tween<double>? tweenEmotBgWidth,
    AnimationController? emoticonBackgroundController,
  }) {
    return ChatReactEmoticonValue(
      keyAnimation: keyAnimation ?? this.keyAnimation,
      selectedEmoticon: selectedEmoticon ?? this.selectedEmoticon,
      emoticonAnimationStatus:
          emoticonAnimationStatus ?? this.emoticonAnimationStatus,
      emoticonAnimationController:
          emoticonAnimationController ?? this.emoticonAnimationController,
      tweenEmotBgWidth: tweenEmotBgWidth ?? this.tweenEmotBgWidth,
      emoticonBackgroundController:
          emoticonBackgroundController ?? this.emoticonBackgroundController,
    );
  }

  @override
  bool operator ==(covariant ChatReactEmoticonValue other) {
    if (identical(this, other)) return true;

    return other.keyAnimation == keyAnimation &&
        other.selectedEmoticon == selectedEmoticon &&
        other.emoticonAnimationStatus == emoticonAnimationStatus &&
        other.emoticonAnimationController == emoticonAnimationController &&
        other.tweenEmotBgWidth == tweenEmotBgWidth &&
        other.emoticonBackgroundController == emoticonBackgroundController;
  }

  @override
  int get hashCode {
    return keyAnimation.hashCode ^
        selectedEmoticon.hashCode ^
        emoticonAnimationStatus.hashCode ^
        emoticonAnimationController.hashCode ^
        tweenEmotBgWidth.hashCode ^
        emoticonBackgroundController.hashCode;
  }
}
