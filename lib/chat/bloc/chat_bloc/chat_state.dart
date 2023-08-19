part of 'chat_bloc.dart';

@immutable
class ChatState extends Equatable {
  final List<ChatMessageModel> chats;
  final bool startTyping;

  const ChatState({
    this.chats = const [],
    this.startTyping = false,
  });

  @override
  List<Object?> get props => [chats, startTyping];

  ChatState copyWith({
    List<ChatMessageModel>? chats,
    bool? startTyping,
  }) {
    return ChatState(
      chats: chats ?? this.chats,
      startTyping: startTyping ?? this.startTyping,
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
