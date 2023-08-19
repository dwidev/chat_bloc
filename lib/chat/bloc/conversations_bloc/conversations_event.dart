part of 'conversations_bloc.dart';

@immutable
sealed class ConversationsEvent {
  const ConversationsEvent();
}

final class GetConversations extends ConversationsEvent {
  final String userID;
  const GetConversations(this.userID);
}

final class ConversationSubscribeMessage extends ConversationsEvent {
  const ConversationSubscribeMessage();
}

final class ConversationReadMessage extends ConversationsEvent {
  final ConversationModel conversation;
  const ConversationReadMessage(this.conversation);
}

final class ConversationSubscribeUserTyping extends ConversationsEvent {
  const ConversationSubscribeUserTyping();
}
