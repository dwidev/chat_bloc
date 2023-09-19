// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'react_animation_cubit.dart';

@immutable
class ReactAnimationState extends Equatable {
  final bool isShowReactOverlay;
  final bool startFloatingAnimation;

  final Offset offsetBubleChat;
  final ChatMessageModel selectedChat;

  final List<ChatReactEmoticonValue> chatReactEmoticonValues;

  const ReactAnimationState({
    required this.isShowReactOverlay,
    required this.offsetBubleChat,
    required this.selectedChat,
    this.startFloatingAnimation = false,
    this.chatReactEmoticonValues = const [],
  });

  String getEmoticon(String key) =>
      chatReactEmoticonValues
          .where((e) => e.keyAnimation == key)
          .firstOrNull
          ?.selectedEmoticon ??
      "";

  ChatReactEmoticonValue get emotAnimationValue {
    final chatReactEmoticonValue = chatReactEmoticonValues.firstWhere(
      (e) => e.keyAnimation == selectedChat.messageId,
    );
    return chatReactEmoticonValue;
  }

  void disponseAnimationController(String key) {
    where(e) => e.keyAnimation == key;
    final animationValue = chatReactEmoticonValues.where(where).firstOrNull;

    if (animationValue != null) {
      animationValue.disponseAnimationControllers();
      chatReactEmoticonValues.remove(animationValue);
    }
  }

  @override
  List<Object> get props => [
        isShowReactOverlay,
        offsetBubleChat,
        selectedChat,
        chatReactEmoticonValues,
        startFloatingAnimation,
      ];

  @override
  bool? get stringify => true;

  ReactAnimationState copyWith({
    bool? isShowReactOverlay,
    bool? startFloatingAnimation,
    Offset? offsetBubleChat,
    ChatMessageModel? selectedChat,
    List<ChatReactEmoticonValue>? chatReactEmoticonValues,
  }) {
    return ReactAnimationState(
      isShowReactOverlay: isShowReactOverlay ?? this.isShowReactOverlay,
      startFloatingAnimation:
          startFloatingAnimation ?? this.startFloatingAnimation,
      offsetBubleChat: offsetBubleChat ?? this.offsetBubleChat,
      selectedChat: selectedChat ?? this.selectedChat,
      chatReactEmoticonValues:
          chatReactEmoticonValues ?? this.chatReactEmoticonValues,
    );
  }
}

class ReactAnimationInitial extends ReactAnimationState {
  ReactAnimationInitial()
      : super(
          isShowReactOverlay: false,
          offsetBubleChat: const Offset(0, 0),
          selectedChat: ChatMessageModel.initial(),
        );
}



// sealed class ReactAnimationState extends Equatable {
//   final String selectedEmoticon;
//   final Offset offsetBubleChat;
//   final ChatMessageModel selectedChat;
//   final List<ReactEmoticonAnimationController>
//       reactEmoticonAnimationControllers;

//   const ReactAnimationState({
//     required this.selectedEmoticon,
//     required this.offsetBubleChat,
//     required this.selectedChat,
//     this.reactEmoticonAnimationControllers = const [],
//   });

//   @override
//   List<Object> get props => [
//         selectedEmoticon,
//         offsetBubleChat,
//         selectedChat,
//         ReactEmoticonAnimationController
//       ];

//   @override
//   bool? get stringify => true;
// }

// class ReactAnimationInitial extends ReactAnimationState {
//   ReactAnimationInitial()
//       : super(
//           selectedEmoticon: "",
//           offsetBubleChat: const Offset(0, 0),
//           selectedChat: ChatMessageModel.initial(),
//         );
// }

// class ReactAnimationSelectEmoji extends ReactAnimationState {
//   final ChatMessageModel chat;

//   const ReactAnimationSelectEmoji({
//     required this.chat,
//     required Offset offsetBubleChat,
//     required String selectedEmoticon,
//   }) : super(
//           selectedEmoticon: selectedEmoticon,
//           offsetBubleChat: offsetBubleChat,
//           selectedChat: chat,
//         );

//   @override
//   List<Object> get props => [chat, selectedEmoticon];
// }

// class ReactAnimationOverlay extends ReactAnimationState {
//   const ReactAnimationOverlay({
//     required Offset offsetBubleChat,
//     required ChatMessageModel selectedChat,
//     required List<ReactEmoticonAnimationController>
//         reactEmoticonAnimationControllers,
//   }) : super(
//           selectedEmoticon: "",
//           offsetBubleChat: offsetBubleChat,
//           selectedChat: selectedChat,
//           reactEmoticonAnimationControllers: reactEmoticonAnimationControllers,
//         );

//   ReactAnimationState copyWith({
//     String? selectedEmoticon,
//     Offset? offsetBubleChat,
//     ChatMessageModel? selectedChat,
//     List<ReactEmoticonAnimationController>? reactEmoticonAnimationControllers,
//   }) {
//     return ReactAnimationOverlay(
//       offsetBubleChat: offsetBubleChat ?? this.offsetBubleChat,
//       selectedChat: selectedChat ?? this.selectedChat,
//       reactEmoticonAnimationControllers: reactEmoticonAnimationControllers ??
//           this.reactEmoticonAnimationControllers,
//     );
//   }

//   @override
//   List<Object> get props => [offsetBubleChat, selectedChat];
// }

// class ReactAnimationStartFloating extends ReactAnimationState {
//   const ReactAnimationStartFloating({
//     required super.selectedEmoticon,
//     required super.offsetBubleChat,
//     required super.selectedChat,
//   });
// }

