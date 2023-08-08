// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'chat_bloc.dart';

@immutable
class ChatState extends Equatable {
  final List<ChatMessageModel> chats;

  const ChatState({
    this.chats = const [],
  });

  @override
  List<Object?> get props => [chats];

  ChatState copyWith({
    List<ChatMessageModel>? chats,
    List<ConversationModel>? conversations,
  }) {
    return ChatState(
      chats: chats ?? this.chats,
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
