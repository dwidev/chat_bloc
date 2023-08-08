import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/conversation_model.dart';
import '../../data/model/socket_event_model.dart';
import '../../data/repository/chat_repository.dart';

part 'conversations_event.dart';
part 'conversations_state.dart';

class ConversationsBloc extends Bloc<ConversationsEvent, ConversationsState> {
  final ChatRepository chatRepository;
  ConversationsBloc({required this.chatRepository})
      : super(const ConversationsState.initial()) {
    on<GetConversations>(_onGetConversations);
    on<SubscribeMessage>(_onSubscribeMessage);
    on<ReadMessage>(_onReadMessage);
  }

  void _onSubscribeMessage(
    SubscribeMessage event,
    Emitter<ConversationsState> emit,
  ) async {
    await emit.forEach(
      chatRepository.socketStream,
      onData: (socketEvent) {
        final message = socketEvent.message;

        if (socketEvent.type == SocketEvent.sendMessage) {
          debugPrint("ADA PESAN BARU NIH BUAT CONVERSATIONS : $message");
          final conversations = state.conversations.toList();
          final indexCon = conversations.indexWhere(
            (c) => c.conversationID == message.conversationID,
          );
          final conv = conversations[indexCon];
          final newConv = conv.copyWith(
            lastMessage: message,
            unreadCount:
                socketEvent.message.unread ? conv.unreadCount + 1 : null,
          );
          conversations
            ..insert(0, newConv)
            ..removeAt(indexCon + 1);
          return state.copyWith(conversations: conversations);
        }

        if (socketEvent.type == SocketEvent.onlineOffline) {
          final isOnline = socketEvent.message.content == "online";
          final conversations = state.conversations.toList();
          final indexCon = conversations.indexWhere(
            (c) => c.participantsID.contains(message.senderID),
          );
          final conv = conversations[indexCon];
          final newConv = conv.copyWith(
            user: conv.user.copyWith(
              status: isOnline ? "online" : "offline",
              statusDate: socketEvent.message.messageDate.toString(),
            ),
          );
          conversations[indexCon] = newConv;
          return state.copyWith(conversations: conversations);
        }

        return state;
      },
      onError: (error, stackTrace) {
        debugPrint("ERROR CONVERSATIONS :$error");
        return state;
      },
    );
  }

  FutureOr<void> _onGetConversations(
    GetConversations event,
    Emitter<ConversationsState> emit,
  ) async {
    final conversations = await chatRepository.getConversations(event.userID);
    emit(state.copyWith(conversations: conversations));
  }

  void _onReadMessage(
    ReadMessage event,
    Emitter<ConversationsState> emit,
  ) {
    final conversations = [...state.conversations];
    final indexCon = conversations.indexWhere(
      (c) => c.conversationID == event.conversation.conversationID,
    );
    final conv = conversations[indexCon];
    final newConv = conv.copyWith(
      lastMessage: conv.lastMessage?.copyWith(messageStatus: "read"),
      unreadCount: 0,
    );
    conversations[indexCon] = newConv;
    emit(state.copyWith(conversations: conversations));
  }
}
