part of 'chat_bloc.dart';

@immutable
sealed class ChatEvent {
  const ChatEvent();
}

final class ChatSubscribeMessage extends ChatEvent {
  final String conversationID;
  const ChatSubscribeMessage(this.conversationID);
}

final class SendMessage extends ChatEvent {
  final String conversationID;
  final String senderID;
  final String receiverID;
  final String content;

  const SendMessage({
    required this.conversationID,
    required this.senderID,
    required this.receiverID,
    required this.content,
  });
}

final class GetMessageByConversationID extends ChatEvent {
  final String conversationID;

  const GetMessageByConversationID(this.conversationID);
}

abstract class JoinOrLeaveRoomEvent extends ChatEvent {
  final String conversationID;
  final String senderID;
  final String receiverID;

  const JoinOrLeaveRoomEvent(
    this.conversationID,
    this.senderID,
    this.receiverID,
  );
}

final class JoinRoomChat extends JoinOrLeaveRoomEvent {
  const JoinRoomChat(super.conversationID, super.senderID, super.receiverID);
}

final class LeaveRoomChat extends JoinOrLeaveRoomEvent {
  const LeaveRoomChat(super.conversationID, super.senderID, super.receiverID);
}

final class ChatTyping extends ChatEvent {
  final bool isStart;
  final String conversationID;
  final String senderID;
  final String receiverID;

  const ChatTyping({
    required this.isStart,
    required this.conversationID,
    required this.senderID,
    required this.receiverID,
  });
}

final class ReplyChat extends ChatEvent {
  final ChatMessageModel? chatMessageModel;

  const ReplyChat(this.chatMessageModel);
}

final class ReactChat extends ChatEvent {
  final ChatMessageModel chatMessageModel;
  final String emoticon;

  const ReactChat(this.emoticon, this.chatMessageModel);
}

final class SubscribeEmot extends ChatEvent {
  const SubscribeEmot();
}
