// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:matchloves/features/chat/data/model/socket_event_model.dart';

class PingPongModel {
  final SocketEvent eventType;

  PingPongModel({
    this.eventType = SocketEvent.pingPong,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'eventType': eventType.toName(),
    };
  }

  factory PingPongModel.fromMap(Map<String, dynamic> map) {
    return PingPongModel(
      eventType: (map['event_type'] as String).toEnum(),
    );
  }

  String toJson() => json.encode(toMap());

  factory PingPongModel.fromJson(String source) =>
      PingPongModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
