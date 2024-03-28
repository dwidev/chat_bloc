// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'matchloves.dart';

@immutable
class ChatState extends Equatable {
  final List<ChatMessageModel> chats;
  final bool startTyping;

  final ChatMessageModel? replayChat;

  const ChatState({
    this.chats = const [],
    this.startTyping = false,
    this.replayChat,
  });

  factory ChatState.resetReplyChat() {
    return const ChatState(
      replayChat: null,
    );
  }

  @override
  List<Object?> get props => [chats, startTyping, replayChat];

  ChatState copyWith({
    List<ChatMessageModel>? chats,
    bool? startTyping,
    ChatMessageModel? replayChat,
  }) {
    return ChatState(
      chats: chats ?? this.chats,
      startTyping: startTyping ?? this.startTyping,
      replayChat: replayChat ?? this.replayChat,
    );
  }

  @override
  bool get stringify => true;
}

class ChatReceiveEmot extends ChatState {
  final List<ChatMessageModel> chatsReceiveEmot;

  const ChatReceiveEmot({required this.chatsReceiveEmot, super.chats});
}

class ChatStateStartEmoticonAnimation extends ChatState {
  const ChatStateStartEmoticonAnimation({required List<ChatMessageModel> chats})
      : super(chats: chats);

  @override
  List<Object?> get props => [chats];
}

class ChatInitial extends ChatState {
  const ChatInitial();
}

class ChatErrorConnectWS extends ChatState {
  final Exception error;
  const ChatErrorConnectWS(this.error);
}
