import 'dart:async';

import 'package:chat_bloc/chat/data/model/socket_event_model.dart';

import '../datasources/http_datasource.dart';
import '../model/chat_message_model.dart';
import 'package:rxdart/rxdart.dart';

import '../datasources/ws_datasource.dart';
import '../model/conversation_model.dart';

const reconnectDelayDuration = Duration(milliseconds: 500);
const attemptsReconnecting = 5;

class ChatRepository {
  final WebSocketDataSource webSocketDataSource;
  final HttpDataSource httpDataSource;

  ChatRepository({
    required this.webSocketDataSource,
    required this.httpDataSource,
  });

  Future<void> connect(String token, {int connectAttempts = 0}) =>
      webSocketDataSource.connect(token, connectAttempts);

  Stream<SocketEventModel> get socketStream => webSocketDataSource.socketStream;

  Stream<WSConnectionStatus> get wsConnectionStream =>
      webSocketDataSource.connectionStream;

  Stream<WSConnectionStatus> get reconnectingStream =>
      webSocketDataSource.connectionStream
          .where((event) => event == WSConnectionStatus.disconnected)
          .delay(reconnectDelayDuration);

  Future<List<ConversationModel>> getConversations(String userID) async {
    return await httpDataSource.getConversations(userID);
  }

  Future<List<ChatMessageModel>> getMessageByConversationID(
    String conversationID,
  ) async {
    return await httpDataSource.getMessageByConversationID(conversationID);
  }

  void sendMessage(ChatMessageModel messageModel) {
    webSocketDataSource.sendMessage(messageModel: messageModel);
  }

  void joinRoom({
    required String conversationID,
    required String sender,
    required String receiver,
  }) =>
      webSocketDataSource.joinRoom(
        conversationID: conversationID,
        sender: sender,
        receiver: receiver,
      );

  void leaveRoom({
    required String conversationID,
    required String sender,
    required String receiver,
  }) =>
      webSocketDataSource.leaveRoom(
        conversationID: conversationID,
        sender: sender,
        receiver: receiver,
      );
}
