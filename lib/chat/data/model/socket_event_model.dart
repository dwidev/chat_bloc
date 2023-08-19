// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'chat_message_model.dart';

enum SocketEvent {
  onlineOffline,
  joinRoom,
  leaveRoom,
  sendMessage,
  pingPong,
  userTyping,
  unknown;

  String toName() {
    switch (this) {
      case onlineOffline:
        return "online_offline";
      case joinRoom:
        return "join_room";
      case leaveRoom:
        return "leave_room";
      case sendMessage:
        return "send_message";
      case pingPong:
        return "ping_pong";
      case userTyping:
        return "user_typing";
      default:
        return "noname";
    }
  }
}

extension StringSocketEventExt on String {
  SocketEvent toEnum() {
    switch (this) {
      case "online_offline":
        return SocketEvent.onlineOffline;
      case "leave_room":
        return SocketEvent.leaveRoom;
      case "join_room":
        return SocketEvent.joinRoom;
      case "send_message":
        return SocketEvent.sendMessage;
      case "ping_pong":
        return SocketEvent.pingPong;
      case "user_typing":
        return SocketEvent.userTyping;
      default:
        return SocketEvent.unknown;
    }
  }
}

class SocketEventModel {
  final SocketEvent type;
  final ChatMessageModel message;

  SocketEventModel({
    required this.type,
    required this.message,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'event_type': type.toName(),
      'message': message.toMap(),
    };
  }

  factory SocketEventModel.fromMap(Map<String, dynamic> map) {
    return SocketEventModel(
      type: (map['event_type'] as String).toEnum(),
      message: ChatMessageModel.fromMap(map['message'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory SocketEventModel.fromJson(String source) =>
      SocketEventModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'SocketEventModel(type: $type, message: $message)';
}
