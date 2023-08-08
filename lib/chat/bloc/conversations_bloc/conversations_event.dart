part of 'conversations_bloc.dart';

@immutable
sealed class ConversationsEvent {
  const ConversationsEvent();
}

final class GetConversations extends ConversationsEvent {
  final String userID;
  const GetConversations(this.userID);
}

final class SubscribeMessage extends ConversationsEvent {
  const SubscribeMessage();
}

final class ReadMessage extends ConversationsEvent {
  final ConversationModel conversation;
  const ReadMessage(this.conversation);
}
