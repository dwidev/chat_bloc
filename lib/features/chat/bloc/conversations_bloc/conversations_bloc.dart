import 'dart:async';

import 'package:chat_bloc/features/chat/data/model/user_model.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../data/model/conversation_model.dart';
import '../../data/model/socket_event_model.dart';
import '../../data/repository/chat_repository.dart';

part 'conversations_event.dart';
part 'conversations_state.dart';

@Injectable()
class ConversationsBloc extends Bloc<ConversationsEvent, ConversationsState> {
  final ChatRepository chatRepository;
  ConversationsBloc({required this.chatRepository})
      : super(const ConversationsState.initial()) {
    on<GetConversations>(_onGetConversations);
    on<ConversationSubscribeMessage>(_onSubscribeMessage);
    on<ConversationReadMessage>(_onReadMessage);
    on<ConversationSubscribeUserTyping>(_onSubscribeUserTyping);
  }

  void _onSubscribeMessage(
    ConversationSubscribeMessage event,
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
            user: conv.user.copyWith(typing: false),
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
              status: isOnline ? onlineState : offlineState,
              statusDate: socketEvent.message.messageDate.toString(),
              typing: !isOnline ? false : conv.user.typing,
            ),
          );
          conversations[indexCon] = newConv;

          if (isOnline) {
            return state.copyWith(conversations: conversations);
          }

          return ConversationsOfflineUserState(
            userRoomInfo: state.userRoomInfo,
            conversations: conversations,
          );
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
    ConversationReadMessage event,
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

  Future<void> _onSubscribeUserTyping(
    ConversationSubscribeUserTyping event,
    Emitter<ConversationsState> emit,
  ) async {
    await emit.forEach(
      chatRepository.userTypingStream,
      onData: (socketEvent) {
        final conversations = [...state.conversations];
        final indexCon = conversations.indexWhere(
          (c) => c.conversationID == socketEvent.message.conversationID,
        );
        final conv = conversations[indexCon];
        final newUser = conv.user.copyWith(
          typing: socketEvent.message.content == "start",
        );
        final newConv = conv.copyWith(user: newUser);
        conversations[indexCon] = newConv;
        return state.copyWith(conversations: conversations);
      },
    );
  }
}
