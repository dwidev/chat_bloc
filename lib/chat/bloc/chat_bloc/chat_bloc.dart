import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/chat_message_model.dart';
import '../../data/repository/chat_repository.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;
  ChatBloc({required this.chatRepository}) : super(const ChatInitial()) {
    on<SendMessage>(_onSendMessage);
    on<GetMessageByConversationID>(_onGetMessage);
    on<ChatSubscribeMessage>(_subscribeMessage);
    on<JoinRoomChat>(_joinRoomChat);
    on<LeaveRoomChat>(_leaveRoomChat);
    on<ChatTyping>(_onTyping);
    on<SubscribeUserTyping>(_onSubscribeUserTyping);
  }

  Future<void> _subscribeMessage(
    ChatSubscribeMessage event,
    Emitter<ChatState> emit,
  ) async {
    final stream = chatRepository.socketStream
        .where((s) => s.message.conversationID == event.conversationID);

    await emit.forEach(stream, onData: (socketEvent) {
      final newChats = [...state.chats, socketEvent.message];
      return state.copyWith(chats: newChats);
    }, onError: (error, stackTrace) {
      return state;
    });
  }

  Future<void> _onGetMessage(
    GetMessageByConversationID event,
    Emitter<ChatState> emit,
  ) async {
    final res = await chatRepository.getMessageByConversationID(
      event.conversationID,
    );
    emit(state.copyWith(chats: res));
  }

  void _onSendMessage(SendMessage event, Emitter<ChatState> emit) {
    debugPrint("SEND MESSAGE");

    final messageModel = ChatMessageModel(
      messageId: '',
      conversationID: event.conversationID,
      content: event.content,
      messageType: "send_message",
      senderID: event.senderID,
      receiverID: event.receiverID,
      messageDate: DateTime.now(),
    );

    chatRepository.sendMessage(messageModel);
  }

  void _joinRoomChat(JoinRoomChat evet, Emitter<ChatState> emit) {
    chatRepository.joinRoom(
      conversationID: evet.conversationID,
      sender: evet.senderID,
      receiver: evet.receiverID,
    );
  }

  void _leaveRoomChat(LeaveRoomChat evet, Emitter<ChatState> emit) {
    chatRepository.leaveRoom(
      conversationID: evet.conversationID,
      sender: evet.senderID,
      receiver: evet.receiverID,
    );
  }

  void _onTyping(ChatTyping event, Emitter<ChatState> emit) {
    emit(state.copyWith(startTyping: event.isStart));
  }

  Future<void> _onSubscribeUserTyping(
    SubscribeUserTyping event,
    Emitter<ChatState> emit,
  ) async {
    // dummy listen event typing
    final stream = Stream.periodic(const Duration(seconds: 5));

    await emit.forEach(
      stream,
      onData: (data) {
        return state.copyWith(receiverIsTyping: !state.receiverIsTyping);
      },
    );
  }
}
