part of 'chat_bloc.dart';

@immutable
class ChatState extends Equatable {
  final List<ChatMessageModel> chats;
  final bool startTyping;
  final bool receiverIsTyping;

  const ChatState({
    this.chats = const [],
    this.startTyping = false,
    this.receiverIsTyping = false,
  });

  @override
  List<Object?> get props => [chats, startTyping, receiverIsTyping];

  ChatState copyWith({
    List<ChatMessageModel>? chats,
    bool? startTyping,
    bool? receiverIsTyping,
  }) {
    return ChatState(
      chats: chats ?? this.chats,
      startTyping: startTyping ?? this.startTyping,
      receiverIsTyping: receiverIsTyping ?? this.receiverIsTyping,
    );
  }
}

class ChatInitial extends ChatState {
  const ChatInitial();
}

class ChatErrorConnectWS extends ChatState {
  final Exception error;
  const ChatErrorConnectWS(this.error);
}
