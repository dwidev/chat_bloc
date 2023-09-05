part of 'react_animation_cubit.dart';

sealed class ReactAnimationState extends Equatable {
  final String selectedEmoticon;
  final Offset offsetBubleChat;
  final ChatMessageModel selectedChat;

  const ReactAnimationState({
    required this.selectedEmoticon,
    required this.offsetBubleChat,
    required this.selectedChat,
  });

  @override
  List<Object> get props => [selectedEmoticon, offsetBubleChat, selectedChat];

  @override
  bool? get stringify => true;
}

class ReactAnimationInitial extends ReactAnimationState {
  ReactAnimationInitial()
      : super(
          selectedEmoticon: "",
          offsetBubleChat: const Offset(0, 0),
          selectedChat: ChatMessageModel.initial(),
        );
}

class ReactAnimationSelectEmoji extends ReactAnimationState {
  final ChatMessageModel chat;

  const ReactAnimationSelectEmoji({
    required this.chat,
    required Offset offsetBubleChat,
    required String selectedEmoticon,
  }) : super(
          selectedEmoticon: selectedEmoticon,
          offsetBubleChat: offsetBubleChat,
          selectedChat: chat,
        );

  @override
  List<Object> get props => [chat, selectedEmoticon];
}

class ReactAnimationOverlay extends ReactAnimationState {
  const ReactAnimationOverlay({
    required Offset offsetBubleChat,
    required ChatMessageModel selectedChat,
  }) : super(
          selectedEmoticon: "",
          offsetBubleChat: offsetBubleChat,
          selectedChat: selectedChat,
        );

  ReactAnimationState copyWith({
    String? selectedEmoticon,
    Offset? offsetBubleChat,
    ChatMessageModel? selectedChat,
  }) {
    return ReactAnimationOverlay(
      offsetBubleChat: offsetBubleChat ?? this.offsetBubleChat,
      selectedChat: selectedChat ?? this.selectedChat,
    );
  }

  @override
  List<Object> get props => [offsetBubleChat, selectedChat];
}

class ReactAnimationStartFloating extends ReactAnimationState {
  const ReactAnimationStartFloating({
    required super.selectedEmoticon,
    required super.offsetBubleChat,
    required super.selectedChat,
  });
}
