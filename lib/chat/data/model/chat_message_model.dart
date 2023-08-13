// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:intl/intl.dart';

class ChatMessageModel {
  final String messageId;
  final String conversationID;
  final String content;
  final String messageType;
  final String senderID;
  final String receiverID;
  final DateTime messageDate;
  final String messageStatus;

  bool get read => messageStatus == "read";
  bool get unread => messageStatus == "unread";

  String get date {
    final date = DateFormat("HH:mm").format(messageDate.toLocal());
    return date;
  }

  String get dateConv {
    final dateNow = DateTime.now();
    if (dateNow.day != messageDate.day) {
      final lastWatch = DateFormat("dd/MM/yyyy HH:mm").format(
        messageDate.toLocal(),
      );
      return lastWatch;
    }

    final lastWatch = DateFormat("HH:mm").format(messageDate.toLocal());
    return lastWatch;
  }

  ChatMessageModel({
    required this.messageId,
    required this.conversationID,
    required this.content,
    required this.messageType,
    required this.senderID,
    required this.receiverID,
    required this.messageDate,
    this.messageStatus = "",
  });

  factory ChatMessageModel.joinOrLeaveRoom({
    required String conversationID,
    required String sender,
    required String receiver,
  }) {
    return ChatMessageModel(
      messageId: '',
      conversationID: conversationID,
      content: '',
      messageType: '',
      senderID: sender,
      receiverID: receiver,
      messageDate: DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    final msgDate = DateFormat("yyyy-MM-dd'T'HH:mm:ssZ'+00:00'").format(
      messageDate,
    );

    return <String, dynamic>{
      'messageId': messageId,
      'conversationID': conversationID,
      'content': content,
      'messageType': messageType,
      'senderID': senderID,
      'receiverID': receiverID,
      'messageDate': msgDate,
    };
  }

  factory ChatMessageModel.fromMap(Map<String, dynamic> map) {
    return ChatMessageModel(
      messageId: map['messageId'] as String,
      conversationID: map['conversationID'] as String? ?? "",
      content: map['content'] as String? ?? "",
      messageType: map['messageType'] as String,
      senderID: map['senderID'] as String,
      receiverID: map['receiverID'] as String,
      messageDate: DateTime.tryParse(map['messageDate']) ?? DateTime.now(),
      messageStatus: map['messageStatus'] as String? ?? "read",
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatMessageModel.fromJson(String source) =>
      ChatMessageModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ChatMessageModel(messageId: $messageId, conversationID: $conversationID, content: $content, messageType: $messageType, senderID: $senderID, receiverID: $receiverID, messageDate: $messageDate, messageStatus: $messageStatus)';
  }

  ChatMessageModel copyWith({
    String? messageId,
    String? conversationID,
    String? content,
    String? messageType,
    String? senderID,
    String? receiverID,
    DateTime? messageDate,
    String? messageStatus,
  }) {
    return ChatMessageModel(
      messageId: messageId ?? this.messageId,
      conversationID: conversationID ?? this.conversationID,
      content: content ?? this.content,
      messageType: messageType ?? this.messageType,
      senderID: senderID ?? this.senderID,
      receiverID: receiverID ?? this.receiverID,
      messageDate: messageDate ?? this.messageDate,
      messageStatus: messageStatus ?? this.messageStatus,
    );
  }
}
