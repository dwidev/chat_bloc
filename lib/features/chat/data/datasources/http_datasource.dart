import 'package:matchloves/features/chat/data/datasources/ws_datasource.dart';
import 'package:matchloves/features/chat/data/model/chat_message_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../model/conversation_model.dart';

@LazySingleton()
class HttpDataSource {
  late Dio dio;

  HttpDataSource() {
    final options = BaseOptions(
      baseUrl: "http://$host:8080/petlove/api/v1/",
      responseType: ResponseType.json,
    );

    dio = Dio(options);
  }

  @disposeMethod
  void dispose() {
    debugPrint("DISPOSING HttpDataSource");
  }

  Future<List<ConversationModel>> getConversations(String userID) async {
    try {
      final res = await dio.get("chat/conversations/$userID");
      final list = res.data as List;
      return list.map((e) => ConversationModel.fromMap(e)).toList();
    } catch (e) {
      debugPrint("ERROR GET CONVERSATION $e");
      return [];
    }
  }

  Future<List<ChatMessageModel>> getMessageByConversationID(
    String conversationID,
  ) async {
    try {
      final res = await dio.get("chat/message/$conversationID");
      final list = res.data as List;
      return list.map((e) => ChatMessageModel.fromMap(e)).toList();
    } catch (e) {
      debugPrint("ERROR GET MESSAGE BY CONVERSATION ID $e");
      return [];
    }
  }
}

final dummyConversations = [
  {
    "conversationID": "64a3f3e83a998bc452af68c7",
    "participants": ["fahmi", "albert"]
  },
  {
    "conversationID": "64a3f6550b4bb21d970ea880",
    "participants": ["fahmi", "dwi"]
  },
  {
    "conversationID": "64a3f65e0b4bb21d970ea886",
    "participants": ["fahmi", "selly"]
  }
];
