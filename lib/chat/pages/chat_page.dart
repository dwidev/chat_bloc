import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/chat_bloc/chat_bloc.dart';
import '../cubit/react_animation_cubit.dart';
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

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  late ReactAnimationCubit reactAnimate;
  late TextEditingController controller;
  Timer? typingDelay;

  bool get isMe => reactAnimate.state.selectedChat.senderID != widget.me;

  @override
  void initState() {
    reactAnimate = context.read<ReactAnimationCubit>();
    controller = TextEditingController();
    final cId = widget.conversationModel.conversationID;
    context.read<ChatBloc>()
      ..add(GetMessageByConversationID(cId))
      ..add(ChatSubscribeMessage(cId))
      ..add(JoinRoomChat(cId, widget.me, widget.receiver.id));

    reactAnimate.initAnimationForOnPressChat(vsync: this);
    reactAnimate.initAnimationForEmoticon(
      vsync: this,
      isSender: true,
    );

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

    return MultiBlocListener(
      listeners: [
        BlocListener<ReactAnimationCubit, ReactAnimationState>(
          listener: (context, state) {
            if (state is ReactAnimationSelectEmoji) {
              context
                  .read<ChatBloc>()
                  .add(ReactChat(state.selectedEmoticon, state.chat));
            }
          },
        ),
        BlocListener<ChatBloc, ChatState>(
          listener: (context, state) {
            print(state);
            if (state is ChatStateStartEmoticonAnimation) {
              reactAnimate.emoticonAnimationController.forward(from: 0);
            }
          },
        ),
      ],
      child: WillPopScope(
        onWillPop: () async {
          final cId = widget.conversationModel.conversationID;
          context
              .read<ChatBloc>()
              .add(LeaveRoomChat(cId, widget.me, widget.receiver.id));
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
                            final reactAnimate =
                                context.watch<ReactAnimationCubit>();
                            return ListView.builder(
                              reverse: true,
                              itemCount: state.chats.length,
                              itemBuilder: (context, index) {
                                final chat =
                                    state.chats.reversed.toList()[index];
                                return ChatTile(
                                  chat: chat,
                                  isMe: chat.senderID != widget.me,
                                  onReplyChat: () {
                                    context
                                        .read<ChatBloc>()
                                        .add(ReplyChat(chat));
                                  },
                                  startAnimation: reactAnimate
                                          .state.selectedChat.messageId ==
                                      chat.messageId,
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
                                      conversationID: widget
                                          .conversationModel.conversationID,
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
                    child: state is ReactAnimationOverlay
                        ? GestureDetector(
                            onTap: () {
                              reactAnimate.closeChatReactOverlay(
                                selectedEmoticon: '',
                              );
                            },
                            child: Container(
                              alignment: isMe
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                              color: Colors.grey.withOpacity(0.5),
                              width: size.width,
                              height: size.height,
                              child: Transform.translate(
                                offset: state.offsetBubleChat,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    ChatTile.overlay(
                                      chat: state.selectedChat,
                                      isMe: isMe,
                                    ),
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
                buildWhen: (previous, current) =>
                    previous.selectedChat != current.selectedChat,
                builder: (context, state) {
                  return Positioned(
                    top: state.offsetBubleChat.dy - 30,
                    right: !isMe ? 30 : null,
                    left: isMe ? 30 : null,
                    child: AnimatedBuilder(
                      animation: reactAnimate.animationController,
                      builder: (context, _) {
                        return Opacity(
                          opacity: reactAnimate.opacityReactAnimation.value,
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
                                        style: const TextStyle(fontSize: 30),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
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
      ),
    );
  }
}

class FloatingReactionAnimation extends StatefulWidget {
  final int index;
  final Size screenSize;
  final String me;

  const FloatingReactionAnimation({
    super.key,
    required this.index,
    required this.screenSize,
    required this.me,
  });

  @override
  State<FloatingReactionAnimation> createState() =>
      FloatingReactionAnimationState();
}

class FloatingReactionAnimationState extends State<FloatingReactionAnimation>
    with TickerProviderStateMixin {
  /// Reaction floating animation
  final animationDuration = const Duration(seconds: 4);
  late final AnimationController _reactFloatingController;

  late Animation<double> translateXAnimation;
  late Animation<double> translateYAnimation;
  late Animation<double> scaleAnimation;

  final random = math.Random();
  late final TweenSequence<double> tweenX;
  late final TweenSequence<double> tweenY;
  late final endXposition =
      random.nextInt(widget.screenSize.width.toInt()).toDouble();
  late final endYposition =
      random.nextInt(widget.screenSize.height ~/ 5).toDouble();
  late final scaleRandom = random.nextDouble() * 3.5;

  @override
  void initState() {
    _reactFloatingController = AnimationController(
      vsync: this,
      duration: animationDuration,
    );
    final curved = CurvedAnimation(
      parent: _reactFloatingController,
      curve: Curves.decelerate,
    );

    final xEnd = widget.index % 5 == 0 ? -endXposition : endXposition;
    tweenX = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween(begin: 0.0, end: xEnd)
              .chain(CurveTween(curve: Curves.fastEaseInToSlowEaseOut)),
          weight: 1,
        ),
        TweenSequenceItem<double>(
          tween: ConstantTween(xEnd)
              .chain(CurveTween(curve: Curves.fastEaseInToSlowEaseOut)),
          weight: 1,
        ),
      ],
    );
    translateXAnimation = tweenX.animate(curved);

    final endY = widget.index % 2 == 1 ? endYposition : -endYposition;
    tweenY = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween(begin: 0.0, end: endY)
              .chain(CurveTween(curve: Curves.fastEaseInToSlowEaseOut)),
          weight: 1,
        ),
        TweenSequenceItem<double>(
          tween: Tween(
            begin: endY,
            end: widget.screenSize.height,
          ).chain(CurveTween(curve: Curves.easeInToLinear)),
          weight: 0.5,
        ),
      ],
    );

    translateYAnimation = tweenY.animate(curved);
    final tweenRotate = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem(
          tween: Tween(
            begin: 1.0,
            end: scaleRandom < 1.0 ? 1.0 : scaleRandom.toDouble(),
          ),
          weight: 30,
        )
      ],
    );
    scaleAnimation = tweenRotate.animate(_reactFloatingController);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _reactFloatingController.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          context.read<ReactAnimationCubit>().resetReactAnimationState();
        }
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _reactFloatingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _reactFloatingController.reset();
        _reactFloatingController.stop(canceled: true);
        return true;
      },
      child: BlocConsumer<ReactAnimationCubit, ReactAnimationState>(
        listener: (context, state) {
          if (state is ReactAnimationStartFloating) {
            _reactFloatingController.forward(from: 0);
          }
        },
        builder: (context, state) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: state is ReactAnimationStartFloating
                ? AnimatedBuilder(
                    animation: _reactFloatingController,
                    builder: (context, child) {
                      final isMe = widget.me == state.selectedChat.senderID;
                      final xOffsetPosition =
                          isMe ? widget.screenSize.width - 30 : 20.0;
                      final xOffsetAnimation = isMe
                          ? -translateXAnimation.value
                          : translateXAnimation.value;

                      return Transform.translate(
                        offset: Offset(
                          xOffsetPosition,
                          state.offsetBubleChat.dy + 18,
                        ),
                        child: Transform.translate(
                          offset: Offset(
                            xOffsetAnimation,
                            -translateYAnimation.value,
                          ),
                          child: Transform.rotate(
                            angle: widget.index % 5 == 1
                                ? translateXAnimation.value.isNegative
                                    ? 0.001
                                    : -0.001
                                : 1,
                            child: Transform.scale(
                              scale: scaleAnimation.value,
                              child: Text(state.selectedEmoticon),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : const Offstage(),
          );
        },
      ),
    );
  }
}
