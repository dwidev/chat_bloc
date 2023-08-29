import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/chat_bloc/chat_bloc.dart';
import '../data/model/conversation_model.dart';
import '../data/model/user_model.dart';
import '../widget/chat_last_seen_animation_widget.dart';
import '../widget/chat_tile_widget.dart';
import '../widget/reply_chat_widget.dart';

class ChatPage extends StatefulWidget {
  final ConversationModel conversationModel;
  final String me;
  final UserModel receiver;

  const ChatPage({
    Key? key,
    required this.conversationModel,
    required this.me,
    required this.receiver,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late TextEditingController controller;
  Timer? typingDelay;

  @override
  void initState() {
    controller = TextEditingController();
    final cId = widget.conversationModel.conversationID;
    context.read<ChatBloc>()
      ..add(GetMessageByConversationID(cId))
      ..add(ChatSubscribeMessage(cId))
      ..add(JoinRoomChat(cId, widget.me, widget.receiver.id));

    super.initState();
  }

  void _onChangeChat(String value) {
    final chatBloc = context.read<ChatBloc>();
    final cId = widget.conversationModel.conversationID;
    if (typingDelay?.isActive ?? false) typingDelay?.cancel();

    typingDelay = Timer(const Duration(seconds: 3), () {
      chatBloc.add(ChatTyping(
        isStart: false,
        conversationID: cId,
        senderID: widget.me,
        receiverID: widget.receiver.id,
      ));
      return;
    });

    if (!chatBloc.state.startTyping) {
      chatBloc.add(ChatTyping(
        isStart: true,
        conversationID: cId,
        senderID: widget.me,
        receiverID: widget.receiver.id,
      ));
    }
  }

  @override
  void dispose() {
    controller.dispose();
    typingDelay?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final cId = widget.conversationModel.conversationID;
        context
            .read<ChatBloc>()
            .add(LeaveRoomChat(cId, widget.me, widget.receiver.id));
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.receiver.name),
              ChatLastSeenAnimationWidget(
                conversationID: widget.conversationModel.conversationID,
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: BlocBuilder<ChatBloc, ChatState>(
                  builder: (context, state) {
                    return ListView.builder(
                      reverse: true,
                      itemCount: state.chats.length,
                      itemBuilder: (context, index) {
                        final chat = state.chats.reversed.toList()[index];
                        return ChatTile(
                          chat: chat,
                          isMe: chat.senderID != widget.me,
                          onReplyChat: () {
                            context.read<ChatBloc>().add(ReplyChat(chat));
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              const ReplyChatWidget(),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller,
                        decoration: const InputDecoration(
                          hintText: "Masukan pesan",
                        ),
                        onChanged: _onChangeChat,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (controller.text.isEmpty) return;

                        final sendMessage = SendMessage(
                          conversationID:
                              widget.conversationModel.conversationID,
                          senderID: widget.me,
                          receiverID: widget.receiver.id,
                          content: controller.text,
                        );
                        context.read<ChatBloc>().add(sendMessage);
                        controller.clear();
                      },
                      icon: const Icon(Icons.send),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
