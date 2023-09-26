import 'package:chat_bloc/chat/data/model/socket_event_model.dart';
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
    on<ReplyChat>(_onReplyChat);
    on<ReactChat>(_reactChat);
    on<SubscribeEmot>(_onSubscribeEmot);
  }

  Future<void> _onSubscribeEmot(
    SubscribeEmot event,
    Emitter<ChatState> emit,
  ) async {
    final stream = Stream.periodic(
      const Duration(seconds: 3),
      (computationCount) => computationCount,
    ).take(3);

    await emit.forEach(stream, onData: (socketEvent) {
      List<ChatMessageModel> chats = [];
      for (var chat in state.chats) {
        if (chat.content == "asgh") {
          chats.add(chat.copyWith(emoticons: [
            EmoticonModel(
              senderID: chat.receiverID,
              emot: '😡',
            ),
            // EmoticonModel(
            //   senderID: chat.senderID,
            //   emot: '😂',
            // )
          ]));
          continue;
        }

        chats.add(chat);
      }
      return state.copyWith(chats: chats);
    }, onError: (error, stackTrace) {
      return state;
    });
  }

  Future<void> _subscribeMessage(
    ChatSubscribeMessage event,
    Emitter<ChatState> emit,
  ) async {
    final stream = chatRepository.socketStream
        .where((s) => s.type == SocketEvent.sendMessage)
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
    List<ChatMessageModel> chats = [];
    for (var chat in res) {
      if (chat.content == "test") {
        chats.add(chat.copyWith(emoticons: [
          EmoticonModel(
            senderID: chat.senderID,
            emot: '😂',
          )
        ]));
        continue;
      }

      if (chat.content == "testanimasi") {
        chats.add(chat.copyWith(emoticons: [
          // EmoticonModel(
          //   senderID: chat.senderID,
          //   emot: '😂',
          // ),
          EmoticonModel(
            senderID: chat.receiverID,
            emot: '❤️',
          )
        ]));
        continue;
      }

      chats.add(chat);
    }
    emit(state.copyWith(chats: chats));
  }

  void _onSendMessage(SendMessage event, Emitter<ChatState> emit) {
    debugPrint("SEND MESSAGE");

    final messageModel = ChatMessageModel(
      messageId: '',
      conversationID: event.conversationID,
      content: event.content,
      messageType: "send_message", // TODO : change to enum
      senderID: event.senderID,
      receiverID: event.receiverID,
      messageDate: DateTime.now(),
    );

    chatRepository.sendMessage(messageModel);
    add(const ReplyChat(null));
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
    final messageModel = ChatMessageModel(
      messageId: '',
      conversationID: event.conversationID,
      content: event.isStart ? "start" : "end",
      messageType: "send_message", // TODO : change to enum
      senderID: event.senderID,
      receiverID: event.receiverID,
      messageDate: DateTime.now(),
    );
    chatRepository.sendUserTyping(messageModel);
    emit(state.copyWith(startTyping: event.isStart));
  }

  void _onReplyChat(ReplyChat event, Emitter<ChatState> emit) {
    if (event.chatMessageModel == null) {
      emit(ChatState(
        chats: state.chats,
        startTyping: state.startTyping,
        replayChat: null,
      ));
      return;
    }

    emit(state.copyWith(replayChat: event.chatMessageModel));
  }

  void _reactChat(ReactChat event, Emitter<ChatState> emit) {
    // final msgID = event.chatMessageModel.messageId;
    // final chats = state.chats.toList();
    // final indexChat = state.chats.indexWhere((c) => c.messageId == msgID);
    // var chatUpdate = chats.firstWhere((c) => c.messageId == msgID);
    // chatUpdate = chatUpdate.copyWith(
    //   emoticons: [
    //     ...chatUpdate.emoticons,
    //     ...[]
    //   ],
    //   emoticonState: EmoticonState.start,
    // );
    // chats.replaceRange(indexChat, indexChat + 1, [chatUpdate]);
    // // emit(ChatStateStartEmoticonAnimation(chats: chats));
  }
}
