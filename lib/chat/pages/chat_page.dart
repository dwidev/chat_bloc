// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chat_bloc/chat/bloc/conversations_bloc/conversations_bloc.dart';
import 'package:chat_bloc/chat/data/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:chat_bloc/chat/data/model/conversation_model.dart';

import '../bloc/chat_bloc/chat_bloc.dart';

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

class _ChatPageState extends State<ChatPage>
    with SingleTickerProviderStateMixin {
  bool showLastWacth = false;
  late TextEditingController controller;

  late AnimationController animationController;
  late Animation<Offset> offsetAnimation;

  @override
  void initState() {
    animationController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animationController.reset();
          setState(() {
            showLastWacth = true;
          });
        }
      });

    offsetAnimation =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(-1, 0))
            .animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.decelerate,
    ));
    Future.delayed(const Duration(seconds: 1), () {
      animationController.forward();
    });

    controller = TextEditingController();
    final cId = widget.conversationModel.conversationID;
    context.read<ChatBloc>()
      ..add(GetMessageByConversationID(cId))
      ..add(ChatSubscribeMessage(cId))
      ..add(JoinRoomChat(cId, widget.me, widget.receiver.id));
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BlocListener<ConversationsBloc, ConversationsState>(
      listener: (context, state) {
        if (state is ConversationsOfflineUserState) {
          animationController.reset();
          setState(() {
            showLastWacth = false;
          });
          Future.delayed(const Duration(seconds: 2), () {
            animationController
              ..stop()
              ..forward();
          });
        }
      },
      child: WillPopScope(
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
                BlocBuilder<ConversationsBloc, ConversationsState>(
                  builder: (context, state) {
                    final user = state.conversations
                        .where((element) =>
                            element.conversationID ==
                            widget.conversationModel.conversationID)
                        .firstOrNull
                        ?.user;
                    final isOnline = user?.online ?? false;

                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return SizeTransition(
                          sizeFactor: animation,
                          child: ScaleTransition(
                            scale: animation,
                            alignment: Alignment.centerLeft,
                            child: child,
                          ),
                        );
                      },
                      child: isOnline
                          ? Text(
                              key: ValueKey<bool>(isOnline),
                              user?.status ?? "",
                              style: textTheme.bodySmall,
                            )
                          : SlideTransition(
                              position: offsetAnimation,
                              child: Text(
                                key: ValueKey<bool>(isOnline),
                                showLastWacth
                                    ? user?.lastWatch ?? ''
                                    : user?.lastSeen ?? '',
                                style: textTheme.bodySmall
                                    ?.copyWith(color: Colors.grey),
                              ),
                            ),
                    );
                  },
                ),
              ],
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: BlocBuilder<ChatBloc, ChatState>(
                    builder: (context, state) {
                      return ListView.builder(
                        reverse: true,
                        itemCount: state.chats.length,
                        itemBuilder: (context, index) {
                          final chat = state.chats.reversed.toList()[index];
                          return Column(
                            crossAxisAlignment: chat.senderID != widget.me
                                ? CrossAxisAlignment.start
                                : CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(chat.content),
                                    const SizedBox(width: 5),
                                    Text(
                                      chat.date,
                                      style: textTheme.bodySmall?.copyWith(
                                        color: Colors.grey,
                                        fontSize: 8,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  // height: 120,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          decoration: const InputDecoration(
                            hintText: "Masukan pesan",
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
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
      ),
    );
  }
}
