import 'dart:async';

import '../data/model/chat_message_model.dart';
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

class _ChatPageState extends State<ChatPage>
    with SingleTickerProviderStateMixin {
  late TextEditingController controller;
  Timer? typingDelay;
  Offset? offsetChatOverlay;
  late ChatMessageModel chatMessageModel;

  bool get isMe => chatMessageModel.senderID != widget.me;

  late final AnimationController _animationController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 500));

  late final Animation<double> opacityReact = Tween(begin: 0.0, end: 1.0)
      .animate(CurvedAnimation(
          parent: _animationController, curve: Curves.decelerate));

  final listEmot = ['❤️', '🥰', '😂', '😵', '😱', '👍🏻'];

  String isReact = '';
  String emot = '';

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
    _animationController.dispose();
    controller.dispose();
    typingDelay?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final mq = MediaQuery.of(context);
    final size = MediaQuery.of(context).size;
    final appBar = AppBar(
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
    );
    // final appBarSize = appBar.preferredSize.height;
    // final vpTop = mq.viewPadding.top;
    // final offSetByAppbar = Offset(0, appBarSize + vpTop);

    return WillPopScope(
      onWillPop: () async {
        final cId = widget.conversationModel.conversationID;
        context
            .read<ChatBloc>()
            .add(LeaveRoomChat(cId, widget.me, widget.receiver.id));
        return true;
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: appBar,
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
                              onLongPress: (offset, msg) {
                                setState(() {
                                  isReact = '';
                                  offsetChatOverlay = offset;
                                  chatMessageModel = msg;
                                });
                                _animationController.forward();
                              },
                              dummyReaction: isReact,
                              emot: emot,
                            );
                          },
                        );
                      },
                    ),
                  ),
                  // if (offsetChatOverlay == null) ...[
                  if (true) ...[
                    Column(
                      children: [
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
                    )
                  ]
                ],
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 100),
              child: offsetChatOverlay != null
                  ? GestureDetector(
                      onTap: () {
                        _animationController.reset();

                        setState(() {
                          offsetChatOverlay = null;
                          isReact = chatMessageModel.content;
                        });
                      },
                      child: Container(
                        alignment:
                            isMe ? Alignment.centerLeft : Alignment.centerRight,
                        color: Colors.black.withOpacity(0.5),
                        width: size.width,
                        height: size.height,
                        child: Transform.translate(
                          offset: offsetChatOverlay!,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ChatTile.overlay(
                                chat: chatMessageModel,
                                isMe: isMe,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : const Offstage(),
            ),
          ),
          if (offsetChatOverlay != null)
            Positioned(
              top: offsetChatOverlay!.dy - 30,
              right: !isMe ? 30 : null,
              left: isMe ? 30 : null,
              child: Material(
                color: Colors.transparent,
                child: AnimatedBuilder(
                  animation: opacityReact,
                  builder: (context, _) {
                    return Opacity(
                      opacity: opacityReact.value,
                      child: AnimatedContainer(
                        duration: const Duration(seconds: 1),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 5,
                              spreadRadius: 3,
                            )
                          ],
                        ),
                        // width: 250,
                        // height: 50,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 2),
                        child: Row(
                          children: List.generate(
                            listEmot.length,
                            (index) => Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: GestureDetector(
                                onTap: () {
                                  _animationController.reset();

                                  setState(() {
                                    offsetChatOverlay = null;
                                    isReact = chatMessageModel.content;
                                    emot = listEmot[index];
                                  });
                                },
                                child: Text(
                                  listEmot[index],
                                  style: const TextStyle(fontSize: 30),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
