// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:matchloves/features/chat/data/model/chat_message_model.dart';
import 'package:matchloves/features/chat/data/model/user_model.dart';

class ConversationModel {
  final String conversationID;
  final List<String> participantsID;
  final ChatMessageModel? lastMessage;
  final UserModel user;

  // state
  final int unreadCount;

  bool unread(String me) =>
      (lastMessage?.unread ?? false) && lastMessage?.receiverID == me;

  ConversationModel({
    required this.conversationID,
    required this.participantsID,
    required this.lastMessage,
    required this.user,
    this.unreadCount = 0,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'conversationID': conversationID,
      'participantsID': participantsID,
      'lastMessage': lastMessage?.toMap(),
    };
  }

  factory ConversationModel.fromMap(Map<String, dynamic> map) {
    return ConversationModel(
      conversationID: map['conversationID'] as String,
      participantsID: List.from((map['participantsID'])),
      lastMessage: map['lastMessage'] != null
          ? ChatMessageModel.fromMap(map['lastMessage'] as Map<String, dynamic>)
          : null,
      user: UserModel.fromMap(map['user']),
      unreadCount: map['unreadCount'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ConversationModel.fromJson(String source) =>
      ConversationModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ConversationModel(conversationID: $conversationID, participantsID: $participantsID, lastMessage: $lastMessage, user: $user)';
  }

  ConversationModel copyWith({
    String? conversationID,
    List<String>? participantsID,
    ChatMessageModel? lastMessage,
    UserModel? user,
    int? unreadCount,
  }) {
    return ConversationModel(
      conversationID: conversationID ?? this.conversationID,
      participantsID: participantsID ?? this.participantsID,
      lastMessage: lastMessage ?? this.lastMessage,
      user: user ?? this.user,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}
