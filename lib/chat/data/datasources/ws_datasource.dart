import 'dart:async';
import 'dart:io';

import 'package:chat_bloc/chat/data/repository/chat_repository.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../model/chat_message_model.dart';
import '../model/socket_event_model.dart';

enum WSConnectionStatus {
  connecting,
  connected,
  reconnected,
  disconnected,
  disconnectedWithReconnectAttempts,
  errorListener,
}

// const host = "localhost";
const host = "192.168.43.104";
// const host = "192.168.10.145";

class WebSocketDataSource {
  late WebSocketChannel webSocketChannel;

  WebSocketDataSource();

  final socketEventController = PublishSubject<SocketEventModel>();
  final wsConnectionController = BehaviorSubject<WSConnectionStatus>();

  Stream<SocketEventModel> get socketStream =>
      socketEventController.stream.asBroadcastStream();
  Stream<WSConnectionStatus> get connectionStream =>
      wsConnectionController.stream.asBroadcastStream();

  var counter = 0;
  Future<void> connect(String token, int connectAttempts) async {
    wsConnectionController.add(WSConnectionStatus.connecting);
    counter++;
    debugPrint("KONEK $counter");
    try {
      final uri = Uri.parse(
        "ws://$host:8080/petlove/ws/v1/?token=$token",
      );
      webSocketChannel = IOWebSocketChannel.connect(
        uri,
        pingInterval: const Duration(seconds: 1),
        connectTimeout: const Duration(seconds: 3),
      );
      await webSocketChannel.ready;
      wsConnectionController.add(WSConnectionStatus.connected);
      debugPrint("socket connected successfuly...");
      _listenConnection(token);
    } catch (e) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (connectAttempts == attemptsReconnecting) {
        wsConnectionController.add(
          WSConnectionStatus.disconnectedWithReconnectAttempts,
        );
        return;
      }
      debugPrint("error connect to websocket server... $counter");
      wsConnectionController.add(WSConnectionStatus.disconnected);
      debugPrint("$e");
    }
  }

  void _listenConnection(String token) {
    final ws = webSocketChannel.stream.asBroadcastStream();

    ws.map((event) => SocketEventModel.fromJson(event)).listen((socketEvent) {
      socketEventController.add(socketEvent);
      debugPrint("socketEvent :$socketEvent");
    }, onDone: () {
      debugPrint("DONE WS LISTENER");
      wsConnectionController.add(WSConnectionStatus.disconnected);
    }, onError: (err) {
      debugPrint("ERROR WS LISTENER : $err");
      wsConnectionController.add(WSConnectionStatus.errorListener);
    });
  }

  // Stream<bool> checkHealthWsConnection() {
  //   print("CHECK HEALTH WS CONNECTION");
  //   return wsStream.map((event) {
  //     print("event from ws health : $event");
  //     return true;
  //   });
  // }

  // Stream<SocketEventModel> msgStream() => wsStream;

  // Stream<SocketEventModel> listenLeaveRoom() {
  //   return wsStream.where((event) => event.type == SocketEvent.leaveRoom);
  // }

  void disconnection() {
    webSocketChannel.sink.close(
      WebSocketStatus.normalClosure,
      "saya keluar dlu",
    );
  }

  void sendMessage({required ChatMessageModel messageModel}) {
    final event = SocketEventModel(
      type: SocketEvent.sendMessage,
      message: messageModel,
    );

    socketEventController.add(event);
    webSocketChannel.sink.add(event.toJson());
  }

  void joinRoom({
    required String conversationID,
    required String sender,
    required String receiver,
  }) {
    final event = SocketEventModel(
      type: SocketEvent.joinRoom,
      message: ChatMessageModel.joinOrLeaveRoom(
        conversationID: conversationID,
        sender: sender,
        receiver: receiver,
      ),
    );

    webSocketChannel.sink.add(event.toJson());
  }

  void leaveRoom({
    required String conversationID,
    required String sender,
    required String receiver,
  }) {
    final event = SocketEventModel(
      type: SocketEvent.leaveRoom,
      message: ChatMessageModel.joinOrLeaveRoom(
        conversationID: conversationID,
        sender: sender,
        receiver: receiver,
      ),
    );

    webSocketChannel.sink.add(event.toJson());
  }

  void sendUserTyping({required ChatMessageModel messageModel}) {
    final event = SocketEventModel(
      type: SocketEvent.userTyping,
      message: messageModel,
    );

    webSocketChannel.sink.add(event.toJson());
  }
}

// Timer.periodic(const Duration(seconds: 10), (timer) {
      //   debugPrint("Cek Healthy server");
      //   final pinpong = PingPongModel();
      //   webSocketChannel.sink.add('9');
      // });