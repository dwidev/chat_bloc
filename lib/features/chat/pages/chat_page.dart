import 'dart:async';

import 'package:chat_bloc/features/chat/bloc/conversations_bloc/conversations_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/colors.dart';
import '../bloc/chat_bloc/chat_bloc.dart';
import '../cubit/react_animation_cubit.dart';
import '../data/model/conversation_model.dart';
import '../data/model/user_model.dart';
import '../widget/chat_floating_react_animation.dart';
import '../widget/chat_last_seen_animation_widget.dart';
import '../widget/chat_tile_widget.dart';
import '../widget/reply_chat_widget.dart';

class ChatPageOptions {
  final ConversationModel conversationModel;
  final String me;
  final UserModel receiver;
  final ConversationsBloc conversationsBloc;

  ChatPageOptions({
    required this.conversationModel,
    required this.me,
    required this.receiver,
    required this.conversationsBloc,
  });
}

class ChatPage extends StatefulWidget {
  final ChatPageOptions options;

  const ChatPage({
    Key? key,
    required this.options,
  }) : super(key: key);

  ConversationModel get conversationModel => options.conversationModel;
  String get me => options.me;
  UserModel get receiver => options.receiver;

  @override
  State<ChatPage> createState() => _ChatPageState();

  static const path = 'room-chat';
}

class _ChatPageState extends State<ChatPage>
    with SingleTickerProviderStateMixin {
  late ReactAnimationCubit reactAnimate;
  late TextEditingController controller;
  Timer? typingDelay;

  bool get isMe => reactAnimate.state.selectedChat.senderID == widget.me;

  @override
  void initState() {
    reactAnimate = context.read<ReactAnimationCubit>();
    controller = TextEditingController();
    final cId = widget.conversationModel.conversationID;
    context.read<ChatBloc>()
      ..add(GetMessageByConversationID(cId))
      ..add(ChatSubscribeMessage(cId))
      ..add(const SubscribeEmot())
      ..add(JoinRoomChat(cId, widget.me, widget.receiver.id));

    reactAnimate.initAnimationForOnPressChat(vsync: this);

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
    debugPrint("DISPOSE CHAT PAGE");
    controller.dispose();
    typingDelay?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final mq = MediaQuery.of(context);
    final textTheme = Theme.of(context).textTheme;
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
        final event = LeaveRoomChat(cId, widget.me, widget.receiver.id);
        context.read<ChatBloc>().add(event);
        return true;
      },
      child: Material(
        color: Colors.red,
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
                        buildWhen: (previous, current) =>
                            previous.chats != current.chats,
                        builder: (context, state) {
                          return ListView.builder(
                            reverse: true,
                            itemCount: state.chats.length,
                            itemBuilder: (context, index) {
                              final chat = state.chats.reversed.toList()[index];
                              return ChatTile(
                                chat: chat,
                                isMe: chat.senderID == widget.me,
                                onReplyChat: () {
                                  context.read<ChatBloc>().add(ReplyChat(chat));
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                    Column(
                      children: [
                        const ReplyChatWidget(),
                        Container(
                          color: whiteColor,
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
                  ],
                ),
              ),
            ),
            BlocBuilder<ReactAnimationCubit, ReactAnimationState>(
              builder: (context, state) {
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: state.isShowReactOverlay
                      ? GestureDetector(
                          onTap: () {
                            reactAnimate.closeChatReactOverlay(
                              selectedEmoticon: '',
                            );
                          },
                          child: Container(
                            alignment: !isMe
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                            color: Colors.grey.shade100.withOpacity(0.9),
                            width: size.width,
                            height: size.height,
                            child: Transform.translate(
                              offset: state.offsetBubleChat,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 5),
                                    child: ChatBubleWidget(
                                      chat: state.selectedChat,
                                      isMe: isMe,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      : const Offstage(),
                );
              },
            ),
            BlocBuilder<ReactAnimationCubit, ReactAnimationState>(
              builder: (context, state) {
                if (state.isShowReactOverlay) {
                  return Positioned(
                    bottom: 30,
                    right: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 30,
                      ),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 237, 237, 237),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      width: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          [CupertinoIcons.reply, 'Balas'],
                          [
                            CupertinoIcons.rectangle_on_rectangle_angled,
                            'Salin'
                          ],
                          [CupertinoIcons.exclamationmark_shield, 'Laporkan'],
                          [CupertinoIcons.delete_solid, 'Hapus']
                        ]
                            .map(
                              (e) => Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      reactAnimate.closeChatReactOverlay(
                                        selectedEmoticon: '',
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: whiteColor,
                                      ),
                                      child: Icon(
                                        (e as List)[0],
                                        size: 20,
                                        color: (e as List)[1] == 'Hapus' ||
                                                (e as List)[1] == 'Laporkan'
                                            ? Colors.red
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    (e as List)[1],
                                    style: textTheme.bodySmall?.copyWith(
                                      fontSize: 13,
                                      color: (e as List)[1] == 'Hapus' ||
                                              (e as List)[1] == 'Laporkan'
                                          ? Colors.red
                                          : Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  );
                }

                return const Offstage();
              },
            ),
            BlocBuilder<ReactAnimationCubit, ReactAnimationState>(
              // buildWhen: (previous, current) =>
              //     previous.selectedChat != current.selectedChat,
              builder: (context, state) {
                return Positioned(
                  top: state.offsetBubleChat.dy - 30,
                  right: isMe ? 30 : null,
                  left: !isMe ? 30 : null,
                  child: AnimatedBuilder(
                    animation: reactAnimate.animationController,
                    builder: (context, _) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: state.isShowReactOverlay
                            ? Container(
                                decoration: BoxDecoration(
                                  color: whiteColor,
                                  borderRadius: BorderRadius.circular(30),
                                  // boxShadow: [
                                  //   BoxShadow(
                                  //     color: Colors.grey.shade200,
                                  //     blurRadius: 4,
                                  //     spreadRadius: 2,
                                  //   )
                                  // ],
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 2,
                                ),
                                child: Row(
                                  children: List.generate(
                                    reactAnimate.lengthEmot,
                                    (index) => Padding(
                                      padding: const EdgeInsets.only(right: 5),
                                      child: RepaintBoundary(
                                        child: GestureDetector(
                                          onLongPress: () {},
                                          onTap: () {
                                            reactAnimate.closeChatReactOverlay(
                                              selectedEmoticon:
                                                  reactAnimate.listEmot[index],
                                            );
                                          },
                                          child: Text(
                                            reactAnimate.listEmot[index],
                                            style:
                                                const TextStyle(fontSize: 30),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : const Offstage(),
                      );
                    },
                  ),
                );
              },
            ),
            ...List.generate(
              25,
              (index) => FloatingReactionAnimation(
                index: index,
                screenSize: size,
                me: widget.me,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
